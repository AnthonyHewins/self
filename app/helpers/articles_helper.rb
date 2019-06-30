module ArticlesHelper
  def author_label(article)
    author = article.author
    handle = author.nil? ? "Anonymous" : author.handle
    content_tag :label, "by #{handle}", class: "ui label"
  end
end
