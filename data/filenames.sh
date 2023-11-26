if [ -z ${VERSION1+x} ];
then
    export VERSION1=$VERSION
    export VERSION2=$VERSION
    export VERSION3=$VERSION
fi

if test "$DET" = "1"
then
    export VERSION=$VERSION1
fi

if test "$DET" = "2"
then
    export VERSION=$VERSION2
fi

if test "$DET" = "3"
then
    export VERSION=$VERSION3
fi

echo $VERSION

export PREFIX="/home/groups/rwr/jtd/IXPEML/"
export DATA_FOLDER=$PREFIX"data/"$DATA_SUBDIR"/"$SEQ"/"
export RAW_FILENAME="event_l1/ixpe"$OBS"_det"$DET"_evt1_v"$VERSION
export FILENAME="recon/ixpe"$OBS"_det"$DET"_evt1_v"$VERSION # recon
export NN_FOLDER=$DATA_FOLDER'recon/'$SOURCE'-det'$DET/


export FINAL_FOLDER=$DATA_FOLDER"event_nn"
export FINAL_FILENAME="ixpe"$OBS"_det"$DET"_nn"

echo $OBS $DET
