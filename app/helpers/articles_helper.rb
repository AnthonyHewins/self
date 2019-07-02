module ArticlesHelper
  def author_label(article)
    author = article.author
    return anonymous_label if author.nil?
    return admin_label(author.handle) if author.admin?
    regular_label(author.handle)
  end

  private
  def anonymous_label
    content_tag(
      :label,
      ("by Anonymous " + content_tag(:i, nil, class: "user secret icon")).html_safe,
      class: "ui black label"
    )
  end

  def admin_label(handle)
    content_tag(
      :label,
      ("by #{handle} " + content_tag(:i, nil, class: "shield alternate icon")).html_safe,
      class: "ui red label"
    )
  end

  def regular_label(handle)
    content_tag(
      :label,
      "by #{handle}",
      class: "ui label"
    )
  end
end
