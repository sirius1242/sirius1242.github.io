---
layout: default
---

<style>
.inner {
	/*max-width: 70%;*/
	max-width: 670px;
}

#header_wrap {
	/*background-image: url('{{ "/assets/background.jpg" | absolute_url }}');*/
	background-size: cover;
	height: 100vh;
	background-attachment: fixed;
	background-position: center;
}

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
	margin-left: 0px;
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

<div>
<div style="float: left; width:30%; overflow: auto; direction: rtl;">
    <ul class="horizontal">
        <!--li id="logo"><a href='{{ "/index.html" | absolute_url }}'><object id="picture" data='{{ "/assets/favicon.png" | absolute_url }}' type="image/png" width="60px" ></object></a></li-->
        <li id="logo"><a href='{{ "/index.html" | absolute_url }}'><object id="picture" data='{{ "assets/favicon.png" | absolute_url }}' type="image/png" width="60px" ></object></a></li><!--
        --><li id="blogs"><a href='{{ "/blog.html" | absolute_url }}'>Blog</a></li><!--
        --><li><a href='{{ "/category/index.html" | absolute_url }}'>Category</a></li><!--
        --><li id="files"><a href='{{ "/files.html" | absolute_url }}'>Files</a></li><!--
        --><li id="pages"><a href='{{ "/pages" | absolute_url }}'>About</a></li><!--
        --><li id="scripts"><a href='/script'>Scripts</a></li><!--
        --><li id="wallpapers"><a href='/bing-wallpaper-collect'>Wallpapers</a></li>
    </ul>
</div>

<div style="width: 70%; position: static; display: inline-block; margin-bottom: 0px; ">
<h1> Welcome to Sirius' Home </h1>

<!--object id="picture" data='{{ "/assets/favicon.png" | absolute_url }}' type="image/png" width="200px" ></object-->
<span style="float: right">This is my home page.</span>

<h3>Latest blogs:</h3>
{% assign post = site.posts[0] %}
<h2>
    <a href="{{ post.url }}">{{ post.title }}</a>
</h2>
&#128193; {{ post.categories[0] }} &emsp; &#128197; {{ post.date }}<br>
<!--{{ post.content | replace: "</h1>", " | " | replace: "</h2>", " | " | strip_html | replace: " | ", "<br>" | truncatewords: 50}}-->
{{ post.excerpt | strip_html | truncate: 500 }}
{{ "---" | markdownify }}

{% assign post = site.posts[1] %}
<h2>
    <a href="{{ post.url }}">{{ post.title }}</a>
</h2>
&#128193; {{ post.categories[0] }} &emsp; &#128197; {{ post.date }}<br>
<!--{{ post.content | replace: "</h1>", " | " | replace: "</h2>", " | " | strip_html | replace: " | ", "<br>" | truncatewords: 50}}-->
{{ post.excerpt | strip_html | truncate: 500 }}
{{ "---" | markdownify }}

<h2><a href='{{ "/blog.html" | absolute_url }}'>Show More...</a></h2>

</div>
</div>
<script src='{{ "/js/jquery-3.5.0.js" | absolute_url }}'></script>
<script type="text/javascript">
	var header=document.getElementsByTagName('header')[0];
    document.getElementById('project_title').textContent="Sirius' Home";
    document.title="Sirius’ Home";
    header.style.paddingTop="20%";
    header.style.position="sticky"
	$("#header_wrap").css("background-image", "url('{{ "/assets/background.jpg" | absolute_url }}')");
	$(window).scroll(function(){
		$( "header" )[0].style.top=-($(this).scrollTop()/3)+"px";
		//if ( $(window).scrollTop() >= 0.15 * $(window).width())
		//$("header")[0].innerText = $(this).scrollTop();
		if ( $(this).scrollTop() >= 0.3 * $(window).width())
			$("#header_wrap").css("background-image", "");
		else
			$("#header_wrap").css("background-image", "url('{{ "/assets/background.jpg" | absolute_url }}')");
	});
</script>
