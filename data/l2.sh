#!/bin/bash

#SBATCH -olog-l2.log
#SBATCH --partition=kipac

source nnpipe_setup.sh
source $HEADAS/headas-init.sh; source $CALDB/software/tools/caldbinit.sh

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
