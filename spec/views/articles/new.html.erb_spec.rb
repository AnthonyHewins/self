require 'rails_helper'

RSpec.describe "articles/new", type: :view do
  before :each do
    render
  end

  it "renders article/_form" do
    assert_select "form[action=?][method=?]", new_article_path, "post" do
      assert_select "input[name=?]", "title"
      assert_select "textarea[name=?]", "tldr"
      assert_select "textarea[name=?]", "body"
      assert_select "input[name=?]", "tldr_image"
    end
  end
end
