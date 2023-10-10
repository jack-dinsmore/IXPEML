#!/bin/bash

#SBATCH -o log-tmp.log
#SBATCH --time=1:00:00
#SBATCH --job-name=tmp
#SBATCH --mem=4G
#SBATCH -c 4
#SBATCH --partition=normal

source ~/mlixpe.sh
source nnpipe_setup.sh
source $HEADAS/headas-init.sh; source $CALDB/software/tools/caldbinit.sh


ixpeadjmod infile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes.fits outfile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_adj.fits clobber=True spmodfile="$PREFIX"caldb/spmod/ixpe_d"$DET"_20170101_spmod_nn.fits

