module JsonResponseHelper
  module Reading
    CREATE_OK = {reading_id: "some_api_key"}
    CREATE_ERR = { error: 'Invalid Input' }
    SHOW = { temperature: 10,humidity: 120,battery_charge: 90,reading_id: nil }
    SHOW_2 = { temperature: 50,humidity: 80,battery_charge: 50,reading_id: nil }
  end

  module ThermoStat
    CREATE_OK = { reading_id: 'some_api_key' }
    INDEX = [{id: 1, household_token: "ddi20NMQ7Qh62QrGUJDihgtt", location: "Germany"}, { id: 2, household_token: "FcvMQzZPP6nvIVus67bUnQtt", location: "India" } ]
    SHOW = {id: 1, household_token: "ddi20NMQ7Qh62QrGUJDihgtt", location: "Germany"}
    NOT_FOUND = "Not found"
    STATS = [{temperature: {avg: 28.142692307692307, min: -12, max: 99}}, {humidity: {avg: 71.36346153846154, min: 4, max: 233.45}}, { battery_charge: { avg: 56.0773, min: 6, max: 101}}]
  end

  module Error
    INVALID_PARAMETER = { error: "Invalid Input" }
    NOT_AUTHENTICATED = { error: "Unauthorized" }

  end

  SUCCESS = { success: true }
end