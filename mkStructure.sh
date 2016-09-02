#!/bin/bash
mkdir -p $home2/data/simphy/tre
cd $home2/data/simphy/tre
for dir in `seq -w 1 550`; do
	mkdir -p $dir
	for i in `seq -w 1 2000`; so
		mkdir -p $dir/$i
		tar xzf $dir/sequence.tar.gz *$i* 
		mv tmp/tmp*/*$i* $dir/$i/
		rm -r tmp/tmp*
	done
	echo "working on $dir has been finished"
done
