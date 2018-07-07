---
layout: content
title: Touchpad in linux
date: 2018-07-07 10:44:36 +0800
categories: linux
---

# Touchpad configure in linux

## [Synaptics](https://wiki.archlinux.org/index.php/Touchpad_Synaptics)

The driver package of touchpad in Archlinux is `xf86-input-synaptics`, After installed it, you can adjust the config file `/etc/X11/xorg.conf.d/70-synaptics.conf`, you can config mapping of gestures of one or two fingers, for example, my configure file is like this:
```sh
Section "InputClass"
    Identifier "touchpad"
    Driver "synaptics"
    MatchIsTouchpad "on"
        Option "TapButton2" "1"             # tap of two fingers stand for left click
        Option "TapButton3" "2"             # tap of three fingers stand for middle button
        Option "RBCornerButton" "3"         # tap in right bottom stand for right click
        Option "LBCornerButton" "1"         # tap in left button stand for left click
        Option "VertTwoFingerScroll" "on"   # enable two fingers scroll in vertical direction
        Option "HorizEdgeScroll" "on"       # enable horizon scroll in bottom
        Option "CircScrollTrigger" "2"
        Option "CoastingSpeed" "0"
        Option "LockedDragTimeout" "40000"  # delay time of drag-after-tap gesture
        Option "PalmDetect" "1"
        Option "PalmMinZ" "10"
        Option "MaxTapTime" "125"
        Option "CircularPad" "on"
        Option "VertHysteresis" "20"
EndSection
```
Because I always touch touchpad inadvertently when typing, so I forbade tap of one fingers, and mapped tap of two fingers to left click.

I gave some meanings of config items in comments, if you want to know in detail, you can man it

![synaptics]({{ "/assets/synaptics.svg" | absolute_url }})

This is the basic configuration of touchpad.

## [libinput-gestures](https://wiki.archlinux.org/index.php/Libinput#libinput-gestures)

libinput-gestures only support swipe of 3 or 4 fingers and pinch, however, it's enough.

my configure file is like this (I remove the comment parts):

```sh
gesture swipe up 3      _internal ws_up
gesture swipe up 4      xdotool key super
gesture swipe down 3    _internal ws_down
gesture swipe down 4    xdotool key ctrl+alt+p
gesture swipe left 3    xdotool key alt+shift+Tab
gesture swipe left 4    xdotool key ctrl+shift+Tab
gesture swipe right 3   xdotool key alt+Tab
gesture swipe right 4   xdotool key ctrl+Tab
gesture pinch in        xdotool key ctrl+minus
gesture pinch out       xdotool key ctrl+equal
```
- Swipe up and down of 3 fingers is for switching in workspaces; (**This is very useful when you open a virtual machine in another workspace**)
- Swipe up of 4 fingers is for overview (gnome);
- Swipe down of 4 fingers is prtscr button, and I bound it to flameshot;
- Swipe left and down of 3 fingers is for switching between applications;
- Swipe left and down of 4 fingers is for switching between tabs;
- And pinch in and out is for zoom in and out.

It use xdotool to map gestures with shortcut. It also works for some functions to your desktop, and you can view the comments of configure file for detail.

## Summary

Some times we view pdf documents or surf internet with browser, we always turn pages, and our hand always stay on touchpad, so if you can do these frequently-used events directly on touchpad, it will be convenient and efficient.

There are other configure ways of touchpad. for example: [fusuma](https://wiki.archlinux.org/index.php/Libinput#fusuma), [GnomeExtendedGestures](https://wiki.archlinux.org/index.php/Libinput#GnomeExtendedGestures) and so on, you can also try these. Find, Configure again and agin, I found it's not hard to use touchpad in linux.
