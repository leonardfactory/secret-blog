---
layout: post
title: "Our simple script for Jekyll"
description: ""
category: 
tags: []
published: false
---

{% include JB/setup %}

So here we go. Here's a simple colorizer plugin to give possibility to use Pygments options even using redcarpet.

<!--more-->

```ruby
require 'redcarpet'
require 'pygments'

# create a custom renderer that allows highlighting of code blocks
class HTMLwithPygments < Redcarpet::Render::HTML
  def block_code(code, language)
    colorized = Pygments.highlight(code, :lexer => language, :options => {:lineanchors => "line"})
    colorized.sub(/<pre>/, "<pre><code class=\"#{language}\">").sub(/<\/pre>/, "</code></pre>")
  end
end

class Jekyll::MarkdownConverter
  def extensions
    Hash[ *@config['redcarpet']['extensions'].map {|e| [e.to_sym, true] }.flatten ]
  end

  def markdown
    @markdown ||= Redcarpet::Markdown.new(HTMLwithPygments, :fenced_code_blocks => true)
  end

  def convert(content)
    return super unless @config['markdown'] == 'redcarpet-pygments'
    markdown.render(content)
  end
end
```

I made this substantially hacking `OtherWork.copy()` only [this plugin](http://dev.af83.com/2012/02/27/howto-extend-the-redcarpet2-markdown-lib.html), thus it doesn't work.

I'm going to add this paragraph only to test if there are enough whitespaces in multiple text lines. Even with an image!

![Google](http://dribbble.s3.amazonaws.com/users/24203/screenshots/1056186/asseenon.jpg)

> You are never too old to set another goal or to dream a new dream.
> <cite>C.S. Lewis</cite>