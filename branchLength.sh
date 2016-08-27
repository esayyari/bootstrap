#!/bin/bash
Path=/oasis/projects/nsf/uot136/esayyari/data/simphy/tre
tmpdir=`mktemp -d`
source ~/.alias
cd $tmpdir
for i in `seq -w $1 $2`; do
        mkdir $i
        cp $Path/$i/truegenetrees $i
	rm $Path/$i/gtbranchlength.info.*
        while read x; do
                echo $x | nw_distance -m p -s a - | mysum - >> $i/genetree_branchlengths.bl;
        done < $i/truegenetrees;
        echo $i;
done

tar czvf $Path/genetree_branchlengths$1-"$2".tar.gz ./*

rm -r $tmpdir
