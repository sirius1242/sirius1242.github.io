---
layout: default
---
<head>
<style>
ul.horizontal {
    list-style-type: none;
    margin: 0;
    background-color: #3399CC;
		padding: 0;
		position: fixed;
		left: 0;
		top: 210px;
		overflow: auto;
		border: 5px;
		border-style: double;
		border-color: #008888;
		box-shadow: 5px 5px 6px black;
}

ul.horizontal li {
    text-align: left;
		font-size: 20px;
}

ul.horizontal li a {
    display: block;
    color: white;
		padding: 14px 20px;
    text-decoration: none;
}

ul.horizontal li a:hover:not(.active) {
    background-color: #004040;
		padding: 14px 20px;
}

ul.horizontal li a.active {
    background-color:#4CAF50;
}
</style>
</head>
<ul class="horizontal">
<li style="float: left; padding: 50px 0px; text-align: center;"><a href='{{ "/index.html" | absolute_url }}'><span style="font-size: 50px;">&#127968;</span></br> home</a></li>
<li style="float: right; padding: 50px 0px; text-align: center;"><a href='{{ "/category/index.html" | absolute_url }}'><span style="font-size: 50px;">&#128188;</span></br> category</a></li>

<li style="padding: 50px;"></li>
<li style="padding: 50px;"></li>
{% for category in site.categories %}
<li><a href="{{ site.url }}/category/{{ category | first | url_encode }}.html">&#128194;{{ category | first }}</a></li>
{% endfor %}
<li><a href='{{ "/files.html" | absolute_url }}'>&#128194;files</a></li>
</ul>

{{ content }}
