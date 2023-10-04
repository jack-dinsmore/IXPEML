#!/bin/bash

#SBATCH -o log-hex-gx-d1.log
#SBATCH --time=16:00:00
#SBATCH --job-name=hex-gx-d1
#SBATCH --mem=16G
#SBATCH -c 8
#SBATCH --partition=kipac

# gx301
SEQ='01002601'
OBS='01002601'
VERSION='02'
SOURCE="gx301"
ATTNUM='1'

DET='1'
EVT='1'

PREFIX="/home/groups/rwr/jtd/IXPEML/"
DATA_FOLDER=$PREFIX"data/leakage/"$SEQ"/"
RAW_FILENAME="event_l1/ixpe"$OBS"_det"$DET"_evt"$EVT"_v"$VERSION
FILENAME="recon/ixpe"$OBS"_det"$DET"_evt"$EVT"_v"$VERSION # recon
NN_FOLDER=$DATA_FOLDER''$SOURCE'-det'$DET'/'


FINAL_FOLDER=$DATA_FOLDER"event_nn"
FINAL_FILENAME="ixpe"$OBS"_det"$DET"_nn"

echo $OBS $DET

cd ..
source ~/mlnn.sh
mkdir $NN_FOLDER

python3 -u run_build_fitsdata.py $DATA_FOLDER$FILENAME'_recon.fits' $NN_FOLDER
