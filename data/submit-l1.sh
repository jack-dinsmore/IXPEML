#!/bin/bash

#SBATCH -olog-l1.log
#SBATCH --job-name l1
#SBATCH --partition=kipac
#SBATCH --mem=16GB
#SBATCH -t 02:00:00
#SBATCH --cpus-per-task=4

source ~/.bashrc
source ~/mlixpe.sh
source $HEADAS/headas-init.sh; source $CALDB/software/tools/caldbinit.sh

# gx301
SEQ='01002601'
OBS='01002601'
VERSION='02'
SOURCE="gx301"
ATTNUM='1'

# gx301 mom
#SEQ='m1002601'
#OBS='01002601'
#VERSION='02'
#SOURCE="gx301"
#ATTNUM='1'

# 4u
#SEQ='02002399'
#OBS='02002302'
#VERSION='01'
#SOURCE="4u"
#ATTNUM='1'

# gx99
#SEQ='01002401'
#OBS='01002401'
#VERSION='01'
#SOURCE='gx99'
#OBS='02001901'
#VERSION='02'
#SOURCE='lmc'
#ATTNUM='2'

# sim
# gx301
# gx301 mom
#SEQ='m1002601'

# 4u
#ATTNUM='1'

#SOURCE='gx99'
#ATTNUM='1'
#SEQ='02001901'
#OBS='02001901'
# sim
#SEQ='00000000'
#OBS='00000000'
#VERSION='01'
#SOURCE='sim'
#ATTNUM='1'

DET='2'
EVT='1'

PREFIX="/home/groups/rwr/jtd/IXPEML/"
DATA_FOLDER=$PREFIX"data/leakage/"$SEQ"/"
RAW_FILENAME="event_l1/ixpe"$OBS"_det"$DET"_evt"$EVT"_v"$VERSION
FILENAME="recon/ixpe"$OBS"_det"$DET"_evt"$EVT"_v"$VERSION # recon
NN_FOLDER=$DATA_FOLDER'recon/'$SOURCE'-det'$DET/


FINAL_FOLDER=$DATA_FOLDER"event_nn"
FINAL_FILENAME="ixpe"$OBS"_det"$DET"_nn"

echo $OBS $DET



fdelcol $DATA_FOLDER"$FILENAME"_recon.fits[EVENTS] STATUS2 no yes
faddcol $DATA_FOLDER"$FILENAME"_recon.fits[EVENTS] $DATA_FOLDER"$FILENAME".fits[EVENTS] STATUS2

fdump $DATA_FOLDER"$RAW_FILENAME".fits[0] tmp.lis - 1 prdata=yes showcol=no
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

echo "Writing NN results in"
python3 write.py $DATA_FOLDER"$FILENAME"'_recon_gain_corr_map.fits' $NN_FILE $DATA_FOLDER"$FILENAME"_recon_nn.fits
#ftpaste $DATA_FOLDER"$FILENAME"'_recon_gain_corr_map.fits[EVENTS][col -DETPHI2;]' $NN_FILE'[1][col NN_PHI, DETPHI2==NN_PHI; NN_WEIGHT, W_NN==NN_WEIGHT; XY_NN_ABS[0], ABSX==ABSX; P_TAIL; FLAG]' $DATA_FOLDER"$FILENAME"_recon_nn.fits history=YES clobber=True
echo "Done writing NN results"
#######

ixpecalcstokes infile=$DATA_FOLDER"$FILENAME"_recon_nn.fits outfile=$DATA_FOLDER"$FILENAME"_recon_nn_stokes.fits clobber=True
# Use nn spmod files for spurious modulation correction.

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

fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] PAKTNUMB no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] SEC no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] MICROSEC no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] LIVETIME no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] MIN_CHIPX no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] MAX_CHIPX no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] MIN_CHIPY no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] MAX_CHIPY no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] ROI_SIZE no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] ERR_SUM no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] DU_STATUS no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] DSU_STATUS no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] NUM_CLU no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] NUM_PIX no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] EVT_FRA no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] SN no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] TRK_SIZE no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] TRK_BORD no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] PHA no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] PHA_EQ no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] DETPHI1 no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] ABSX no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] ABSY no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] BARX no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] BARY no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] TRK_M2T no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] TRK_M2L no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] TRK_M3L no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] TRK_SKEW no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] PHA_T no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] PHA_CHG no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] DETPHI2 no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] W_NN no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] P_TAIL no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] FLAG no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] DETPHI no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] DETX no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] DETY no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] DETQ no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME".fits[1] DETU no yes

