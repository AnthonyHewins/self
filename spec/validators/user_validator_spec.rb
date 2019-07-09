require 'rails_helper'
require 'user_validator'
require 'validation_lib/attachment_validator'

require_relative './validation_lib/attachment_validator'
require_relative './validation_lib/tags_validator'

require_relative '../custom_matchers/define_constant'

RSpec.describe UserValidator do
  include_examples(
    "attachment",
    UserValidator.new,
    :user,
    :profile_picture,
    UserValidator::CONTENT_TYPE
  )

  it {should define_constant :CONTENT_TYPE, 'image/'}
  it {should define_constant :PW_MIN, 6}
  it {should define_constant :PW_MAX, 72}
  it {should define_constant :PW_SPECIAL_CHARS, '!@#$%^&*()'}
  it {should define_constant :HANDLE_MIN, 1}
  it {should define_constant :HANDLE_MAX, 64}
end
