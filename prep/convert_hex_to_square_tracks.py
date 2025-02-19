"""
Hexagonal track to square track conversion functions.
"""
import numpy as np
import os
import torch
import copy as cp
import matplotlib.pyplot as plt

XPOL_COL_PITCH = 0.050
XPOL_COL_OFFSET = 7.4625
XPOL_ROW_PITCH = 0.0433
XPOL_ROW_OFFSET = 7.59915
ROI_KEYS = ['MIN_CHIPX', 'MAX_CHIPX', 'MIN_CHIPY', 'MAX_CHIPY']


def fits_rec_to_roi(fits_rec):
    """Extract the ROI information from a specific a row in a Lv1/2 FITS file.

    This return a (min_col, max_col, min_row, max_row) tuple.
    """
    return tuple((fits_rec[key] for key in ROI_KEYS))


def roi_to_offset(min_col, max_col, min_row, max_row):
    """Convert an ROI into the corresponding column and row idexes (i.e., the
    rough equivalent of the offset coordinates in the C++ world).
    """
    num_cols = max_col - min_col + 1
    num_rows = max_row - min_row + 1
    idx = np.arange(num_cols * num_rows)
    col = idx % num_cols + min_col
    row = idx // num_cols + min_row
    return col, row


def xpol_pixel_to_world(col, row):
    """Convert a generic set of offset coordinates on the XPOL ASIC grid
    into the corresponding physical x and y coordinates.

    This is a pure-Python implementation of a functionality that is
    coded in C++ and exposed through the SWIG wrappers. It was duplicated
    here to support the NN processing in the pipeline, see
    https://bitbucket.org/ixpesw/gpdsw/issues/315

    For the C++ code, see ixpeHexagonalGrid.h/cpp in the Geometry package.
    Note that the pitch and offset values defined at the top of the module
    correspond to the values calculated into the ixpeHexagonalGrid constructor
    for the appropriate XPOL hexagnonal grid (even R).
    """
    x = (col - 0.5 * (row & 1)) * XPOL_COL_PITCH - XPOL_COL_OFFSET
    y = XPOL_ROW_OFFSET - row * XPOL_ROW_PITCH
    return x, y


def rot60(x, y, idx):
    """Rotate x,y, coordinates of hexagonal track by idx*60 degrees.
    """
    xy = np.stack([x, y])
    xy_rot = np.matmul(
        np.array([[np.cos(idx * np.pi / 3), -np.sin(idx * np.pi / 3)],
                  [np.sin(idx * np.pi / 3),
                   np.cos(idx * np.pi / 3)]]), xy)
    return xy_rot[0], xy_rot[1]


def reflect(x, y, idx):
    """Reflect x,y, coordinates of hexagonal track along cardinal axis idx.
    """
    if idx not in [0, 1, 2, 3, 4, 5]:  #identity
        return x, y
    else:
        xy = np.stack([x, y])
        theta = 2 * (idx * np.pi / 6)
        xy_mirror = np.matmul(
            np.array([[np.cos(theta), np.sin(theta)],
                      [np.sin(theta), -np.cos(theta)]]), xy)
        return xy_mirror[0], xy_mirror[1]


def hex2square_sub(hex_track,
                   hex_track_mc=None,
                   n_pixels=50,
                   augment=3,
                   shift=2):
    """Parallelizable helper function. Takes one hexagonal track and outputs square track cube.
    """
    sim = False
    flag = 0

    #this line should be fixed
    if hex_track_mc is not None:
        sim = True

    if sim:
        angles_sq = np.zeros(augment)
        mom_phis_sq = np.zeros(augment)
        abs_pts_sq = np.zeros((augment, shift, 2))
        abs_pt_aug = np.empty(2)

    mom_abs_pt_aug = np.empty(2)
    mom_abs_pts_sq = np.zeros((augment, shift, 2))

    pha = hex_track['PIX_PHAS_EQ'] // 8
    mask = hex_track['PIX_TRK'] == 0
    col, row = roi_to_offset(*fits_rec_to_roi(hex_track))
    x, y = xpol_pixel_to_world(col, row)

    xs = x[mask]
    ys = y[mask]
    Qs = pha[mask]

    tracks_cube = np.zeros((augment, shift, 3, len(Qs)), dtype=np.int16)

    mom_phi = hex_track['DETPHI2'] if hex_track['DETPHI2'] != 0.0 else hex_track['DETPHI1']
    mom_abs_pt = np.array([hex_track['ABSX'], hex_track['ABSY']])

    if xs.size == 0:
        flag = 1
        if sim:
            return tracks_cube, angles_sq, abs_pts_sq, mom_phis_sq, mom_abs_pts_sq, flag
        else:
            return (tracks_cube, mom_phi, mom_abs_pts_sq, flag)

    if sim:
        abs_pt = np.array([hex_track_mc['ABS_X'], hex_track_mc['ABS_Y']])
        abs_pt = np.argmin(np.sqrt((xs - abs_pt[0])**2 + (ys - abs_pt[1])**2))
    mom_abs_pt = np.argmin(
        np.sqrt((xs - mom_abs_pt[0])**2 + (ys - mom_abs_pt[1])**2))

    adj = np.argmin(np.sqrt((xs - xs[0])**2 +
                            (ys - ys[0])**2)[1:]) + 1  #find adjacent point
    r = np.sqrt((xs[0] - xs[adj])**2 + (ys[0] - ys[adj])**2) / 2
    a = r / np.cos(30 * np.pi / 180)

    n_flip = -1
    if augment == 3:
        n_rots = np.array([0, 2, 4])
    elif augment == 6:
        n_rots = np.array([0, 1, 2, 3, 4, 5])
    else:
        n_rots = [0]

    for k in range(augment):
        n_rot = n_rots[k]

        #reflect
        if sim:
            reflect_angle = reflect(np.cos(hex_track_mc['PE_PHI']),
                                    np.sin(hex_track_mc['PE_PHI']), n_flip)
            rotation = np.arctan2(reflect_angle[1],
                                  reflect_angle[0]) - hex_track_mc['PE_PHI']
            rotation += n_rot * np.pi / 3

        xs_aug, ys_aug = reflect(xs, ys, n_flip)

        #rotate
        xs_aug, ys_aug = rot60(xs_aug, ys_aug, n_rot)

        if sim:
            angle_new = hex_track_mc['PE_PHI'] + rotation
            angle_new = np.mod(angle_new + np.pi, 2 * np.pi) - np.pi
            mom_angle_new = (hex_track['DETPHI2'] + rotation 
                            if hex_track['DETPHI2'] != 0.0 
                            else hex_track['DETPHI1'] + rotation)
            mom_angle_new = np.mod(mom_angle_new + np.pi, 2 * np.pi) - np.pi
            angles_sq[k] = angle_new
            mom_phis_sq[k] = mom_angle_new

        xs_aug_shift = np.where(
            np.mod(np.round((ys_aug - ys_aug.min()) / (1.5 * a)), 2) == 1,
            xs_aug + r, xs_aug)
        if a == 0:
            flag = 1
        j, i = np.round((ys_aug - ys_aug.min()) / (1.5 * a)), np.round(
            ((xs_aug_shift - xs_aug_shift.min())) / (2 * r))
        if sim:
            abs_pts_sq[k, 0, 0], abs_pts_sq[k, 0, 1] = i[abs_pt], j[abs_pt]
        mom_abs_pts_sq[k, 0,
                       0], mom_abs_pts_sq[k, 0,
                                          1] = i[mom_abs_pt], j[mom_abs_pt]

        Q_square = np.zeros((n_pixels, n_pixels))
        bol = (i < n_pixels) * (
            j < n_pixels
        )  #square crop to n_pixel size, a minority of high energy tracks will be sliced
        Q_square[j[bol].astype(np.int), i[bol].astype(np.int)] = Qs[bol]
        indices = np.where(Q_square != 0)  #sparse representation
        values = Q_square[indices]
        try:
            tracks_cube[k, 0, :, :] = np.stack([*indices, values])  #Q_square
        except ValueError:
            #Cropping track to fit in the box and flagging bad event
            flag = 1
            missing_lenth = len(Qs) - len(values)
            indices = np.concatenate((indices, (n_pixels - 1) * np.ones(
                (2, missing_lenth))),
                                     axis=1)
            values = np.concatenate((values, np.zeros(missing_lenth)), axis=0)
            tracks_cube[k, 0, :, :] = np.stack([*indices, values])  #Q_square

        if shift > 1:
            xs_aug_shift = np.where(
                np.mod(np.round((ys_aug - ys_aug.min()) / (1.5 * a)),
                       2) == 0, xs_aug + r, xs_aug
            )  #(np.round(ys_aug,5) - 0.45465)/(1.5*a)),2)==1, xs_aug+r, xs_aug)
            j, i = np.round((ys_aug - ys_aug.min()) / (1.5 * a)), np.round(
                ((xs_aug_shift - xs_aug_shift.min())) / (2 * r))
            if sim:
                abs_pts_sq[k, 1, 0], abs_pts_sq[k, 1, 1] = i[abs_pt], j[abs_pt]
            mom_abs_pts_sq[k, 1,
                           0], mom_abs_pts_sq[k, 1,
                                              1] = i[mom_abs_pt], j[mom_abs_pt]

            Q_square = np.zeros((n_pixels, n_pixels))
            bol = (i < n_pixels) * (
                j < n_pixels
            )  #square crop to n_pixel size, a minority of high energy tracks will be sliced
            Q_square[j[bol].astype(np.int), i[bol].astype(np.int)] = Qs[bol]
            indices = np.where(Q_square != 0)  #sparse representation
            values = Q_square[indices]
            try:
                tracks_cube[k, 1, :, :] = np.stack([*indices,
                                                    values])  #Q_square
            except ValueError:
                #Cropping track to fit in the box
                missing_lenth = len(Qs) - len(values)
                indices = np.concatenate((indices, (n_pixels - 1) * np.ones(
                    (2, missing_lenth))),
                                         axis=1)
                values = np.concatenate((values, np.zeros(missing_lenth)),
                                        axis=0)
                tracks_cube[k, 1, :, :] = np.stack([*indices,
                                                    values])  #Q_square

    if sim:
        return tracks_cube, angles_sq, abs_pts_sq, mom_phis_sq, mom_abs_pts_sq, flag
    else:
        return tracks_cube, mom_phi, mom_abs_pts_sq, flag


def hex2square(hex_tracks,
               cut=None,
               n_final=None,
               augment=3,
               n_pixels=50,
               shift=2):
    """ Applied hex2square transformation to set of hexagonal tracks. Output depends on whether
    tracks are simulated or measured (real).
    """
    print("\n Beginning hex -> square conversion \n")
    if isinstance(hex_tracks, tuple):
        assert n_final is not None
        assert n_final <= len(hex_tracks[0]['DETPHI2'][cut])
        results = [None] * n_final
        i = 0
        j = 0
        while j < n_final:
            if cut[i]:
                results[j] = hex2square_sub(hex_tracks[0][i],
                                            hex_tracks[1][i],
                                            augment=augment)
                j += 1
                if (j % int(n_final / 20) == 0):
                    print("{} of {} tracks constructed.".format(j, n_final))
            i += 1

        tracks_cum, angles_cum, abs_pts_cum, mom_phi_cum, mom_abs_pts_cum, flag_cum = zip(
            *results)
        angles_cum = torch.from_numpy(np.array(angles_cum).astype(np.float))
        abs_pts_cum = torch.from_numpy(np.array(abs_pts_cum).astype(np.float))
        mom_phi_cum = torch.from_numpy(np.array(mom_phi_cum).astype(np.float))
        mom_abs_pts_cum = torch.from_numpy(
            np.array(mom_abs_pts_cum).astype(np.float))
        print("Final size: ", mom_phi_cum.shape)
        print("Flagged {} tracks.".format(int(np.sum(flag_cum))))
        flag_cum = torch.from_numpy(np.array(flag_cum).astype(np.int16))
        print("Finished \n")
        return tracks_cum, angles_cum, mom_phi_cum, abs_pts_cum, mom_abs_pts_cum, flag_cum
    else:
        results = [None] * len(hex_tracks)
        for i, hex_track in enumerate(hex_tracks):
            results[i] = hex2square_sub(hex_track, augment=augment)
            if (i % int(len(hex_tracks) / 20) == 0):
                print("{} of {} tracks constructed.".format(
                    i, len(hex_tracks)))

        tracks_cum, mom_phi_cum, mom_abs_pts_cum, flag_cum = zip(*results)
        mom_phi_cum = torch.from_numpy(np.array(mom_phi_cum).astype(np.float))
        mom_abs_pts_cum = torch.from_numpy(
            np.array(mom_abs_pts_cum).astype(np.float))
        print("Final size: ", mom_phi_cum.shape)
        print("Flagged {} tracks.".format(int(np.sum(flag_cum))))
        flag_cum = torch.from_numpy(np.array(flag_cum).astype(np.int16))
        print("Finished \n")
        return tracks_cum, mom_phi_cum, mom_abs_pts_cum, flag_cum