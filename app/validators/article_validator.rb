require 'validation_lib/attachment_validator'
require 'validation_lib/tags_validator'

class ArticleValidator < ActiveModel::Validator
  include ValidationLib::AttachmentValidator
  include ValidationLib::TagsValidator

  CONTENT_TYPE = 'image/'
  
  TITLE_MIN = 10
  TITLE_MAX = 1000

  TLDR_MAX = 1500

  TLDR_IMAGE_MAX = ValidationLib::AttachmentValidator::MAX_SIZE

  TLDR_IMAGE_BAD_TYPE = 'is not the right content type (must be image)'

  BODY_MIN = 1

  TAGS_MAX = 5

  def validate(record)
    check_image(record, :tldr_image, content_type: CONTENT_TYPE)
    check_tags record
  end
end
