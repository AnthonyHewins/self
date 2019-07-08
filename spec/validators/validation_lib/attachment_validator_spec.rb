require 'rails_helper'
require 'validation_lib/attachment_validator'

RSpec.describe ValidationLib::AttachmentValidator do
  context '#check_image(record, field, content_type:, max_size:)' do
    before :all do
      @field = :profile_picture
      @validator = Object.new
      @validator.extend ValidationLib::AttachmentValidator
    end

    before :each do
      @file = Tempfile.new("toobig")
      @obj = create :user
    end

    context "if size is greater than max_size bytes" do
      before :all do
        @max = 1
      end
      
      before :each do
        @file.write "a" * (@max + 1)
        @file.rewind
        @obj.profile_picture.attach(io: @file, filename: "x", content_type: "image/jpeg")
        @validator.send :check_image, @obj, @field, content_type: 'image/jpeg', max_size: @max
      end

      it "purges the attachment" do
        expect(@obj.profile_picture.attachment).to be nil
      end

      it "adds an error" do
        expect(@obj.errors[@field].length).to be > 0
      end
    end

    context "if the content type isn't an image" do
      before :each do        
        @obj.profile_picture.attach(io: @file, filename: "x", content_type: "application/exe")
        @validator.send :check_image, @obj, @field, content_type: 'image/jpeg'
      end

      it "purges the attachment" do
        expect(@obj.profile_picture.attachment).to be nil
      end
      
      it "raises an error" do
        expect(@obj.errors[@field].length).to be > 0
      end
    end
  end
end
