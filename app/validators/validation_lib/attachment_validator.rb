module ValidationLib
  module AttachmentValidator
    MAX_SIZE = 10_000_000
    
    def check_image(record, field, content_type:, max_size: MAX_SIZE)
      blob = record.send(field).blob

      check_size record, field, max_size, blob.byte_size
      check_content_type record, field, content_type, blob.content_type
    end

    private
    def check_size(record, field, max, size)
      return unless size > max
      error record, field, "is #{size} bytes, max is #{max}"
    end

    def check_content_type(record, field, correct_type, received_type)
      return if received_type.starts_with?(correct_type)
      error(
        record,
        field,
        "must have content type #{correct_type}, received type #{received_type}"
      )
    end

    def error(record, field, str)
      record.send(field).purge
      record.errors[field] << str
    end
  end
end
