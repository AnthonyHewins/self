require 'rails_helper'
require_relative '../spec_helper_modules/login'
require_relative '../spec_helper_modules/ckeditor_helpers'

RSpec.configure do |config|
  config.include Login
  config.include CkeditorHelpers
end

RSpec.describe 'Author set', type: :feature do
  before :each do
    random_fill_in
  end

  context 'when the user isnt an admin' do
    
  end
end
