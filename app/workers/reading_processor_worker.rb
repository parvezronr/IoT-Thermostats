class ReadingProcessorWorker
  include Sidekiq::Worker
  sidekiq_options queue: "high", retry: 2, backtrace: 5, failures: :exhausted

  sidekiq_retries_exhausted do |msg, ex|
    Sidekiq.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
  end

  def perform(thermostat_id, number)
    thermo_stat = ThermoStat.where(id: thermostat_id).first
    if thermo_stat.present? && number.present?
      reading_params = eval(thermo_stat.unsaved_readings["#{number}"].to_s)
      reading = thermo_stat.readings.new(reading_params)
      reading.number = number
      if reading.save
        thermo_stat.unsaved_readings.delete("#{number}")
      else
        Rails.logger.fatal("Readings Processor: Please verify if the redis server is running, reading paramerter")
        Rails.logger.fatal("#{Rails.backtrace_cleaner.clean(e.backtrace).join("\n")}")
      end
    end
  end
end