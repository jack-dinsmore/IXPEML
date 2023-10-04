#!/bin/bash

#SBATCH --mem=16G
#SBATCH --partition=kipac
#SBATCH --time=16:00:00
#SBATCH -c 4
#SBATCH -n 1
#SBATCH -o log-sim.log
#SBATCH --job-name=sim


#source /home/groups/rwr/jtd/heasoft-6.32/x86_64-pc-linux-gnu-libc2.17/headas-init.sh; source /home/groups/rwr/jtd/caldb/software/tools/caldbinit.sh
source ~/gpdsw/setup.sh

~/gpdsw/bin/ixpesim -n 1000000 \
            --random-seed 194 \
            --output-file sim/sim_spec.fits \
            --log-file sim/log-sim.log \
            --src-spectrum user \
            --src-spec-file sim/flat.txt \
            --src-pol-degree 0 \
            --src-pol-angle 0 \
            --dme-pressure 687 \

echo "Fits splitting"
python3 ~/gpdsw/gpdswpy/fitsplit.py sim/sim_spec.fits 

