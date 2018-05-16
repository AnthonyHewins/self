require 'rails_helper'

RSpec.describe "articles/_form", type: :view do
  before(:each) do
    @article = create :article
    render partial: 'articles/form', locals: {article: @article}
  end

  it "renders the form" do
    assert_select "form[action=?][method=?]", article_path(@article), "post" do
      assert_select "input[name=?]", "article[title]"
      assert_select "textarea[name=?]", "article[body]"
      assert_select "input[name=?]", "article[tldr_image]"
      assert_select "textarea[name=?]", "article[tldr]"
    end
  end
  
  it "has div#katex-output that has a default message before it begins rendering HTML/LaTeX" do
    expect(rendered).to match /Start typing to view the raw HTML you're generating/i
  end
end
