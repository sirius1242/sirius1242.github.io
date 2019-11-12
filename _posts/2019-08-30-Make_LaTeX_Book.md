---
layout: content
title: Make LaTeX Book
date: 2019-08-30 14:23:19 +0800
categories: summary chinese
---

　　假期看了《某科学的超电磁炮》，因为是番外，又去看了《魔法禁书目录》。但魔禁三拍的实在是让人看得云里雾里，看到好多评论说要去看原著才能看懂，找了一下，发现只有 TXT 版本的，和 EPUB 版本的。因为找到的资源里 EPUB 版本的都在百度网盘，以及我需要在手机上看等原因，我就直接选择了把 TXT 格式的版本用 LaTeX 转换成 PDF 格式，正好可以尝试一下 LaTeX 的 Book。

<!--more-->

　　说干就干，首先是把导言区写好，然后就是将正文里的章节用 `\chapter`，`\section`，`\subsection` 等划分，这一步可以直接用正则表达式过滤，不过因为 TXT 质量可能有点差，有些地方需要目录生成之后自己检查有哪些地方出问题了然后进行调整。其次是特殊符号的调整，这个 TXT 里面有一些特殊字符是用 html 代码（类似`&#8231;`）的形式表示的，因此也需要把它们转化成本来的字符（注：因为字符集的原因，部分字符直接放在文本里时会导致 vim 报错，因此建议每次替换就保存一次，防止特殊字符导致无法保存而又找不到问题出在哪里）。其他的符号基本上就是因为 `&`、`#`、`%`、`_`等符号在 LaTeX 里面有其他的意义，因此需要加上 `\` 进行转义，链接里面同样有很多特殊字符，直接用 `\url` 括起来就好了。

　　我对整个文本里面的注释进行了替换，用 `\footnote` 括了起来，这样就变成了书下注释，我比较喜欢这样（利用 LaTeX 的特性），这步完全可以不搞。可以用正则替换或者宏录制，不过一部分还是要手工调节（因为不规范，大部分都是以全角括号结尾的，但部分用了半角括号甚至其他符号，另外注释内有括号的情况也会干扰）。

　　刚开始编译完成的时候发现部分字显示不出来，查了一下是字体的原因，直接`\setCJKmainfont{SimSun}`的话页眉又比较难看，找了好久发现可以直接`\setCJKmainfont[BoldFont=FZXiaoBiaoSong-B05S, ItalicFont=KaiTi]{SimSun}`，也就是其实 ctexbook 里面页眉用的是斜体字体，section head 等处的字体使用的是粗体字体，找到与默认里页眉和 section head 等处字体相似的粗体字体和斜体字体添到里面就可以了。（虽然可能是因为基础不扎实，不过折腾了半天，还是要写出来的。）

　　然后就是目录结构了，把各章节里数字单独一行的小节用 `\subsection` 括起来，但因为没有标题，全部放在目录里很丑，为(ge)了(ren)美(xi)观(hao)起见，我选择了在每个 `\chapter` 开头添加该章节的子目录，于是使用了 `minitoc` 宏包，需要在 `\tableofcontents` 前添加 `\dominitoc`，并且在每个 `\chapter` 行后面添加 `\minitoc`，然后还是个人喜好起见，把只有一个数字的 `\subsection` 中心对齐，并且去掉自动生成的章节号（本来标题只有一个数字，前面要是加上一堆乱七八糟的行号就感觉很难看），分别使用了 `titlesec` 宏包以及使用 `\setcounter{secnumdepth}{1}` 取消 `\subsection` 的行号生成（用 `\subsection*` 的话目录里不会出现，直接用这个比较省力）。有的 `section` 标题是中文后面带英文的，有点太长，于是就用了 `\section[短标题]{原标题}` 的形式来减少目录和页眉中的标题长度。

　　编译出来发现子目录是有了，而且 `subsection` 的页码也对，但链接不对（点击时全部会跳转到该 `section` 下的第一个 `subsection`），找了半天发现原来是 `minitoc` 与 `titlesec` 两个宏包冲突（这点 log 里有说，不过不知道链接不对是这个原因），又找了半天用了一个比较奇怪的命令 `\g@addto@macro{\CTEX@subsection@format}{\centering}`（前后分别要加上 `\makeatletter` 和 `\makeatother`），抛弃了 `titlesec`。（`titletoc` 也可以做到类似 `minitoc` 的事情，但不知道为什么我这边生成的目录里面章节号和 chapter head 重叠了，很难看，而且没法看，所以还是选择了一个代替 `titlesec` 的解决方案。

　　剩下的问题基本就是 TXT 本身的问题了，编译出来之后真是一边看一边挑错，大多是在不该断行的地方断行（特别多，大概是因为这个 TXT 的编辑之一（因为只有几个章节这种问题特别多）使用的编辑器的问题），还有一些符号使用不规范，比如 `”` 变成了其他各种各样的符号之类的。错别字问题倒不多，不过里面 `纹丝不动` 被称作 `文风不动`，不懂是不是某个地区的特殊叫法（更新：原来就是成语，是我基础不扎实了）。如果不担心质量，挑错就不必了，不过强迫症表示忍不了（主要还是源代码在手上，要不然也没必要改了）。
　　
　　还有一点就是有一部分引用和正文放到一起会显得乱，`\textit` 不能用于多行，找了一下发现 `\textbf`，`\textit`，`textsf` 等都有配套的用于多行的命令，分别是 `\bfseries`，`\itshape`，`\sffamily`。（这个大概也是基础不扎实吧）

　　总之，因为想要定制所以花了不少时间，但也是很多问题需要搜索之后才知道怎么解决，继魔禁旧约之后又把魔禁新约前二十卷也做成了 pdf，这次就快多了。然后很多步骤按理说用正则表达式可以轻松解决的，但因为 TXT 原件的不规范多做了不少重复性的工作。总的来说虽然花了不少时间，不过挺有成就感的，然后 LaTeX 做出来的 pdf 真好看！（暴言）

旧约以及 SS1，SS2 已简单校对完毕（边读边校），项目地址：[](https://github.com/sirius1242/Toaru-index)，编译好的 pdf 可以在 Release 中找到。

　　注：
本篇提到的 tex 代码导言区及解释：
```latex
\documentclass[a6paper]{ctexbook} % 因为要在手机上看，所以使用 a6paper，但实现 a6paper 需要下一行
\usepackage[paperwidth=105mm, paperheight=148mm]{geometry}
\usepackage{pdfpages, minitoc} % 要加封面可以用 pdfpages
\usepackage{hyperref} % 自动生成链接，以及 \url 需要
\usepackage{amssymb} % 部分特殊字符
\newcommand\sbullet[1][.5]{\mathbin{\vcenter{\hbox{\scalebox{#1}{$\bullet$}}}}} % 用于人名分隔符，个人认为 \bullet 太大，\cdot 太小

\setCJKmainfont[BoldFont=FZXiaoBiaoSong-B05S, ItalicFont=KaiTi]{SimSun} % 字体设置，Linux 默认的 fandol 字族部分字显示不出
\setcounter{tocdepth}{1} % 限制目录深度（subsection 不列入总目录）
\setcounter{minitocdepth}{3} % 限制子目录深度（此句可无）
\setcounter{secnumdepth}{1} % subsection 及以下不进行自动编号
\makeatletter
\g@addto@macro{\CTEX@subsection@format}{\centering} % 居中 subsection head
\makeatother
```

　　注：想知道魔禁三为什么拍的这么烂可以去看 JZB 的访谈，[这个链接](https://tieba.baidu.com/p/6094916945)是贴吧网友从里面挑出来的一些东西，献上一张表情包：

![]({{ "/assets/JZB.jpg" | absolute_url }})
