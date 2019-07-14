module Concerns
  module Taggable
    protected
    def find_tags
      tags = params[:tags]
      tags.blank? ? [] : Tag.find(tags.split(',').uniq)
    end
  end
end
