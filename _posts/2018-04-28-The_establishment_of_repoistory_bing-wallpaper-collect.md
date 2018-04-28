---
layout: default
title: The establishment of repoistory bing-wallpaper-collect
date: 2018-04-28 22:39:03 +0800
categories: sort_out
---

# The establishment of repoistory bing-wallpaper-collect

## The purpose of this repoistory
The backgrounds of [bing](https://cn.bing.com) is always good, and it refresh every day, I use them as wallpaper, log-in background, grub background, and so on. I always download them manually, It may not very troublesome, but my touchpad's right key broken recently, so I decided to download it automatically.

And I think: why not push it on github? It can also published to my github page, and then people can browse them, and download their favorite, so I established this repoistory.

## The implement of auto download
I wrote a simple script [curl.sh](https://sirius1242.github.io/script/curl.sh) first, and it can automatically download today's bing wallpaper. However, I need to run it with cron, so I need to modify it to fit my need.

```sh
#!/bin/bash

[[ -z $1 ]] && workdir='/root/git/bing-wallpaper/assets/' || workdir=$1
site=cn.bing.com
cd $workdir
text=`wget -O- $site`
if [[ -z $text ]]; then
	echo "connecting to $site failed!" | mail -s "bing-wallpaper" root
fi
url=`echo $text | grep img={url | sed -n 's#.*\(/az/[^"]*\).*#\1#;p'`
filename=`echo $url | awk -F/ '{print $NF}'`
echo file:$site$url
if [[ -e $filename ]]; then
	echo "file exist!" | mail -s "bing-wallpaper" root
	echo "file exist!"
else
	wget -O $workdir$filename https://$site/$url
	git add $filename
	git commit -a -m `date -I`
	git push origin master
fi
```

The script is based on string processing, and I extract the background image address from the source code of [cn.bing.com](https://cn.bing.com), I don't know it will always work properly or not, if the execute get into trouble, I will receive e-mail, I will let it run until I receive it.

I run it in my server by cron, and I also have local repoistory, I can pull from server when I need.

## Publish to GitHub Page
There are too many wallpapers, so it's not easy to select, so I decide to list it in my GitHub Page. But I met many problems.

- Firstly, I put the wallpapers in the root of git repository (It's just a directory which stores these wallpapers before I type `git init`.) However, I need to traversal these pictures, and they can't be find by jekyll. So, I can only put them into a new directory, and I had to adjust my `XDG_PICTURE_DIR` variable :(
- After I move all wallpapers into `assets/` directory, I can traversal them as static files. However, the repository always have error when building, and then I found there are tabs in `_config.yml` because I edited it by vim :(
- (During the commits, I found I need to modify some early commits, and then I found `git rebase` is very useful.)
- After this problem solved, the pictures can't be displayed, and then I found the links of pictures weren't right. My site is [sirius1242.github.io](https://sirius1242.github.io), and this bing-wallpaper-collect repoistory is hooked as [sirius1242.github.io/bing-wallpaper-collect](https://sirius1242.github.io/bing-wallpaper-collect), so the links are like `sirius1242.github.io/assets/xxx.jpg`, and my main repoistory didn't have these files XD. Finally, I decide to use relative url in my `index.md`, and then they can be shown properly as you see XD.

After all, I hope this repoistory can make sense.
