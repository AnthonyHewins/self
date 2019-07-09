require 'validation_lib/tags_validator'

RSpec.shared_examples "tags" do |validator, model, max=nil|
  max ||= ValidationLib::TagsValidator::TAGS_MAX

  before :each do
    @obj = create model
  end

  it 'adds an error if too many tags are attached' do
    too_many = max.succ
    @obj.update tags: create_list(:tag, too_many)
    expect(@obj.errors[:tags]).to include "max is #{max}, got #{too_many}"
  end
end
