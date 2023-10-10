#!/bin/bash
#
#SBATCH -o log-nn-gx99-d1.log
#SBATCH --job-name=NN-gx99-d1
#SBATCH --time=12:00:00
#SBATCH --ntasks=1
##SBATCH --cpus-per-task=2
#SBATCH --mem=32G
#SBATCH --partition=owners
#SBATCH --gres gpu:2
#SBATCH -C GPU_MEM:16GB
##SBATCH -C GPU_BRD:GEFORCE
##SBATCH -C GPU_SKU:RTX_2080Ti
##SBATCH -C GPU_CC:7.5

#source ~/mlixpe.sh
#module load py-pytorch/1.11.0_py39
#module load py-h5py/3.7.0_py39
#module load cuda/12.2.0
#module load cudnn/7.6.5
#module load ifort/2019

source ~/mlnn.sh

SEQ='01002401'
OBS='01002401'
VERSION='01'
SOURCE='gx99'
ATTNUM='1'

DET='1'
EVT='1'

PREFIX="/home/groups/rwr/jtd/IXPEML/"
DATA_FOLDER=$PREFIX"data/leakage/"$SEQ"/"
RAW_FILENAME="event_l1/ixpe"$OBS"_det"$DET"_evt"$EVT"_v"$VERSION
FILENAME="recon/ixpe"$OBS"_det"$DET"_evt"$EVT"_v"$VERSION # recon
NN_FOLDER=$DATA_FOLDER''$SOURCE'-det'$DET'/'


FINAL_FOLDER=$DATA_FOLDER"event_nn"
FINAL_FILENAME="ixpe"$OBS"_det"$DET"_nn"

echo $OBS $DET

cd ..
echo $SOURCE"-det"$DET
echo $DATA_FOLDER
nvidia-smi
python3 run_ensemble_eval.py $SOURCE"-det"$DET --data_list $NN_FOLDER --batch_size 512
