---
layout: content
title: Hackergame 2022 writeup
date: 2022-10-29 15:33:19 +0800
categories: misc chinese
---

怎么说呢，上一次好好打 Hackergame 还是 2017 年的第四届，中间因为各种原因一般只看几道感兴趣的题目（其实都是找借口）。离开学校了反倒认真打了一场，但因为时间有限以及个人能力不行，最后也没打多少分，就写个心路历程吧，整理一下做出来或者花了较多时间但最后没做出来的题目的思路（没做出来的题目会标出来）

<!--more-->

## Hackergame2022 解题心路历程

先看一下总分吧，binary 少的可怜，不过虚拟机炸了所以几乎没怎么看 PE 相关的题目（又找借口，不过按最后还有几道题目有思路但没时间的情况看来，花时间把虚拟机折腾好再做题的性价比确实不如直接去看其他题），从比赛开始第二天晚上就掉出前 100 没再能回来了，555。

<img alt="score" src='{{ "/assets/score.jpg" | absolute_url }}' width="100%">

注：由于（可能是老版本）GitHub Pages 过于惜字如金，所以文中所附的代码都去掉了空行，否则在本地预览时代码块无法正确渲染。

### 签到
- 没啥可说的，经典操作，改 url。要命的是一开始没看到，反而去 inspect element 去了，一小会没思路就去做别的题去了，后面回过头来才发现

### 猫咪问答喵
- NEBULA 成立：2017-03 [ref](https://cybersec.ustc.edu.cn/2022/0826/c23847a565848/page.htm)
- SFD KDE 程序：Kdenlive。Slides 上找半天没找到，尝试搜索引擎搜图也没搜到相关结果（毕竟这些软件都很像），最后去翻了视频：[ref](https://ftp.lug.ustc.edu.cn/%E6%B4%BB%E5%8A%A8/2022.9.20_%E8%BD%AF%E4%BB%B6%E8%87%AA%E7%94%B1%E6%97%A5/video/2022-09-17%2014-21-43.mkv)
- Firefox Win2000: 12 [ref](https://firefox.softwaredownload.co.in/windows-2000)
- argc 不允许为 0: 仓库里搜 CVE-2021-4034 得到[对应 commit](https://github.com/torvalds/linux/commit/dcd46d897adb70d63e025f175a00a89797d31a43) 为 `dcd46d897adb70d63e025f175a00a89797d31a43`
- 连接域名：搜索 `e4:ff:65:d7:be:5d:c8:44:1d:89:6b:50:f5:50:a0:ce` 得到如下页面：[ssh.log — Book of Zeek (git/master)](https://docs.zeek.org/en/master/logs/ssh.html)，log 里的 `id.resp_h` 字段的 ip: 205.166.94.16，去搜索引擎反查可知域名为 sdf.org。
- 网络通定价：搜了半天，在 [关于实行新的网络费用分担办法的通知](https://www.ustc.edu.cn/info/1057/4931.htm) 看到 2011-01-01 不对，然后看到`终止网字 [2003] 1 号` 字样，去[网络信息中心网字文件](https://ustcnet.ustc.edu.cn/11109/list2.htm) 搜到[网字 1 号文件](https://ustcnet.ustc.edu.cn/2003/0301/c11109a210890/page.htm)，显示为 2003-03-01 开始实行。

### 家目录里的秘密
- vscode config: 我是直接解压完 grep 就看到 flag 了
- rclone: 配置文件（`user/.config/rclone/rclone.conf`）下的密码的加密 key 是被硬编码的，通过如下 go 程序可以 recover：[ref](https://forum.rclone.org/t/how-to-retrieve-a-crypt-password-from-a-config-file/20051)
```go
package main
import (
    "crypto/aes"
    "crypto/cipher"
    "crypto/rand"
    "encoding/base64"
    "errors"
    "fmt"
    "log"
)
// crypt internals
var (
    cryptKey = []byte{
        0x9c, 0x93, 0x5b, 0x48, 0x73, 0x0a, 0x55, 0x4d,
        0x6b, 0xfd, 0x7c, 0x63, 0xc8, 0x86, 0xa9, 0x2b,
        0xd3, 0x90, 0x19, 0x8e, 0xb8, 0x12, 0x8a, 0xfb,
        0xf4, 0xde, 0x16, 0x2b, 0x8b, 0x95, 0xf6, 0x38,
    }
    cryptBlock cipher.Block
    cryptRand  = rand.Reader
)
// crypt transforms in to out using iv under AES-CTR.
//
// in and out may be the same buffer.
//
// Note encryption and decryption are the same operation
func crypt(out, in, iv []byte) error {
    if cryptBlock == nil {
        var err error
        cryptBlock, err = aes.NewCipher(cryptKey)
        if err != nil {
            return err
        }
    }
    stream := cipher.NewCTR(cryptBlock, iv)
    stream.XORKeyStream(out, in)
    return nil
}
// Reveal an obscured value
func Reveal(x string) (string, error) {
    ciphertext, err := base64.RawURLEncoding.DecodeString(x)
    if err != nil {
        return "", fmt.Errorf("base64 decode failed when revealing password - is it obscured? %w", err)
    }
    if len(ciphertext) < aes.BlockSize {
        return "", errors.New("input too short when revealing password - is it obscured?")
    }
    buf := ciphertext[aes.BlockSize:]
    iv := ciphertext[:aes.BlockSize]
    if err := crypt(buf, buf, iv); err != nil {
        return "", fmt.Errorf("decrypt failed when revealing password - is it obscured? %w", err)
    }
    return string(buf), nil
}
// MustReveal reveals an obscured value, exiting with a fatal error if it failed
func MustReveal(x string) string {
    out, err := Reveal(x)
    if err != nil {
        log.Fatalf("Reveal failed: %v", err)
    }
    return out
}
func main() {
    fmt.Println(MustReveal("YOUR PSEUDO-ENCRYPTED PASSWORD HERE"))
}
```

### HeiLang
- 也是回过头来看到的，根据题目描述和查看代码发现只要简单地将 `A[x|y|z]=t` 语法改为 `A[x]=A[y]=A[z]=t` 即可，在 vim 里 `s/ | /]=a[/g` 再运行即可

### Xcaptcha
- 其实就是简单地把验证页面的运算数字提取算出来再把结果喂给 server 就好了，结果在这题因为 cookie 卡了很久，浪费了很多时间
- 最后调试完写了如下脚本：
```sh
curl -c cookie.txt 'http://202.38.93.111:10047/?token=<your_token>'
curl -b cookie.txt -c cookie.txt 'http://202.38.93.111:10047/' # 需通过 -c cookie.txt 刷新 cookie，否则可能会导致 session 错误
curl -b cookie.txt -c cookie.txt 'http://202.38.93.111:10047/xcaptcha' -H 'Connection: keep-alive' -H 'Referer: http://202.38.93.111:10047/'> tmp.html
# 本来下面三行 grep 想直接忽略数字，然后逐条处理放进数组的，结果数组死活加不进去元素，有点急所以用了不优雅的写法（
a1=$(grep 'for="captcha1' tmp.html | sed -E 's/.*>([0-9]+\+[0-9]+)\ .*/\1/g' | bc);
a2=$(grep 'for="captcha2' tmp.html | sed -E 's/.*>([0-9]+\+[0-9]+)\ .*/\1/g' | bc);
a3=$(grep 'for="captcha3' tmp.html | sed -E 's/.*>([0-9]+\+[0-9]+)\ .*/\1/g' | bc);
data="captcha1=$a1&captcha2=$a2&captcha3=$a3"
# 下面这里要加一些 headers（比如 Referer 之类的），否则服务器会报 500，我是通过浏览器 copy as curl 改的。
curl -b cookie.txt 'http://202.38.93.111:10047/xcaptcha' -X POST -H <lots_of_headers> --data-raw $data
```

### 旅行照片2.0（<span style="color:red">只解出第一问</span>）
- 照片分析：直接在 exiftools 里读，我是通过 `exiftools -a -u -g1 <photo.jpg>` 看的，然后 EXIF Version 要改一下，改成提示的小数形式

### LaTeX 机器人
- 之前从没想过做 LaTeX 自动生成居然还会有这种安全问题，纯文本直接 `input("/flag1")` 即可
- 特殊字符混入的：在 `input`/`include` 前面加 ``\catcode`\#=12`` 即可（下划线把 `#` 换成 `_`）。
    - 大概就是这样：[ref](https://tex.stackexchange.com/a/353018)
    ```latex
    {\lowercase{
    \catcode`\#=12
    \cactcode`\_=12}
    \input{"/flag2"}}}
    ```

### Flag 的痕迹（<span style="color:red">未解出</span>）
- 本来找了半天 dokuwiki 的 bug，发现好像并没有很多相关信息
- 然后发现了可以通过 `rev=<rev_id>` 在关闭 `do=revision` 时访问历史版本([ref](https://forum.dokuwiki.org/d/14567-current-revision-of-page/9))
- 但这你要先知道版本号，然后又查到了 `at=<timestamp>` 的语法([ref](https://www.dokuwiki.org/date_at?rev=1412251581))，并且在右下角会显示 `<rev_id>.txt.gz`，然后发现了两个历史版本：`1665224447`和`1665224470`，并且现在的版本号为`1666320801`。然而两个历史版本中并没在 start 页面藏 flag，和题目描述不符啊，尬住了。然后最后实在想不出来还把前两个版本页面上全部 base64 解码了，属于是病急乱投医了

### 安全的在线测评（<span style="color:red">只解出第一问</span>）
- 无法 AC 的题目：看了代码之后看到 `/data/static.out`，想到可以读这个文件来输出结果。
```c
#include <stdio.h>
int main()
{
    FILE *fp = fopen("./data/static.out", "r");
    char a[512], b[512];
    while (fscanf(fp, "%s\n%s", &a, &b) != EOF)
    {
        printf("%s\n%s\n", a, b);
    }
    return 0;
}
```
- 动态数据：（<span style="color:red">未解出</span>）
<br>想到也是分别读 `/data/dynamic%d.out`。然后因为要运行多次，还做了写一个文件记录当前进行到第几个数据的方案。发现 RE 之后没多想，以为是没有写权限之类的（因为并没能拿到 stdout），又做了个一次性读取 `/data/static.out` 和 `/data/dynamic%d.out` 的方案，最后才发现 server 端脚本有这句：
```python
os.chmod(outpaths[i], 0o700)
```
    - 之前一直在想既然 static 能读，那目录是有读权限的，dynamic 应该也能读，还是代码没看仔细；又因为本地跑的时候，还没配置过，su 要输密码会卡住，就直接把 `su -c runner [path]` 改成了 `[path]`，结果本地跑的好好的远程跑不动，真的是（

### 线路板
- 用 `gerbv` 打开，`ebaz_sdr-F_Cu.gbr` 那一层，flag 那里用鼠标小心框出选中 flag 的文字部分笔画，最后人肉 OCR 得到 flag。
<img alt="first flag image" src='{{ "/assets/flag_layer.jpg" | absolute_url }}' width="100%">

### 微积分计算小练习（<span style="color:red">未解出</span>）
- 一开始没搞懂，还以为数据会存在本地（抱歉，菜到各位了）。然后后面发现是分享连接后面的 `result` 是 `score:name` 的 base64，并且会把 base64 解码后的结果插入正文的 HTML 中，于是想到了 XSS，然后一直在尝试各种插入 js，最后发现运行不了，实在想不出来就去做别的题了。中间也有尝试用 get cookie without js 之类的关键词搜索过，但就是没搜出来，搜索能力还是太差。

### 惜字如金（<span style="color:red">只解出第一问</span>）
看了下题目描述，发现是要爆破 secret，不过爆破规则比较简单，就是在各个辅音字母位点尝试插入一到多个相同的辅音字母，在每段末位插入 0 到 1 个 'e' 即可。因为急所以没写 XZRJification 脚本，只对比了 hash 开头，不过一共没几个，脚本输出之后人眼确认一下就好，上 exp：
```python
from hashlib import sha384

vowel=['a','e','i','o','u']

key1 = "us"
key2 = "t"
key3 = "c"
key4 = ".ed"
key5 = "u"
key6 = ".c"
key7 = "n"

diff = 39 - 11 + 1
for i in range(diff):
    key_1 = key1 + i*'s'
    for j in range(diff-i):
        key_2 = key_1 + key2 + j*'t'
        for k in range(diff-i-j):
            key_3 = key_2 + k*'c' + key3
            for x in range(2):
                key_4 = key_3 + x * 'e'
                for l in range(diff-i-j-k-x):
                    key_5 = key_4 + key4 + l*'d'
                    for y in range(2):
                        key_6 = key_5 + key5 + y*'e'
                        for m in range(diff-i-j-k-x-l-y):
                            key_7 = key_6 + key6 + m * 'c'
                            n = diff-i-j-k-x-l-y-m
                            for o in range(2):
                                key = key_7 + (n-o)*'n' + o*'e'
                                secret = bytes(key.encode())
                                _hash = sha384(secret).hexdigest()
                                if _hash[:5] == "ec18f" or _hash[:6] == "ecc18f" or _hash[:7] == "eccc18f" or _hash[:8] == "ecccc18f" or _hash[:6] == "eccccc":
                                    print(key+":"+_hash)
```

### 不可加密的异世界（<span style="color:red">只解出前两问</span>）
- 疏忽的神：算法为：明文 Name+"Open the door!" 再根据输入的 key 进行 padding，如果 key 超过长度则后半部分作为 iv，最后明密文相等则给 flag。一开始想 ECB 弱密码，当时没看到是只加密一次且明密文要相等，搞错了。然后想：既然只加密一次，那只有加入 IV 才有希望，只要限制在一个 block，CBC 可以对明文 IV 异或一次再加密。明文 14 长，所以肯定是 AES（脚本限制 DEC 为 8），然后用随意一个 key（称 key1）解密明文，得到的结果再和明文异或，就得到了所需的 IV，最后提交的时候选 AES+CBC，key 为刚才解密时的 key+IV，就能拿到 flag。
- 心软的神：算法为，生成一串随机明文，然后输入多次 key，每次取一段明文，要求明文整体加密后与该段明文对应的密文与该段明文相同，还是上题的办法，但要倒推，每段密文先解密，把解密出的明文和对应的该段明文异或得到 IV（也就是上一段密文），最后倒退到开头得到初始 IV，代码如下：
```python
from magic_box import *
passes=bytes.fromhex(input())
key=bytes.fromhex("01010101010101010101010101010101")
magic_box = Magic_box("AES", "ECB", key)
for i in range(10):
    iv = passes[i*16:(i+1)*16] #current crypted, same as plain in first round
    for j in range(i+1):
        curr_p = passes[(i-j)*16:(i-j+1)*16] #current plain
        mid = bytes(magic_box.auto_dec(iv))
        iv = bytes(x^y for x,y in zip(mid, curr_p))
print("01010101010101010101010101010101" + iv.hex())
```
虽然思路是对的，但中间调试脚本调了半天。
- 严苛的神：(<span style="color:red">未解出</span>)
<br>这次不能选择 IV 了，并且要加密两次。加密两次就终于用到第一问思路的弱密码了，所以就 DES-ECB。但要求 key 是由输入进行 crc128 计算得到的，刚开始搞错了，尝试爆破了一下，发现半天没出来菜想到数量级不对。然后想用现成的逆向工具，搜到了[crchack](https://github.com/resilar/crchack)，也不知道是题目用的算法和工具有点差异还是工具算 128 有点问题（没仔细研究代码），crc32 的逆向都没问题，但 128 的就是不行。然后找到了[CRC and how to Reverse it](http://www.woodmann.com/fravia/crctut1.htm)（如果该页看不了请想其他办法），但大晚上实在是看不进去，再加上有点急（你先别急），最后就去看别的题了。

### 置换魔群（<span style="color:red">只解出第一问</span>）
- RSA：就是一个置换群阶的问题，题目给出了 e = 65537，模是置换群的长度 n 阶乘，直接求 $e^{-1} \mod{n!}$ 即可得到 d，然后把输出的密文转化成 permutation_element，对其进行 d 次变换即可（即 permutation_element 为 msg，求 msg ** d）。但发现要求计算 15 次，然后题目那边的输出有个 [1,2,3] 有点干扰，昨晚很急，不想思考只想上分，调了半天脚本，exp 如下：
```python
import re
from Crypto.Util.number import inverse
from permutation_group import permutation_element, permutation_group
from math import factorial
import socket
def s2n(x): return [int(x) for x in re.findall(r"\-?\d+\.?\d*", x)]
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect(('202.38.93.111', 10114))
print(s.recv(1024))
s.send(bytes("<your_token>\n".encode()))
print(s.recv(1024).decode())
s.send(bytes("1\n".encode()))
log = s.recv(1024).decode()
for i in range(15):
    log = s.recv(1024).decode()
    print(log)
    # only save msg to log
    log = s.recv(16384).split(b'\n')[-3].decode()
    key = s2n(log)
    print(key)
    msg = permutation_element(len(key), key)
    d = inverse(65537, factorial(len(key)))
    ans = '['+(','.join(str(x) for x in ((msg ** d).permutation_list))+'\n')+']'
    print(ans)
    s.send(ans.encode())
    print(s.recv(1024).decode())
print(s.recv(1024).decode())
```

### 光与影
- 把网页 html 和 js 下下来，一开始瞎改，题目描述说要不断前进，以为用加速的办法，加速到地面都要平了结果还是没东西出来
- 然后看了一下代码里的 lessons，得知 shader 函数主要在 fragment-shader.js 里面（这个看代码体量应该就能看出来）
- 然后在这部分代码里瞎改，从这个函数得到主要的渲染图像
```glsl
float distClosest, tClosest = rayMarchHybrid(rayO, rayD, distClosest, dummy, isTerrain);
```
- 其中这里上半部分是指定地面，下半部分指定天空的图像(被遮挡的 flag)，只保留下面的部分可以去掉地景
```glsl
if (tHMap < tSDF) {
    dist = distHMap;
    pColor = pColorMap;
    isTerrain = true;
    return tHMap;
} else {
    dist = distSDF;
    pColor = pColorSDF;
    isTerrain = false;
    return tSDF;
}
```
- 然后 tSDF 是由 `rayMarchConservative` 函数计算的，函数 return 的 `t` 由 `dist = sceneSDF(curIsect, pColor)` 计算的 dist 得到，继续看 `sceneSDF`
- 有个 `pTO` 变量贯穿 `sceneSDF` 始终，pTO 的计算为，这个 mk_trans 估计就是遮挡的函数，去掉得到如下渲染结果：
```glsl
vec4 pTO = mk_trans(35.0, -5.0, -20.0) * mk_scale(1.5, 1.5, 1.0) * pH;
```
<img alt="first flag image" src='{{ "/assets/first_flag_img.jpg" | absolute_url }}' width="100%">
- 不够清晰，折腾半天最后直接大力出奇迹，把天空改成灰色（在 `shadeSkybox` 里改 vec value），然后调出合适的 scale ratio 得到如下图片：
```glsl
vec4 pTO = mk_scale(2.5, 2.5, 1.0) * pH;
```
<img alt="second flag image" src='{{ "/assets/second_flag_img.jpg" | absolute_url }}' width="100%">
- 不会 opengl，然后电脑比较菜，每次渲染都要半天，一开始改一点代码的时候会卡在 rendering 上，以为改炸了，然后赶紧去看别的地方，后来才意识到只是还在渲染中，你先别急。

### 片上系统（<span style="color:red">只解出第一问</span>）
- 引导扇区：经过搜索得到需要使用 [pulseview/sigrok](https://sigrok.org/doc/pulseview/0.4.1/manual.html)，把给的 zip 当作 .sr 打开，就显示了信号，添加 SPI decoder，然后指定 CS,CLK,MISO,MISI 分别对应的 channel 就能在最下面得到一个 array，在 python 里将该 array 转化为 `bytes` 就能得到对应的二进制，末尾即为 flag。
<img alt="second flag image" src='{{ "/assets/pulseview.png" | absolute_url }}' width="100%">

### 企鹅拼盘（<span style="color:red">只解出第一问</span>）
- 这么简单我闭眼都可以！：一开始没仔细看，也没搞懂玩法，随便搞了几个字串瞎搞居然拿到 flag 了，真就闭眼都可以了，最后也没时间去仔细看题目了。

### 尾声
最后总结一下，其实还有几道题有思路但没时间做了（所以确实有点急，尽管《你先别急》看了一眼没思路就跑了），然后又因为两道 web 钻了牛角尖差在了最后一步，crc128 逆向虽然没仔细研究原理，但去找 exp 也找了半天然后最后还没做出来，还有一些题目一开始思路错了也花了不少时间。

不过就结果来说，比起 2017 年感觉还是有进步的（5 年了而且主要是大学期间，要是还没进步的话不如找块豆腐撞死算了），然后感觉今年好像确实蛮卷的。

一晃 Hackergame 已经成功举办九届了，从一开始校内的小比赛到现在的规模，也离不开出题人和组委会的努力（为什么你们总有这么多想法来出题啊.jpg），以及各位参赛选手的宣传。挺感慨的，但词穷了（
