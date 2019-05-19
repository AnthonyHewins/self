require 'rails_helper'
require_relative '../../spec_helper_modules/login'
require_relative '../../spec_helper_modules/article_fill_helper'

RSpec.configure do |config|
  config.include Login
  config.include ArticleFillHelper
end

RSpec.describe 'Article length validations', type: :feature do
  before :all do
    @title_blank = /title can't be blank/i
    @title_short = /title is too short \(minimum is 10 characters\)/i
    @title_long = /title is too long \(maximum is 1000 characters\)/i

    @body_short = /body is too short \(minimum is 128 characters\)/i

    @tldr_long = /tldr is too long \(maximum is 1500 characters\)/i

    @expect = lambda do |*msgs|
      click_button "Submit"
      flash_message_text = find('#flash').text
      msgs.each {|msg| expect(flash_message_text).to match msg}
    end

    @set_title = lambda {|txt| find("#title").set txt}
    @set_tldr = lambda {|txt| find("#tldr").set txt}
    @set_body = lambda {|txt| find("#body").set txt}

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

    it "raises title too long, body too short on a title greater than 1000 chars" do
      @set_title.call('a' * 1001)
      @expect.call @body_short, @title_long
    end

    it 'raises only body too short error on a valid title' do
      @set_title.call 'valid'
      @expect.call @body_short
    end
  end

  context 'only filling in tldr' do
    it 'raises all errors when tldr is over 160 characters' do
      @set_tldr.call 'a' * (Article::TLDR_MAX + 1)
      @expect.call @tldr_long, @title_short, @title_blank, @body_short
    end
  end

  context 'only filling in the body' do
    it 'raises body, title too short if body is under 128 chars' do
      @set_body.call'a'
      @expect.call @body_short, @title_blank, @title_short
    end
  end

  it 'handles a bare bones article, just barely making the cut on validations' do
    @set_body.call('body' * 150)
    @set_title.call 'Length 10.'
    @set_tldr.call 'Very short summary'
    @expect.call(/success/i)
  end

  it 'handles a content-heavy article with all fields filled out' do
    random_fill_in
    @set_tldr_image.call
    @expect.call(/success/i)
  end
end
