---
layout: default
---

<style>
ul.horizontal {
	list-style-type: none;
	text-align: right;
	background-color: #f2f2f2;
	overflow: hidden;
    position: static;
    /*float: left;*/
    margin-right: 30px;
    height: 100%;
    width: 150px;
	box-shadow: 0px 0px 0px 0px #0366d6;
    /*border-radius: 10px 10px 10px 10px;*/
}
ul.horizontal li {
    font-size: 20px;
    display: block;
    border: none;
}
ul.horizontal li a {
	display: block;
	color: black;
	padding: 5px 10px;
	text-decoration: none;
}
ul.horizontal li a:hover:not(.active) {
	/*background-color: #606060;*/
	font-weight: bold;
	padding: 5px 10px;
    display: inline-block;
    background-color: #606060;
    border-radius: 2px 2px 2px 2px;
}
#logo a:hover:not(.active){
    background-color: #00ff88;
    width: 70px;
    border-radius: 100px 10px 10px 100px;
}
#picture {
	-webkit-transition: -webkit-transform 1.6s ease-in-out;
			transition: 		transform 1.6s ease-in-out;
}

#picture:hover {
	-webkit-transform: rotate(720deg);
			transform: rotate(720deg);
}
</style>

<div style="float: left; width:30%; overflow-y: hidden;">
    <ul class="horizontal">
        <!--li id="logo"><a href='{{ "/index.html" | absolute_url }}'><object id="picture" data='{{ "/assets/favicon.png" | absolute_url }}' type="image/png" width="60px" ></object></a></li-->
        <li id="logo"><a href='{{ "/index.html" | absolute_url }}'><object id="picture" data='{{ "assets/favicon.png" | absolute_url }}' type="image/png" width="60px" ></object></a></li><!--
        --><li id="blogs"><a href='{{ "/blog.html" | absolute_url }}'>Blog</a></li><!--
        --><li><a href='{{ "/category/index.html" | absolute_url }}'>Category</a></li><!--
        --><li id="files"><a href='{{ "/files.html" | absolute_url }}'>Files</a></li><!--
        --><li id="scripts"><a href='/script'>Scripts</a></li><!--
        --><li id="wallpapers"><a href='/bing-wallpaper-collect'>Wallpapers</a></li>
    </ul>
</div>

<div style="width: 70%; position: static; display: inline-block; margin-bottom: 0px;">
<h1> Welcome to Sirius' Home </h1>

<!--object id="picture" data='{{ "/assets/favicon.png" | absolute_url }}' type="image/png" width="200px" ></object-->
<span style="float: right">This is my home page.</span>

<h3>Latest blog:</h3>
{% assign post = site.posts[0] %}
<h2>
    <a href="{{ post.url }}">{{ post.title }}</a>
</h2>
&#128193; {{ post.categories }} &emsp; &#128197; {{ post.date }}<br>
{{ post.content | replace: "</h1>", " | " | replace: "</h2>", " | " | strip_html | replace: " | ", "<br>" | truncatewords: 50}}
{{ "---" | markdownify }}


</div>
<script type="text/javascript">
    document.getElementById('project_title').textContent="Sirius' Home";
    document.title="Sirius’ Home";
</script>