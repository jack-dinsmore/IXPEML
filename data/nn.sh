#!/bin/bash
#
#SBATCH -o log-nn.log
#SBATCH --job-name=NN1-01002601
#SBATCH --time=8:00:00
#SBATCH --ntasks=1
##SBATCH --cpus-per-task=2
#SBATCH --mem=24G
#SBATCH --partition=owners
#SBATCH --gres gpu:2
#SBATCH -C GPU_MEM:16GB
##SBATCH -C GPU_BRD:GEFORCE
##SBATCH -C GPU_SKU:RTX_2080Ti
##SBATCH -C GPU_CC:7.5

source nnpipe_setup.sh
cd ..
nvidia-smi
python3 run_ensemble_eval.py $SOURCE"-det"$DET --data_list $DATA_FOLDER --batch_size 512
