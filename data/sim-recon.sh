#!/bin/bash

~/gpdsw/bin/ixperecon --write-tracks \
            --input-files leakage/00000000/event_l1/ixpe00000000_det1_evt1_v01.fits \
            --threshold 20\
            --output-folder leakage/00000000/recon\


