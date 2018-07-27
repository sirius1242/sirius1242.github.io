---
layout: content
title: Use windows software in Linux 
date: 2018-07-08 12:38:08 +0800
categories: linux
---

# How to use windows software in Linux?

For this kind of situation, I always use software of open-source similar in functions, for example:
- Adobe PhotoShop -> Gimp
- Adobe illustrator -> Inkscape
- MS Office -> Libreoffice
- ...

And, some software which use widely have Linux version, such as Matlab, Mathmatica, Xilinx Vivado and so on. So you can download Linux version of them and install directory.

However, there are still many software which not have a similar open-source software to replace (or you haven't found), and they don't have Linux version, how to use them?

## [Wine](https://wiki.archLinux.org/index.php/Wine)

Wine is a compatibility layer capable of running Microsoft Windows applications on Unix-like operating systems.

wine is open-source, so you may find it in your official mirrors. If not, you can download version of your distribution and install it.

Some period ago, wine is not good, I'm a Chinese, and sometimes it can't show all Chinese characters correctly, so I gave up. It seems wine is much batter now, so you can have a try.

## [CrossOver](https://en.wikipedia.org/wiki/CrossOver_(software))

CrossOver is a Microsoft Windows compatibility layer available for macOS and Linux. CrossOver is better than wine, and its league is also the biggest contributor of wine. However, it's non-free, and it's commercial software, I didn't have tried it, so I can't give any suggestions.

## Deepin-wine

[Deepin](https://en.wikipedia.org/wiki/Deepin) is a distribution of Linux, and it is created by Chinese. Deepin developed their own wine, its performance is batter than wine, but it only supports several packages, such as QQ, WeChat and so on.

Arch Linux users can install the packages running in deepin-wine from [AUR](https://aur.archLinux.org/).

## [Appimage](https://en.wikipedia.org/wiki/AppImage)

Appimage can be directly executed because it packed the dependencies and other things, so if you don't want wine or other things to mass your system, you can directly download the software's appimage, and then you can directly execute them without install anything, and it also not need sudo.

## [Virtual Machine](https://en.wikipedia.org/wiki/Virtual_machine)

Some people thought virtual machine is very slow. Yes, it can only use part of your system resources, and it also needs to convert the instructions sent by your application from guest to host. However, if your computer is not too bad, and you chose a light guest OS, it performance good.

I use [VirtualBox](https://wiki.archLinux.org/index.php/VirtualBox), you can also try VMWare.

My CPU is `Intel(R) Core(TM) i5-7200U CPU @ 2.50GHz`, and I have memory of 8GB, and my disk is 256GB SSD, Windows XP and Windows 7 perform well, Windows 10 also fluent but the temperature is always around $70^\circ C$ and sometimes make my Arch Linux become slow.

But, most software I need can use in Windows 7 or Windows XP, so it's fine.

For software like QQ and others which need higher versions of Windows, I use them in Windows 7, and for some software likes Red Alert, which costs many resources and not need high version, I run them in Windows XP. (I have tried OpenRA, but it's a little complex, and I gave up)

I use Windows 7 with virtual disk allocate in fixed size, and it may run faster. I allocated 20 GB, and it still only used half. If you don't install much software in virtual machine (In fact, you always not need to install much) , you don't need to allocate much.

### Boot your dual system of Windows in VirtualBox

[reference](https://superuser.com/questions/495025/use-physical-harddisk-in-virtual-box)

Sometimes you work in a team, and you need to unify the environment, you have to use some software which can only be installed in Windows 10 or higher version, and you need to use virtual machine of Windows 10 now.

I'm in a similar situation now, and I decided to use my local dual system of Windows 10 in VirtualBox.

It's not complex, and it needs only several steps.

- create disk image
```sh
VBoxManage internalcommands createrawvmdk \
    -filename /path/to/file.vmdk \
    -rawdisk disk (-partitions number1,number2,...)
```
	- This image includes my EFI partition and Windows data partition, and it can be directly boot after I add the vmdk to virtual machine.

- You can also change the mode of vmdk, for example: you can set Writethrough to vmdk, then you can do modification in that partition in your virtual machine.
![virtualdisk]({{ "/assets/virtualdisk.png" | absolute_url }})
- And don't forget to enable EFI boot in your Virtual Machine settings.

Because I use UEFI boot, so this is the tutor of Windows with UEFI boot, I think legacy boot should not too far away from this.

## Boot your dual system of Windows?

However, if the software cost many resources, you may need to use your dual system Windows 10, if you don't have it, I'm afraid you need to install one.
