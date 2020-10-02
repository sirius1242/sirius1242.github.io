---
layout: content
title: systemd for user and tmux for services
date: 2020-09-18 17:28:06 +0800
categories: linux chinese
---

## 用 systemctl --user 管理你的服务

之前在同学的服务器上折腾 teeworlds 服务器的时候由于没有 root，然后又面临不能自动启动的局面，于是想到了 systemd --user。

后来因为机器突然坏了，所以配置都烂在了那台机器里，导致后面再次配置的时候又搞了半天，因此为了避免再出现这种状况，就写个 blog 记录一下。
<!--more-->

首先需要在 `$HOME/.config/systemd/user/` 目录下建立一个 [service_name].service 的文件，比如在某台机器上建立一个 minecraft.service 文件，内容如下：

```sh
[Unit]
Description=Minecraft servers by tmux
[Service]
ExecStart=/path/to/script/boot.sh
Type=forking
Restart=always
[Install]
WantedBy=default.target
```

boot.sh 是启动脚本，这个脚本会将 minecraft 启动到 tmux 的特定 session 的 pane 中，比如：

```sh
tmux new -d -s "$session"

cmd="cd $dir && [command]"
tmux split-window -f -h -t "$session" "$cmd"
tmux select-pane -T "$title"
tmux kill-pane -t "$session":0.0
tmux select-layout -t "$session" tiled
```

由于脚本执行之后就会退出，因此需要在 minecraft.service 中指定 Type=forking，这样 systemd 会监控 fork 出的子进程，Restart=always 会在程序退出后重启服务（会在任何一个子进程退出后重启服务）。详细可见 `man systemd.service`

#### <span style="color:red">注意：tmux 必须由此脚本开启，split-windows 开启的 task 属于 tmux 的子进程，tmux 不由该脚本开启 systemd 则无法监控这个子进程，会导致 systemd 认为服务 dead 而不断重启服务，因此此方法不能在同一个用户下使用多个此类服务，目前我还没有找到此问题的解决方法。</span>

写好 .service 文件之后就可以使用 `systemctl --user daemon-reload` 加载更改后的文件，使用 `systemctl --user enable [service_name].service` 来设置开机启动，使用 `systemctl --user start [service_name].service` 来启动服务，使用 `systemctl --user stop [service_name].service` 来重启，总之一切都可以在 systemd 的控制下，这可以使管理更为方便。

由于服务需要在用户退出之后仍然继续运行，根据 [Arch wiki](https://wiki.archlinux.org/index.php/Systemd/User#Automatic_start-up_of_systemd_user_instances)，需使用

```sh
# loginctl enable-linger username
```

来使得服务在开机即启动以及用户退出后继续运行。

## 用 tmux 同时开启多个运行服务

之前的 boot.sh 是基于之前在同学服务器上开 teeworlds 服务器时方便管理写的一套脚本中提取了一些内容实现的。当时的需求是在 tmux 中开启多个 pane，每一个 pane 运行一个 teeworlds 服务器，这样各服务器的状态可以一目了然。本来刚开始是手动分的，但当时在折腾 shell 脚本，于是写了一套自动化脚本。

脚本的主要部分就是使用 tmux 开启多个 pane，并且为每一个 pane 分配不同的执行命令，如下：

```sh
# 读取变量文件
source "/path/to/env.sh"

# 判断是否已有相应的 session，如果没有，启动一个
tmux has-session -t "$session"
if [ $? -ne 0 ]
then
        tmux new -d -s "$session"
        tmux detach -s "$session"
fi

# 一些个性化设置
tmux set-option mouse on
tmux set -g pane-border-status top
tmux set -g pane-border-format "#{pane_index} #{pane_title}"
tmux set -g pane-border-style fg=cyan

# 遍历 env.sh 的命令列表逐一启动命令
for i in "${cmdlist[@]}"
do
        (
        dir=$(echo $i | cut -d' ' -f1 | xargs dirname) # 由于没有设置各命令路径，直接通过切割的方式拿到路径
        cmd="cd $dir && $i" # 设置发给 tmux 的命令
        tmux split-window -f -h -t "$session" "$cmd" # 切割窗口并发送命令
        tmux select-pane -T "$i" # 设置 pane 标题
        tmux select-layout -t "$session" tiled # 重新安排 pane 布局
        )&
        sleep 1
done

tmux kill-pane -t "$session":0.0 # 去掉 tmux 开启后默认开启的 shell pane，可省略
tmux select-layout -t "$session" tiled # 重新安排 pane 布局
```

由于之前经常会一次性开启很多服务器（20+），因此在分 pane 的时候有可能会失败，经过 debug，使用了每次切割窗口时都重新安排布局（tmux split-window 等命令均为对当前 active 的 pane 进行操作，因此如果没有进行过调整，会对最后一个 pane 进行操作，没有重新安排布局的话分出来的会越来越小，最后太小了就分不出来了）以及每次切割窗口后都 sleep 1s 的解决办法，可根据不同情况进行调整。

脚本设置结束，添加执行权限后即可用上一 part 的方法使用 systemd 控制这套脚本，因为程序退出之后相应的 pane 也会消失，因此请单独记录 log 或使用 tee 命令等方式记录 log。

## 分组管理

有时会有如上述内容所示的统一管理一批服务的需求，但如果又想可以通过 systemd 单独管理每个服务，比如在某一个服务 down 时自动重启，则目前想到的解决办法是使用 systemd 的分组管理。

如[这篇文章](http://alesnosek.com/blog/2016/12/04/controlling-a-multi-service-application-with-systemd/)所示，首先需要写一个 dummy service (如 app.service)：

```sh
[Unit]
Description=Application
[Service]
# dummy 程序运行后退出
Type=oneshot
# 随意找一个可以启动后立刻正常退出的命令作为 Execstart
ExecStart=/bin/true
# 主程序退出后仍认为 service 在运行
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target
```

之后在这个组内的其他服务需要增加 `PartOf`, `After` 以及修改 `WantedBy` ：
```sh
[Unit]
Description=Application Component 1
# 对 app.service 的停止及重启操作将被同时传递给这个服务
PartOf=app.service
# 在 app.service 之后启动
After=app.service
[Service]
ExecStart="your_command"
Restart=always
[Install]
# app.service 启动时这个服务也将启动
WantedBy=app.service
```

组内服务都添加完毕后需要 enable 各服务，这时会将 service 文件软链接到 app.service.want 目录下，这样这些服务在 app.service 服务启动后会自动启动。

不过这种办法带来的问题是，没办法直观地查看全部组内服务的运行状态，以及 task 的 log 会记录进系统日志，如果输出较多会干扰系统日志的查看。不知道后面能否找到更好的解决办法。

前者可以通过使用 `systemctl list-dependencies --before app.service` 来查看依赖于 app.service 的其他 service 的启动状态作一个粗略的查看（仅能判断运行状态，无法获得其他信息），后者可以通过重定向 task 输出到指定 log 文件，通过 tail 等来查看 log，虽然不是很优雅，不过看起来搞一套脚本的话是可用的。
