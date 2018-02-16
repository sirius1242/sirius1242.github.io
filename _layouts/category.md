---
layout: default
---

<h2> <a href="{{ site.url }}">Back to home</a> </h2>

<h1> {{ page.category }} </h1>
{% for post in site.categories[page.category] %}
    <a href="{{ post.url | absolute_url }}">
			<h2 style="color:#44aaff">{{ post.title }}</h2>
			{{ post.date }}
    </a>
{% endfor %}

