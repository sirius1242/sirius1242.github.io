---
layout: content
title: convert image to ascii art
date: 2018-02-21 15:48:07 +0800
categories: python
---
## [Back to home]({{ site.url }}/)

# use python to convert image to ascii art

Recently, I found a python script which can convert image whose size is smaller than 1MB to ascii drawing.

and there is an example:
![doraemon.png]({{ "/assets/doraemon.png" | absolute_url }})

result:

[`doraemon.txt`]({{ "/doraemon.txt" | absolute_url }})[^1]

[^1]: wanted to put it on the page directly, but because the width of empty lines, the ratio isn't right, so I put there a link

### This is the code of that script
[`asciinator.py`](https://github.com/cdiener/pyart/blob/master/asciinator.py)[^2]

[^2]: I found it in a ctf problem originally, but when I write this blog, I searched for it, and found it in github
```python
import sys
from PIL import Image
import numpy as np

# settings
chars = np.asarray(list(' -"~rc()+=01exh%'))
SC, GCF, WCF = 1/10, 1, 7/4 

# read file
img = Image.open(sys.argv[1])

# process
S = ( round(img.size[0]*SC*WCF), round(img.size[1]*SC) )
# calculate the size to resize according to the ratio of width and length of characters
img = np.sum( np.asarray( img.resize(S) ), axis=2)
# resize and calculate the value of color in every pixel
img -= img.min()
# make the lowest value of color to 0
img = (1.0 - img/img.max())**GCF*(chars.size-1)
# convert color value to index of chars

arr = chars[img.astype(int)]
# convert index to characters
arr = '\n'.join(''.join(row) for row in arr)
print(arr)
```

not so complex, isn't it?

Ratio and other thing you can adjust by yourself, and you can also make them to commandline options to adjust them when executing. Characters are used to identify outline of every color, so what it like doesn't matter, you can also adjust the length of character array to make ascii draw in more detail, but it seems better to use the characters with bigger density to describe deeper colors, and use ones with smaller density to describe shallow colors. All in all, have a try and you may found arguments to make asciinator perform better!
