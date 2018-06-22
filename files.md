---
layout: content
title: static files
---

# This is a page which will list all my static files in this repo

[This post](/file_intro.html) will do a brief introduction to some of these files.

## static pdf files

{% assign pdfiles = site.static_files | where: "pdf", true %}
{% for mypdf in pdfiles %}
> #### [&#128442;{{ mypdf.name }}]({{ mypdf.path }})
> ###### {{ mypdf.modified_time }}
{% endfor %}
