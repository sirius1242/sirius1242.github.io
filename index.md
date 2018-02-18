## Welcome to My GitHub Pages

## These are my essays[^1]:

>  [![categories]({{ "/assets/categories.png" | absolute_url }} ){:class='img-responsive"} <span style="font-size: 36px;">categories</span>]({{ site.url }}/category/)

<ul>
  {% for post in site.posts %}
    <h1>
      <a href="{{ post.url }}">{{ post.title }}</a>
    </h1>
    &#128193; {{ post.categories }} &emsp; &#128197; {{ post.date }}<br>
		<details>
		<summary>click to view excerpt</summary>
   {{ post.content | replace: "</h1>", " | " | strip_html | remove: "Back to home" | replace: " | ", "<br>" | truncatewords: 50}}
	 </details>
  {% endfor %}
</ul>

[^1]: No comment function added, so if you have any advice, you can open issue to my github repo:[https://github.com/sirius1242/sirius1242.github.io/issues](https://github.com/sirius1242/sirius1242.github.io/issues). And I'm not a native English speaker, hope you forgive my poor English.

## &#128211; There are some things about Jekyll Themes and markdown<sup>[^2]</sup>
[^2]: (My pages are using slate theme, which is an Jekyll Theme, and Jekyll Theme use markdown)

<details><summary markdown="span"><code>click to view</code></summary>

You can use the [editor on GitHub](https://github.com/sirius1242/sirius1242.github.io/edit/master/index.md) to maintain and preview the content for your website in Markdown files.

Whenever you commit to this repository, GitHub Pages will run [Jekyll](https://jekyllrb.com/) to rebuild the pages in your site, from the content in your Markdown files.

### Markdown
Markdown is a lightweight and easy-to-use syntax for styling your writing. It includes conventions for

```markdown
Syntax highlighted code block

# Header 1
## Header 2
### Header 3

- Bulleted
- List

1. Numbered
2. List

**Bold** and _Italic_ and `Code` text

[Link](url) and ![Image](src)
```

For more details see [GitHub Flavored Markdown](https://guides.github.com/features/mastering-markdown/).

### Jekyll Themes

Your Pages site will use the layout and styles from the Jekyll theme you have selected in your [repository settings](https://github.com/sirius1242/sirius1242.github.io/settings). The name of this theme is saved in the Jekyll `_config.yml` configuration file.

### Support or Contact

Having trouble with Pages? Check out our [documentation](https://help.github.com/categories/github-pages-basics/) or [contact support](https://github.com/contact) and we’ll help you sort it out.

</details>
