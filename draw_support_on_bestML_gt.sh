#!/bin/bash
i=$1
p=$2
cd $p
f=$3
h=$4
for j in `seq -w 1 $f`; do
	if [ "$h" != "" ]; then
		jt=${j}_${h}
	else
		jt=${j}
	fi
	if [ ! -d $i/$jt/bestMLestimatedgenetree/ ]; then

		mkdir -p $i/$jt/bestMLestimatedgenetree/; 

	fi
	if [ "$h" != "" ]; then
		e=bestMLestimatedgenetree_"$h"
		b=estimatedgenetre_"$h".gtr
	else
		e=bestMLestimatedgenetree
		b=estimatedgenetre.gtr
	fi
	echo $b;
	sed -n "$j,$j p" $i/$e/$b > $i/$jt/bestMLestimatedgenetree/$b; 

	cat $i/$jt/genetrees."$jt"_TRUE.phy.repstart*/fasttree.tre.BS-all > $i/$jt/bestMLestimatedgenetree/fasttree.bootstrap.all.tre; 

	ngt=$(cat $i/$jt/bestMLestimatedgenetree/fasttree.bootstrap.all.tre | wc -l);

	if [ "$ngt" -ne "100" ]; then
		echo in $i,$jt there is no 100 bootstrap gene trees, instead there is $ngt
	fi
 
	g=$(nw_labels -I $i/$jt/bestMLestimatedgenetree/$b | head -n 1 ); 

	nw_reroot $i/$jt/bestMLestimatedgenetree/$b $g > $i/$jt/bestMLestimatedgenetree/$b.rerooted; 

	nw_reroot $i/$jt/bestMLestimatedgenetree/fasttree.bootstrap.all.tre $g > $i/$jt/bestMLestimatedgenetree/fasttree.bootstrap.all.tre.rerooted; 

	ngt=$(cat $i/$jt/bestMLestimatedgenetree/$b.rerooted | wc -l)
	if [ "$ngt" -ne "1" ]; then
		echo in $i,$jt there is no rooted bestML gene tree, instead there is $ngt
	fi

	nw_support -p $i/$jt/bestMLestimatedgenetree/$b.rerooted $i/$jt/bestMLestimatedgenetree/fasttree.bootstrap.all.tre > $i/$jt/bestMLestimatedgenetree/$b.rerooted.final;
	
	echo working on $i, $jt finished
done
cat $i/*/bestMLestimatedgenetree/$b.rerooted.final > $i/bestMLestimatedgenetree/$b.rerooted.final
