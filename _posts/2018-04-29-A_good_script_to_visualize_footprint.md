---
layout: default
title: A good script to visualize footprint
date: 2018-04-29 20:43:52 +0800
categories: 
---

# Visualization of footprint

source: [shengxinjing/footprint](https://github.com/shengxinjing/footprint)

I occasionally found this repo in GitHub, and it's really beautiful. It use the api of baidu map to get the location of city or area of the given name, and then draw it on the map. It also used the echart script of baidu (I think this is the most difficult part, you need to read the document in detail, once I want to add a static label on it, but I didn't succeed. And I also want to use api of google map to get the location of citys in the world, but api of google map need to register, and I think I may not need it, so I didn't change it).

The author made a front-end by javascript:

![front-end]({{ "assets/footprint.gif" | absolute_url }})

It may use in many areas not only for footprints. For example, I made a dynamic graph of the universities my high school classmates went, and you can also use it to record the special things of areas in china. If you can change the code, you can also use it to show the data flow, popularity and other data, in other worlds, it can be used to visualize data.

This is an example the author given:
{% include footprint.html %}
