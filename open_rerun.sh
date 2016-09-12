#!/bin/bash
st=$1
en=$2
source ~/.alias
cd $home1/data/simphy/tre/
for i in `seq $st $en`; do 
	j=$(rl $i | sed -e 's/.*\///'); 
	echo $j; 
	cd $j; 
	rm -r tmp; 
	tar xzvf estimatedgenetrees.tar.gz;
	mv tmp es; 
	mv es/tmp*/all-genes.phylip .;  
	tar xzvf sequence.tar.gz; 
	for i in `seq -w 1 2000`; do  
		rm $i/*; mv tmp/tmp.*/$i* $i/; 
		echo $i; 
	done; 
	rm -r tmp; 
	mv es tmp; 
	cd ../; 
	tar czvf $j.tar.gz $j/*
	test "$?" -eq "0" && cp $j.tar.gz $home2/data/simphy/tre
	if [ "$?" -eq "0" ]; then
		a=$(cd $home2/data/simphy/tre/; pwd; rm -r $j; tar xzvf $j.tar.gz);
	else
		echo "something  was wrong!"
		exit 1
	fi
 done
