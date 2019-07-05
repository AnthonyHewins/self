require 'rails_helper'
require 'ffaker'

RSpec.context UsersController, type: :controller do
  let(:valid_attributes) {{
    handle: FFaker::HipsterIpsum.characters(UserValidator::HANDLE_MAX),
  }}

  let(:invalid_attributes) {{
    author: 1,
    created_at: DateTime.now,
    updated_at: DateTime.now,
  }}

  let(:valid_session) {{user_id: create(:user).id}}
  let(:valid_admin_session) {{user_id: create(:user, admin: true).id}}

  context "GET #index" do
    it "returns a success response with no params" do
      create(:user)
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  context "GET #show" do
    it "returns a success response" do
      get :show, params: {id: create(:user).to_param}, session: valid_session
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
    it "raises Permission::AccessDenied when not logged in" do
      expect {get :edit}.to raise_error Permission::AccessDenied
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
    it "raises Permission::AccessDenied when not logged in" do
      expect {get :edit}.to raise_error Permission::AccessDenied
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
    it "when you're not a logged in user raises Permission::AccessDenied" do
      expect {patch :update}.to raise_error Permission::AccessDenied
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
