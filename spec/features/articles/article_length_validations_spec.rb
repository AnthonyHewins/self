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
    @title_short = /title is too short \(minimum is #{ArticleValidator::TITLE_MIN} character/i
    @title_long = /title is too long \(maximum is #{ArticleValidator::TITLE_MAX} character/i

    @body_short = /body is too short \(minimum is #{ArticleValidator::BODY_MIN} character/i

    @tldr_long = /tldr is too long \(maximum is #{ArticleValidator::TLDR_MAX} character/i
  end

  before :each do
    login
    visit new_article_path
  end

  context "with an article that's completely blank" do
    before :each do
      click_on 'Submit'
      @flash = find('#flash').text
    end
    
    it 'flashes an error on title being too short' do
      expect(@flash).to match @title_short
    end
    
    it 'flashes an error on body being too short' do
      expect(@flash).to match @body_short
    end
    
    it 'flashes an error on title being blank' do
      expect(@flash).to match @title_blank
    end
  end

  context 'when filling in the title' do
    context "with a title less than #{ArticleValidator::TITLE_MIN} chars" do
      before :each do
        random_fill_in title: ArticleValidator::TITLE_MIN - 1
        click_on 'Submit'
        @flash = find('#flash').text
      end

      it 'raises title too short' do
        expect(@flash).to match @title_short
      end
    end

    context "on a title less greater than #{ArticleValidator::TITLE_MAX} chars" do
      before :each do
        random_fill_in title: ArticleValidator::TITLE_MAX + 1
        click_on 'Submit'
        @flash = find('#flash').text
      end

      it "raises title too long" do
        expect(@flash).to match @title_long
      end
    end
  end

  context 'when filling in tldr' do
    context 'with nothing' do
      before :each do
        random_fill_in tldr: nil
        click_on 'Submit'
        @flash = find('#flash').text
      end
      
      it 'raises no errors are raised about minimum length' do
        expect(@flash).to match /success/i
      end
    end

    context "with over #{ArticleValidator::TLDR_MAX} chars" do
      before :each do
        random_fill_in tldr: ArticleValidator::TLDR_MAX + 1
        click_on 'Submit'
        @flash = find('#flash').text
      end

      it 'errors on tldr being too long' do
        expect(@flash).to match @tldr_long
      end
    end
  end

  context 'when filling the body' do
    context "when the body is under #{ArticleValidator::BODY_MIN} chars" do
      before :each do
        random_fill_in body: ArticleValidator::BODY_MIN - 1
        click_on 'Submit'
        @flash = find('#flash').text
      end

      it 'errors on body being too short' do
        expect(@flash).to match @body_short
      end
    end
  end

  it 'successfully saves on a proper article' do
    random_fill_in
    click_on 'Submit'
    expect(find('#flash').text).to match /success/i
  end
end
