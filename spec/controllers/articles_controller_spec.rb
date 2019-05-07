require 'rails_helper'
require 'ffaker'

RSpec.describe ArticlesController, type: :controller do
  let(:valid_attributes) {{
    title: FFaker::HipsterIpsum.characters(Article::TITLE_MAX),
    body: FFaker::HipsterIpsum.characters(Article::BODY_MIN),
    tldr: FFaker::HipsterIpsum.characters(Article::TLDR_MAX),
  }}

  let(:invalid_attributes) {{
    author: 1,
    created_at: DateTime.now,
    updated_at: DateTime.now,
  }}

  let(:valid_session) {{user_id: create(:user).id}}
  let(:valid_admin_session) {{user_id: create(:user, admin: true).id}}

  describe "GET #index" do
    it "returns a success response with no params" do
      create(:article)
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end

    %i(tags author).each do |sym|
      it "raises ActiveRecord::RecordNotFound when no :#{sym} can be found with that id" do
        expect{get :index, params: {sym => "not even a PK"}}
          .to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: {id: create(:article).to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    context "raises Permission::AccessDenied" do
      it "when you're not a logged in user" do
        expect {
          get :edit, params: {id: create(:article).to_param}
        }.to raise_error Permission::AccessDenied
      end

      it "if you aren't the owner or an admin" do
        expect {
          get :edit, params: {id: create(:article).to_param}, session: valid_session
        }.to raise_error Permission::AccessDenied
      end
    end

    it "returns a success response if you're an admin" do
      get :edit, params: {id: create(:article).to_param}, session: valid_admin_session
      expect(response).to be_successful
    end

    it "returns a success response if you own the Article" do
      user = create :user
      get :edit, params: {id: create(:article, author: user).to_param}, session: {user_id: user.id}
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    it "fails if you aren't a logged in user" do
      expect {
        post :create, params: valid_attributes
      }.to raise_error Permission::AccessDenied
    end

    context "with valid params" do
      it "creates a new Article" do
        expect {
          post :create, params: {article: valid_attributes}, session: valid_session
        }.to change(Article, :count).by(1)
      end

      it "redirects to the created article" do
        post :create, params: {article: valid_attributes}, session: valid_session
        expect(response).to redirect_to(Article.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {article: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "PUT #update" do
    context "raises Permission::AccessDenied" do
      it "when you're not a logged in user" do
        expect {
          get :edit, params: {id: create(:article).to_param, article: valid_attributes}
        }.to raise_error Permission::AccessDenied
      end

      it "if you don't own the article and aren't an admin" do
        expect {
          put :update, params: {id: create(:article).to_param, article: valid_attributes}, session: valid_session
        }.to raise_error Permission::AccessDenied
      end
    end

    context "with valid params" do
      it "updates the requested article if you're an admin" do
        article = create(:article)
        put :update, params: {id: article.to_param, article: valid_attributes}, session: valid_admin_session
        article.reload
        expect(response).to redirect_to(article)
      end

      it "updates the requested article if you own the article" do
        user = create :user
        article = create(:article, author: user)
        put :update, params: {id: article.id, article: valid_attributes}, session: {user_id: user.id}
        article.reload
        expect(response).to redirect_to(article)
      end

      it "redirects to the article if the update succeeded in any way" do
        put :update, params: {id: create(:article).to_param, article: valid_attributes}, session: valid_admin_session
      end
    end

    context "with invalid params" do
      it "returns a success response" do
        put :update, params: {id: create(:article).to_param, article: invalid_attributes}, session: valid_admin_session
        expect(response).to have_http_status(302)
      end
    end
  end
end
