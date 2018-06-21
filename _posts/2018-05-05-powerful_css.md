---
layout: content
title: powerful css
date: 2018-05-05 11:17:01 +0800
categories: sort_out
---

# CSS is powerful!

during my GitHub Page building, I have tried some css tricks, such as the omit of items according to the width in top panel; put the panel on the top; and the spining avatar and so on.

## Spin avatar

this is my spining avatar, try to put arrow on it:

<object id="picture" data='{{ "/assets/favicon.png" | absolute_url }}' type="image/png" width="200px" ></object>

And its implement is only several lines:
```css
#picture {
	-webkit-transition: -webkit-transform 1.6s ease-in-out;
		 transition: 	      transform 1.6s ease-in-out;
}

#picture:hover {
	-webkit-transform: rotate(720deg);
		 transform: rotate(720deg);
}
```

## animation

However, CSS can not only do this, I found an animation implemented totally by CSS in a [site](https://ustcta.com) built by my friend:

{% include sun.html %}

And I also found a changing taichi graph implemented totally by css, and the author wrote a [blog](https://css-tricks.com/creating-yin-yang-loaders-web/) to explain the process, and he gave other implement ways, like Canvas+JavaScript, and SVG+JavaScript:

{% include taichi.html %}

And following is a card when you put arrow on it, it will turn over and show the contents in the back.

{% include overturn.html %}

[source site](https://2017.igem.org/Team:Michigan_Software)
## Summary

This is a simple introduction of fancy work by css, and these are only a little part of works css can do, css is very powerful, we can use it to do many things and make our websites more fancy.