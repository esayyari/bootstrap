#!/bin/bash
set -x
tmp=`mktemp --tmpdir=/tmp/ -d`



tru=$1
est=$2

bas=$(basename $est);
das=$(dirname $est);

mkdir $das/directory.$bas/

cd $tmp

tf=$tmp/true.tmp;
egf=$tmp/estimated.tmp;
comptmp=$tmp/compare.tmp;


a=$(cat $est | grep -o ";" | wc -l) 
at=$(cat $tru | grep -o ";"| wc -l )
test "$a" -ne "$at" && echo "number of estimated gene trees is $a not equal to $at number of true gene trees" && exit 1

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
        cat $comptmp | tr '\n' ' ' >> $tmp/score-estimategenetre.sc;
        echo "" >> $tmp/score-estimategenetre.sc;
done  3<$tru 4<$est

cp $tmp/score-estimategenetre.sc $das/directory.$bas/score-estimategenetre.sc
rm -r $tmp

