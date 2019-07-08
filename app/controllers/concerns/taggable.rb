module Concerns
  module Taggable
    def create_with_tags(new_obj, params)
      tags = params.delete :tags
      klass.transaction do
        swallow_invalid_exception {klass.new(params).save}
        tags.each {|i| 
      end
    end

    def update_with_tags(record, params)
      record.transaction do
        swallow_invalid_exception {record.update(params)}
      end
    end

    private
    def swallow_invalid_exception
      begin
        yield
      rescue ActiveRecord::RecordInvalid
      end
    end
  end
end
