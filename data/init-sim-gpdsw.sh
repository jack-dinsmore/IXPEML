#!/bin/bash

#SBATCH -olog-init-sim.log
#SBATCH --partition=kipac
#SBATCH --job-name=init-sim
#SBATCH --mem=24GB
#SBATCH -t 02:00:00

source ~/mlixpe.sh
source ./source_select.sh
source $HEADAS/headas-init.sh; source $CALDB/software/tools/caldbinit.sh

export HEADASNOQUERY=
export HEADASPROMPT=/dev/null

set -e

export DET='1'
source filenames.sh

echo $DATA_FOLDER"$RAW_FILENAME".fits
echo $DATA_FOLDER'/recon/'

cd ~/gpdsw/bin/ 
./ixperecon --write-tracks \
            --input-files $DATA_FOLDER"$RAW_FILENAME".fits\
            --threshold 20\
            --output-folder $DATA_FOLDER'recon/'
