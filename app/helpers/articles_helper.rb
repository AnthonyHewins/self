module ArticlesHelper
  def author_label(article)
    author = article.author
    return anonymous_label if author.nil?
    return admin_label(author) if author.admin?
    regular_label(author)
  end

  private
  def anonymous_label
    content_tag(
      :label,
      ("by Anonymous " + content_tag(:i, nil, class: "user secret icon")).html_safe,
      class: "ui black label"
    )
  end

  def admin_label(author)
    link_to(
      ("by #{author.handle} " + content_tag(:i, nil, class: "shield alternate icon")).html_safe,
      user_path(author),
      class: "ui red label"
    )
  end

  def regular_label(author)
    link_to("by #{author.handle}", user_path(author), class: "ui label")
  end
end
