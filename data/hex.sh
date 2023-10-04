#!/bin/bash

#SBATCH -o log-hex.log
#SBATCH --time=16:00:00
#SBATCH --job-name=hex
#SBATCH --partition=kipac
#SBATCH --mem=16G
#SBATCH -c 8

source nnpipe_setup.sh
source $HEADAS/headas-init.sh; source $CALDB/software/tools/caldbinit.sh
#source ~/.bashrc
cd ..

mkdir $NN_FOLDER
python3 -u run_build_fitsdata.py $DATA_FOLDER$FILENAME'_recon.fits' $NN_FOLDER
