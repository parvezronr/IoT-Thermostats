require 'rails_helper'

RSpec.describe Api::V1::ThermoStatsController, :type => :controller do

  before(:each) do |test|
    if test.metadata[:my_stats]
      @thermo_stat = FactoryBot.create(:thermo_stat)
      request.headers['x-api-key'] = @thermo_stat.household_token
      old_controller = @controller
      @controller = Api::V1::ReadingsController.new()
      post :create, params: { reading: JsonResponseHelper::Reading::SHOW }
      @reading_details = JSON.parse(response.body)
      @controller = old_controller
    end
  end

  let(:valid_attributes) {
    {thermo_stat: {  location: "Chennai, India"}}
  }

  let(:invalid_attributes) {
     { thermo_stat: {  location: "" } }
  }


  describe "POST Create thermostats" do
    describe "with valid params" do
      it "Create thermostats with valid params" do
        post :create, params: valid_attributes
        process :index, method: :get
        expect(json_response).not_to be_nil
        expect_json_response(json_response, JsonResponseHelper::ThermoStat::INDEX)
      end
    end

    describe "with invalid params" do
      it "Create thermostats with invalid params" do
        post :create, params: invalid_attributes
        expect(response).to have_http_status(:bad_request)
        expect(json_response).not_to be_nil
      end
    end
  end

  describe "GET show" do
    it "assigns the requested thermo_stat as @thermo_stat" do
      thermo_stat = FactoryBot.create(:thermo_stat)
      get :show, params: { id: thermo_stat.id}
      expect(response).to have_http_status(:ok)
      expect(json_response).not_to be_nil
    end

    it "Not found" do
      get :show, params: { id: 100 }
      expect(response.status).to eq 404
      expect(json_response.has_key?('error')).to be_truthy
      expect(json_response['error']).equal?(JsonResponseHelper::ThermoStat::NOT_FOUND)
    end
  end

  describe "GET Index - List all Thermo Stats" do
    it "assigns the requested thermo_stat as @thermo_stats" do
      get :index, params: {}
      expect(response).to have_http_status(:ok)
      expect_json_response(json_response, JsonResponseHelper::ThermoStat::INDEX)
    end
  end

  describe "GET my_stats" do
    describe "with valid params" do

      it "gives thermostat stats", :my_stats do
        get :my_stats
        parse_response =  JSON.parse(response.body)
        expect(parse_response).not_to be_nil
        expect_json_response(parse_response, JsonResponseHelper::ThermoStat::STATS)
      end

      it "check for thermostat stats for single reading", :my_stats do
        get :my_stats
        parse_response =  JSON.parse(response.body)
        expect(parse_response[0]['temperature']['min'].to_f).equal?(JsonResponseHelper::Reading::SHOW[:temperature])
        expect(parse_response[0]['temperature']['max'].to_f).equal?(JsonResponseHelper::Reading::SHOW[:temperature])
        expect(parse_response[0]['temperature']['avg'].to_f).equal?(JsonResponseHelper::Reading::SHOW[:temperature])
        expect(parse_response[1]['humidity']['min'].to_f).equal?(JsonResponseHelper::Reading::SHOW[:temperature])
        expect(parse_response[1]['humidity']['max'].to_f).equal?(JsonResponseHelper::Reading::SHOW[:temperature])
        expect(parse_response[1]['humidity']['avg'].to_f).equal?(JsonResponseHelper::Reading::SHOW[:temperature])
        expect(parse_response[2]['battery_charge']['min'].to_f).equal?(JsonResponseHelper::Reading::SHOW[:temperature])
        expect(parse_response[2]['battery_charge']['max'].to_f).equal?(JsonResponseHelper::Reading::SHOW[:temperature])
        expect(parse_response[2]['battery_charge']['avg'].to_f).equal?(JsonResponseHelper::Reading::SHOW[:temperature])
      end

      it "check for thermostat stats for  multiple reading", :my_stats do
        old_controller = @controller
        @controller = Api::V1::ReadingsController.new()
        post :create, params: { reading: JsonResponseHelper::Reading::SHOW_2 }
        @reading_details = JSON.parse(response.body)
        @controller = old_controller
        get :my_stats
        parse_response =  JSON.parse(response.body)
        expect(parse_response[0]['temperature']['min'].to_f).equal?(10)
        expect(parse_response[0]['temperature']['max'].to_f).equal?(50)
        expect(parse_response[0]['temperature']['avg'].to_f).equal?(30)
        expect(parse_response[1]['humidity']['min'].to_f).equal?(80)
        expect(parse_response[1]['humidity']['max'].to_f).equal?(120)
        expect(parse_response[1]['humidity']['avg'].to_f).equal?(100)
        expect(parse_response[2]['battery_charge']['min'].to_f).equal?(50)
        expect(parse_response[2]['battery_charge']['max'].to_f).equal?(90)
        expect(parse_response[2]['battery_charge']['avg'].to_f).equal?(70)
      end
    end

    describe "with invalid params" do
      it "Create thermostats with invalid params" do
        get :my_stats
        expect(response).to have_http_status(:unauthorized)
        expect(json_response).equal?(JsonResponseHelper::Error::NOT_AUTHENTICATED)
      end
    end
  end

  describe "Redis Object for ThermoStat", :my_stats do
    it "should require a location" do
      expect(@thermo_stat.reading_count.value).equal?(1)
    end

    it "should respond to unsaved_readings", :my_stats do
      expect(@thermo_stat.unsaved_readings.all).equal?({})
    end

    it "should respond to stats", :my_stats do
      expect_json_response(@thermo_stat.stats.all, JsonResponseHelper::ThermoStat::STATS)
    end
  end

end
