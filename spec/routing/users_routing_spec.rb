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

    it "does NOT route to #edit using ID" do
      expect(:get => "/users/1/edit").to_not route_to("users#edit", :id => "1")
    end

    it "routes to #edit using top level edit-profile" do
      expect(:get => "edit-profile").to route_to("users#edit")
    end

    it "does NOT route to #create" do
      expect(:post => "/users").to_not route_to("users#create")
    end

    it "does NOT route to #update via PUT using ID" do
      expect(:put => "/users/1").to_not route_to("users#update", :id => "1")
    end

    it "does NOT route to #update via PATCH using ID" do
      expect(:patch => "/users/1").to_not route_to("users#update", :id => "1")
    end

    it "routes to #update using top level update-profile" do
      expect(:patch => "update-profile").to route_to("users#update")
    end

    it "does NOT route to #destroy using ID" do
      expect(:delete => "/users/1").to_not route_to("users#destroy", :id => "1")
    end

    it "routes to #destroy using top level delete" do
      expect(:delete => "delete").to route_to("users#destroy")
    end

    it "routes to #change_password" do
      expect(:get => "/users/change-password").to route_to("users#change_password")
    end

    it "routes to #update_password" do
      expect(:patch => "/users/change-password").to route_to("users#update_password")
    end
  end
end
