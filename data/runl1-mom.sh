#!/bin/bash
#SBATCH -olog-l1-sim.log
#SBATCH --job-name=l1-sim
#SBATCH --partition=kipac
#SBATCH --mem=16GB
#SBATCH --cpus-per-task=4

export HEADASNOQUERY=
export HEADASPROMPT=/dev/null

source source_select.sh

ftcopy $DATA_FOLDER"$RAW_FILENAME"'.fits[EVENTS][STATUS2 == b0x0000000000x00x]' $DATA_FOLDER"$FILENAME"'.fits' clobber=True

OUT_FOLDER=$DATA_FOLDER'/recon/l1-d'$DET'.log'

bash l1-mom.sh &> $OUT_FOLDER
bash l1-mom-repeat.sh

grep -n 'Segmentation' $OUT_FOLDER
grep -n 'Traceback' $OUT_FOLDER
grep -n 'ERROR' $OUT_FOLDER




export DET='2'
source filenames.sh

ftcopy $DATA_FOLDER"$RAW_FILENAME"'.fits[EVENTS][STATUS2 == b0x0000000000x00x]' $DATA_FOLDER"$FILENAME"'.fits' clobber=True

OUT_FOLDER=$DATA_FOLDER'/recon/l1-d'$DET'.log'

bash l1-mom.sh &> $OUT_FOLDER
bash l1-mom-repeat.sh

grep -n 'Segmentation' $OUT_FOLDER
grep -n 'Traceback' $OUT_FOLDER
grep -n 'ERROR' $OUT_FOLDER




export DET='3'
source filenames.sh

ftcopy $DATA_FOLDER"$RAW_FILENAME"'.fits[EVENTS][STATUS2 == b0x0000000000x00x]' $DATA_FOLDER"$FILENAME"'.fits' clobber=True

OUT_FOLDER=$DATA_FOLDER'/recon/l1-d'$DET'.log'

bash l1-mom.sh &> $OUT_FOLDER
bash l1-mom-repeat.sh

grep -n 'Segmentation' $OUT_FOLDER
grep -n 'Traceback' $OUT_FOLDER
grep -n 'ERROR' $OUT_FOLDER
