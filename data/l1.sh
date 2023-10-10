#!/bin/bash

#SBATCH -olog-l1.log
#SBATCH --job-name=l1
#SBATCH --partition=kipac
#SBATCH --mem=16GB
#SBATCH --cpus-per-task=4

source ~/mlixpe.sh
source nnpipe_setup.sh
source $HEADAS/headas-init.sh; source $CALDB/software/tools/caldbinit.sh

#######

fdelcol $DATA_FOLDER"$FILENAME"_recon.fits[EVENTS] STATUS2 no yes
faddcol $DATA_FOLDER"$FILENAME"_recon.fits[EVENTS] $DATA_FOLDER"$FILENAME".fits[EVENTS] STATUS2

fdump $DATA_FOLDER"$RAW_FILENAME".fits[0] tmp.lis - 1 prdata=yes showcol=no
grep -i S_VDRIFT tmp.lis >> fix.lis
grep -i S_VBOT tmp.lis >> fix.lis
grep -I S_VGEM tmp.lis >> fix.lis
echo "FILE_LVL = '1'" >> fix.lis

fmodhead $DATA_FOLDER"$FILENAME"_recon.fits fix.lis
rm tmp.lis fix.lis

#######
echo "Starting IXPE pipeline"

ixpegaincorrtemp infile=$DATA_FOLDER"$FILENAME"_recon.fits outfile=$DATA_FOLDER"$FILENAME"_recon_gain.fits hkfile="$DATA_FOLDER"hk/ixpe"$OBS"_all_pay_132"$DET"_v01.fits clobber=True logfile=recon.log

#######

ixpechrgcorr infile=$DATA_FOLDER"$FILENAME"_recon_gain.fits outfile=$DATA_FOLDER"$FILENAME"_recon_gain_corr.fits initmapfile="$CALDB"/data/ixpe/gpd/bcf/chrgmap/ixpe_d"$DET"_20170101_chrgmap_01.fits outmapfile=$DATA_FOLDER"$FILENAME"_chrgmap.fits phamax=60000.0 clobber=True

#######

export HEADAS=/home/groups/rwr/alpv95/tracksml/moments/heasoft-6.30.1/x86_64-pc-linux-gnu-libc2.17
source $HEADAS/headas-init.sh; source $CALDB/software/tools/caldbinit.sh

ixpegaincorrpkmap infile=$DATA_FOLDER"$FILENAME"_recon_gain_corr.fits outfile=$DATA_FOLDER"$FILENAME"_recon_gain_corr_map.fits clobber=True pkgainfile=CALDB hvgainfile=CALDB

python3 test.py $DATA_FOLDER"$FILENAME"_recon_gain_corr_map.fits

export HEADAS=/home/groups/rwr/jtd/heasoft-6.32.1/x86_64-pc-linux-gnu-libc2.17
source $HEADAS/headas-init.sh; source $CALDB/software/tools/caldbinit.sh

#######

NN_FILE=$PREFIX'data_leakage_'$SEQ'_'$SOURCE'-det'$DET'___'$SOURCE'-det'$DET'__ensemble.fits'

python3 write.py $DATA_FOLDER"$FILENAME"'_recon_gain_corr_map.fits' $NN_FILE $DATA_FOLDER"$FILENAME"_recon_nn.fits

#######

ixpecalcstokes infile=$DATA_FOLDER"$FILENAME"_recon_nn.fits outfile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes.fits clobber=True

#######

ixpeadjmod infile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes.fits outfile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_adj.fits clobber=True spmodfile="$PREFIX"caldb/spmod/ixpe_d"$DET"_20170101_spmod_nn.fits

#######

ixpeweights infile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_adj.fits outfile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_adj_w.fits clobber=True

#######

## Add some missing header values.
yes | ftlist $DATA_FOLDER"$RAW_FILENAME".fits["EVENTS"] outfile=STDOUT ROWS=0 | grep TC > wcs.lis
sed -i 's/36 /44 /;s/37 /45 /' wcs.lis
echo -e "TLMIN44 = 1\nTLMAX44 = 600\nTLMIN45 = 1\nTLMAX45 = 600" >> wcs.lis
fthedit $DATA_FOLDER"$FILENAME"_recon_nn_stokes_adj_w.fits["EVENTS"] @wcs.lis

# Delete the events with the wrong status
fdelcol $DATA_FOLDER"$FILENAME"_recon_nn_stokes_adj_w.fits[EVENTS] STATUS2 no yes
faddcol $DATA_FOLDER"$FILENAME"_recon_nn_stokes_adj_w.fits[EVENTS] $DATA_FOLDER""$FILENAME".fits[EVENTS]" STATUS2


#######

# Purge the terminal environment for some reason otherwise the wrong xspec will be loaded
tput reset && source ~/.bash_profile
source ~/.bashrc

source ~/mlixpe.sh
source nnpipe_setup.sh
source $HEADAS/headas-init.sh; source $CALDB/software/tools/caldbinit.sh

#######

echo "About to start ixpedet2j2000"
## Coordinate transformations.
ixpedet2j2000 infile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_adj_w.fits outfile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_adj_w_j2000.fits attitude="$DATA_FOLDER"hk/ixpe"$OBS"_det"$DET"_att_v0"$ATTNUM".fits clobber=True

#######

cp $DATA_FOLDER"$FILENAME"_recon_nn_stokes_adj_w_j2000.fits $DATA_FOLDER"$FILENAME"_recon_nn_stokes_adj_w_j2000_int.fits

echo "About to start ixpeaspcorr"
ixpeaspcorr infile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes_adj_w_j2000.fits clobber=True n=300 att_path="$DATA_FOLDER"hk/ixpe"$OBS"_det"$DET"_att_v0"$ATTNUM".fits

echo "Done"
echo

#######

mkdir -p $FINAL_FOLDER
cp $DATA_FOLDER"$FILENAME"_recon_nn_stokes_adj_w_j2000.fits $FINAL_FOLDER/"$FINAL_FILENAME".fits

#######

source l2.sh

