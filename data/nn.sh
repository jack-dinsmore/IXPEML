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

#source ~/mlixpe.sh
#module load py-pytorch/1.11.0_py39
#module load py-h5py/3.7.0_py39
#module load cuda/12.2.0
#module load cudnn/7.6.5
#module load ifort/2019

module unload python
module load system
module load physics
module load ncurses
module load zlib
module load readline
module load perl
module load expat
module load x11
module load boost/1.64.0
module load gcc/10.1.0
module load libressl/3.2.1
module load viz
module load python/3.6
module load py-numpy/1.18.1_py36
module load py-astropy
module load py-scipy/1.4.1_py36
module load py-matplotlib/3.2.1_py36
module load cuda/12.2.0
module load cudnn/7.6.5
module load py-pytorch/1.6.0_py36
module load gh
module load git
module load py-h5py/3.1.0_py36

source nnpipe_setup.sh
cd ..
echo $SOURCE"-det"$DET
echo $DATA_FOLDER
nvidia-smi
python3 run_ensemble_eval.py $SOURCE"-det"$DET --data_list $DATA_FOLDER --batch_size 512
