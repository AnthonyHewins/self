require 'validation_lib/attachment_validator'

class UserValidator < ActiveModel::Validator
  include ValidationLib::AttachmentValidator

  CONTENT_TYPE = 'image/'.freeze
  
  PW_MIN = 6
  PW_MAX = 72 # this constraint is given by has_secure_password
  PW_SPECIAL_CHARS = '!@#$%^&*()'.freeze
  PW_REGEX = /(?=.*[a-zA-Z])(?=.*[0-9#{PW_SPECIAL_CHARS}]).{#{PW_MIN},#{PW_MAX}}/

  HANDLE_MIN = 1
  HANDLE_MAX = 64

  PROFILE_PIC_MAX_SIZE = ValidationLib::AttachmentValidator::MAX_SIZE

  def validate(record)
    if record.profile_picture.attached?
      check_image(record, :profile_picture, content_type: 'image/')
    end
    check_handle record.errors, record.handle
  end

  private
  def check_handle(errors, handle)
    if handle.nil?
      errors.add(:handle, "Handle cannot be null")
    elsif handle.downcase == "anonymous"
      errors.add(:handle, "Anonymous is a reserved handle")
    end
  end
end
