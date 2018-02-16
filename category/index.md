---
layout: default
title: categories
---
## [Back to home]({{ site.url }}/)

---
{% for category in site.categories %}
> <h1><a href="{{ site.url }}/category/{{ category | first | url_encode }}/index.html">{{ category | first }}</a></h1>
---
{% endfor %}
