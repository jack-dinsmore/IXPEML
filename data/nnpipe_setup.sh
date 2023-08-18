#SEQ='01002601'
#OBS='01002601'
SEQ='02002399'
OBS='02002302'
DET='3'
EVT='1'
VERSION='01'
ATTNUM='1'
SOURCE="4u"

PREFIX="/home/groups/rwr/jtd/IXPEML/"
DATA_FOLDER=$PREFIX"data/leakage/"$SEQ"/"
RAW_FILENAME="event_l1/ixpe"$OBS"_det"$DET"_evt"$EVT"_v"$VERSION
FILENAME="recon/ixpe"$OBS"_det"$DET"_evt"$EVT"_v"$VERSION # recon/


WORKING_DIR=$DATA_FOLDER"tmp/"
FINAL_FOLDER=$DATA_FOLDER"event_nn"
FINAL_FILENAME="ixpe"$OBS"_det"$DET"_nn"

# sh init.sh
# sbatch recon.sh
# sbatch hex.sh
# sbatch nn.sh
# sh l2.sh
