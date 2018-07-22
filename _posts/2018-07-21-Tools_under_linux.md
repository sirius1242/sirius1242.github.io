---
layout: content
title: Tools under Linux
date: 2018-07-21 19:26:09 +0800
categories: Linux
---

# This is a post about some good open source tools under Linux.

I think it will continue updating because I may find more good tools in my using.

## About graph processing
### [Gimp](https://www.gimp.org/)

Gimp is a powerful tool of graph processing, it includes many functions, I think if you are not very professional, it can replace of Adobe Photoshop. If you are familiar with Photoshop, it is not hard to study it.

![Gimp]({{ "/assets/gimp-shot.png" | absolute_url }})

### [Inkscape](https://inkscape.org/)

Inkscape is also a powerful tool, but it is for processing vector drawings. You can translate bitmap to vector by path scanning, or directly draw it by the tools like Bezier curves or other, and you can also do union, intersection and many other operations to paths. I haven't been used Adobe Illustrator, but I think their function may be similar.

![inkscape]({{ "/assets/inkscape-shot.png" | absolute_url }})

### [Imagemagick](https://www.imagemagick.org/script/index.php)

Imagemagick is a commandline tool, it nearly have no graphic interface, so it may be difficult to use at first. However, it can accurately cut, draw and do other operations by the coordinate, and it's also convenient to do some simple operations, such as reverse the color, convert the format, make a gif with many pictures and so on, I usually use these commands, but if I need to do some complex operations, I will change to other tool considering the time cost (I need to look up the manual or Google to get the command arguments, it may be time costing). I have a repository called [imagemagick-note](https://github.com/sirius1242/imagemagick-note), there are arguments of a few simple operations.

This is an example of adding background:

![add background]({{ "/assets/add-background.svg" | absolute_url }})

|:---:|---:|
|origin|after|
|![origin]({{ "/assets/imagemagick.png" | absolute_url }})|![after]({{ "/assets/imagemagick-background.png" | absolute_url }})|

## About graph viewing and managing
### [nomacs](https://nomacs.org/)

> nomacs is a free, open source image viewer, which supports multiple platforms. You can use it for viewing all common image formats including RAW and PSD images.

It's the best graph viewer I have used, you cannot only view graph, you can also do some simple editing, rename, check the meta information and other operations. It has the function of action synchronization, you can synchronize your action and edit in multiple instances, even in other machines though LAN. I think it's one of the best image viewers in Linux. However, it didn't have the function of copy by dragging, I think this function is useful.

![inkscape]({{ "/assets/nomacs-shot.png" | absolute_url }})

## About screenshot in Linux

### [flameshot](https://github.com/lupoDharkael/flameshot)

Flameshot is also a powerful screenshot tool in Linux. It can do simple editing after shot, these include drawing lines, arrows, frames, and blurring, highlighting and so on. New version add the text adding function, I think it's convenient.

![flameshot]({{ "/assets/flameshot-shot.png" | absolute_url }})

This is the result:

![flameshot-result]({{ "/assets/flameshot-result.png" | absolute_url }})

## 3D modeling

### [Blender](https://www.blender.org/)

Blender is a powerful 3D modeling software in Linux. It can establish the 3D model, and then render a photo by the camera tool, or you can also make an animation, it even has the function of video editing. It approves multiple formats, like OBJ, DAE and others. It has many functions, so it may a little hard to learn, if you are new to 3D modeling, you can watch teaching videos in YouTube, it may amaze you.

![blender]({{ "/assets/blender-shot.png" | absolute_url }})

![blender]({{ "/assets/blender-shot2.png" | absolute_url }})

## Reading documents

### [Evince](https://wiki.gnome.org/Apps/Evince)

Evince is a component of GNOME, so it's a good choice if you use GNOME desktop environment. It's fast and light, you can view pdf or djvu fluently. You can add bookmarks, mark in the document, and you can also play slides in pdf format ... Evince will cache the index of documents recently opened, so you can find recently opened documents soon.

![evince]({{ "/assets/evince-shot.png" | absolute_url }})

## Editing

### [Vim](https://www.vim.org/)

Vim is a traditional editor in unix, and there are alway arguments between vim users and emacs users, because I'm a vim user, not a emacs user, I recommend vim only. Vim's keys are convenient, you can move your without moving your hand away from main part of keyboard; some commands can make you easily find the position you want to edit; it's very convenient to find and replace with regular expression ... It's very light, and you can directly use it in your terminal. (vim have a GUI version called `gvim`) However, it maybe a little old, and it's not convenient to install plugins, finding a suitable plugin may cost a lot of time. It's still convenient to edit small files, such as code with hundreds of lines and so on.

![vim]({{ "/assets/vim-shot.png" | absolute_url }})

### [visiual studio code](https://code.visualstudio.com)

![vscode]({{ "/assets/vscode-shot.png" | absolute_url }})

Visual studio code is a project of Microsoft, and Microsoft made it open source. It's a powerful editor, its completion is good and it is easy to manage plugins. When I need a plugin, I only need to switch to the plugin tag, search, and install. For convenience, I installed vim plugin and use vim keys. You can call out the shell, and do some operations on it directly ...

## Password management

### [Keepass](https://keepass.info/)

> Today you need to remember many passwords. You need a password for the Windows network logon, your e-mail account, your website's FTP password, online passwords (like website member account), etc. etc. etc. The list is endless. Also, you should use different passwords for each account. Because if you use only one password everywhere and someone gets this password you have a problem... A serious problem. The thief would have access to your e-mail account, website, etc. Unimaginable.
> 
> KeePass is a free open source password manager, which helps you to manage your passwords in a secure way. You can put all your passwords in one database, which is locked with one master key or a key file. So you only have to remember one single master password or select the key file to unlock the whole database. The databases are encrypted using the best and most secure encryption algorithms currently known (AES and Twofish).

Not need to remember the long passwords anymore! (However, you still need to remember one, which is used for unlock the database.)

![keepass]({{ "/assets/keepass-shot.jpg" | absolute_url }})

## About internet surfing and virtual machine

Firefox, Chromium browser, VirtualBox, VMWare and so on ... I think these softwares are very familiar with most of you, so I won't overtalk.
