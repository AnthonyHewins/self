module Concerns
  module Taggable
    protected
    def create_article(article, params)
      record.transaction do
        catch_error {record.save}
      end
    end

    private
    def catch_error
      begin
        yield
      rescue ActiveRecord::RecordInvalid

      end
    end
  end
end
