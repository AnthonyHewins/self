module UsersHelper
  def leaderboard_crown(rank)
    case rank
    when 1
      number_one
    when 2
      second_place
    when 3
      third_place
    else
      content_tag(:h3, rank)
    end
  end

  private
  def number_one
    content_tag(
      :h3,
      ('1' + content_tag(:i, nil, class: 'chess king icon')).html_safe,
      class: 'gold'
    )
  end

  def second_place
    content_tag(
      :h3,
      ('2' + content_tag(:i, nil, class: 'chess queen icon')).html_safe,
      class: 'silver'
    )
  end

  def third_place
    content_tag(
      :h3,
      ('3' + content_tag(:i, nil, class: 'chess rook icon')).html_safe,
      class: 'bronze'
    )
  end
end
