require 'validation_lib/attachment_validator'

class ArticleValidator < ActiveModel::Validator
  include ValidationLib::AttachmentValidator

  TITLE_MIN = 10
  TITLE_MAX = 1000

  TLDR_MAX = 1500

  TLDR_IMAGE_MAX = ValidationLib::AttachmentValidator::MAX_SIZE
  
  TLDR_IMAGE_BAD_TYPE = 'is not the right content type (must be image)'
  
  BODY_MIN = 128

  TAGS_MAX = 5

  def validate(record)
    if record.tldr_image.attached?
      check_image(record, :tldr_image, content_type: 'image/')
    end
    check_tags(record)
  end

  private
  def check_tags(record)
    to_save = record.tags.map(&:id)
    count = to_save.count
    record.errors[:tags] << "has duplicates" if to_save.uniq.count < count
    record.errors[:tags] << "have a maximum of #{TAGS_MAX} (submitted #{count})" if count > 5
  end
end
