---
layout: content
title: Use tig to monitor your machine
date: 2020-09-12 16:31:56 +0800
categories: sort_out chinese
---

所谓 tig，就是指 telegraf，influxdb 以及 grafana 组成的一套工具链。telegraf 负责数据收集，influxdb 是数据库，负责数据存储和管理，grafana 则是可视化界面，查询 influxdb 中存储的数据并以可视化图表的形式展现出来。

<!--more-->

之前豆豆搞过一个活动室的温湿度监控的系统，就是用的这套工具链，再加上受 mcwindy teeworlds Online 人数查询 bot 的启发，我觉得可以每隔一段时间查询各 mod 的人数记录下来，再用这套工具链表现人数的变化。

首先是写脚本，mcwindy 的那套脚本是 js 的，而且我不需要那么多功能，索性就自己用 python 写了一个，就是用 status.tw 的 api 查询全部服务器信息。因为 status.tw 做了 bot 的检测，所以要加一个 UA，否则会 403。

从 api 拿到的数据首先转换成 json，然后提取出其中国服的数据，将各 mod 的人数加起来，存储到事先准备好的 dict 里面。目前的方法会导致入流量很大，因为会拿到所有服务器的数据，之后可能研究一下 api 只拿国服的数据可能会好一些。

```python
data2 = data.read().decode()
jdata = json.loads(data2)
for i in jdata['servers']:
    if i['country'] == 'China': # and len(i['players']) != 0:
        try:
            num_player[i['gamemode']] += len(i['players'])
        except KeyError:
            num_player[i['gamemode']] = len(i['players'])
```

然后再计算一下总人数，再把 dict 按照 json 格式打印出来就行。

服务器是 Debian 10，源里面是没有 telegraf 和 grafana 的，要自己去下 deb：[telegraf](https://github.com/influxdata/telegraf/releases)，[grafana](https://grafana.com/grafana/download)。然后从源里安装 influxdb 和 influxdb-client。

influxdb 要设置一个 admin 和普通用户，后者用来给 telegraf 写数据。毕竟是放在公网上面的服务，还是加个权限比较好。

```sql
create user admin with password <password> with all privileges; 
create user telegraf with password <password>;
grant [READ,WRITE,ALL] on telegraf to telegraf;
```

然后改 telegraf 的配置，要改用户名和密码，然后要把 net 插件的注释去掉

```sh
[[inputs.net]]
   interfaces = ["eth0"]
```

自己写的收集数据的脚本可以用 exec 插件，在 /etc/telegraf/telegraf.d/ 下建立一个配置文件：

```sh
[[inputs.exec]]
  commands = ["python3 /path/to/script/getnum.py"]
  interval = "60s"
  timeout = "60s"
  data_format = "json"
  name_suffix = "player_num"
```

由于脚本输出的是 json 格式，所以 data_format 设置为 "json"。

之后重启 telegraf。

Grafana 安装之后启动，可以访问 `<服务器 IP>:3000` 来查看（也可以在 /etc/grafana/grafana.ini 里更改端口），别忘了防火墙放行 3000 端口。默认用户名和密码都是 admin，登录后会要求更改密码。在设置里添加数据源，选择 influxdb。

Grafana 有很多现成的模板，比如 928。可以选用现成的模板也可以自己添加 panel
<img alt="import_template" src='{{ "/assets/import_template.png" | absolute_url }}' width="30%">

添加 panel 是比较复杂的一个过程，也可以参考现有的模板，另外 net 插件收集到的 byte_recv 和 byte_sent 数据是流量统计，因此要统计带宽占用的话需要对其求导，之前这里卡了很久。Panel 的添加都是通过图形界面完成的，添加完成后在 grafana.ini 中去掉 anonymous 的注释，其他人就可以无需登录就能查看图表：

```sh
[auth.anonymous]
enabled = true
org_name = Main Org.
```

这是我做的图表，统计了 teeworlds 各 mod 的人数和我管理的那台服务器的统计数据：[Teeworlds Dashboard](http://47.101.147.245:3000/d/LH3kRzdMk/teeworlds-dashboard?orgId=1)

截图如下：

<img alt="grafana screenshot" src='{{ "/assets/grafana.png" | absolute_url }}' width="100%">
