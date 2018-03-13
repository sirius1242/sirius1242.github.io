---
layout: content
title: Mass send message by python in QQ
date: 2018-02-15 21:54:03 +0800
categories: python
---
## [Back to home]({{ site.url }}/)
# some experiences for sending QQ message by python
I have many friends in QQ, so it's a tired job to send message to greet when the festival came. I saw a project not long ago for giving suggesstions to newers in the community group, and I contacted qqbot at that time: 
## [QQbot](https://github.com/pandolia/qqbot)
qqbot is a robot for QQ based on Tencent SmartQQ protocol realized by python, you can use it to write your own QQ bot in python.
## Installation:
```sh
pip install qqbot
```
## Usage:
#### usage is on the github, and in Chinese, I won't copy it
there is my example:
```python
import time
# for using sleep , the first time didn't add sleep, and I was banned for hours (XD)
from qqbot import _bot as bot
bot.Login(['-q', 'your_qq_number'])
# it may pop up the image viewer for displaying the QR code for logging in
g = bot.List('buddy')
# variable for storing the informations of your friends
clist = ['mark_a', 'mark_b']
# list to store marks of the friends whose mark and call is the same
blist = {'mark_a1': 'call_1', 'mark_a2': 'call_2'}
# list to store marks and calls of the friends whose mark and call is different
for i in g:
    if i.mark in blist:
        bot.SendTo(i, '新年快乐！'+blist[i.mark])
        time.sleep(0.2)
    elif i.mark in clist:
        bot.SendTo(i, '新年快乐！'+i.mark)
        time.sleep(0.2)
```
That's my script, if you have other demand, you can use the interfaces to write other scripts, there are many interfaces it offers, the project is really great!

##### I don't mean to hurt someone's feeling, just a test for qqbot, and I really added too many friends, so don't tell others:)
