---
layout: content
title: convert kanji to kana
date: 2018-02-17 18:28:33 +0800
categories: misc
---

# kakasi --- the program which can convert kanji to kana

Kanji in japanese source from chinese characters, and the pronunciation of kanji are different from chinese characters. Kanji can pronunce by kana or romaji, so how to convert kanji to kana or romaji? I found a program -- kakasi.

### [KAKASI](http://kakasi.namazu.org/)
kakasi is a program which can Convert Kanji characters to Hiragana, Katakana or Romaji, for archlinux users, it is in the `community` repository

	Usage: kakasi -a[jE] -j[aE] -g[ajE] -k[ajKH] -E[aj] -K[ajkH] -H[ajkKH] -J[ajkKH]
		-i{oldjis,newjis,dec,euc,sjis,utf8} -o{oldjis,newjis,dec,euc,sjis,utf8}<br>
		-r{hepburn,kunrei} -p -s -f -c"chars"  [jisyo1, jisyo2,,,]

so if you want to convert kanji to hiragana, you can type:
```sh
echo "漢字" | kakasi -JH -KH -Ea -s -iutf8 -outf8
```
if you want to convert kanji to katakana, type:
```sh
echo "漢字" | kakasi -JK -HK -Ea -s -iutf8 -outf8
```
if you want to convert kanji to romaji, type:
```sh
echo "漢字" | kakasi -Ja -Ha -Ka -Ea -s -iutf8 -outf8
```
if kanji in text file, use redirect.

based on the complex options, I wrote a shell script:

`kanji-kana.sh`
```sh
#!/bin/bash

#script rely on kakasi, be used to convert kanji to kana or romaji
usage="usage:\t./kanji-kana.sh <-H|-k|-r> kanji\n-H\tconvert kanji to hiragana\n-k\tconvert kanji to katakana\n-r\tconvert kanji to romaji\n-h\tprint this manual"
while getopts "H:k:r:h" arg; do
  case $arg in
    h)  
      echo -e $usage
      ;;  
    H)  
      echo "$OPTARG" | kakasi -JH -KH -Ea -s -iutf8 -outf8
      ;;  
    k)  
      echo "$OPTARG" | kakasi -JK -HK -Ea -s -iutf8 -outf8
      ;;  
    r)  
      echo "$OPTARG" | kakasi -Ja -Ha -Ka -Ea -s -iutf8 -outf8
      ;;  
  esac
```
And if you type `./kanji-kana.sh`, it will output the help page (stored in the `usage` variable)

#### It may help a little with the recongize of kanji characters.

---
> I found usage of `kakasi` can be simpler if you want to convert only kanji:
>
> If you want to convert kanji to Hiragana, you can type:
> ```sh
> echo "漢字" | kakasi -JH -iutf8 -outf8
> ```
> If you want to convert kanji to Romaji, type:
> ```sh
> echo "漢字" | kakasi -Ja -iutf8 -outf8
> ```
> If you want to convert kanji to Katakana, type:
> ```sh
> echo "漢字" | kakasi -JK -iutf8 -outf8
> ```
> but these can only convert kanji to other format, if there are other characters like kana, it will not be converted, so the usage in that complex version can be more accurate, it is the combination of options, so characters in other format is converted.

	"J" is kanji, "H" is hiragana, "K" is katakana, "a" is romaji, "E" is English,
	options are used to convert between these formats, and "-s" is for insert space between words.
