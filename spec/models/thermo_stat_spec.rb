require 'rails_helper'

RSpec.describe ThermoStat, :type => :model do

  describe "Associations" do
    describe "Belongs to thermostat" do
      it "creates a new Reading" do
        t = ThermoStat.reflect_on_association(:readings)
        expect(t.macro).to eq(:has_many)
      end
    end
  end

  describe "Validations for ThermoStat" do
    it "should require a location" do
      expect(FactoryBot.build(:thermo_stat, location: "")).not_to be_valid
      expect(FactoryBot.build(:thermo_stat, location: "India")).to be_valid
    end
  end
  describe "before_create" do
    thermo_stat = FactoryBot.build(:thermo_stat)

    it "should auto assign household_token" do
      expect{ thermo_stat.save }.to change{ thermo_stat.household_token }
    end
  end

  describe "Class methods" do
    thermo_stat = FactoryBot.build(:thermo_stat)
    it "should return Thermo stat from API key" do
      expect(ThermoStat.from_api_key(thermo_stat.household_token).try(:id) ).equal?(thermo_stat.id)
    end

    it "Get Thermo stat from Invalid API key" do
      expect(ThermoStat.from_api_key("2324324324").try(:id) ).to be_nil
    end

    it "Generate Household token" do
      token = ThermoStat.generate_household_token
      expect(token ).not_to be_nil
      expect(ThermoStat.exists?(household_token: token)).to be_falsy
    end

    it "checks for valid sequence" do
      expect(thermo_stat.is_valid_sequence?(1)).to be_truthy
    end

  end

end
