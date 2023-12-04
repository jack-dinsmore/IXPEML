#!/bin/bash

#SBATCH -o log-hex-%j.log
#SBATCH --time=64:00:00
#SBATCH --job-name=hex
#SBATCH --partition=kipac
#SBATCH --mem=24G
#SBATCH -c 4

source source_select.sh
source ~/mlnn.sh
source $HEADAS/headas-init.sh; source $CALDB/software/tools/caldbinit.sh
#source ~/.bashrc
cd ..

export DET='1'
source data/filenames.sh
mkdir $NN_FOLDER
python3 -u run_build_fitsdata.py $DATA_FOLDER$FILENAME'_recon.fits' $NN_FOLDER

export DET='2'
source data/filenames.sh
mkdir $NN_FOLDER
python3 -u run_build_fitsdata.py $DATA_FOLDER$FILENAME'_recon.fits' $NN_FOLDER

export DET='3'
source data/filenames.sh
mkdir $NN_FOLDER
python3 -u run_build_fitsdata.py $DATA_FOLDER$FILENAME'_recon.fits' $NN_FOLDER
