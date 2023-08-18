#!/bin/bash

#SBATCH -o logrecon1.log
#SBATCH --time=16:00:00
#SBATCH --job-name=r1-01002601
#SBATCH -c 4

source nnpipe_setup.sh
source ~/.bashrc
cd ~/gpdsw
source setup.sh
cd bin

./ixperecon --write-tracks --input-files "$DATA_FILDER"event_l1/"$FILENAME".fits --threshold 20 --output-folder $WORKING_DIR
