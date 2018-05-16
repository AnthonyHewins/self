require 'spec_helper'
require_relative '../spec_helper_modules/login'
require_relative '../spec_helper_modules/ckeditor_helpers'

RSpec.configure do |config|
  config.include Login
  config.include CkeditorHelpers
end

RSpec.describe 'Adding an article', type: :feature do
  before :all do
    @title_blank = /title can't be blank/i
    @title_short = /title is too short \(minimum is 3 characters\)/i
    @title_long = /title is too long \(maximum is 256 characters\)/i

    @body_short = /body is too short \(minimum is 128 characters\)/i

    @tldr_long = /tldr is too long \(maximum is 160 characters\)/i

    @expect = lambda do |*msgs|
      click_button "Create Article"
      flash_message_text = find('#flash').text
      msgs.each {|msg| expect(flash_message_text).to match msg}
    end

    @set_title = lambda {|txt| find(:xpath, "/html/body/div[2]/form/div[1]/input").set txt}
    @set_tldr = lambda {|txt| find(:xpath, '//*[@id="tldr"]').set txt}

    test_file = Rails.root.join('tmp/file.png')
    File.write(test_file, '')
    @set_tldr_image = lambda {find('#tldr-image').set test_file}
  end

  before :each do
    login
    visit new_article_path
  end

  it "that's completely blank raises all blank/short errors" do
    @expect.call @title_short, @title_blank, @body_short
  end

  context 'only filling in the title' do
    it "raises title and body too short errors with a title less than 3 chars and no body" do
      @set_title.call 'aa'
      @expect.call @title_short, @body_short
    end

    it "raises title too long, body too short on a title greater than 256 chars" do
      @set_title.call('a' * 257)
      @expect.call @body_short, @title_long
    end

    it 'raises only body too short error on a valid title' do
      @set_title.call 'valid'
      @expect.call @body_short
    end
  end

  context 'only filling in tldr' do
    it 'raises all errors when tldr is over 160 characters' do
      @set_tldr.call 'a' * 161
      @expect.call @tldr_long, @title_short, @title_blank, @body_short
    end
  end

  context 'only filling in the body', js: true do
    it 'raises body, title too short if body is under 128 chars' do
      fill_in_editor 'body', 'a'
      @expect.call @body_short, @title_blank, @title_short
    end
  end

  # JS tests that don't really belong in any other context
  context '', js: true do
    it 'handles a bare bones article, just barely making the cut on validations' do
      @set_title.call 'Title'
      @set_tldr.call 'Very short summary'
      fill_in_editor 'body', ('body' * 150)
      @expect.call(/success/i)
    end

    it 'handles a content-heavy article with all fields filled out' do
      @set_title.call 'Title'
      @set_tldr.call 'Very short summary'
      fill_in_editor 'body', ('body' * 150)
      @set_tldr_image.call
      @expect.call(/success/i)
    end
  end
end
