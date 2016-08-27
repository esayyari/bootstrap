#!/bin/bash
set -x
tmp=`mktemp -d`
cd $tmp
if [ ! -s $1/sequence.tar.gz ]; then
	tar czvf $1/sequence.tar.gz $1/*.fas $1/all-genes.phylip
fi
cp $1/sequence.tar.gz $tmp
tar xzvf $tmp/sequence.tar.gz
s="-p $RANDOM"
for k in `find $tmp -name "*.phy" | head -n 2`; do
	ktt=$(basename $k | sed -e 's/_TRUE.phy//')
	d=$(dirname $k)
	kt=$(basename $k)
	mkdir $d/$ktt
	cd $d/$ktt
	raxmlHPC -m GTRGAMMA -n best.gtr -s $k $s -N $2  &> $d/"$ktt".gtr.log.best_std.errout
	raxmlHPC -m GTRGAMMA --JC69 -n best.jc -s $k $s -N $2  &> $d/"$ktt".jc.best_std.errout
done
cd $$tmp
rm $d/*.phy
rm $d/*.fas
rm $tmp/*.tar.gz
cat $d/*/RAxML_bestTree.best.jc  > $tmp/estimatedgenetre.jc
cat $d/*/RAxML_bestTree.best.gtr > $tmp/estimatedgenetre.gtr
tar czvf $1/estimatedgenetrees-raxml.tar.gz $tmp/*

echo $tmp
rm -r $tmp

