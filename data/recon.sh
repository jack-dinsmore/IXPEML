#!/bin/bash

#SBATCH -o log-recon.log
#SBATCH --time=16:00:00
#SBATCH --job-name=recon
#SBATCH --partition=kipac
#SBATCH --mem 16G
#SBATCH -c 4

SEQ='02002399'
OBS='02002302'
VERSION='01'
SOURCE="4u"
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




cd ~/gpdsw
source setup.sh
cd bin

echo "$DATA_FOLDER"event_l1/"$FILENAME".fits
./ixperecon --write-tracks --input-files "$DATA_FOLDER"event_l1/ixpe"$OBS"_det"$DET"_evt"$EVT"_v"$VERSION".fits --threshold 20 --output-folder /home/groups/rwr/jtd/IXPEML/data/recon-no-event
