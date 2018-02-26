---
layout: default
title: static files
---

## There are some files:

{% assign pdfiles = site.static_files | where: "pdf", true %}
{% for mypdf in pdfiles %}
> #### [{{ mypdf.name }}]({{ mypdf.path }})
> ###### {{ mypdf.modified_time }}
{% endfor %}
