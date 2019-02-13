#!/bin/bash

#set -x

module load python
module load dendropy
DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")"  && pwd )
echo "USAGE: ${BASH_SOURCE[0]} [alignment name without fasta or phylip at the end] [Replicate ID (each gene seperately)] [GENEID in replicate ID] [path (directory where all replicates located)] [label (a label for this run)] [repnum (number of replicates for each boostrapping] [reppartiallen (length of each replicate)] [randomraxml (random number)] [number_to_run from what replicate you want to continue]"
test $# == 9 || exit 1
ALIGNAME=$1
ID=$2
GENEID=$3
path=$4
label=$5
repnum=$6
reppartiallen=$7
randomraxml=$8
number_to_run=$9
rep=$(( repnum * reppartiallen ))
repstart=$(( repnum * reppartiallen - reppartiallen + 1 ))
repend=$(( repnum * reppartiallen ))
total_number_to_run=$(( $number_to_run + $repend - $repstart ))
in=$ALIGNAME
u="-p $randomraxm_"
dirn=fasttreboot."$in"."$label".start_"$repstart".end_"$repend".uandomraxml_"$randomraxml"

host=$(hostname | grep -o "comet\|gordon\|tscc")
if [ "$host" == "tscc" ]; then
	mkdir -p $path/$ID/$GENEID
	outpath=$path/$ID/$GENEID
else
	outpath=$inpath/
fi
inpath=$path/$ID/$GENEID/
seqpath=$path/$ID/sequence/
echo $seqpath
echo $outpath
echo $inpath
wdone=$outpath/done."$ALIGNAME".repstart_"$number_to_run".repend_"$total_number_to_run".randraxml_"$randomraxml"
if [ -s "$wdone" ]; then
	wDone=$(cat $wdone | grep -o "Done");
	test "$wDone" == "Done" && echo "wokring on this $wdone partition was finished previousely!" && exit 0
fi
tmpdir=`mktemp -d`
ls $seqpath/$ALIGNAME
cp $seqpath/$ALIGNAME $tmpdir/$ALIGNAME
cp $seqpath/$GENEID.fas $tmpdir/$GENEID.fas
maxLen=$(cat $tmpdir/$GENEID.fas | wc -L)

#sed -i 's/_0_0//g' $tmpdir/$ALIGNAME
cd $tmpdir
pwd
mkdir logs

test "`head -n 1 $ALIGNAME`" == "0 0" && exit 1

model=GTRGAMMA
ftmodel="-nt -nopr -gamma -gtr"

mkdir $dirn
cd $dirn

#Figure out if main ML has already finished
 


#Figure out if bootstrapping has already finished
#Bootstrap if not done yet
crep=$rep
  # if bootstrapping is partially done, resume from where it was left
if [ -s RAxML_info.BS ]; then
	  rm RAxML_info.BS	
fi
if [ -s fast*.BS* ]; then
	rm fast*.BS*
fi
rnd=$randomraxml
raxmlHPC  -s ../$ALIGNAME -f j -b $rnd -n BS -m $model -# $crep
mv ../*.BS* .
if [ "$maxLen" -lt "13000" ]; then
  	for bs in `seq $(( repstart - 1)) $(( crep - 1 ))`; do
		
   		cat "$ALIGNAME".BS"$bs" >> "$ALIGNAME".BS-all
  	done
else
	for bs in `seq $(( repstart - 1)) $(( crep - 1 ))`; do
		cat "$ALIGNAME".BS"$bs" | tail -n +2 | sed -e 's/^/>/'| sed -e 's/ $//' | sed -e 's/ \+/ /g' | tr ' ' '\n' | grep -e "[>A-Za-z0-9]" > "$GENEID".fas.BS$bs
	done
	
fi


if [ "$maxLen" -lt "13000" ]; then
  	ttrep=$(( repend -repstart  + 1 ))
  	fasttree $ftmodel -n $ttrep $ALIGNAME.BS-all > fasttree.tre.BS-all 2> ft.log.BS-all;  
  	test $? == 0 || { cat ft.log.BS-all; exit 1; }
else
  	for bs in `seq $(( repstart - 1)) $(( crep - 1 ))`; do
		fasttree -nt -nopr -gamma "$GENEID"*fas*BS"$bs" > fasttree.tre.BS$bs 2>ft.log.BS$bs;
		test $? == 0 || { cat ft.log.BS$bs; exit 1; }
  	done
  	cat fasttree.tre.BS* > fasttree.tre.BS-all
  	cat ft.log.BS* >  ft.log.BS-all
  	rm fasttree.tre.BS[0-9]*
  	rm ft.log.BS[0-9]*
fi



sp=$(head -n 1 fasttree.tre.BS-all | nw_labels -I - | wc -l)
if [ ! `grep ";" fasttree.tre.BS-all | wc -l` -eq $ttrep ]; then

	echo `pwd`>>$outpath/notfinishedproperly
	echo "repstart is $repstart, rep end is $repend, $randraxml" >> $outpath/notfinishedproperly
	echo "the error is the number of trees is not equal to $ttrep" >> $outpath/notfinishedproperly 
	exit 1
fi
while read x; do
		if [ ! `echo $x | nw_labels -I - | wc -l` -eq "$sp" ]; then
			echo `pwd`>>$outpath/notfinishedproperly
		    	echo "repstart is $repstart, rep end is $repend, $randraxml" >> $outpath/notfinishedproperly	
			echo "number of species is not constantly equal to $sp" >> $outpath/notfinishedproperly
			exit 1
		fi
done < fasttree.tre.BS-all
trep=$(( $repend - $repstart + 1 ))
g=$(cat fasttree.tre.BS-all | grep -o ";" | wc -l)
test "$g" -ne "$trep" && echo "repstart is $repstart, rep end is $repend, $randraxml, gene trees was not computed properly" >> $outpath/notfinishedproperly && exit 1
 #Finalize
 
mkdir -p $outpath/genetrees."$ALIGNAME".repstart_"$number_to_run".repend_"$total_number_to_run".randraxml_"$randomraxml"/
cp fasttree.tre.BS-all $outpath/genetrees."$ALIGNAME".repstart_"$number_to_run".repend_"$total_number_to_run".randraxml_"$randomraxml"/fasttree.tre.BS-all
tar cfj $outpath/genetrees.tar.bz."$ALIGNAME".repstart_"$number_to_run".repend_"$total_number_to_run".randraxml_"$randomraxml" $tmpdir 
cd $outpath/
echo "Done">$outpath/done."$ALIGNAME".repstart_"$number_to_run".repend_"$total_number_to_run".randraxml_"$randomraxml"
