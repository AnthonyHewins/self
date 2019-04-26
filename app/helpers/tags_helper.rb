module TagsHelper
  def tag_to_href(*tags)
    tags.map! {|tag| "tags=#{find_id tag}"}
    "/articles?#{tags.join('&')}"
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
