module IotThermostat
  module CommonStatMethods


    # Public:      To Calculate Avg, Min, Max for a given ThermoStat
    #              and store in redis.
    #
    # thermostat_id   - thermostat Object
    # number - House sequence number
    # reading_params - Hash reading_params which include
    #                  temperature, humidity, battery_charge
    #
    # Returns nothing
    def calculate_stats(thermo_stat, number, reading_params )
      prev_stats = eval(thermo_stat.stats.all.to_s)
      thermo_stat.stats[:temperature] = unit_stat(:temperature, reading_params[:temperature.to_s].to_f, prev_stats, number )
      thermo_stat.stats[:humidity] = unit_stat(:humidity, reading_params[:humidity.to_s].to_f, prev_stats, number )
      thermo_stat.stats[:battery_charge] = unit_stat(:battery_charge, reading_params[:battery_charge.to_s].to_f, prev_stats, number )
    end

    # Public:      To Calculate Avg, Min, Max for a given ThermoStat
    #
    # type   - :temperature/ :humidity/ :battery_charge
    # value - reading value for a given type
    # prev_stats - Prev redis object to a given thermostat
    # number - House sequence number
    #
    # Returns avg, min, max for a given type
    def unit_stat(type, value, prev_stats, number)
      if prev_stats.present?
        object = eval(prev_stats["#{type.to_s}"])
        counter = number - 1
        type_avg = ( ( object[:avg].to_f * counter) + value ) / (number)
        type_min = ( object[:min].to_f <= value) ? object[:min].to_f : value
        type_max = ( object[:max].to_f >= value) ? object[:max].to_f : value
      else
        type_avg = type_min = type_max = value
      end
      { avg: type_avg, min: type_min, max: type_max}
    end

  end
end