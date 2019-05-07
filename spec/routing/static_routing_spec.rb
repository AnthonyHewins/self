require "rails_helper"

RSpec.describe StaticController, type: :routing do
  describe "routing" do
    it "routes /contact to static#contact" do
      expect(:get => "/contact").to route_to("static#contact")
    end

    it "routes /privacy to static#privacy" do
      expect(:get => "/privacy").to route_to("static#privacy")
    end

    it "routes / to static#index" do
      expect(:get => "/").to route_to("static#index")
    end
  end
end
