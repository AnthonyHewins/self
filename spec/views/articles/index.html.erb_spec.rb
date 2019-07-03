require 'rails_helper'

RSpec.describe "articles/index", type: :view do
  before :each do
    # Stub current_user
    view.define_singleton_method(:current_user) do
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
  end
  
  describe "displays" do
    before :each do
      @article = create :article
      @articles = Article.paginate(page: 1, per_page: 10)
      render
    end

    %i[tldr title].each do |attr|
      it "renders the article's :#{attr}" do
        expect(rendered).to include @article.send attr
      end
    end

    it 'renders the author handle' do
      expect(rendered).to include @article.author.handle
    end
  end
end
