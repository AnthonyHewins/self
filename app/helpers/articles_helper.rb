module ArticlesHelper
  include ActionView::Helpers::SanitizeHelper

  def author_label(article)
    author = article.author
    handle = author.nil? ? "Anonymous" : author.handle
    content_tag :label, "by #{handle}", class: "ui label"
  end

  def parse_katex(html)
    partition = html.split('$$')
    partition.each_with_index do |text,i|
      partition[i] = Katex.render(text) if i.odd?
    end
    sanitize partition.join('').html_safe
  end
end
