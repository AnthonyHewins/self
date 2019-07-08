module ValidationLib
  module Taggable
    TAGS_MAX = 5

    protected
    def check_tags(record, uniq: true, max: TAGS_MAX)
      record.tags = record.tags.uniq if uniq
      count = record.tags.count
      record.errors[:tags] << "max is #{max}, got #{count}" if count > max
    end
  end
end
