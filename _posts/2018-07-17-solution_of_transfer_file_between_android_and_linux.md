---
layout: content
title: solution of transfer file between android and linux
date: 2018-07-17 16:01:11 +0800
categories: linux
---

# Solution of file transfering of multi-device

## Scheme I Once Used
Sometimes, we need to transfer files between computer and cell phone, if we don't have a good solution, it will be troublesome.

- **USB**: Originally, I use USB to connect cell phone with computer, and there will be a mtp device on the computer and be mounted, we can enter the directory and copy files between them. However, because it use mtp, the speed is very slow, and I need a data line, it's still troublesome.

- **mid-server**: Then, I tried another way, I have a little server, I can transfer file to the server and then download it in another device. However, because it use scp, so I use termux in my android device, but the file downloaded can't be directly used in QQ or other applications, because lack of informations (I use Huawei phone). And it's also troublesome when I send the file, I need to type all the path of the file, the path is alway long.

- **bluetooth**: And then transfer with bluetooth came into my mind. It's very convenient, when sending files, I only need to select files in android device and choose 'share by bluetooth' or use command `bluetooth-sendto <filename>` in my linux. However, the speed of sending is very low, I always need to wait a long time when sending a file with a little bigger size.

- **social contact software**: An common method of this kind of file transfer is solved by QQ in China, however, QQ don't have a linux version, so I need to use it in virtual machine, if just for a file, it's too troublesome!

- **ftp**: And there is another way: use ftp. However, I still need to find the path of file in android side (although it's more convenient than type the whole path).

## File transfer by LAN

- **Solution of transfer from linux to cell phone or other devices:** When I'm finding the convenient way of file sharing, I found an article in a Subscription of weixin: [This is the link of the article](https://mp.weixin.qq.com/s/5KLfoTHfIdBHSh20OpuArA), it introduced an package: [**qr-filetransfer**](https://github.com/claudiodangelis/qr-filetransfer), It can directly transfer the file in LAN, and download by QR-code. It's really very convenient and fast, except for the long name of command (hahaha, I alias the command to a short name). **Don't forget, you need to put the send and receive devices in the same LAN.** And I just need to open a QR-code scanner to scan the qr-code in android device when download. (I found a good QR-code scanner: [QR Code Scanner](https://www.appsapk.com/qr-code-scanner/), it seems have no ads, and it works well. this is just for a recommendation).

![qr-filetransfer]({{ "assets/qr-filetransfer.svg" | absolute_url }})

- **Solution of transfer from android to computer or other devices:** However, I found a long time for an application like qr-filetransfer of android, and finally, I found one today, it's [**Sweech**](https://www.downloadatoz.com/sweech/com.sweech/). I only need to choose files, and select share, then choose Sweech, then it will give an address and a qr-code. If your receiver is phone, you can directly scan the qr-code, On your computer, you can type the address in your browser.
![Send-1]({{ "assets/Send-1.png" | absolute_url }})
![Send-2]({{ "assets/Send-2.png" | absolute_url }})
The speed is not very fast, but it's faster than bluetooth, and you can also use it when there is no network, you just need to open a hotspot on your laptop or cell phone, it can transfer so long as they are in the same LAN.

This solution cost me a long time to discover, it's really time-costing when configure these things. If this solution not fit you, hope you can find your own solution soon!
