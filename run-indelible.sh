#!/bin/bash
#set -x
tmp=`mktemp -d`
cd $tmp
cp $1/* $tmp/
indelible
cat *phy | sed '/^ *$/d' > all-genes.phylip

#rm *phy

tar czvf $1/sequence.tar.gz $tmp/*
echo $tmp
rm -r $tmp
