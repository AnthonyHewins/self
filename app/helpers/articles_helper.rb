module ArticlesHelper
  def author_label(article)
    if article.author.nil?
      content_tag :label, "by Anonymous", class: "ui label"
    else
      content_tag(:label, class: "ui image label") do
        image_tag(article.author.gravatar_url rating: 'X', secure: true) + 
          " by #{article.author.handle}".html_safe
      end
    end
  end

  def parse_katex(html)
    partition = html.split('$$')
    partition.each_with_index do |text,i|
      partition[i] = Katex.render(text) if i.odd?
    end
    partition.join('').html_safe
  end
end
