import numpy as np
from astropy.io import fits
import matplotlib.pyplot as plt

fig, axs = plt.subplots(ncols=2, figsize=(12,6))
with fits.open("data_leakage_01002601_gx301-det2___gx301-det2__ensemble.fits") as hdul:
    print(hdul[1].columns)
    xs = hdul[1].data["XY_NN_ABS"][:,0]
    ys = hdul[1].data["XY_NN_ABS"][:,1]

    axs[0].hist2d(xs, ys, bins=np.linspace(-5,5, 80))

with fits.open("data_leakage_01002601_gx301-det1___gx301-det1__ensemble.fits") as hdul:
    print(hdul[1].columns)
    xs = hdul[1].data["XY_NN_ABS"][:,0]
    ys = hdul[1].data["XY_NN_ABS"][:,1]

    axs[1].hist2d(xs, ys, bins=np.linspace(-5,5, 80))
    fig.savefig("fig.png")
