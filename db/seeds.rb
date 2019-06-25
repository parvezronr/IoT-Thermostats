puts "Initializing Settings"

# Generattion/creation of ThermoStats.
puts "Initializing Thermostats"
["India", "China", "Japan", "Australia", "Canada", "United States"].each do |address|
  thermostat = ThermoStat.new(location: address)
  thermostat.household_token = ThermoStat.set_up_household_token
  puts "#{thermostat.id} with token #{thermostat.household_token} Created" if thermostat.save
end