#!/bin/bash
set -x
file=$1
starting=$2
ending=$3

for i in `seq $starting $ending`; do
	command=$(sed -n "$i,$i p" $file);
	eval ${command};	
	test #? -ne 0 && echo "something happend!" && exit 1
done
echo "done"
	
