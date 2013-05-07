require 'redcarpet'
require 'pygments'

# Provides a custom Redcarpet renderer with some tweaks for code blocks and links.
class HTMLwithPygmentsCodeblocks < Redcarpet::Render::HTML
  def initialize(extensions = {})
      super extensions.merge(:link_attributes => { :target => "_blank" }) # Open link in new window
    end
    
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