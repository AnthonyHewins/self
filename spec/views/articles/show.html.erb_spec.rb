require 'rails_helper'

RSpec.describe "articles/show", type: :view do
  before(:each) do
    # Stub current_user
    view.define_singleton_method(:current_user) do
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    @article = create :article
    render
  end

  [:tldr, :title, :body].each do |attr|
    it "renders attribute :#{attr}" do
      expect(rendered).to include @article.send attr
    end
  end

  it 'renders the author handle with his/her gravatar' do
    expect(rendered).to include @article.author.handle
  end
end
