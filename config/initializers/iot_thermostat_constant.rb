# encoding: utf-8
# Explicit mention of the encoding like in the commented line above is
# needed for specifying some Unicode characters.
# To use the constants use IotThermostat::Constants::ClassName::ConstantName
module IotThermostat
  module Constants
    module Reading
      REQUIRED_PARAMS = [:temperature, :humidity, :battery_charge]
    end

    module ThermoStat
      MINIMUM = 5
      MAXIMUM = 200
    end
  end
end