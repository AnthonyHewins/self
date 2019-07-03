require "rails_helper"

RSpec.describe UsersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/users").to route_to("users#index")
    end

    it "does NOT route to #new" do
      expect(:get => "/users/new").to_not route_to("users#new")
    end

    it "routes to #show" do
      expect(:get => "/users/1").to route_to("users#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/users/1/edit").to route_to("users#edit", :id => "1")
    end

    it "does NOT route to #create" do
      expect(:post => "/users").to_not route_to("users#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/users/1").to route_to("users#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/users/1").to route_to("users#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/users/1").to route_to("users#destroy", :id => "1")
    end

    it "routes to #change_password" do
      expect(:get => "/users/change-password").to route_to("users#change_password")
    end

    it "routes to #update_password" do
      expect(:patch => "/users/change-password").to route_to("users#update_password")
    end
  end
end
