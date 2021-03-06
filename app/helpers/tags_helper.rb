module TagsHelper
  def tag_icon(tag, size: nil)
    color = "color: ##{tag.color}"
    klass = "#{size} #{tag.icon.icon} icon"
    content_tag(:i, nil, class: klass, style: color)
  end

  private
  def find_id(arg)
    case arg
    when String
      Tag.select(:id).where('name = ?', arg).limit(1).pluck(:id).first
    when Tag
      arg.id
    else
      raise TypeError, "Can't find the ID from #{arg.class}"
    end
  end
end
