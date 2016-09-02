#!/bin/bash
#set -x
tmp=`mktemp -d`
cd $tmp
cp $1/control.txt $tmp/
cp $1/truegenetrees $tmp/
cp $1/*trees $tmp/
indelible
cat *phy | sed '/^ *$/d' > all-genes.phylip

#rm *phy

tar czvf $1/sequence.tar.gz $tmp/*
echo $tmp
rm -r $tmp
