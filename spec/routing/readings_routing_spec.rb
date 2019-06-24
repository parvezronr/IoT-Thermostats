require "rails_helper"

RSpec.describe  Api::V1::ReadingsController, :type => :routing do
  describe "routing" do

    it "routes to #show" do
      expect(:get => "api/v1/readings/1").to route_to("api/v1/readings#show", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "api/v1/readings").to route_to("api/v1/readings#create")
    end
  end
end
