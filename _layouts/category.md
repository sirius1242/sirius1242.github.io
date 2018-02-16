---
layout: default
---

<a href="{{ site.url }}/category/"><img align="left" alt="categories" src="{{ '/assets/categories.png' | absolute_url }}"><h2 style="color:#0f79d0"> Back to categories list</h2></a>

<h1> {{ page.category }} </h1>
{% for post in site.categories[page.category] %}
    <a href="{{ post.url | absolute_url }}">
			<h2 style="color:#44aaff">{{ post.title }}</h2>
			{{ post.date }}
    </a>
{% endfor %}

