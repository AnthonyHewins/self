require 'rails_helper'
require 'article_validator'
require 'validation_lib/attachment_validator'

require_relative './validation_lib/attachment_validator'
require_relative './validation_lib/tags_validator'

require_relative '../custom_matchers/define_constant'

RSpec.describe ArticleValidator do
  include_examples("tags", ArticleValidator.new, :article)

  include_examples(
    "attachment",
    ArticleValidator.new,
    :article,
    :tldr_image,
    ArticleValidator::CONTENT_TYPE
  )

  it {should define_constant :CONTENT_TYPE, 'image/'}
  it {should define_constant :TITLE_MIN, 10}
  it {should define_constant :TITLE_MAX, 1000}
  it {should define_constant :TLDR_MAX, 1500}
  it {should define_constant :BODY_MIN, 128}
end 
