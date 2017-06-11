#!/bin/bash

i=$1
p=$2
cd $p
echo $i
pwd

#nw_ed $i/bestMLestimatedgenetree/estimatedgenetre.jc.rerooted.final 'i & (b<=0)' o > $i/bestMLestimatedgenetree/estimatedgenetre.jc.rerooted.final.contracted.0; 
nw_ed $i/bestMLestimatedgenetree/estimatedgenetre.jc.rerooted.final 'i & (b<3)' o > $i/bestMLestimatedgenetree/estimatedgenetre.jc.rerooted.final.contracted.3; 
nw_ed $i/bestMLestimatedgenetree/estimatedgenetre.jc.rerooted.final 'i & (b<5)' o > $i/bestMLestimatedgenetree/estimatedgenetre.jc.rerooted.final.contracted.5; 
nw_ed $i/bestMLestimatedgenetree/estimatedgenetre.jc.rerooted.final 'i & (b<7)' o > $i/bestMLestimatedgenetree/estimatedgenetre.jc.rerooted.final.contracted.7; 
#nw_ed $i/bestMLestimatedgenetree/estimatedgenetre.jc.rerooted.final 'i & (b<10)' o > $i/bestMLestimatedgenetree/estimatedgenetre.jc.rerooted.final.contracted.10; 
nw_ed $i/bestMLestimatedgenetree/estimatedgenetre.jc.rerooted.final 'i & (b<20)' o > $i/bestMLestimatedgenetree/estimatedgenetre.jc.rerooted.final.contracted.20; 
#nw_ed $i/bestMLestimatedgenetree/estimatedgenetre.jc.rerooted.final 'i & (b<25)' o > $i/bestMLestimatedgenetree/estimatedgenetre.jc.rerooted.final.contracted.25; 
#nw_ed $i/bestMLestimatedgenetree/estimatedgenetre.jc.rerooted.final 'i & (b<33)' o > $i/bestMLestimatedgenetree/estimatedgenetre.jc.rerooted.final.contracted.33;
#nw_ed $i/bestMLestimatedgenetree/estimatedgenetre.jc.rerooted.final 'i & (b<50)' o > $i/bestMLestimatedgenetree/estimatedgenetre.jc.rerooted.final.contracted.50;
#nw_ed $i/bestMLestimatedgenetree/estimatedgenetre.jc.rerooted.final 'i & (b<66)' o > $i/bestMLestimatedgenetree/estimatedgenetre.jc.rerooted.final.contracted.66; 
#nw_ed $i/bestMLestimatedgenetree/estimatedgenetre.jc.rerooted.final 'i & (b<75)' o > $i/bestMLestimatedgenetree/estimatedgenetre.jc.rerooted.final.contracted.75;
#nw_ed $i/bestMLestimatedgenetree/estimatedgenetre.jc.rerooted.final 'i & (b<90)' o > $i/bestMLestimatedgenetree/estimatedgenetre.jc.rerooted.final.contracted.90;
#nw_ed $i/bestMLestimatedgenetree/estimatedgenetre.jc.rerooted.final 'i & (b<100)' o > $i/bestMLestimatedgenetree/estimatedgenetre.jc.rerooted.final.contracted.100;
