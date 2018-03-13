---
layout: content
title: basically use jekyll theme in Github Page
date: 2018-02-13 12:52:16 +0800
categories: sort_out
---
## [Back to home]({{ site.url }}/)
# basically tutor to use jekyll theme in Github Page
### if you don't have a Github Page, create it first.
- create a repository with the name: username.github.io

- And enter the `settings` page, find `change theme`
![settings]({{ "/assets/settings.png" | absolute_url}})

- choose a theme you want to use

- clone your repository to local

- you will found a `index.md` in your repository (index.html didn't work any more)

- the blog pages need to store in `_post` directory, and its name is `YYYY-MM-DD-blog_name.MARKUP` format (MARKUP is the file extension, usually html or md).

- the post file must have a YAML font matter:
> The front matter is where Jekyll starts to get really cool. Any file that contains a YAML front matter block will be processed by Jekyll as a special file. The front matter must be the first thing in the file and must take the form of valid YAML set between triple-dashed lines. Here is a basic example:
```markdown
---
layout: content
title: file to create
date: 2018-02-13 12:39:30 +0800
categories: jekyll update
---
```
> Between these triple-dashed lines, you can set predefined variables (see below for a reference) or even create custom ones of your own. These variables will then be available to you to access using Liquid tags both further down in the file and also in any layouts or includes that the page or post in question relies on.

- for displaying an index of post, you can add this in the format you like in index.md:
 ```markdown
  <ul>
  	{% raw %} {% for post in site.posts %} {% endraw %}
  		<li>
  			<a href="{% raw %}{{ post.url }}{% endraw %}">{% raw %}{{ post.title }}{% endraw %}</a>
  		</li>
  	{% raw %} {% endfor %} {% endraw %}
  </ul>
 ```
 you can change it into the format you want to, for example, you can change `<li>` tab to `<h1>` tab.

- if you want to add image to posts, you can store the image file in a subdirectory of root directory with name like `assets`, and then use `absolute_url` in the link location:
```markdown
![alt text]({% raw %}{{ "/assets/graph_name.jpg" | absolute_url }}{% endraw %})
```
these can found in [official website of jekyll](https://jekyllrb.com/docs/posts/), there are also things such as displaying post categories or tags and so on.

- back to home link can realize by this:
```markdown
[Back to home]({% raw %}{{ site.url }}{% endraw %}/)
```

- you can use post.exerpt or post.content to show the exerpt of your post, and deal with it with the help of string filters of [liquid template](https://help.shopify.com/themes/liquid/filters/string-filters), here is my example:
```markdown
{% raw %}{{ post.content | replace: "</h1>", " | " | strip_html | remove: "Back to home" | replace: " | ", "<br>" | truncatewords: 50}}{% endraw %}
```
- and with the help of utf8 characters, your blog will be more beautiful!
- use html `<details>` tag to fold the contents, but markdown will not be processed, however, use liquid template `markdownify` to process it, if want detail, you can check my code.
- there are also categories and other things to imporve your blog, you can find tutors in [jekyllrb.com](https://jekyllrb.com/docs/home/)
### after finished your blog, you can preview it locally

- write a Gemfile with these lines:
```sh
source 'https://rubygems.org'
gem 'github-pages', group: :jekyll_plugins
```
- if you have ruby 2.1.0 or higher installed (you can check it with `ruby --version`), directly use `gem install bundler`

- type `bundle install`

- type `bundle exec jekyll serve`, and it will give you the address, usually `http://127.0.0.1:4000`, and you can access this address in browser to preview your blog

you can find the help there: [Setting up your GitHub Pages site locally with Jekyll](https://help.github.com/articles/setting-up-your-github-pages-site-locally-with-jekyll/)

### if you think it's time to hand on, push it!
