module ArticlesHelper
  include ActionView::Helpers::SanitizeHelper

  def author_label(article)
    author = article.author
    handle = author.nil? ? "Anonymous" : author.handle
    content_tag :label, "by #{handle}", class: "ui label"
  end

  def parse_katex(html)
    return nil if html.blank?
    safe_render(html).join('').html_safe
  end

  private
  def safe_render(html)
    partition = html.split('$$')
    partition.each_with_index do |text,i|
      partition[i] = i.odd? ? Katex.render(text) : sanitize(text)
    end
    partition
  end
end
