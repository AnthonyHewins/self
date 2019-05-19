require 'rails_helper'
require_relative '../../spec_helper_modules/login'
require_relative '../../spec_helper_modules/article_fill_helper'

RSpec.configure do |config|
  config.include Login
  config.include ArticleFillHelper
end

RSpec.describe 'Author set', type: :feature do
  context "creating an article" do
    before :each do
      @user = login
      visit new_article_path
      random_fill_in
    end

    it 'when saved, saves the author as current_user if the Anonymous box is unchecked' do
      click_on "Submit"
      expect(Article.last.author).to eq @user
    end

    it 'when saved, saves the author as nil if the Anonymous box is checked' do
      find("#anonymous").set true
      click_on "Submit"
      expect(Article.last.author).to be nil
    end
  end

  context "updating an article" do
    context 'as the creator' do
      before :each do
        @user = login
        @article = create(:article, author: @user)
        visit edit_article_path(@article)
        random_fill_in
      end

      it 'when saved, saves the author as current_user if the Anonymous box is unchecked' do
        click_on "Submit"
        expect(@article.reload.author).to eq @user
      end

      it 'when saved, saves the author as nil if the Anonymous box is checked' do
        find("#anonymous").set true
        click_on "Submit"
        expect(@article.reload.author).to be nil
      end
    end

    context 'as an admin, and not the creator' do
      before :each do
        @user = login admin: true
        @article = create(:article, author: @user)
        visit edit_article_path(@article)
        random_fill_in
      end

      it 'when saved, saves the author as current_user if the Anonymous box is unchecked' do
        click_on "Submit"
        expect(@article.reload.author).to eq @user
      end

      it 'when saved, saves the author as nil if the Anonymous box is checked' do
        find("#anonymous").set true
        click_on "Submit"
        expect(@article.reload.author).to be nil
      end
    end
  end
end
