#!/bin/bash
set -x
file=$1
starting=$2
ending=$3

for i in `seq $starting $ending`; do
	command=$(sed -n "$i,$i p" $file);
<<<<<<< HEAD
	eval "${command}"
=======
	eval ${command};	
	test #? -ne 0 && echo "something happend!" && exit 1
>>>>>>> a8e94dc7d9079c64029e7ee2512fab9b5f87bfea
done
echo "done"
	
