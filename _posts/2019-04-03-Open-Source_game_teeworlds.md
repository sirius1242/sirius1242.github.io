---
layout: content
title: Open-Source game Teeworlds
date: 2019-04-03 15:02:19 +0800
categories: summary chinese
---

　　好久没有写博客了，这次我打算开始用中文写，感觉用英文写完全是给自己和别人找麻烦，自己英文水平不好，完全没有必要。

　　[Teeworlds](https://www.teeworlds.com/) 是 “A retro multiplayer shooter”， 一款开源复古[[^1]]多人射击游戏。 

<!--more-->

　　一开始入坑是因为同学玩，然后当时正好对开源的东西比较感兴趣，结果一玩就是两年，带我入坑的同学大多都退坑了，然而我还在玩这个游戏。因为开源，这款游戏有很多 mod，比如 fng（祭祀），ddrace（闯关），infclass（僵尸），zcatch（吃鸡），teesmash（大乱斗）等等，也增加了它的可玩性，比如 FNG 和 DDRace 就是比较硬核的 mod，要求玩家掌握很多 Teeworlds 的技巧，尤其是 DDRace，可能有点像 I Wanna Be The Guy（我没玩过，只是听说），很难，而且有很多地图，因为老玩家的技术越来越强，因此地图也越来越难，心态不好的可能会砸键盘。（

　　当然在这个游戏中，我不仅仅是玩游戏。从玩游戏到加入社区到开服务器到最近干脆在写 mod，在这个游戏中我虽然浪费了不少时间，但也得到了一些东西。首先是加入社区，Teeworlds 中国社区有自己的论坛（虽然最近因为域名问题进不去了），也有 QQ 群，我只加了 QQ 群，群里的玩家从小学到已经工作的，平时大家聊聊天什么的也都挺好，有的时候也在群里约 Tee（另外群里的话题经常会走到技术向，因为据说玩这游戏的有很多 OI 和 ACM 大佬）。我之前并没怎么参与过社区，初三的时候逛逛化学吧也算一点，但大多数都是看贴，QQ 群交流则自然很多，不过也水很多。

　　另外一点就是开服务器和写 mod。刚开始折腾服务器是练习 fng 的时候需要本地服务器，然后就去 github 找源码，当时 mod 的 README 都是直接照搬官方的 README，也不知道怎么编译（当然其实官网上面有编译教程，而且官方的 README 有官网的链接，只不过当时因为搜索技能几乎为零，所以没找到）。摸索中知道了用 [bam](https://github.com/matricks/bam) 来编译（Teeworlds 作者写的一个项目，似乎专门用来编译 Teeworlds，当然估计初衷并不是这样的，但我 Google 之后第一个 bam 相关的是 manual，第二个就是 Compiling Teeworlds 了），找了很多 mod 的代码，后来我一个也经常玩 Tee 的同学买了台服务器放在学校，就在他的服务器上跑了一些服务器，我还写了一个通过 tmux 的启动框架，然后每次一个命令就可以全跑起来，并且开机启动。所以其实冠名"USTC-LUG"的服务器是在个人的服务器上跑的，只是服务器的拥有者和维护者都是 LUG 成员而已。而写 mod 是近期的事情，我原先并不会 C++，但上学期编译原理实验写了一些，而且体会到了 vscode 的便捷（虽然可能和 CLion 什么的还是差不少），然后有个想法就写了一下，刚开始就是做一点改动，后来正好因为 0.7 刚出没多久，就把 0.6 的 fng 和 TeeSmash 移植过去了。在写 mod 的过程中有了不少收获，学到了不少 C++ 的东西，还踩了一些坑。Teeworlds 的代码可读性很好，改起来也比较舒服。基本上是通过玩的时候的规则写的（所以会出现之前因为没有改锤子的力道被人说手感有点奇怪），后来一些功能也借鉴了 0.6 的代码，总之感觉这一段时间在 teeworlds 上收获还挺多的。

[^1]:不知道是不是卷轴，我查 retro 这个词只查到了复古的意思
