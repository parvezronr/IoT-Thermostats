FactoryBot.define do
  factory :thermo_stat do
    household_token { "some_api_key" }
    location { "Rosenthaler, Germany" }
  end
end
