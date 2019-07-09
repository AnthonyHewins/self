RSpec.shared_examples "attachment" do |validator, model, field, content_type=nil, max=nil|
  max ||= ValidationLib::AttachmentValidator::MAX_SIZE

  before :each do
    @file = Tempfile.new("toobig")
    @obj = create model
  end

  context "if size is greater than #{max} bytes" do
    before :each do
      @file.write "a" * (max + 1)
      @file.rewind
      @obj.send(field).attach(io: @file, filename: "x", content_type: "image/jpeg")
      validator.validate @obj
    end

    it "purges the attachment" do
      expect(@obj.send(field).attachment).to be nil
    end

    it "adds an error" do
      expect(@obj.errors[field]).to include "is #{@file.size} bytes, max is #{max}"
    end
  end

  context "if the content_type isn't #{content_type}" do
    before :each do
      @type = "application/exe"
      @obj.send(field).attach(io: @file, filename: "x", content_type: @type)
      validator.validate @obj
    end

    it "purges the attachment" do
      expect(@obj.send(field).attachment).to be nil
    end
    
    it "raises an error" do
      expect(@obj.errors[field]).to include "is #{@type}, must be type #{content_type}"
    end
  end
end
