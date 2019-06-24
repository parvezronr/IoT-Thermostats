namespace :redis_objects do
  task :init => :environment do
    reset_thermostat_readings_counter
    update_thermostat_readings_counter

    reset_thermostat_unsaved_readings

    reset_thermostat_stats
    update_thermostat_stats

  end

  task :reset_thermostat_readings_counter => :environment do
    reset_thermostat_readings_counter
  end

  task :update_thermostat_readings_counter => :environment do
    update_thermostat_readings_counter
  end

  task :reset_thermostat_unsaved_readings => :environment do
    reset_thermostat_unsaved_readings
  end

  task :reset_thermostat_stats => :environment do
    reset_thermostat_stats
  end

  task :update_thermostat_stats => :environment do
    update_thermostat_stats
  end

  def reset_thermostat_readings_counter
    ThermoStat.all.each do |thermo_stat|
      thermo_stat.reading_count.value = 0
    end
  end

  def update_thermostat_readings_counter
    ThermoStat.all.each do |thermo_stat|
      thermo_stat.reading_count.value = thermo_stat.readings.count
    end
  end

  def reset_thermostat_unsaved_readings
    ThermoStat.all.each do |thermo_stat|
      thermo_stat.unsaved_readings.clear
    end
  end

  def reset_thermostat_stats
    ThermoStat.all.each do |thermo_stat|
      thermo_stat.stats.clear
    end
  end

  def update_thermostat_stats
    ThermoStat.all.each do |thermo_stat|
      IotThermostat::Constants::Reading::REQUIRED_PARAMS.each do |type|
        readings = thermo_stat.readings.order(type)
        if readings.present?
          type_avg = readings.pluck(type).sum / readings.count
          type_min = readings.first[type]
          type_max = readings.last[type]
          thermo_stat.stats[type] = { avg: type_avg, min: type_min, max: type_max}
        else
          thermo_stat.stats.clear
        end
      end
    end
  end
end