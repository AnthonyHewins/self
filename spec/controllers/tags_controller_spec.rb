require 'rails_helper'
require 'ffaker'

require_relative '../spec_helper_modules/authenticate'

require_relative '../custom_matchers/error_on'

RSpec.configure do |config|
  config.include Authenticate
end

RSpec.describe TagsController, type: :controller do
  let(:valid_attributes) {{
    name: FFaker::HipsterIpsum.characters(Tag::NAME_MAX),
    color: FFaker::Color.hex_code,
    semantic_ui_icon_id: create(:semantic_ui_icon).id
  }}

  let(:invalid_attributes) {{
    name: FFaker::HipsterIpsum.characters(Tag::NAME_MAX + 1),
    color: "#000",
    semantic_ui_icon_id: -1
  }}

  let(:session) {{user_id: create(:user).id}}
  let(:admin_session) {{user_id: create(:user, admin: true).id}}

  describe "GET #index" do
    it "returns a success response" do
      get :index, session: session
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "raises Concerns::Permission::AccessDenied when not at least admin" do
      authenticate {get :new, session: session}
    end

    it "returns a success response when an admin" do
      get :new, session: admin_session
      expect(response).to be_successful
    end
  end

  describe "DELETE #destroy" do
    before :each do
      @id = create(:tag).to_param
    end

    context "raises Concerns::Permission::AccessDenied" do
      it "if you aren't at least admin" do
        authenticate {delete :destroy, params: {id: @id}, session: session}
      end
    end

    context 'as an admin' do
      it "destroys the tag" do
        expect {
          delete :destroy, params: {id: @id}, session: admin_session
        }.to change{Tag.count}.by(-1)
      end

      it "redirects to tags_path if you're an admin" do
        delete :destroy, params: {id: @id}, session: admin_session
        expect(response).to redirect_to(tags_path)
      end
    end
  end

  describe "GET #edit" do
    before :each do
      @tag = create :tag
    end
    
    context "raises Concerns::Permission::AccessDenied" do
      it "if you aren't at least an admin" do
        authenticate {get :edit, params: {id: @tag.to_param}, session: session}
      end
    end

    it "returns a success response if you're an admin" do
      get :edit, params: {id: @tag.to_param}, session: admin_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    it "fails if you aren't at least an admin" do
      authenticate {post :create, session: session}
    end

    context "as an admin" do
      context 'with valid params' do
        it "creates a new Tag" do
          expect {
            post :create, params: {tag: valid_attributes}, session: admin_session
          }.to change(Tag, :count).by(1)
        end

        it "redirects to tags_path" do
          post :create, params: {tag: valid_attributes}, session: admin_session
          expect(response).to redirect_to(tags_path)
        end
      end

      context 'with invalid params' do
        before :each do
          post :create, params: {tag: invalid_attributes}, session: admin_session
        end

        it {should error_on :new}
      end
    end
  end

  describe "PUT #update" do
    before :each do
      @tag = create(:tag)
    end

    context "raises Concerns::Permission::AccessDenied" do
      it "if you aren't at least an admin" do
        authenticate do
          put :update, params: {id: @tag.to_param, tag: valid_attributes}, session: session
        end
      end
    end

    context "as an admin" do
      context 'with valid params' do
        it "updates the requested tag" do
          put :update, params: {id: @tag.to_param, tag: valid_attributes}, session: admin_session
          expect(@tag.reload).to have_attributes valid_attributes
        end

        it "redirects to tags_path if the update succeeded" do
          put :update, params: {id: @tag.to_param, tag: valid_attributes}, session: admin_session
          expect(response).to redirect_to(tags_path)
        end
      end
    end

    context 'with invalid params' do
      before :each do
        put :update, params: {id: @tag.to_param, tag: invalid_attributes}, session: admin_session
      end

      it {should error_on :edit}
    end
  end
end
