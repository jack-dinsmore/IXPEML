import numpy as np
from astropy.io import fits
import sys

filename = sys.argv[1]
with fits.open(filename) as hdul:
    events = hdul[1].data
    print(len(events))
    print("All events", [np.nanpercentile(events["PI"], i) for i in range(0, 105, 10)])

    if "STATUS2" in events.names:
        events = events[np.all(~events["STATUS2"], axis=1)]
    print(len(events))
    print("Unflagged events", [np.nanpercentile(events["PI"], i) for i in range(0, 105, 10)])
