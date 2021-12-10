---
layout: content
title: Experience of establishing Minecraft Servers
date: 2021-10-22 17:33:08 +0800
categories: misc chinese
---

最近搭建了两个 Minecraft 服务器，调研了一些 MC 服务器搭建相关的开源工具链，于是想写篇 blog 总结一下（虽然已经拖了一段时间了，但免得再拖下去时间长都忘掉了）。
<!--more-->

## 1.17.1 原版服务器

之前在 FAT 服务器因为一点事情离开了，以及原服主也不愿意升级 1.17，于是就要了一份存档 fork 了出来。大概在 8 月末的时候正好发现 Debian bullseye 有 OpenJDK-17 了，于是直接打了个 mcdr+openjdk-17 的 [docker 镜像](https://hub.docker.com/r/sirius1242/mcdr)，然后直接 fabric 升级到 1.17。本来想试试 Lithium，但 Lithium 还是对原版特性有一些改动不是很放心，而且目前服务器 mspt 也不高，就没有安装。然后再套个 [carpet](https://github.com/gnembon/fabric-carpet)。Phosphorus 更新了 1.17 版本，装上了之后解决了大云杉运行时及运行后持续掉刻的问题，整体 mspt 略有降低。

### MCDReforged

[MCDReforged](https://github.com/Fallen-Breath/MCDReforged)，简称 mcdr，`是一个可以在完全不对 Minecraft 服务端进行修改的情况下，通过可自定义的插件系统，提供对服务端的管理能力的工具`，由 TIS 服务器现任服主 [Fallen-Breath](https://github.com/Fallen-Breath) 开发，提供了很多方便的插件，比如：
- [QuickBackupMulti](https://github.com/TISUnion/QuickBackupM)，也就是俗称的 qbm，是非常方便的备份和恢复工具，搭配 [TimedQBM](https://github.com/TISUnion/TimedQBM) 进行定时备份，完全可以满足大多数备份/恢复需求。
- [Here](https://github.com/TISUnion/Here)，显示玩家坐标并使其发光，在多人服务器中很实用，可以方便地配合小地图 mod (Voxel/Xaero) 进行寻人。
- [joinMOTD](https://github.com/TISUnion/joinMOTD)，玩家登录时发送登录信息，可以配合 Velocity/BungeeCord 等进行方便的服务器间切换。
- [LocationMarker](https://github.com/TISUnion/LocationMarker)，可以方便地标记服务器内地点，玩家通过 !!loc 获得服务器内标记地点的坐标，还可以配合小地图快速添加坐标点。
- 还有很多很好的插件，插件仓库地址：[https://github.com/MCDReforged/PluginCatalogue](https://github.com/MCDReforged/PluginCatalogue)

### MapCrafter

之前玩的服务器都是用 [dynmap](https://github.com/webbukkit/dynmap)，然后我当时迁移的时候 dynmap 还没有官方的 fabric 版本，调研了一下发现了 [bluemap](https://github.com/BlueMap-Minecraft/BlueMap)/mapcrafter（没错，就是 [TIS 的 map 方案](https://map.tis.world/)），然后选择了 mapcrafter。

[Mapcrafter](https://github.com/mapcrafter/mapcrafter) 是一个基于 C++ 的地图渲染器，会根据配置内容渲染出一套服务器的平面/3D map，可以配合 nginx 来进行网页展示，相比于 dynmap 来说更新不及时，但只有渲染时有较大开销，平时服务时只有 nginx 运行，开销应该会比较小。然后有人做了高版本的 docker image: [https://hub.docker.com/r/dinip/mapcrafter](https://hub.docker.com/r/dinip/mapcrafter)，通过修改 mapcrafter-cron 来安排更新渲染时间（与 cron 规则一样，不过注意容器内时区），修改 render.conf 来控制渲染的内容。（具体配置方法请参阅原仓库文档）

### 外置登录

之前旧服因为是 Spigot，原服主选用的登录认证方案是 [AuthMeReloaded](https://github.com/AuthMe/AuthMeReloaded)，是在登录时需要在聊天栏通过指令输入密码登录，虽然是一个兼容大多数人接受范围的解决方案，但首先每次登录要输入密码比较麻烦，其次在下界门内等不能打开输入框的地方下线就会被卡住，需要服主 tp 出来，以及没有 fabric 版本。经过调研选择了 [authlib-injector](https://github.com/yushijinhun/authlib-injector)，支持 Blessing Skin 等皮肤站方案，启动服务器时加入 `-javaagent:{authlib-injector.jar 的路径}={验证服务器 URL (API 地址)}` JVM 参数服务端即配置完毕，客户端的话在你服务端指定的皮肤站注册帐号，为启动器配置好外置登录启动后即可直接登录服务器，无需额外的验证，非常方便。（具体配置方法请参阅原仓库文档）

### 通过 sshfs 挂载其他服务器的硬盘

除了 QBM 的备份以外，还做了定期备份 qb slot 的方案，就是写了一个备份脚本然后 cron 执行。而且云服务器硬盘容量较小，因此通过 [zero-tier](https://github.com/zerotier/ZeroTierOne) + sshfs 挂上另一台机器的硬盘，并且使用的是一个只有 sftp 权限的用户保障安全。然后定期备份和之后可能一些占用空间较大的存储需求会放到 sshfs 上，不过本来服务器带宽就较小，通过 sshfs 传输速度很慢，再加上被 sshfs 的服务器不是特别稳定，其实并不是一个很好的方案。

### Velocity

之前调研 joinMOTD 的时候发现可以直接不断连接切换服务器，调研了一下发现需要 [BungeeCord](https://github.com/SpigotMC/BungeeCord)/[Velocity](https://github.com/PaperMC/Velocity) 来进行类似 nginx 的反向代理，感觉 Velocity 更好配一些，尝试了一下结果发现服务器内存不够。本来是打算再搞个创造服/镜像服用 Velocity 连接起来，然后使用 [RegionFileUpdater](https://github.com/TISUnion/RegionFileUpdater) 来进行部分区块文件的同步（暂时不清楚是否可行，因为之前调研没有找到大型生电服务器的镜像同步方案，只是折中的一个想法），但无奈硬件设备不够，之后有条件了再折腾吧，想折腾 BungeeCord/Velocity 反代配置的话可以看[这篇 Blog](https://my.minecraft.kim/tech/2020/11/19/post-113/)。

### 总结

感觉与 MC 相关的开源软件还是蛮多的，除了这些给服务器管理带来很大方便的工具链，很多 mod 也都是开源的，MC 这样一个商业软件催生出这么多相关的开源软件，而且还有很多都是 GPLv3 协议的自由软件，非常有意思。

## 模组服务器

我以前几乎不玩模组，MC 入坑时间也不是很长，但之前看[四川柯基菌](https://space.bilibili.com/37780021) 的[末日多人生存系列](https://www.bilibili.com/video/BV1oU4y1h7WA)感觉很好玩，但又不想玩太难的，就从中拆了一些个人觉得很不错的模组，调研并添加了一些自己选的模组，约了一波朋友在暑假开了服务器玩了一阵。

### 规划

首先搞了个群并且在某个熟人团体内宣传了一波，让感兴趣的同学加群，然后就开始挑选 mod 并且定期更新已经选定的列表问大家的意见，但基本都没人发表意见，最后大多数还是我自己定的。当然有同学说机械动力，我觉得和这个包的定位差距太大就没加。然后在宣传的时候还截了个图作为封面：

<a href='{{ "/assets/byg-pack-cover.png" | absolute_url }}'><img alt="byg_pack_cover" src='{{ "/assets/byg-pack-cover-small.png" | absolute_url }}' width="100%"></a>

### 挑选模组

- 首先这个模组包的定位是冒险和探索，也就是新内容的添加，主要是 BYG 和 When Dungeons Arise
- 还有添加了城市模组 Lost Cities（但弄得到处都是城市，不过连通整个世界的地铁网络还是蛮不错的）
- 以及用于装饰的 Nef‘s Medieval Pub 和 Supplementaries（虽然最后并没什么人搞建筑）
- 动物模组用的 Better Animals Plus（结果里面敌对生物太多了，搞得初期有点难）
- 食物模组用的 Farmers' Delight。
- 然后有一些辅助类比如 Failing Tree, Paraglider, Travelers' Backpack, Way stones, AdHooks 等
- 然后加了难度递增的模组：Majrusz's Progressive Difficulty（然后发现并没有想象中平衡地那么好，以及到了后期动不动就不死军团超级烦人）
- 为了应对提高的难度加了枪械模组 MrCrayfish's Gun Mod（其实还是想玩枪，不过有了枪之后就太强了）
- 加了提升环境效果的 Dynamic Surroundings
- 以及载具 MrCrayfish`s Vehicle Mod
- 考虑到打完龙之后可能就没多少可玩的了，于是加了修改末地进入条件的 EndRemastered
- 新维度 The Abyss Chapter 2（因为我们玩的稳定版，内容很少，而且感觉除了难一点以及有任务以外和主世界大同小异，没什么新东西）

### 开服

首先启动器就用的 [Forge](https://github.com/MinecraftForge/MinecraftForge)，之后调研 mcdr 的时候换成了 mcdr，加了 here 插件，在多人跑图的时候非常好用，然后用 TimedQBM 替代以前脚本备份。

机器是用的同学服务器的容器，然后他配了转发。

刚开荒的时候人特别多，有 10 个人，结果当时出生点在城市，连吃的都没有，楼里又到处刷怪，之后又因为人太多在出生点区块待的有点久导致 Progressive Difficulty 增加难度较多，开局大家都很难受然后被迫难度改成 Normal，然后直到迁移到一个热带草原村庄才逐步安定下来。玩了 3-4 天就没啥人了，然后搞了刷铁机，有了枪之后就基本没啥难度了，剩下的就是开车开船到处跑图，以及探索城市之类的，大多数时间是我和服主在跑图，偶尔有其他 1-2 个人上线。到后来存档跑了 6G+，Dungeons Arise 的大多数地表建筑类型都探过了，最后我俩也不怎么玩了。确实这种添加新内容的模组感觉比较容易玩一段时间就失去兴趣了，后来又更新了一些模组，加了两个新维度的模组也没什么人玩了，感觉大概还是整合包组的不太好，不过玩的还是蛮开心的。

### 总结

模组服技术上的东西很少，就是总结一下第一次组模组服的这个经历，这种服务器多人玩还是蛮有趣的，虽然因为大家大都比较忙以及包组的可能不太好导致很快就没什么人了，不过也算是在预料之中了，感觉看很多 UP 玩模组服务器一般也不会玩太久，还是原版更耐玩一些。

放几张游戏截图（当时顺手截的，也没考虑很多，电脑配置比较低也没开光影）：

<table>
<tr><td><img alt="byg_pic1" src='{{ "/assets/byg-pic1.png" | absolute_url }}' width="100%"></td>
<td><img alt="byg_pic2" src='{{ "/assets/byg-pic2.png" | absolute_url }}' width="100%"></td></tr>
<tr><td><img alt="byg_pic3" src='{{ "/assets/byg-pic3.png" | absolute_url }}' width="100%"></td>
<td><img alt="byg_pic4" src='{{ "/assets/byg-pic4.png" | absolute_url }}' width="100%"></td></tr>
</table>
