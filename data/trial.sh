source ~/mlixpe.sh
source nnpipe_setup.sh
source $HEADAS/headas-init.sh; source $CALDB/software/tools/caldbinit.sh

#######

NN_FILE=$PREFIX'data_leakage_'$SEQ'_'$SOURCE'-det'$DET'___'$SOURCE'-det'$DET'__ensemble.fits'

echo "Writing NN results in"
python3 write.py $DATA_FOLDER"$FILENAME"'_recon_gain_corr_map.fits' $NN_FILE $DATA_FOLDER"$FILENAME"_recon_nn.fits



#######

ixpecalcstokes infile=$DATA_FOLDER"$FILENAME"_recon_nn.fits outfile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes.fits clobber=True
# Use nn spmod files for spurious modulation correction.

#######

ixpeadjmod infile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes.fits outfile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_adj.fits clobber=True spmodfile="$PREFIX"caldb/spmod/ixpe_d"$DET"_20170101_spmod_nn.fits


echo "DONE"
