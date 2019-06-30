class ArticleValidator < ActiveModel::Validator
  TITLE_MIN = 10
  TITLE_MAX = 1000

  TLDR_MAX = 1500

  TLDR_IMAGE_MAX = 10_000_000
  
  TLDR_IMAGE_BAD_TYPE = 'is not the right content type (must be image)'
  
  BODY_MIN = 128

  TAGS_MAX = 5
  
  def validate(record)
    check_image(record) if record.tldr_image.attached?
    check_tags(record)
  end

  private
  def check_image(record)
    blob = record.tldr_image.blob
    size = blob.byte_size
    content_type = blob.content_type
    
    if size > TLDR_IMAGE_MAX
      append_tldr_image_error record, "is #{size} bytes, max is #{TLDR_IMAGE_MAX}"
    end
    unless content_type.starts_with?('image/')
      append_tldr_image_error record, "must be image, uploaded file with type #{content_type}"
    end
  end

  def append_tldr_image_error(record, str)
    record.tldr_image.purge
    record.errors[:tldr_image] << str
  end
  
  def check_tags(record)
    to_save = record.tags.map(&:id)
    count = to_save.count
    record.errors[:tags] << "has duplicates" if to_save.uniq.count < count
    record.errors[:tags] << "have a maximum of #{TAGS_MAX} (submitted #{count})" if count > 5
  end
end
