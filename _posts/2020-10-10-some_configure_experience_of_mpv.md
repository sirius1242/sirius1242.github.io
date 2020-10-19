---
layout: content
title: some configure experience of mpv
date: 2020-10-10 21:40:08 +0800
categories: linux chinese
---

## 一些 mpv 折腾经验

之前音视频播放都是用 mplayer，之前因为一些奇怪的需求发现 mpv 更易定制，于是就用下来了，也折腾了一些配置。
<!--more-->

首先是快捷键的设置，与 mplayer 写死的快捷键不同，mpv 可以自己定制快捷键，可以在 `$HOME/.config/mpv/input.conf` 中通过 `按键 命令` 的方式定制快捷键。mpv 的 man page 中介绍了可使用的各命令及格式，可以通过分号使得一个快捷键绑定多个操作，比如，可以通过如下配置使得按下 Alt+p 后 mpv 在播放完当前曲目后退出（清空播放列表以及取消列表循环）：

```sh
Alt+p playlist-clear; set loop-playlist "no"
```

这里的快捷键是在 mpv 为当前任务时生效的，mpv 还自带一个与 mplayer 键位保持一致的配置文件 `mplayer-input.conf` ，如果习惯了 mplayer 的键位也可以把这个文件替换 `$HOME/.config/mpv/input.conf` 来在 mpv 中还原 mplayer 键位。

除了使用快捷键的方式输入命令外，mpv 还可以通过 socket 在外部向其发送命令。socket 默认似乎在 /tmp/mpv-socket 下，可以在 `$HOME/.config/mpv/mpv.conf` 中添加如 `input-ipc-server=~~/socket` 以改变 socket 文件位置到 `$HOME/.config/mpv/socket`，之前可能是因为 /tmp 下面的 socket 不能用所以改到了这里。也可以在 mpv 启动时指定 `--input-ipc-server=<file>` 来指定该 mpv 实例的 socket，不同实例使用不同的 socket 文件可以区分发送到不同 mpv 实例的命令。

在外部 shell 向 mpv 发送命令可通过命令:

```sh
echo "<command>" | socat - /path/to/socket/file
```

因此这使得 mpv 脱离 shell 运行成为可能，据此我用 python 和 tkinter 写了[一套脚本](https://github.com/sirius1242/mpv-pyscript)，使用 systemd 管理 idle 状态下的 mpv，然后用 Python 脚本通过 socket 向其发送 loadfile 等命令执行播放列表选择，暂停/播放，停止等功能，本来是打算通过绑定系统快捷键让 mpv 可以运行在后台的同时随时随地接收我发送的命令，这样就不用每次切换到开启 mpv 的终端标签进行操作了，不过后来感觉意义不大，尤其是发现 mpv-mpris 插件之后。不过既然都写出来了，而且的确可以方便一点，就这样吧。我目前是为打开列表（open）和调出命令界面（cmd）绑定了快捷键，然后暂停以及上一曲下一曲直接用键盘上面的多媒体键来控制。

其实一开始想搞这套脚本是因为发现了 firefox 里播放的视频会显示在 gnome 的通知栏里，有 title，作者，以及上一曲目，下一曲目，以及播放/暂停的按钮，也能被键盘上面的多媒体控制键控制，就感觉这样一个全局的控制还挺方便的就有了做脚本的想法。结果脚本写了一半，查到了这个是 MPRIS API 的作用（firefox 似乎在最近的版本中才添加 MPRIS 的支持），而且 mpv 有一个 mpv-mpris 的插件，可以让 mpv 支持这套接口。安装好了之后就可以通过键盘的多媒体键来控制了，可以少绑（记）三个快捷键。

mpv 支持 JavaScript, Lua 的 script，有很多非官方的脚本，可[查看此页](https://github.com/mpv-player/mpv/wiki/User-Scripts)。
