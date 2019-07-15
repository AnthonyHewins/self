require 'rails_helper'

RSpec.describe "articles/form/_form", type: :view do
  before(:each) do
    @article = create :article
    render partial: 'articles/form/form', locals: {article: @article}
  end

  it "renders the form" do
    assert_select "form[action=?][method=?]", article_path(@article), "post" do
      assert_select "textarea[name=?]", "article[title]"
      assert_select "textarea[name=?]", "article[body]"
      assert_select "input[name=?]", "article[tldr_image]"
      assert_select "textarea[name=?]", "article[tldr]"
      assert_select "input[name=?]", "article[anonymous]"
    end
  end

  %i[title tldr body].each do |sym|
    it "has div#katex-output that renders :#{sym}" do
      expect(rendered).to include @article.title
    end
  end
end
