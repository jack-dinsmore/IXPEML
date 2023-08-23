# gx301
#SEQ='01002601'
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
SEQ='01002401'
OBS='01002401'
VERSION='01'
SOURCE='gx99'
ATTNUM='1'

DET='2'
EVT='1'

PREFIX="/home/groups/rwr/jtd/IXPEML/"
DATA_FOLDER=$PREFIX"data/leakage/"$SEQ"/"
RAW_FILENAME="event_l1/ixpe"$OBS"_det"$DET"_evt"$EVT"_v"$VERSION
FILENAME="recon/ixpe"$OBS"_det"$DET"_evt"$EVT"_v"$VERSION # recon


FINAL_FOLDER=$DATA_FOLDER"event_nn"
FINAL_FILENAME="ixpe"$OBS"_det"$DET"_nn"

echo $OBS $DET

# sh init.sh
# sbatch recon.sh
# sbatch hex.sh
# sbatch nn.sh
# sh l2.sh
