module ArticlesHelper
  include ActionView::Helpers::SanitizeHelper

  def author_label(article)
    author = article.author
    handle = author.nil? ? "Anonymous" : author.handle
    content_tag :label, "by #{handle}", class: "ui label"
  end

  def parse_katex(html, strip_tags: false)
    return nil if html.blank?
    compile_katex(html, strip_tags).html_safe
  end

  private
  def compile_katex(html, strip_tags)
    tokens = html.split('$$')
    strip_tags ? strip_and_compile(tokens) : sanitize_and_compile(tokens)
  end

  def sanitize_and_compile(tokens)
    tokens.each_with_index do |text, i|
      tokens[i] = Katex.render(text) if i.odd?
    end
    tokens.join('')
  end

  def strip_and_compile(tokens)
    tokens.each_with_index do |text, i|
      tokens[i] = i.odd? ? Katex.render(text) : strip_tags(text)
    end
    tokens.join('')
  end
end
