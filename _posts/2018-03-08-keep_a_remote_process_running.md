---
layout: content
title: keep a remote process running
date: 2018-03-08 12:09:14 +0800
categories: linux
---

# How to keep a process running when you are in a remote shell like ssh?

Sometimes we need to run porgrams in remote shell, such as download, update or other things, but if you quit the shell, the process will be killed, so how to keep it?

### nohup
Linux offered a command called `nohup`, it will redirect output of your program to a file called `nohup.out` in your current directory, and you can execute it like this:
```sh
nohup aria2c $url &
```
you need to add a `&` to put the process to the backgroud, and shell will output like `[1] $pid` to show you the process id. And the `[1]` is the pid of your background processes, you can use `jobs` to check them.

that's not all, you also need to make the process not belong to your shell any more, otherwise, it will still be killed when you quit remote shell, so you need to type `disown %1`(if your background pid is 1) to make the process separate from your shell.

a little troublesome, isn't it?

### tmux
Linux have a command called tmux:
> tmux is a software application that can be used to multiplex several virtual consoles, allowing a user to access multiple separate terminal sessions inside a single terminal window or remote terminal session. It is useful for dealing with multiple programs from a command-line interface, and for separating programs from the Unix shell that started the program. It provides much of the same functionality as GNU Screen, but it is distributed under a BSD-like license. --[wikipedia](https://en.wikipedia.org/wiki/Tmux)

![tmux]({{ "/assets/480px-Tmux.png" | absolute_url }})

tmux can not only divide your screen, it can also separate programs from the Unix shell that started the program, you can execute your program in tmux and then quit the shell, and the process will still running. if you want to check the output informations of the process, you can use `tmux attach` to enter former shell. If you attach a tmux which is running, operations will be synchronized, so it's a good way to show some operations to others.

If you are in tmux, and you want to quit shell, you can use `ctrl+b+d` or `ctrl+b :detach` to quit tmux, and the process will still running, and you can do other things or quit remote shell. 

`ctrl+b` is a command to enter `god mode`, to divide screen, to call out clock and to do other things, you need to enter `god mode` first, and then type respective commands.

#### [there is a simple tutor to tmux](https://lukaszwrobel.pl/blog/tmux-tutorial-split-terminal-windows-easily/)

Tmux is useful, and I think it may be good to enter tmux before executing a time-consuming process, and you can avoid process interrupted by doing this.
