#!/bin/bash

#SBATCH -olog-runl1-sim.log
#SBATCH --job-name=runl1
#SBATCH --partition=kipac
#SBATCH --mem=16GB
#SBATCH --cpus-per-task=4

source ~/mlixpe.sh
source $HEADAS/headas-init.sh; source $CALDB/software/tools/caldbinit.sh
source source_select.sh
export HEADASNOQUERY=
export HEADASPROMPT=/dev/null

export DET='1'
source filenames.sh

OUT_FOLDER=$DATA_FOLDER'/recon/l1-d'$DET'.log'

echo $RAW_FILENAME

ixpeweights infile=$DATA_FOLDER"$FILENAME"_recon.fits outfile=$DATA_FOLDER"$FILENAME"_w.fits clobber=True &> $OUT_FOLDER

