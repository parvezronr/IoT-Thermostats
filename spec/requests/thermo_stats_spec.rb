require 'rails_helper'

RSpec.describe "ThermoStats", :type => :request do
  describe "GET /thermo_stats" do
    it "works! (now write some real specs)" do
      get api_v1_thermo_stats_path
      expect(response).to have_http_status(200)
    end
  end
end
