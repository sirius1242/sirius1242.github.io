#!/bin/bash

filename=_posts/`date +%Y-%m-%d-``echo $1 | sed 's/\ /\_/g'`.md
echo $filename
yaml="---\nlayout: default\ntitle: $1\ndate: `date '+%Y-%m-%d %H:%M:%S'` +0800\ncategories: jekyll update\n---\n## [Back to home]({{ site.url }}/)"
if [ -e "$filename" ]
then
	echo "$filename found."
	vim $filename
else
	touch $filename
	echo -e $yaml > $filename
	vim $filename
fi
