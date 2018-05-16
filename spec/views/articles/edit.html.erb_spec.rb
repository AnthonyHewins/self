require 'rails_helper'

RSpec.describe "articles/edit", type: :view do
  before(:each) do
    @article = create :article
    render
  end

  it "renders articles/_form" do
    assert_select "form[action=?][method=?]", article_path(@article), "post" do
      assert_select "input[name=?]", "article[title]"
      assert_select "textarea[name=?]", "article[body]"
      assert_select "input[name=?]", "article[tldr_image]"
      assert_select "textarea[name=?]", "article[tldr]"
    end
  end
end
