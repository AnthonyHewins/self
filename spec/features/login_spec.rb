require 'rails_helper'
require_relative '../spec_helper_modules/login'

RSpec.configure do |config|
  config.include Login
end

RSpec.describe "Login", type: :feature do
  before :all do
    @css_class = lambda {|color| "ui #{color} message"}
  end

  before :each do
    visit login_path
  end

  context "shows an error message" do
    before :all do
      @expect_macro = lambda do |user, password|
        login user, password
        expect(page).to have_selector "div",
                                      class: @css_class.call("red"),
                                      text: SessionsController::INCORRECT_COMBINATION_PROMPT
      end
    end

    it "when the email doesn't match any email in the DB" do
      @expect_macro.call User.new(email: "a@a.com"), "doesnt-matter-wont-work"
    end

    it "when the email matches an email that isn't confirmed, but the password is wrong" do
      @expect_macro.call create(:user, email_confirmed: false), "invalid-pw"
    end

    it "when the email matches an email that is confirmed, but the password is wrong" do
      @expect_macro.call create(:user), "invalid-pw"
    end
  end

  it "shows a warning flash message when the email's not confirmed but credentials match" do
    user = create(:user, email_confirmed: false, password: 'a!!!!!')
    login user, 'a!!!!!'
    expect(page).to have_selector "div",
                                  class: @css_class.call("warning"),
                                  text: SessionsController::EMAIL_NOT_CONFIRMED_PROMPT
  end

  it "shows an info flash message when the email's confirmed and pw is right" do
    login
    expect(page).to have_selector "div",
                                  class: @css_class.call("info"),
                                  text: SessionsController::LOGIN_PROMPT
  end

  it 'redirects to root_path after a successful login' do
    login
    expect(current_path).to eq root_path
  end
end
