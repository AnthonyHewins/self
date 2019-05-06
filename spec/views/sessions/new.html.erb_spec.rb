require 'rails_helper'

RSpec.describe "sessions/new.html.erb", type: :feature do
  before :each do
    visit login_path
  end

  # Basic login fields
  it {expect(page).to have_selector("input", id: "handle")}
  it {expect(page).to have_selector("input", id: "password")}
  it {expect(page).to have_selector("input", id: "login")}
end
