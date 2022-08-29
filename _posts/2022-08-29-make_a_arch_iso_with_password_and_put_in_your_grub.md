---
layout: content
title: make a arch iso with password and put in your grub
date: 2022-08-29 20:50:42 +0800
categories: linux chinese
---

折腾了一下定制一个带 root 密码的 arch iso 并且通过 loopback 的方式放进 grub 的方案。虽然在 wiki 上有，不过稍微零散了一点，毕竟折腾了一下就顺便水个 blog。

<!--more-->
<span style="color:red">注：以下仅为作者自身的折腾经历，作者不为按本文所述方式进行操作后产生的问题负责。</span>

注：部分命令可能需要 sudo 权限。

archiso 的可定制性很强，可以进行各种定制，而且 archiso 的工具也是较为丰富的，除了安装系统外，<del>经常被作为医疗事故后抢救的工具来使用</del>。

首先需要安装 archiso 软件包，如果是 arch 本身，直接 pacman -S 就好了；如果是其他发行版，可以下一个 archiso 然后解压里面的 squashfs，再 arch-chroot 进去安装，总之环境还是很好配的。之后就是把 archiso 带的配置文件复制出来，Ref:[Prepare a custom profile](https://wiki.archlinux.org/title/archiso#Prepare_a_custom_profile)：

```sh
$ cp -r /usr/share/archiso/configs/releng/ archlive
```

之后可以对里面进行各种定制，wiki 上说了可以更改 pacman.conf 之类的，这里以为 root 添加密码为例，Ref:[Users and passwords](https://wiki.archlinux.org/title/archiso#Users_and_passwords)：

```sh
$ openssl passwd -6
```
输入密码之后将生成的 hash 写入 `archlive/airootfs/etc/shadow` root 项的第二个字段即可。当然也可以添加用户并且为其添加密码，wiki 这部分有进行说明。

做好这些之后还不够，如果你现在 build iso 并且运行就会发现，仍然会 autologin，这时需要修改`archive/airootfs/etc/systemd/system/getty@tty1.service.d/autologin.conf`中的 getty 相关配置，Ref:[Changing automatic login](https://wiki.archlinux.org/title/archiso#Changing_automatic_login)。如果仅仅是删掉该文件，iso 会卡在一些奇怪的地方，不过你可以通过进入其他 tty 来登录。

如果需要指定用户，只提示用户输入密码，应按如下修改，Ref:[Prompt only the password for a default user in virtual console login](https://wiki.archlinux.org/title/getty#Prompt_only_the_password_for_a_default_user_in_virtual_console_login)：
```sh
[Service]
ExecStart=
ExecStart=-/sbin/agetty -o '-p -- <username>' --noclear --skip-login - $TERM
```

定制完成之后 Build ISO，Ref:[Build the ISO](https://wiki.archlinux.org/title/archiso#Build_the_ISO):
```sh
$ mkarchiso -v -w /path/to/work_dir -o /path/to/out_dir /path/to/profile/
```
其中 work_dir 是一个存放生成 iso 所需临时文件的目录，/path/to/profile/ 即为刚才指定的配置文件（上例为 `archlive`）

可通过run_archiso 脚本或者直接通过 qemu 来对生成的 iso 进行测试，Ref:[Test the ISO in QEMU](https://wiki.archlinux.org/title/archiso#Using_the_IS://wiki.archlinux.org/title/archiso#Test_the_ISO_in_QEMU)：

```sh
$ run_archiso -i /path/to/archlinux-yyyy.mm.dd-x86_64.iso
```

如果发现不符合预期，可以删掉 `work_dir` 中的文件重新 mkarchiso，之前下载完成的软件安装包 (zst) 似乎并不需要重新下载。

结果如图：

<img alt="login" src='{{ "/assets/login.png" | absolute_url }}' width="50%">

测试完成后，剩下的就是通过 grub 启动，Ref:[Configuring GRUB](https://wiki.archlinux.org/title/Multiboot_USB_drive#Configuring_GRUB)

如果只是需要在本机添加 grub 启动项而非 MultibootUSB，将 iso 放入 /boot/iso，并直接在 /etc/grub.d/40_custom 添加如下语句即可（若放在其他位置，isofile 等变量需进行修改）：

```sh
set imgdevpath="/dev/disk/by-uuid/UUID_value"
menuentry '[loopback]archlinux-yyyy.mm.dd-x86_64.iso' {
	set isofile='/boot/iso/archlinux-yyyy.mm.dd-x86_64.iso'
	loopback loop $isofile
	linux (loop)/arch/boot/x86_64/vmlinuz-linux img_dev=$imgdevpath img_loop=$isofile earlymodules=loop
	initrd (loop)/arch/boot/intel-ucode.img (loop)/arch/boot/amd-ucode.img (loop)/arch/boot/x86_64/initramfs-linux.img
}
```

最后 grub-mkconfig:
```sh
$ grub-mkconfig -o /boot/grub/grub.cfg
```

第一句也可以是 wiki 中提到的其他语句（另一种 Using UUID 或 Using labels）

在我本机（Arch Linux with kernel 5.18.15-arch1-2）上进行上述操作后发现 grub 找不到 iso 文件，经过调试后发现是 $root 变量设置出现问题，不知道是不是 os-prober 的干扰，于是在 set imgdevpath 语句前添加了:

```sh
search --no-floppy --fs-uuid --set=root UUID_value
```

上述链接中也提供了设置多 iso 并让 grub 自动寻找的方案，不过这里因为主要叙述我的折腾经历，因此不再提及。

如果想默认隐藏 grub 菜单，也可以使用 `GRUB_HIDDEN_TIMEOUT` 变量，这样在设置的 timeout 时间内仅会展示一个 countdown，这时按 esc 进入 grub menu，否则进入 default 启动项。（`GRUB_TIMEOUT` 需设置为 0）Ref:[Simple configuration handling](https://www.gnu.org/software/grub/manual/grub/html_node/Simple-configuration.html)
