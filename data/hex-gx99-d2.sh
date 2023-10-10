#!/bin/bash

#SBATCH -o log-hex-gx99-d2.log
#SBATCH --time=16:00:00
#SBATCH --job-name=hex-gx99-d2
#SBATCH --mem=24G
#SBATCH -c 8
#SBATCH --partition=kipac


# 4u
SEQ='01002401'
OBS='01002401'
VERSION='01'
SOURCE="gx99"
ATTNUM='1'

DET='2'
EVT='1'

PREFIX="/home/groups/rwr/jtd/IXPEML/"
DATA_FOLDER=$PREFIX"data/leakage/"$SEQ"/"
RAW_FILENAME="event_l1/ixpe"$OBS"_det"$DET"_evt"$EVT"_v"$VERSION
FILENAME="recon/ixpe"$OBS"_det"$DET"_evt"$EVT"_v"$VERSION # recon
NN_FOLDER=$DATA_FOLDER''$SOURCE'-det'$DET'/'


FINAL_FOLDER=$DATA_FOLDER"event_nn"
FINAL_FILENAME="ixpe"$OBS"_det"$DET"_nn"

echo $OBS $DET

source ~/mlnn.sh
cd ..

mkdir $NN_FOLDER
python3 -u run_build_fitsdata.py $DATA_FOLDER$FILENAME'_recon.fits' $NN_FOLDER
