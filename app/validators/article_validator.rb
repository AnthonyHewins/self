require 'validation_lib/attachment_validator'
require 'validation_lib/taggable'

class ArticleValidator < ActiveModel::Validator
  include ValidationLib::AttachmentValidator
  include ValidationLib::Taggable

  TITLE_MIN = 10
  TITLE_MAX = 1000

  TLDR_MAX = 1500

  TLDR_IMAGE_MAX = ValidationLib::AttachmentValidator::MAX_SIZE
  
  TLDR_IMAGE_BAD_TYPE = 'is not the right content type (must be image)'
  
  BODY_MIN = 128

  TAGS_MAX = ValidationLib::Taggable::TAGS_MAX

  def validate(record)
    if record.tldr_image.attached?
      check_image(record, :tldr_image, content_type: 'image/')
    end
    check_tags record
  end
end
