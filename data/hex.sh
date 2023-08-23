#!/bin/bash

#SBATCH -o loghex1.log
#SBATCH --time=16:00:00
#SBATCH --job-name=hex1-01002601
#SBATCH -c 8

source nnpipe_setup.sh
source $HEADAS/headas-init.sh; source $CALDB/software/tools/caldbinit.sh
#source ~/.bashrc
cd ..

python3 -u run_build_fitsdata.py $DATA_FOLDER$FILENAME'_recon.fits' $DATA_FOLDER
