require 'rails_helper'

RSpec.describe "Readings", :type => :request do
  describe "GET /readings/1" do
    it "works! (now write some real specs)" do
      get api_v1_reading_path(1)
      expect(response).to have_http_status(401)
    end
  end
end
