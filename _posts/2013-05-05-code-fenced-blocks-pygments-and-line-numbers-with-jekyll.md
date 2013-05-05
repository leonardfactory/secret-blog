---
layout: post
title: "Code fenced blocks, Pygments and line numbers with jekyll"
description: "Pygments for code highlighting, line numbers with CSS Counters and custom redcarpet plugin"
category: 
tags: ["Coding", "Jekyll"]
published: true
---

{% include JB/setup %}
When I started this personal blog project, the first feature I wanted was code highlighting. Markdown with **Pygments** is the right man for the job, and **Jekyll** has nice support, so I began writing some code.

The first problem I meet was using Pygments with code fenced blocks (did someone say three backticks?). Using something like `{% raw %}{% highlight ruby %}{% endraw %}` is not my style, but switching rendering engine to **redcarpet** solved the problem at a glance.

<!--more-->
Even finding a nice color theme wasn't hard: [Solarized](http://ethanschoonover.com/solarized) is a wonderful palette from Ethan Schoonover.

> Solarized is a sixteen color palette (eight monotones, eight accent colors) designed for use with terminal and gui applications.

Implementing it needs only a _CSS_ theme, found on [this gist](https://gist.github.com/scotu/1272660) which provides the light scheme, but on this [repository](https://github.com/jrunning/github-solarized) you can find even the dark theme.

So we're going to link the theme in our `{{ '<head>' | escape }}` tag

```html
<head>
	...
    <!-- Solarized theme for highlighting code -->
	<link rel="stylesheet" href="{{ ASSET_PATH }}/css/solarized.css">
    ...
</head>
```

Here I'm using `{{ ASSET_PATH }}/css/` folder because it's the way Jekyll Bootstrap works, but feel free to put it wherever you want.

After code highlighting, another feature I needed was line numbers. It could be helpful to have them, so I found an [article](http://www.alexpeattie.com/blog/github-style-syntax-highlighting-with-pygments/) by **Alex Peattie**, who explained how to do it in a wonderful CSS-only solution. 

This required however *Line anchors*, a configuration option that isn't provided standalone with Jekyll. So I came up with a little plugin, after reading some [nice info](http://dev.af83.com/2012/02/27/howto-extend-the-redcarpet2-markdown-lib.html) on how Redcarpet & Jekyll could be customized.

Placing this code saved as `redcarpet_pygments.rb` _(i.e.)_ in the `_plugin` folder got the job done, handling markdown conversion with redcarpet and code highlighting with **Pygments**, customized with `:lineanchors` set to true.

```ruby
require 'redcarpet'
require 'pygments'

# Provides a custom Redcarpet renderer with some tweaks for code blocks.
class HTMLwithPygmentsCodeblocks < Redcarpet::Render::HTML
  def block_code(code, language)
    colorized = Pygments.highlight(code, :lexer => language, :options => {:lineanchors => "line"}) # Add lineanchors for line numbers
    colorized.sub(/<pre>/, "<pre><code class=\"#{language}\">").sub(/<\/pre>/, "</code></pre>")
  end
  
  def codespan(code)
    "<code class=\"inline-code\">#{code}</code>" # Inline code custom class
  end 
end

class Jekyll::MarkdownConverter
  def extensions
    Hash[ *@config['redcarpet']['extensions'].map {|e| [e.to_sym, true] }.flatten ]
  end

  def markdown
    @markdown ||= Redcarpet::Markdown.new(HTMLwithPygmentsCodeblocks, :fenced_code_blocks => true)
  end

  def convert(content)
    return super unless @config['markdown'] == 'redcarpet-pygments'
    markdown.render(content)
  end
end
```

After this you need only to change the `_config.yml` *markdown* option, setting it to `redcarpet-pygments`.

Now we can put the code provided by [Alex](http://www.alexpeattie.com/) in our CSS to get line numbers automagically appear.

```css
@import "compass/css3/box-shadow";

pre {
	counter-reset: line-numbering;
	border: solid 1px #d9d9d9;
	border-radius: 0;
	background: #fff;
	padding: 0;
	line-height: 23px;
	margin-bottom: 30px;
	white-space: pre;
	overflow-x: auto;
	word-break: inherit;
	word-wrap: inherit;
}

pre a::before {
	content: counter(line-numbering);
	counter-increment: line-numbering;
	padding-right: 1em; /* space after numbers */
	width: 25px;
	text-align: right;
	opacity: 0.7;
	display: inline-block;
	color: #aaa;
	background: #eee;
	margin-right: 16px;
	padding: 2px 10px;
	font-size: 13px;
	border-right: 1px solid #dedede;
	-webkit-touch-callout: none;
	-webkit-user-select: none;
	-khtml-user-select: none;
	-moz-user-select: none;
	-ms-user-select: none;
	user-select: none;
}

pre a:first-of-type::before {
	padding-top: 10px;
	@include box-shadow(rgba(255, 255, 255, 0.9) 0px 1px 1px inset);
}

pre a:last-of-type::before {
	padding-bottom: 10px;
}

pre a:only-of-type::before {
	padding: 10px;
}
```

Here we go!

Now all your fenced code blocks will have awesome line numbers and colors. You can even customize style for inline code blocks using custom CSS for the `.inline-code` class.

```css
code.inline-code {
	padding: 0.2em 0.4em;
	background-color: #fdfdfd;
	@include box-shadow(0 1px rgba(255,255,255,.75), inset 0 1px 3px rgba(0,0,0,.07));
    
	color: $light-gray;

	@include border-radius(4px);
    border: solid 1px #dedede;
    
    white-space: nowrap;
}
```

Enjoy!
