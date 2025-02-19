#!/bin/bash

#SBATCH -olog-runl1.log
#SBATCH --job-name=runl1
#SBATCH --partition=kipac
#SBATCH --mem=16GB
#SBATCH --cpus-per-task=4

source ~/mlixpe.sh
source $HEADAS/headas-init.sh; source $CALDB/software/tools/caldbinit.sh
source source_select2.sh
export HEADASNOQUERY=
export HEADASPROMPT=/dev/null

export DET='2'
source filenames.sh

OUT_FOLDER=$DATA_FOLDER'/recon/l1-d'$DET'.log'
OUT_FOLDER2=$DATA_FOLDER'/recon/l1-d'$DET'-repeat.log'

sh l1.sh &> $OUT_FOLDER
sh l1-repeat.sh &> $OUT_FOLDER2

grep -n 'Segmentation' $OUT_FOLDER
grep -n 'Traceback' $OUT_FOLDER
grep -n 'ERROR' $OUT_FOLDER

grep -n 'Segmentation' $OUT_FOLDER2
grep -n 'Traceback' $OUT_FOLDER2
grep -n 'ERROR' $OUT_FOLDER2
