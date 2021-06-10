#! /bin/bash
if [ -d $2 ]
then
	mount --bind $1 $2
else
	mkdir -p $2
	mount --bind $1 $2
fi
