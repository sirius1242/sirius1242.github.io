---
layout: content
title: color terminal background when ssh
date: 2021-01-16 10:16:43 +0800
categories: linux chinese
---

模仿 volltin 搞了个 ssh 时终端背景颜色变化的配置，调研之后我用的是在 ssh 前后加控制字符的方法（需要终端支持），在 zshrc 中加入如下代码：
<!--more-->

```sh
function colorssh () { echo -e "\033]11;#101010\a"; /usr/bin/ssh $*; echo -e "\033]11;#182C36\a" }
alias ssh="colorssh"
```
然而发现此方案在 ssh 连接失败 kill 的时候会无法恢复终端颜色，因此采用了 [StackExchange](https://superuser.com/a/603910) 的 ssh LocalCommand 与 alias 结合的方案（没有使用 setterm）。但这又会使得 git remote 的使用 ssh 的 push 和 pull 出现问题。

之后通过查阅手册发现 ssh 可以加 -o 参数来临时指定 option，于是改为：

```sh
function colorssh () { /usr/bin/ssh -o LocalCommand='echo -e "\033]11;#101010\a"' $*; echo -e "\033]11;#182C36\a" }
alias ssh="colorssh"
```

这时需要通过修改 /etc/ssh/ssh_config ，在其中加入 `PermitLocalCommand yes` 来允许 ssh 执行本地命令。最后通过 -o 指定这个选项，使得仅在终端使用 ssh 时临时允许本地命令执行，这样可以避免修改 ssh 配置文件，也要安全一点，因此最终的配置如下：

```sh
function colorssh () { /usr/bin/ssh -o PermitLocalCommand=yes -o LocalCommand='echo -e "\033]11;#101010\a"' $*; echo -e "\033]11;#182C36\a" }
alias ssh="colorssh"
```

最终方案使用了一段时间还没有遇到问题，如果后续发现问题可能会继续更新。# 后面为颜色，可以根据喜好自己定义，前面的是连接 ssh 时的颜色，后面是 ssh 连接断开后恢复为终端的正常颜色。
