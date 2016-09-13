#!/bin/bash
DIR=$( cd $(dirname "${BASH_SOURCE[0]}") && pwd)
H=$1
ID=$2
G=$3
ALIGNNAME=$4
test $# -ne "4" && echo "USAGE: $0 [path_to_replicates] [replicate_ID] [#GENES] [GENE_NAMES]" && exit 1
ast=$(basename `find $WS_HOME/ASTRAL -name "astral.*jar"`)
echo $ast
echo $DIR
tmpdir=`mktemp -d`
cd $tmpdir

head -n $G $H/$ID/$ALIGNNAME > estimated"$G".gene_trees.trees

java -Xmx4000M -jar $WS_HOME/ASTRAL/$ast -i estimated"$G".gene_trees.trees -o estimated"$G".species_tree.trees > info."$G".log 2>&1
test $? -ne "0" && echo "something was wrong" && exit 1
k=$(basename $tmpdir)
j=$(dirname $tmpdir)
cd ../
mv $k $H/$ID/ASTRAL_SPECIES"$G"
echo "Done"

