#!/bin/bash
set -x
H=$1
ID=$2
G=$3
ALIGNNAME=$4
bs=$5
DIR=$(cd "$(dirname ${BASH_SOURCE[0]})" && pwd)
echo $DIR
test "$#" -ne "5" && echo "$0 [REPLICATED_DIR] [REPLICATE_ID] [#GENES] [GENE_ALIGN_NAMES] [BS_NUMBER]" && exit 1
ast=$(basename `find $WS_HOME/ASTRAL -name "astral*.jar"`)

tmpdir=`mktemp -d`
cd $tmpdir

ls $H/$ID/*/$ALIGNNAME > list_BS_files.txt; 
BS=$(printf "%03d\n" $bs)
if [ -d "$H/$ID/MLBS_$G/$BS" ]; then
	if [ -s "$H/$ID/MLBS_$G/$BS/"$ALIGNNAME"_"$BS"_"$G".species_tree.trees" ]; then
		echo "species tree was infered previousely";
		exit 0
	fi
fi
while read x; do
sed -n "$BS,$BS p" $x 
done < list_BS_files.txt | head -n $G > "$ALIGNNAME"_"$BS"_"$G".gene_trees.trees
sed -i "s/_0_0//g" "$ALIGNNAME"_"$BS"_"$G".gene_trees.trees
sed -i "s/'//g" "$ALIGNNAME"_"$BS"_"$G".gene_trees.trees
java -Xmx9000M -jar $WS_HOME/ASTRAL/$ast -i "$ALIGNNAME"_"$BS"_"$G".gene_trees.trees -o  "$ALIGNNAME"_"$BS"_"$G".species_tree.trees > "$ALIGNNAME"_BS"$BS"_"$G".log.info 2>&1
test "$?" -ne "0" && echo "something wrong has happened" && cp "$ALIGNNAME"_BS"$BS"_"$G".log.info $H/$ID/ && exit 1
mkdir -p $H/$ID/MLBS_$G/$BS
cd ..
k=$(basename $tmpdir)
mkdir -p $H/$ID/MLBS_$G/$BS
mv $k/* $H/$ID/MLBS_$G/$BS/
echo "Done"


