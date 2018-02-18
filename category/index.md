---
layout: default
title: categories
---
## [Back to home]({{ site.url }}/)

---
{% for category in site.categories %}
> <h1><a href="{{ site.url }}/category/{{ category | first | url_encode }}.html">&#128194;{{ category | first }}</a></h1>
---
{% endfor %}
