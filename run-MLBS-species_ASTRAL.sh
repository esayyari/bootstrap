#!/bin/bash

H=$1
ID=$2
G=$3
ALIGNNAME=$4
BS=$5
DIR=$(cd "$(dirname ${BASH_SOURCE[0]})" && pwd)
echo $DIR
test "$#" -ne "5" && echo "$0 [REPLICATED_DIR] [REPLICATE_ID] [#GENES] [GENE_ALIGN_NAMES] [BS_NUMBER]" && exit 1
ast=$(basename `find $WS_HOME/ASTRAL -name "astral*.jar"`)

tmpdir=`mktemp -d`
cd $tmpdir

ls $H/$ID/*/$ALIGNNAME > list_BS_files.txt; 
while read x; do
sed -n "$BS,$BS p" $x 
done < list_BS_files.txt | head -n $G > "$ALIGNNAME"_"$BS"_"$G".gene_trees.trees
sed -i "s/_0_0//g" "$ALIGNNAME"_"$BS"_"$G".gene_trees.trees
sed -i "s/'//g" "$ALIGNNAME"_"$BS"_"$G".gene_trees.trees
java -Xmx4000M -jar $ast -i "$ALIGNNAME"_"$BS"_"$G".gene_trees.trees -o  "$ALIGNNAME"_"$BS"_"$G".species_tree.trees >"$ALIGNNAME"_"$BS"_"$G".log.info 2>&1
test "$#" -ne "0" && echo "something wrong has happened" && exit 1
cd ..
k=$(basename $tmpdir)
mkdir -p $H/$ID/MLBS_$G
mv $k $H/$ID/MLBS_$G/$BS
echo "Done"


