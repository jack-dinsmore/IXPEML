from astropy.io import fits
import sys, shutil
import numpy as np

nn_file = sys.argv[2]
in_file = sys.argv[1]
out_file = sys.argv[3]

with fits.open(nn_file) as hdul:
    table = hdul[1].data
    nn_phi = table["NN_PHI"]
    nn_weight = table["NN_WEIGHT"]
    xy_nn_abs = table["XY_NN_ABS"]
    nn_energy = table["NN_ENERGY"]
    p_tail = table["P_TAIL"]
    flag = table["FLAG"]

pi = np.round((nn_energy - 0.020) / 0.040).astype(int)
print([np.nanpercentile(pi, i) for i in range(0, 105, 10)])

unwrapped_flags = np.zeros((len(flag), 16), bool)
for i in range(16):
    unwrapped_flags[:,i] = (flag & (1 << i)) != 0

shutil.copy(in_file, out_file)

with fits.open(out_file, mode="update") as hdul:
    hdul.info()
    columns = hdul[1].columns
    flags = hdul[1].data["STATUS2"] | unwrapped_flags
    
    # Update old columns
    columns["DETPHI2"].data = nn_phi
    columns["PI"].data = pi
    columns["ABSX"].data = xy_nn_abs[:,0]
    columns["ABSY"].data = xy_nn_abs[:,1]
    columns["STATUS2"].data = flags 

    # Add new column
    columns.add_col(fits.Column(array=p_tail, name="P_TAIL", format="1E"))
    columns.add_col(fits.Column(array=nn_weight, name="W_NN", format="1E"))

    header = hdul[1].header
    hdul[1] = fits.BinTableHDU.from_columns(columns, header)
    
    hdul.flush()

with fits.open(out_file) as hdul:
    hdul.info()
