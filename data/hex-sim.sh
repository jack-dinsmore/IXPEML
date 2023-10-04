#!/bin/bash

#SBATCH -o log-hex-sim.log
#SBATCH --time=16:00:00
#SBATCH --job-name=hex-sim
#SBATCH --mem=16G
#SBATCH -c 8

SEQ='00000000'
OBS='00000000'
VERSION='01'
SOURCE='sim'
ATTNUM='1'

DET='1'
EVT='1'

PREFIX="/home/groups/rwr/jtd/IXPEML/"
DATA_FOLDER=$PREFIX"data/leakage/"$SEQ"/"
RAW_FILENAME="event_l1/ixpe"$OBS"_det"$DET"_evt"$EVT"_v"$VERSION
FILENAME="recon/ixpe"$OBS"_det"$DET"_evt"$EVT"_v"$VERSION # recon


FINAL_FOLDER=$DATA_FOLDER"event_nn"
FINAL_FILENAME="ixpe"$OBS"_det"$DET"_nn"

echo $OBS $DET

source ~/mlnn.sh
source $HEADAS/headas-init.sh; source $CALDB/software/tools/caldbinit.sh
#source ~/.bashrc
cd ..

python3 -u run_build_fitsdata.py $DATA_FOLDER$FILENAME'_recon.fits' $DATA_FOLDER
