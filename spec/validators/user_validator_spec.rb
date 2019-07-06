require 'rails_helper'
require 'user_validator'
require 'validation_lib/attachment_validator'

RSpec.describe UserValidator do
  before :all do
    @obj = UserValidator.new
  end

  it { expect(UserValidator.included_modules).to include ValidationLib::AttachmentValidator}
  
  context "constants" do
    [[:PW_MIN, 6], [:PW_MAX, 72], [:HANDLE_MIN, 1], [:HANDLE_MAX, 64]].each do |name, val|
      it "#{name} equals #{val}" do
        expect(UserValidator.const_get name).to eq val
      end
    end
  end
end
