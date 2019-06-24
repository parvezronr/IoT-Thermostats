require 'rails_helper'

RSpec.describe Api::V1::ReadingsController, :type => :controller do

  before(:each) do |test|
    @thermo_stat = FactoryBot.create(:thermo_stat)
    request.headers['x-api-key'] = @thermo_stat.household_token unless test.metadata[:unauthorized]
  end

  let(:valid_attributes) {
    { reading: { temperature: "10", humidity: "120", battery_charge: "90"}}
  }

  let(:missing_attributes) {
    { reading: { temperature: "10", humidity: "120"}}
  }

  let(:invalid_attributes) {
    { reading: { temperature: "1abc0", humidity: "120", battery_charge: "90"}}
  }

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Reading" do
        post :create, params: valid_attributes
        expect(response.status).to eq 201
        expect(response).to have_http_status(:created)
        expect(json_response.keys).to contain_exactly('reading_id')
      end

      it "error with valid params and missing api key", :unauthorized do
        post :create, params: valid_attributes
        expect(response.status).to eq 401
        expect(response).to have_http_status(:unauthorized)
        expect(json_response).equal?(JsonResponseHelper::Error::NOT_AUTHENTICATED)
      end
    end

    describe "with invalid params" do
      it "error saving reading with missing attributes" do
        post :create, params: missing_attributes
        expect(response).to have_http_status(:bad_request)
        expect(json_response.has_key?('error')).to be_truthy
      end

      it "error saving reading with missing attributes" do
        post :create, params: invalid_attributes
        expect(response).to have_http_status(:bad_request)
        expect(json_response.has_key?('error')).to be_truthy
      end
    end
  end

  describe "GET show" do
    it "handle show reading details" do
      post :create, params: valid_attributes
      get :show, params: { id: json_response['reading_id'] }
      expect(response.status).to eq 200
      expect(response).to have_http_status(:ok)
      expect_json_response(JSON.parse(response.body), JsonResponseHelper::Reading::SHOW)
    end

    it "handle error with missing reading_id" do
      get :show, params: { id: 300 }
      expect(response.status).to eq 200
      expect(json_response).to be_nil
    end

    it "handle empty response with wrong reading id" do
      get :show, params: { id: 999 }
      expect(response.status).to eq 200
      expect(response).to have_http_status(:ok)
      expect(json_response).to be_nil
    end

  end


end
