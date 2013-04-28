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