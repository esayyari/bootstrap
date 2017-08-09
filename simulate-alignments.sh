#!/bin/bash

perl post_stidsim.pl tre 1
for r in `seq -w 1 50`; do 
	
	sed -i 's/_0_0//g' tre/$r/g_trees[0-9]*.trees
	cat tre/$r/g_trees[0-9]*.trees > tre/$r/truegenetrees; 
	rm  tre/$r/g_trees[0-9]*.trees; 
	echo "working on $r has been finished"
done
