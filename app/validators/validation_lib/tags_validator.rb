module ValidationLib
  module TagsValidator
    TAGS_MAX = 5

    protected
    def check_tags(record, max: TAGS_MAX)
      size = record.tags.size
      record.errors[:tags] << "max is #{max}, got #{size}" if size > max
    end
  end
end
