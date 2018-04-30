#!/bin/bash

[[ -z $2 ]] && editor="vim" || editor=$2
filename=_posts/`date +%Y-%m-%d-``echo $1 | sed 's/\ /\_/g'`.md
echo $filename
yaml="---\nlayout: content\ntitle: $1\ndate: `date '+%Y-%m-%d %H:%M:%S'` +0800\ncategories: \n---\n"
if [ -e "$filename" ]
then
	echo "$filename found."
	$editor $filename
else
	touch $filename
	echo -e $yaml > $filename
	$editor $filename
fi
