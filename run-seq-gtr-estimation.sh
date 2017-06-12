#!/bin/bash
set -x 
DIR="$( cd "$( dirname $0)" && pwd)"
#if [ ! -s $1/sequence.tar.gz ]; then
$DIR/run-indelible.sh $1
#fi
$DIR/ft-gtr.sh $1 $2
#tmpd=`mktemp -d`
#cp $1/estimatedgenetrees.tar.gz $tmpd
#cd $tmpd
#tar xzvf $tmpd/estimatedgenetrees.tar.gz
#ejc=$(find $tmpd/ -name "estimatedgenetre.jc")
#egt=$(find $tmpd/ -name "estimatedgenetre.gtr")
#sed -i 's/_0_0//g' $ejc
#sed -i 's/_0_0//g' $egt
#head -n $2 $1/truegenetrees > $tmpd/truegenetrees
#tmp=`mktemp`; 
#cp $1/s_tree.trees $tmpd
#tf=$tmpd/true.tmp;
#egf=$tmpd/estimated-gtr.tmp;
#ejf=$tmpd/estimated-jc.tmp;
#comptmp=$tmpd/compare.tmp;

#while read t<&3 && read eg<&4 && read ej<&5; do
#	echo $t > $tf;
#	echo $eg > $egf;
#	echo $ej > $ejf; 
#	di=$(nw_stats $egf | grep "dichotomies" | sed -e 's/.*:\t//g'); 
#	if [ "$di" -eq "0" ] || [ "$di" -eq "1" ]; then 
#		echo "- - 1" > $comptmp; 
#	else  
#		$WS_HOME/global/src/shell/compareTrees.missingBranch $egf $tf > $comptmp; 
#	fi; 
#	$WS_HOME/global/src/shell/compareTrees.missingBranch $tf $egf >> $comptmp; 
#	cat $comptmp | tr '\n' ' ' >> $tmpd/score-estimategenetre-gtr.sc; 
#	echo "" >> $tmpd/score-estimategenetre-gtr.sc; 
#       di=$(nw_stats $ejf | grep "dichotomies" | sed -e 's/.*:\t//g');
#        if [ "$di" == "0" ] || [ "$di" == "1" ]; then
#                echo "- - 1" > $comptmp;
#        else
#                $WS_HOME/global/src/shell/compareTrees.missingBranch $ejf $tf > $comptmp;
#        fi;
#        $WS_HOME/global/src/shell/compareTrees.missingBranch $tf $ejf >> $comptmp;
#        cat $comptmp | tr '\n' ' ' >> $tmpd/score-estimategenetre-jc.sc;
#        echo "" >> $tmpd/score-estimategenetre-jc.sc;
#done  3<$tmpd/truegenetrees 4<$egt 5<$ejc; 

#rm $comptmp;
#echo $tmpd
#rm $tf
#rm $egf
#rm $ejf
#tar czvf $1/results.tar.gz $tmpd/score-*.sc $ejc $egt
#rm -r $tmpd
#rm $tmp
