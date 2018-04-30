# This is my github page
#### last repository is deleted by me because unsucessfully theme using XD

I may put some things on the page

### this is the entrance:
[https://sirius1242.github.io](https://sirius1242.github.io)

### I wrote a shell script: `create_post.sh`
after you cloned it, you need to adjust the permissions, and then execute it, the argument is the filename:
```sh
chmod +x create_post.sh
./create_post.sh "file to create"
```
and it will create a file with filename `_posts/2018-02-13-file_to_create.md`, and add the YAML Front Matter in the head of file:
```markdown
---
layout: content
title: file to create
date: 2018-02-13 12:39:30 +0800
categories: 
---
## [Back to home]({{ site.url }}/)
```
you will enter the environment of editing the file (vim)

The date and the time in filename is the time you execute the command.
