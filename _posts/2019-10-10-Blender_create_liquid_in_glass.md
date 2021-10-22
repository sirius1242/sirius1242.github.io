---
layout: content
title: Blender create liquid in glass
date: 2019-10-10 20:57:06 +0800
categories: misc chinese
---

最近又折腾了一下 Blender，上次折腾的东西感觉忘得差不多了，于是这次记一下~~省得下次再忘了~~。

<!--more-->

首先是透明材质中放置液体，也就是常见的“杯子里面有水”的场景，原来的直接创建一个液柱的方法有点麻烦（主要是要和杯壁贴紧），而且也不是很真实（因为中间有空气层），然后我看到了[这篇文章](http://blog.gregzaal.com/2013/10/19/fluid-in-a-glass)，他的办法就是将杯壁内部有水的部分取出，赋予该部分一个特定的 IOR（折射率），再加上水面的部分，结合起来就比较真实了。

根据他的文章以及进行了一些尝试，我对 blender cycle 渲染的工作原理进行了一些推测：

- blender 渲染的时候并没有实体，只存在表面
- 对光源打过来的光进行处理时，光源通过表面则进行相应的处理，比如按材质进行反射和折射，直到遇到下一个表面

因此，原作者的方法就便于理解了（~~其实他说的挺明白的，只是一开始没搞懂~~），光源通过外层的玻璃表面时，进行一个 IOR[glass]/IOR[air] 的折射，玻璃与水的交界处加一个界面（也就是原先的玻璃面），把这个面赋予一个 IOR[water]/IOR[glass] 的折射率，按照 blender 的渲染方法，这和现实中水与玻璃界面的折射效果是一样的。但 IOR[water] = 1.33，IOR[glass] = 1.5（近似，依材质不同而异），二者的商约为 0.8，而作者说材料的折射率是空气中的光速除以该材质中的光速得到的，因此这意味着这种材质中的光速要大于空气中的光速，这是不被允许的（~~具体是否不允许我没有尝试渲染过，不过材质的 IOR 的确是可以小于 1 的~~），于是将这个面的法向量反向，并将 IOR 设置为 1.25，这样就达到预期效果了。

于是，按照这个原理，我们首先创建杯子形状的 object，然后进入 edit mode，选择内部盛水的几个面：

<img alt="water-glass" src='{{ "/assets/water_glass.png" | absolute_url }}' width="100%">

然后 flip normal，可以通过右图来查看 normal 方向，折射率是由 normal 反方向介质 IOR 除以 normal 方向介质的 IOR 得到的。

<img alt="flip-normal" src='{{ "/assets/flip_normal.png" | absolute_url }}' width="60%"><img alt="normal" src='{{ "/assets/normal.png" | absolute_url }}' width="40%">

给玻璃-水界面链接材料

<img alt="assign-material" src='{{ "/assets/assign_material.png" | absolute_url }}' width="100%">

别忘了水面的部分，然后调节好参数就可以进行渲染了，不过看起来可能棱角比较多，而 shade smooth 又会把杯子的侧面与底面交界处 smooth 掉，导致杯壁看起来很奇怪，这时候可以勾选 auto smooth，然后对不想 smooth 的 edge 标记为 sharp：

<img alt="auto-smooth" src='{{ "/assets/auto_smooth.png" | absolute_url }}' width="30%"><img alt="mark-sharp" src='{{ "/assets/mark_sharp.png" | absolute_url }}' width="70%">

最后就是渲染结果：

<img alt="result" src='{{ "/assets/result.png" | absolute_url }}' width="100%">

~~展开想象的翅膀~~还可以做出其他例子：

<img alt="result" src='{{ "/assets/example1.png" | absolute_url }}' width="100%">
<img alt="result" src='{{ "/assets/wine.png" | absolute_url }}' width="100%">
<img alt="result" src='{{ "/assets/lamp.png" | absolute_url }}' width="100%">
