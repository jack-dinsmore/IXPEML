#!/bin/bash

#SBATCH -olog-l2.log
#SBATCH --partition=kipac

source nnpipe_setup.sh
source $HEADAS/headas-init.sh; source $CALDB/software/tools/caldbinit.sh

cp $FINAL_FOLDER/"$FINAL_FILENAME".fits $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits

fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits PAKTNUMB no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits SEC no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits MICROSEC no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits LIVETIME no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits MIN_CHIPX no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits MAX_CHIPX no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits MIN_CHIPY no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits MAX_CHIPY no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits ROI_SIZE no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits ERR_SUM no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits DU_STATUS no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits DSU_STATUS no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits NUM_CLU no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits NUM_PIX no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits EVT_FRA no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits SN no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits TRK_SIZE no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits TRK_BORD no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits PHA no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits PHA_EQ no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits DETPHI1 no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits ABSX no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits ABSY no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits BARX no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits BARY no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits TRK_M2T no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits TRK_M2L no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits TRK_M3L no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits TRK_SKEW no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits PHA_T no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits PHA_CHG no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits DETPHI2 no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits W_NN no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits P_TAIL no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits FLAG no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits DETPHI no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits DETX no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits DETY no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits DETQ no yes
fdelcol $FINAL_FOLDER/"$FINAL_FILENAME"_l2.fits DETU no yes
