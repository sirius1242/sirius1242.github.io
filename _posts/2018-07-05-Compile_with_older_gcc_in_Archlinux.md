---
layout: content
title: Compile with older gcc in Archlinux
date: 2018-07-05 10:32:09 +0800
categories: linux
---

# Compile with older gcc in Archlinux

## Reason
I'm an Archlinux user, and because the version of packages in Archlinux are always almost the newest. So when I compile the code written in distros with older gcc, such as Ubuntu, I always fail to compile.

For example, when I compile a teeworlds server with mod CSTT, I always got error and it can't output the binary, but when I compile it in Ubuntu, things got much easier. However, the binary compiled in Ubuntu can't run in my Archlinux, either (It always said can't find command, and the mod can't be loaded correctly, such as dm++ can only serve as dm).

<object id="failure" data='{{ "/assets/failure.svg" | absolute_url }}' type="image/svg"></object>

compilation always fail

## Solution

So I come up with using a different version of gcc when compile. However, I didn't find how to appoint gcc version in `bam.lua`. Firstly, I installed `community/gcc54` with `pacman`, `gcc54` is in version 5.4.1 now. And what if link `gcc-5` and `g++-5` to local directory? And I also set `PATH=.:$PATH bam config` and `PATH=.:$PATH bam server_release` to make it call local command first when compile with bam. And it works! So I directly add `PATH=.:$PATH` in my zshrc, so I can directly use this way in future. (don't forget to clean binaries former by `bam -c all`)

<object id="failure" data='{{ "/assets/deathmatch.svg" | absolute_url }}' type="image/svg"></object>

I think make can also use this way, but you can directly modify `Makefile` , and add `CC="gcc-5"` or directly use `make CC=gcc-5`, it will directly solve this problem.

so, have a good time!

![deathmatch]({{ "/assets/deathmatch.png" | absolute_url }})
