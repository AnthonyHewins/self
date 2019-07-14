require 'rails_helper'
require 'ffaker'

require_relative '../spec_helper_modules/authenticate'

require_relative '../custom_matchers/error_on'

RSpec.configure do |config|
  config.include Authenticate
end

RSpec.context UsersController, type: :controller do
  let(:valid_attributes) {{
    handle: FFaker::HipsterIpsum.characters(UserValidator::HANDLE_MAX),
  }}

  let(:invalid_attributes) {{
    author: 1,
    created_at: DateTime.now,
    updated_at: DateTime.now,
  }}

  let(:session) {{user_id: create(:user).id}}
  let(:admin) {{user_id: create(:user, admin: true).id}}

  context "GET #index" do
    it "returns a success response with no params" do
      create(:user)
      get :index, params: {}, session: session
      expect(response).to be_successful
    end
  end

  context 'PATCH #verify' do
    before :each do
      @user = create :user
    end

    it 'blocks anything that isnt admin' do
      authenticate {patch :verify, params: {id: @user.to_param}, session: session}
    end

    context 'when an admin' do
      before :each do
        @tag = create :tag
        patch :verify, params: {id: @user.to_param, tags: @tag.id}, session: admin
      end

      it 'updates the tags the user is verified in (admin only)' do
        expect(@user.tags.to_a).to eq [@tag]
      end

      it 'redirects to users#show when successful' do
        expect(response).to redirect_to user_path(@user)
      end
    end

    context 'with invalid params' do
      it 'returns 404 because it cant find the tag' do
        expect{
          patch :verify, params: {id: @user.to_param, tags: 'op'}, session: admin
        }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  context "GET #show" do
    it "returns a success response" do
      get :show, params: {id: create(:user).to_param}, session: session
      expect(response).to be_successful
    end

    it "raises ActiveRecord::RecordNotFound when the id doesn't exist" do
      expect{get :show, params: {id: "not even a PK"}}
        .to raise_error ActiveRecord::RecordNotFound
    end
  end

  %i[new create].each do |sym|
    context "GET ##{sym}" do
      it "404s because it isn't supported" do
        expect{get sym}.to raise_error ActionController::UrlGenerationError
      end
    end
  end

  context "DELETE #destroy" do
    it "raises Concerns::Permission::AccessDenied when not logged in" do
      expect {get :edit}.to raise_error Concerns::Permission::AccessDenied
    end

    context 'when logged in' do
      before :each do
        @user = create :user
        @session = {user_id: @user.id}
      end

      it "deletes the current_user" do
        delete :destroy, session: @session
        expect(response).to redirect_to users_path
      end
    end
  end

  context "GET #edit" do
    it "raises Concerns::Permission::AccessDenied when not logged in" do
      expect {get :edit}.to raise_error Concerns::Permission::AccessDenied
    end

    context 'when logged in' do
      before :each do
        @user = create :user
        @session = {user_id: @user.id}
      end

      it "redirects to the edit-profile path" do
        get :edit, session: @session
        expect(response).to be_successful
      end
    end
  end

  context "PATCH #update-profile" do
    it "when you're not a logged in user raises Concerns::Permission::AccessDenied" do
      expect {patch :update}.to raise_error Concerns::Permission::AccessDenied
    end

    context 'when logged in' do
      before :each do
        @user = create :user
        @session = {user_id: @user.id}
      end

      context "with valid params" do
        it "updates the current_user" do
          patch :update, params: {user: valid_attributes}, session: @session
          expect(@user.reload.handle).to eq valid_attributes[:handle]
        end

        it "redirects to the user if the update succeeded in any way" do
          patch :update, params: {user: valid_attributes}, session: @session
          expect(response).to redirect_to(@user)
        end
      end

      context "with invalid params" do
        it "redirects with errors" do
          patch :update, params: {user: invalid_attributes}, session: @session
          expect(response).to have_http_status(302)
        end
      end
    end
  end
end
