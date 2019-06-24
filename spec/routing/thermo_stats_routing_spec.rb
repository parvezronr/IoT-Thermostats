require "rails_helper"

RSpec.describe  Api::V1::ThermoStatsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "api/v1/thermo_stats").to route_to("api/v1/thermo_stats#index")
    end

    it "routes to #show" do
      expect(:get => "api/v1/thermo_stats/1").to route_to("api/v1/thermo_stats#show", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "api/v1/thermo_stats").to route_to("api/v1/thermo_stats#create")
    end

  end
end
