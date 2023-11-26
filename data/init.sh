#!/bin/bash

#SBATCH -olog-init.log
#SBATCH --partition=kipac
#SBATCH --mem=24GB
#SBATCH --job-name=init
#SBATCH -t 08:00:00

source ~/mlixpe.sh
source source_select.sh
source $HEADAS/headas-init.sh; source $CALDB/software/tools/caldbinit.sh

export HEADASNOQUERY=
export HEADASPROMPT=/dev/null

set -e

export DET='1'
source filenames.sh

ftcopy $DATA_FOLDER"$RAW_FILENAME"'.fits[EVENTS][STATUS2 == b0x0000000000x00x]' $DATA_FOLDER"$FILENAME"'.fits' clobber=True

ixpeevtrecon infile=$DATA_FOLDER"$FILENAME".fits outfile=$DATA_FOLDER$FILENAME'_recon.fits' clobber=True writeTracks=True 1> /dev/null 

## Add some missing header values.
fdump $DATA_FOLDER"$RAW_FILENAME".fits[1] tmp.lis - 1 prdata=yes showcol=no
grep -i S_VDRIFT tmp.lis >> fix.lis
grep -i S_VBOT tmp.lis >> fix.lis
grep -I S_VGEM tmp.lis >> fix.lis
echo "FILE_LVL = '1'" >> fix.lis

fthedit $DATA_FOLDER"$FILENAME"_recon.fits @fix.lis
rm tmp.lis fix.lis


export DET='2'
source filenames.sh

ftcopy $DATA_FOLDER"$RAW_FILENAME"'.fits[EVENTS][STATUS2 == b0x0000000000x00x]' $DATA_FOLDER"$FILENAME"'.fits' clobber=True

ixpeevtrecon infile=$DATA_FOLDER"$FILENAME".fits outfile=$DATA_FOLDER$FILENAME'_recon.fits' clobber=True writeTracks=True 1> /dev/null

## Add some missing header values.
fdump $DATA_FOLDER"$RAW_FILENAME".fits[1] tmp.lis - 1 prdata=yes showcol=no
grep -i S_VDRIFT tmp.lis >> fix.lis
grep -i S_VBOT tmp.lis >> fix.lis
grep -I S_VGEM tmp.lis >> fix.lis
echo "FILE_LVL = '1'" >> fix.lis

fthedit $DATA_FOLDER"$FILENAME"_recon.fits @fix.lis
rm tmp.lis fix.lis


export DET='3'
source filenames.sh

ftcopy $DATA_FOLDER"$RAW_FILENAME"'.fits[EVENTS][STATUS2 == b0x0000000000x00x]' $DATA_FOLDER"$FILENAME"'.fits' clobber=True

ixpeevtrecon infile=$DATA_FOLDER"$FILENAME".fits outfile=$DATA_FOLDER$FILENAME'_recon.fits' clobber=True writeTracks=True 1> /dev/null

## Add some missing header values.
fdump $DATA_FOLDER"$RAW_FILENAME".fits[1] tmp.lis - 1 prdata=yes showcol=no
grep -i S_VDRIFT tmp.lis >> fix.lis
grep -i S_VBOT tmp.lis >> fix.lis
grep -I S_VGEM tmp.lis >> fix.lis
echo "FILE_LVL = '1'" >> fix.lis

fthedit $DATA_FOLDER"$FILENAME"_recon.fits @fix.lis
rm tmp.lis fix.lis
