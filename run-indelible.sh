#!/bin/bash
#set -x
tmp=`mktemp /oasis/tscc/scratch/esayyari/largeN/tmp.XXXXX -d`
cd $tmp
cp $1/control.txt $tmp/
cp $1/truegenetrees $tmp/
cp $1/*trees $tmp/
indelible
cat *phy | sed '/^[[:space:]]*$/d' > all-genes.phylip

#rm *phy

tar czvf $1/sequence.tar.gz $tmp/*
cp all-genes.phylip $1/
echo $tmp
rm -r $tmp
