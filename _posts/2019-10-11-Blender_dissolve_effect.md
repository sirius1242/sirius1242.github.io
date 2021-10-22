---
layout: content
title: Blender dissolve effect
date: 2019-10-11 12:44:09 +0800
categories: misc chinese
---

可能是因为 blender 2.8 改动太大，按照[原文](https://blenderdiplom.com/en/tutorials/simulation/394-tutorial-dissolve-your-logo-in-blender-262.html)中的一些操作我不知道如何进行（比如给 material 加上 blend texture，在 node 界面倒是可以加上一些 texture，但这里要的 blend 类型没有），不过省略了一些步骤之后仍然 work，我对其进行了一些总结，总的来说制作 dissolve effect 的步骤如下：
<!--more-->

- 首先你需要一个 mesh
- 对 mesh 进行 remesh（将表面重新分割成~~烫烫烫~~数量的 faces）
- 添加 particle system 为溶解（后面进行的 explode 操作）进行路径规划，详见：[blender manual](https://docs.blender.org/manual/en/latest/modeling/modifiers/simulate/explode.html#explode-modifier)
- 添加 wind，turbulence 等 force field 使得路径更为逼真
- 对 particle system 加一个 blend texture 使得从左到右进行而不是一次性全部发射出来
- 添加 explode modifier

原文说的是对文字进行溶解，但后面其实是转换成了 mesh，因此原理上任何 mesh 都可以（只不过效果不一定好罢了），甚至你加个 plane 然后贴一张 png 的材质，cycle 渲染的效果还是很好的（不过 plane 需要用 subdivide modifier 而不是 remesh）。这里我使用 blender 的 logo 进行演示。

首先将 logo 的 svg 转换成 mesh 并且增加一定厚度

<img alt="logo-mesh" src='{{ "/assets/logo_mesh.png" | absolute_url }}' width="100%">

然后分别对颜色不同的两部分添加 remesh modifier（建议在不影响效果的前提下保持材料不同的部分为不同的 object 分别 remesh，因为 remesh 后整个 object 会全部变成一种材料，也可以使用 subdivision surface，可以不用重新 map，但效果可能会差一点（溶解时可能会出现较大块的碎片））。

<img alt="mesh" src='{{ "/assets/remesh.png" | absolute_url }}' width="50%">

对两个 object 进行合并，添加 particle system，使用 rotation 让 particle 在溶解时旋转，移除重力等不符合预期的作用力。参数如下，用红圈标出了需要修改的参数，注意 paricle system 的 emission number 应与 face number 保持一致，原作者说 blender 2.64 或更高版本的应该调高一些，作为一个 bug 的 workaround，但我使用的 2.80 版本并没有问题，也许 bug 已经被修掉了。frame number 与 Lifetime 决定了 particle 发射的帧数（在 blend texture 添加后表现出来，添加之前一起发射出来的话帧数只有 Lifetime 的帧数）：

<img alt="particle-system" src='{{ "/assets/particle_system.png" | absolute_url }}' width="60%"><img alt="particle-system2" src='{{ "/assets/particle_system2.png" | absolute_url }}' width="40%">

添加两个力场，并对 turbulence 的参数进行改动，wind 要旋转一下使其向右，这样可以将 particle 吹向右边：

<img alt="add-field" src='{{ "/assets/add_field.png" | absolute_url }}' width="55%"><img alt="turbulence" src='{{ "/assets/turbulence.png" | absolute_url }}' width="45%">

对 particle system 添加 blend texture：

<img alt="new-texture" src='{{ "/assets/new_texture.png" | absolute_url }}' width="50%"><img alt="blend-texture" src='{{ "/assets/blend_texture.png" | absolute_url }}' width="50%">

如果 particle 表现得不正常可以添加一个 plane 完全覆盖住要溶解的部分，让其渲染不可见，并将 particle system 的 texture map 到这个 plane 上。

<img alt="plane" src='{{ "/assets/plane.png" | absolute_url }}' width="45%"><img alt="plane2" src='{{ "/assets/plane2.png" | absolute_url }}' width="55%">

添加最后的 explode modifier（注意不要 apply，否则效果就会消失）。

<img alt="explode" src='{{ "/assets/explode.png" | absolute_url }}' width="50%">

渲染结果（转成了 gif，似乎转的时候带进来了网格的效果，视频是没有的）

<a href='{{ "/assets/result.gif" | absolute_url }}'><img alt="result" src='{{ "/assets/result_small.gif" | absolute_url }}' width="50%"></a>
