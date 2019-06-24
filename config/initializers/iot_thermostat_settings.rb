IOT_THERMOSTAT_SETTINGS = HashWithIndifferentAccess.new(Rails.application.config_for(:iot_thermostat_settings))

def build_url()
  custom_port =
    ![443, 80].include?(IOT_THERMOSTAT_SETTINGS[:port].to_i) ?
    ":#{IOT_THERMOSTAT_SETTINGS[:port]}" : nil

  [ IOT_THERMOSTAT_SETTINGS[:protocol],
    "://",
    IOT_THERMOSTAT_SETTINGS[:host],
    custom_port,
    IOT_THERMOSTAT_SETTINGS[:relative_url_root],
  ].join('')
end

IOT_THERMOSTAT_SETTINGS[:url] = build_url()
