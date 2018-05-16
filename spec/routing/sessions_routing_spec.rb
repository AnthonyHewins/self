require "rails_helper"

RSpec.describe SessionsController, type: :routing do
  it "routes GET /login to sessions#new" do
    expect(:get => "/login").to route_to("sessions#new")
  end

  it "routes POST /login to sessions#create" do
    expect(:post => "/login").to route_to("sessions#create")
  end

  it "routes GET /logout to sessions#destroy" do
    expect(:get => "/logout").to route_to("sessions#destroy")
  end
end
