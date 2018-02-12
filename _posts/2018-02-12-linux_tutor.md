---
layout: default
title:  "linux tutor"
date:   2018-02-12 18:41:52 +0800
categories: jekyll update
---
# A basicall tutor to linux using
### these are based on my personal experience, only for advice
## mirrors config
### these are for chinese users, and I chose mirrors of USTC, for help of other mirrors, please check their official website
- [USTC mirrors](http://mirrors.ustc.edu.cn/)
- Archlinux: [Arch Linux mirrors help](http://mirrors.ustc.edu.cn/help/archlinux.html)
- Ubuntu: [Ubuntu Linux mirrors help](http://mirrors.ustc.edu.cn/help/ubuntu.html)
- Fedora: [Fedora Linux mirrors help](http://mirrors.ustc.edu.cn/help/fedora.html)
## basical commands
- ls: 
	- if no arguments, to list all files in the current directory.
	- if argument is directory, list all files and directories under that directory.
	- if argument is a regular expression, list files whose file name match the regex.
	- there are some options, such as -a, it can list all files including whose filename begin with a '.'.
	- '-l' to list informations in detail.
	- '-h' to make the size human-readable

	```sh
	ls -hl

	总用量 20K
	-rw-r--r-- 1 lwr lwr   25 2月  12 16:14 _config.yml
	drwxr-xr-x 2 lwr lwr 4.0K 2月  12 16:23 file
	-rw-r--r-- 1 lwr lwr 1.6K 2月  12 16:27 index.md
	drwxr-xr-x 3 lwr lwr 4.0K 2月  12 16:45 _posts
	-rw-r--r-- 1 lwr lwr  223 2月  12 16:17 README.md
	```

- cd:
	- change the directory, it will change current directory to the argument you added.
	- '..' is the parent directory of current directory, and '.' is current directory.

- pwd:
	show path of current directory

- man:
	- the command to help you learn more about linux commands.

- cp:
	- copy files

	```sh
	cp source destination
	```
	- if copy directory, you need to add '-r' option.

- rm:
	- remove the file
	- if remove directory, you need to add '-r' option, then it will travel all directories beneath destionation directory and it subdirectories and subdirectories of the subdirectories ..., and then totally remove the directory, you may need to add '-f' to directly remove without many confirms
	- **caution : it's not easy to recover files in linux, so carefully think before remove!!!** you can add "alias rm='rm -i'" in your shell rc file (~/.bashrc, ~/.zshrc and so on) to confirm you before remove.

- mv:
	- move files

	```sh
	mv source destination
	```
	- if __destination__ is a name not appeared in current directory, mv will change the name of __source__ to destionation.
	- if __destination__ is the filename of another file in current directory, mv will replace __destination__ with __source__ ('-i' will confirm before replace)
	- if __destination__ is the name of a directory under current directory, mv will move __source__ under the directory __destination__.

- history:
	to check the commands you have typed.

- locate:
	- to find files
	- it need to build a database of index, so sometimes you need to update database manually by __updatedb__ when you want to find a new file you created before a short period.

- vi(vim):
	- a good editor
	- there are also good other editors, such as emacs, visualstudiocode, and so on.

- find:
	- find files

	```sh
	find -name 'filename' -print
	```

- df:
	- check the disk usage, use '-h' to show space by 'K,M,G'.
	- there is a software with gui: __baobab__, it can analyse the usage of files in detail.

- sudo:
	- execute the command as root
	- **caution: it's a dangerous command, root have right to do anything, and it can also damage anything**

- ...

## anything is file

- devices are under '/dev' directory, you can use __mount__ command to mount block devices to certain directory, or use __unmount__ command to cancel the mount. Normal file can also be mounted, so you can directly check the files in iso file by mounting it.

- every file stored in certain blocks of your disk, and the file you saw in the directory is a pointer pointing to the file, and __ln__ command can create "hard link", which is another pointer in another location to the same file, and the file will disappear only when all pointers are removed, but it can only created in the same diskpart.

## pipe and redirect

- pipe:
	- make the output of the command before pipe as the input after the pipe.

	```sh
	ls |grep index

	index.md
	```

- redirect:
	- '<' '>' and '>>'

	```sh
	a.out < input.txt
	```

	use the content of __input.txt__ as the input of __a.out__

	```sh
	a.out > output.txt
	```

	export the output of __a.out__ to the file __output.txt

	```sh
	a.out >> output.txt
	```

	export the output of __a.out__ to the tail of file __output.txt

- file descriptor
	- 0: stdin
	- 1: stdout
	- 2: stderr

## some softwares in linux platform

- office: libreoffice and wps
- pdf: texlive
- input method: fcitx and ibus
- image processing: gimp and imagemagick, and inkscape is for editing vector illustrations.
- data processing: ipython (an interactive shell of python), scilab. Matlab and mathematica also have linux version.
- audio and video: mplayer (based on cli), vlc
- virtual machine: virtualbox (vmware have linux version.
- browser: firefox, chromium and so on
- dictionary: goldendict
- processes manager: htop (top is installed when system installed, but htop is more integrated and easier to use)
- learning with cards: anki
- games(XD): teeworlds and so on, steam platform have linux version, but the GPU driver of linux are not so good, so it many cause poor experience when playing games which need many resources.
