---
layout: content
title: static files
---
## [Back to home]({{ site.url }}/)

# static pdf files

{% assign pdfiles = site.static_files | where: "pdf", true %}
{% for mypdf in pdfiles %}
> #### [&#128442;{{ mypdf.name }}]({{ mypdf.path }})
> ###### {{ mypdf.modified_time }}
{% endfor %}
