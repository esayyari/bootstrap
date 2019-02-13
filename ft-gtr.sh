#!/bin/bash
set -x
host=$(hostname | grep -oe "comet\|gordon")
if [ "$host" == "comet" ]; then
	TMPDIR=/oasis/scratch/comet/$USER/temp_project/multiind
else
	TMPDIR=/oasis/tscc/scratch/$USER/
fi
tmpd=`mktemp --tmpdir=$TMPDIR -d`
tmp=`mktemp --tmpdir=$TMPDIR -d`
#if [ ! -s $1/sequence.tar.gz ]; then
#	tar czvf $1/sequence.tar.gz $1/*.fas $1/all-genes.phylip
#fi
echo $tmpd
cd $tmpd
cp $1/sequence.tar.gz $tmpd 
tar xzvf $tmpd/sequence.tar.gz --wildcards --no-anchored "*.fas" 
tar xzvf $tmpd/sequence.tar.gz --wildcards --no-anchored "all-genes.phylip"
a=$(find $tmpd -name "*.fas" | head -n 1)
at=$(dirname $a) 

cd $tmp
x=$(find $tmpd -name "all-genes.phylip")
echo $x
mv $x $tmp/all-genes.phylip

l=$tmp
ml=$(cat $tmp/all-genes.phylip | wc -L )
echo $ml
w=$2
echo $w
if [ "$w" == "all" ]; then
	cp $1/truegenetrees $tmp/truegenetrees
	n=$(cat $tmp/truegenetrees | wc -l)
	w=$n
else
	head -n $w $1/truegenetrees > $tmp/truegenetrees
	n=$w
fi
tf=$tmp/true.tmp;
egf=$tmp/estimated-gtr.tmp;
comptmp=$tmp/compare.tmp;
w2=$w

if [ "$ml" -gt "13000" ]; then
	mv $at/*.fas $tmp/
        var=$(find $tmp -name "*.fas" | head -n 1 | sed -e 's/.*\///' | sed -e 's/.fas//')	
	digit=$(echo "${#var}")

	for i in ` seq  1 $w2 | tr ' ' '\n' |  sort | head -n $w`; do
		i=$(printf "%0"$digit"d" $i)
		k=$l/$i.fas	
		sed -n "$i,$i"p $tmp/truegenetrees > $tf
		kt=$(basename $k)
		ogtr=$tmp/estimatedgenetre.gtr
		fasttree -nt -gtr -nopr -gamma $k >>  $tmp/estimatedgenetre.gtr 2>> $tmp/estimatedgenetre.gtr.info
		test "$?" -ne 0 && echo "an error encountered" && exit 1
		tail -n 1 $tmp/estimatedgenetre.gtr > $egf
		di=$(nw_stats $egf | grep "dichotomies" | sed -e 's/.*:\t//g');
        	if [ "$di" -eq "0" ] || [ "$di" -eq "1" ]; then
                	echo "- - 1" > $comptmp;
	        else
                $WS_HOME/global/src/shell/compareTrees.missingBranch $egf $tf > $comptmp;
        	fi;
	        $WS_HOME/global/src/shell/compareTrees.missingBranch $tf $egf >> $comptmp;
        	cat $comptmp | tr '\n' ' ' >> $tmp/score-estimategenetre-gtr.sc;
	        echo "" >> $tmp/score-estimategenetre-gtr.sc;
        	done
else
	x=$l/all-genes.phylip
	ogtr=$tmp/estimatedgenetre.gtr

	fasttree -nt -gtr -nopr -gamma -n $n $x > $ogtr 2>$ogtr.info
fi
a=$(cat $ogtr | wc -l)
at=$n
test "$a" -ne "$at" && echo "number of estimated gene trees is $a not equal to $at number of true gene trees" && exit 1

if [ "$ml" -le "13000" ]; then
	while read t<&3 && read eg<&4; do
        	echo $t > $tf;
	        echo $eg > $egf;
        	di=$(nw_stats $egf | grep "dichotomies" | sed -e 's/.*:\t//g');
	        if [ "$di" -eq "0" ] || [ "$di" -eq "1" ]; then
        	        echo "- - 1" > $comptmp;
	        else
        	        $WS_HOME/global/src/shell/compareTrees.missingBranch $egf $tf > $comptmp;
	        fi;
        	$WS_HOME/global/src/shell/compareTrees.missingBranch $tf $egf >> $comptmp;
	        cat $comptmp | tr '\n' ' ' >> $tmp/score-estimategenetre-gtr.sc;
        	echo "" >> $tmp/score-estimategenetre-gtr.sc;
	done  3<$tmp/truegenetrees 4<$tmp/estimatedgenetre.gtr;
fi
a=$(seq -w 1 $w2 | tr ' ' '\n' | head -n 1)
if [ -s $tmp/$a.fas ]; then
	rm  $tmp/*.fas
fi
tar czvf $1/estimatedgenetrees.tar.gz $tmp/*
rm $tmpd/sequence.tar.gz
rm -r $tmpd/tmp*
cp $1/estimatedgenetrees.tar.gz $tmpd
cd ~
rm -r $tmp

