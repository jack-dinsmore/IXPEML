#!/bin/bash

#SBATCH -olog-runl1-%j.log
#SBATCH --job-name=runl1
#SBATCH --partition=kipac
#SBATCH --mem=16GB
#SBATCH --cpus-per-task=4
#SBATCH -t 08:00:00

source ~/mlixpe.sh
source $HEADAS/headas-init.sh; source $CALDB/software/tools/caldbinit.sh
source source_select.sh
export HEADASNOQUERY=
export HEADASPROMPT=/dev/null

export DET='1'
source filenames.sh

OUT_FOLDER=$DATA_FOLDER'recon/'$OBS'l1-d'$DET'.log'
OUT_FOLDER2=$DATA_FOLDER'recon/'$OBS'l1-d'$DET'-repeat.log'

sh l1.sh &> $OUT_FOLDER
sh l1-repeat.sh &> $OUT_FOLDER2

echo "Round 1"
grep -n 'Segmentation' $OUT_FOLDER
grep -n 'Traceback' $OUT_FOLDER
grep -n 'ERROR' $OUT_FOLDER

echo "Round 2"
grep -n 'Segmentation' $OUT_FOLDER2
grep -n 'Traceback' $OUT_FOLDER2
grep -n 'ERROR' $OUT_FOLDER2


export DET='2'
source filenames.sh


OUT_FOLDER=$DATA_FOLDER'recon/'$OBS'l1-d'$DET'.log'
OUT_FOLDER2=$DATA_FOLDER'recon/'$OBS'l1-d'$DET'-repeat.log'

sh l1.sh &> $OUT_FOLDER
sh l1-repeat.sh &> $OUT_FOLDER2

echo "Round 1"
grep -n 'Segmentation' $OUT_FOLDER
grep -n 'Traceback' $OUT_FOLDER
grep -n 'ERROR' $OUT_FOLDER

echo "Round 2"
grep -n 'Segmentation' $OUT_FOLDER2
grep -n 'Traceback' $OUT_FOLDER2
grep -n 'ERROR' $OUT_FOLDER2

export DET='3'
source filenames.sh

OUT_FOLDER=$DATA_FOLDER'recon/'$OBS'l1-d'$DET'.log'
OUT_FOLDER2=$DATA_FOLDER'recon/'$OBS'l1-d'$DET'-repeat.log'

sh l1.sh &> $OUT_FOLDER
sh l1-repeat.sh &> $OUT_FOLDER2

echo "Round 1"
grep -n 'Segmentation' $OUT_FOLDER
grep -n 'Traceback' $OUT_FOLDER
grep -n 'ERROR' $OUT_FOLDER

echo "Round 2"
grep -n 'Segmentation' $OUT_FOLDER2
grep -n 'Traceback' $OUT_FOLDER2
grep -n 'ERROR' $OUT_FOLDER2

