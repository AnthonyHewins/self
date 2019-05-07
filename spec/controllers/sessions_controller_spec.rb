require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    before :each do
      @password = "a!!!!!"
      @user = create :user, password: @password
    end

    it "creates a login session for the user when credentials match" do
      post :create, params: {handle: @user.handle, password: @password}
      expect(session[:user_id]).to eq @user.id
    end

    it "doesn't create a login session when the credentials don't match" do
      post :create, params: {handle: @user.handle, password: "garbage-pw"}
      expect(session[:user_id]).to be_nil
    end
  end
  
  describe "DELETE #logout" do
    it "destroys login session (session[:user_id])" do
      @request.session['user_id'] = create(:user).id
      delete :destroy
      expect(session[:user_id]).to be_nil
    end
  end
end
