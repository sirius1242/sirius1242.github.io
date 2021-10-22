---
layout: content
title: Create Minecraft-style anime
date: 2021-02-20 18:13:20 +0800
categories: misc chinese
---

## 制作 MC 画风的动画

突然就有了把 Minecraft 存档转换成 3D 模型的想法，经过搜索发现了 [Mineways](https://www.realtimerendering.com/erich/minecraft/public/mineways/) 这个软件。

<!--more-->

Mineways 只有 Windows 版本，于是跑在了 Windows 7 虚拟机里。不过在转换大范围的存档时内存可能不够用，需要事先把虚拟机内存开大一点。读存档的话就打开存档所在的目录，选择 level.dat 即可打开存档，可通过 View 标签在出生点、玩家位置、下界、末地等几个位置切换。也可以进行切换材质等。使用右键划出需要转换的区域，选择转换的高度范围，如果选定的高度范围内不是包括了所有可见方块（暴露出来的方块），程序会询问是否切换到计算好的高度范围（包括了所有可见方块）。

选择导出区域：

<img alt="area_select" src='{{ "/assets/area_select.png" | absolute_url }}' width="50%">

之后选择 for rendering/for 3D printing。可以转换为 obj/stl/usda/wrl 等几种格式，还可以直接上传到 Sketchfab 或导出地图 PNG 图像等。选择好格式之后就可以导出。为防止范围过大导致渲染时远处看不到，我会把每个方块的大小调为 100mm 而不是默认的 1000mm。

导出选项：

<img alt="result" src='{{ "/assets/export_options.png" | absolute_url }}' width="50%">

之后在 3D 软件中打开相应的文件即可。Blender 需要使用 [MCPrep 插件](https://theduckcow.com/dev/blender/mcprep/)来进行材质调整，否则会出现比如玻璃内部都是黑的（不透明）之类的问题，当然也可以手动调整，只不过很麻烦，手动调整见 [For Blender](https://www.realtimerendering.com/erich/minecraft/public/mineways/mineways.html#blender) #9 Material Conversion。使用 MCPrep 插件的话首先在 Edit-\>preferences 中 勾选 MCPrep，之后在 MCPrep 选项卡中点击 `Prep Materials`。
<img alt="result" src='{{ "/assets/mcprep.png" | absolute_url }}' width="20%">

在调整完材质之后效果已经好多了，而 MCPrep 插件除此之外还有更多的功能。首先 Create MC Sky 可以生成一个 MC 风格的天空，还可以调整时间，不过看起来调整时间目前还不支持动画。生成天空的时候还可以同时生成云彩。除了生成天空，还可以生成生物，从 Steve，村民，牛羊等被动生物，僵尸骷髅等攻击型生物都可生成。生成时还会有 skeleton，便于后面制作相应生物的动画。下图是一个旧存档中部分区块导出 obj 之后在 blender 中渲染的结果，可以看到比不论是 MC 游戏中，还是网页地图等渲染的效果都要好了很多。

<a href='{{ "/assets/building.png" | absolute_url }}'><img alt="result" src='{{ "/assets/building_small.png" | absolute_url }}' width="100%"></a>

当然如果只是渲染存档的话搞一个好一些的光影（虽然光影的话我的电脑估计带不动）或者使用 CHUNKY 等渲染器效果可能也不会差很多，导出 3D 模型的主要好处还是可以使用导出的模型制作动画。个人刚接触人物动画，对这些还不熟悉，就用 MCPrep 的 Simple Player 和 Simple Villager 两个模型简单制作了一个小动画：

<iframe src="//player.bilibili.com/player.html?aid=331755520&bvid=BV1hA411M7N7&cid=300368213&page=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

使用的是 Simple 模型，只有四肢和头可以动，MCPrep 还有更复杂一些的模型，可以使用这些来让动画变得更精细。

### 使用 Cycles 渲染引擎

因为求快，上述跑的都是 Blender 的 Eevee 渲染引擎，如果是环境光不够充足的情况下可能就需要用 Cycles，Eevee 的效果会差不少（不过如果跑 Cycles，渲染时间恐怕要增加几十倍甚至几百倍，但看起来 Eevee 不渲染材质光源），如下是海底神殿的模型用 Eevee 和 Cycles 渲染的效果对比（左为 Eevee，右为 Cycles）

<a href='{{ "/assets/ocean_eevee.png" | absolute_url }}'><img alt="eevee" src='{{ "/assets/ocean_eevee_small.png" | absolute_url }}' width="50%" style="float:left"></a>
<a href='{{ "/assets/ocean_cycles.png" | absolute_url }}'><img alt="cycles" src='{{ "/assets/ocean_cycles_small.png" | absolute_url }}' width="50%" style="float:right"></a>

最近学会了投影（Litematica）mod 的使用方法，于是把我校服务器（UMS）里面我建的部分和邻居们建好了的部分复制到了一个同种子单人档里面，导出了 obj 模型。因为这是生存服务器，所以地面上很多火把，我就想晚上应该也可以蛮好看的，就想试试。

但 MCPrep 中为非固体的光源方块添加的发光材质不知道为什么没能生效，简单调整了一下，通过编辑 material 的 nodes 连接，将图片的颜色链接到材质的 Emission value 上面就发光了，然而有一个问题，如果想要火把起到一定的照明作用的话，火把柄也会发出很亮的光，某同学说“火把变荧光棒”，最后经过调试，解决办法就是把颜色同样链接到 Emission Strength 上面，并且中间加一个 Multply Add 的 math node（为了保留少量的发光，否则火把柄因为渲染逻辑的问题不会被照亮会有点奇怪），如下所示：

<img alt="shading_nodes" src='{{ "/assets/shading_nodes.png" | absolute_url }}' width="70%">

Cycles 引擎 OpenImageDenoise 去噪（NLM 在光线较暗时仍然会产生很多噪点）渲染结果（大图 10+M）：

<a href='{{ "/assets/ums_xyxq.png" | absolute_url }}'><img alt="ums_xyxq" src='{{ "/assets/ums_xyxq_small.png" | absolute_url }}' width="100%"></a>

其中灯笼是`*32-4`，火把是`*28-4`，末地烛是`*20-4`，下界传送门直接`*8`，当然这是我个人感觉比较合适的数值，如果有兴趣做类似渲染可以另行调整。

当然因为只有 CPU，这张图花了 1h 左右来渲染，恐怕 cycles 在没有 GPU 的情况下并不能胜任渲染动画的工作。
