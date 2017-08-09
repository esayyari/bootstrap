#!/bin/bash
seq=$1


tmp=`mktemp`

tail -n +2 $seq > $tmp
sed -i '/^[[:space:]]*$/d' $tmp
awk '{name=$1; seq=$2; printf ">%s\n%s\n",name,seq;}' $tmp 

rm $tmp

