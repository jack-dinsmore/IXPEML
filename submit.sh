#!/bin/bash
#
#SBATCH -o msh-gen.log
#SBATCH --job-name=GPUtest
#SBATCH --time=80:00
#SBATCH --ntasks=1
##SBATCH --cpus-per-task=2
#SBATCH --mem=16G
#SBATCH --partition=owners
#SBATCH --gres gpu:2
#SBATCH -C GPU_MEM:16GB
##SBATCH -C GPU_BRD:GEFORCE
##SBATCH -C GPU_SKU:RTX_2080Ti
##SBATCH -C GPU_CC:7.5

N="9"

nvidia-smi
python3 run_ensemble_eval.py nn_msh --data_list data/02001399/recon/ --batch_size 512
