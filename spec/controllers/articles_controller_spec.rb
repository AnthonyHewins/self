require 'rails_helper'
require 'ffaker'

require_relative '../spec_helper_modules/authenticate'

require_relative '../custom_matchers/error_on'

RSpec.configure do |config|
  config.include Authenticate
end

RSpec.describe ArticlesController, type: :controller do
  let(:valid_attributes) {{
    title: FFaker::HipsterIpsum.characters(ArticleValidator::TITLE_MAX),
    body: FFaker::HipsterIpsum.characters(ArticleValidator::BODY_MIN),
    tldr: FFaker::HipsterIpsum.characters(ArticleValidator::TLDR_MAX),
  }}

  let(:invalid_attributes) {{
    title: FFaker::HipsterIpsum.characters(ArticleValidator::TITLE_MAX + 1),
    body: FFaker::HipsterIpsum.characters(ArticleValidator::BODY_MIN + 1),
    tldr: FFaker::HipsterIpsum.characters(ArticleValidator::TLDR_MAX + 1),
  }}

  let(:session) {{user_id: create(:user).id}}
  let(:admin_session) {{user_id: create(:user, admin: true).id}}

  describe "GET #index" do
    it "returns a success response with no params" do
      get :index, session: session
      expect(response).to be_successful
    end

    %i[tags author].each do |sym|
      it "raises ActiveRecord::RecordNotFound when no :#{sym} can be found with that id" do
        expect{get :index, params: {sym => "not even a PK"}}
          .to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "GET #show" do
    before :each do
      @article = create :article
    end

    it 'returns a success response at any permission level' do
      get :show, params: {id: @article.to_param}
      expect(response).to be_successful
    end

    it 'increases the number of views on the article by 1' do
      expect {get :show, params: {id: @article.to_param}}
        .to change {@article.reload.views}.by(1)
    end
  end

  describe "GET #new" do
    it "raises Concerns::Permission::AccessDenied when not logged in" do
      authenticate {get :new}
    end

    it "returns a success response when logged in" do
      get :new, session: session
      expect(response).to be_successful
    end
  end

  describe "DELETE #destroy" do
    before :each do
      @article = create :article
    end

    context "raises Concerns::Permission::AccessDenied" do
      it "when you're not a logged in user" do
        authenticate {delete :destroy, params: {id: @article.to_param}}
      end

      it "if you aren't the owner or an admin" do
        authenticate {delete :destroy, params: {id: @article.to_param}, session: session}
      end
    end

    context "destroys the article" do
      it 'if you own it' do
        delete :destroy, params: {id: @article.to_param}, session: {user_id: @article.author.id}
        expect(Article.exists? @article.id).to be false
      end

      it 'if youre an admin' do
        delete :destroy, params: {id: @article.to_param}, session: admin_session
        expect(Article.exists? @article.id).to be false
      end
    end

    it "redirects to articles_path when destroyed by any permission level" do
      delete :destroy, params: {id: @article.to_param}, session: {user_id: @article.author.id}
      expect(response).to redirect_to(articles_path)
    end
  end

  describe "GET #edit" do
    before :each do
      @article = create :article
    end

    context "raises Concerns::Permission::AccessDenied" do
      it "if you aren't the owner or an admin" do
        authenticate {get :edit, params: {id: @article.to_param}, session: session}
      end
    end

    it "returns a success response if you're an admin" do
      get :edit, params: {id: @article.to_param}, session: admin_session
      expect(response).to be_successful
    end

    it "returns a success response if you own the Article" do
      get :edit, params: {id: @article.to_param}, session: {user_id: @article.author.id}
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    it "fails if you aren't a logged in user" do
      authenticate {post :create, params: valid_attributes}
    end

    context "with valid params" do
      it "creates a new Article" do
        expect {
          post :create, params: {article: valid_attributes}, session: session
        }.to change(Article, :count).by(1)
      end

      it "redirects to the created article" do
        post :create, params: {article: valid_attributes}, session: session
        expect(response).to redirect_to(Article.last)
      end
    end

    context "with invalid params" do
      before :each do
        post :create, params: {article: invalid_attributes}, session: session
      end

      it {should error_on :new}
    end
  end

  describe "PUT #update" do
    before :each do
      @article = create :article
    end

    context "raises Concerns::Permission::AccessDenied" do
      it "if you don't own the article and aren't an admin" do
        authenticate {put :update, params: {id: @article.to_param}, session: session}
      end
    end

    context "with valid params" do
      it "updates the requested article if you're an admin" do
        put :update, params: {id: @article.to_param, article: valid_attributes}, session: admin_session
        expect(@article.reload).to have_attributes valid_attributes
      end

      it "updates the requested article if you own the article" do
        put :update, params: {id: @article.to_param, article: valid_attributes}, session: {user_id: @article.author.id}
        expect(@article.reload).to have_attributes valid_attributes
      end

      it "redirects to the article if the update succeeded in any way" do
        put :update, params: {id: @article.to_param, article: valid_attributes}, session: admin_session
        expect(response).to redirect_to(@article)
      end
    end

    context "with invalid params" do
      before :each do
        put :update, params: {id: @article.to_param, article: invalid_attributes}, session: admin_session
      end

      it {should error_on :edit}
    end
  end
end
