class Api::V1::ReadingsController < ApiBaseController
  include IotThermostat::CommonStatMethods

  before_action :find_node

  swagger_controller :readings, 'Reading Management'

  swagger_api :show do
    summary 'Shows a Reading'
    notes 'Shows a Reading'
    param :path, :id, :integer, :required, 'Reading ID'
    response :ok
    response :unauthorized
    response :bad_request
  end

  # GET /readings/1
  def show
    params[:reading_id] ||= params[:id]
    if params[:reading_id].present?
      @reading = @thermo_stat.readings.find_by_number(params[:reading_id]) ||
        format_redis_keys(eval(@thermo_stat.unsaved_readings["#{params[:reading_id]}"].to_s) , { reading_id: params[:reading_id] } )
      render json: @reading
    else
      render_error_state('Invalid Input', :bad_request)
    end
  end

  swagger_api :create do
    summary 'Reading create action'
    notes 'Creates a Reading'
    param :form, :"reading[temperature]", :number, :required, 'Temperature'
    param :form, :"reading[humidity]", :number, :required, 'Humidity'
    param :form, :"reading[battery_charge]", :number, :required, 'Battery Charge'
    response :created
    response :unauthorized
    response :bad_request
  end

  # POST /readings
  def create
    if validate_reading_params(params[:reading])
      number = @thermo_stat.reading_count.increment
      if @thermo_stat.is_valid_sequence?(number)
        reading_data = clean_up_params(params[:reading], IotThermostat::Constants::Reading::REQUIRED_PARAMS)
        @thermo_stat.unsaved_readings["#{number}"] = reading_data
        ReadingProcessorWorker.perform_async(@thermo_stat.id, number)
        # Calculate Stats
        self.calculate_stats(@thermo_stat, number, reading_data )
        render_success_json_with_number(number)
      end
    else
      render_error_state('Invalid Input', :bad_request)
    end
  end


  private

    def validate_reading_params(reading)
      reading.present? &&
        IotThermostat::Constants::Reading::REQUIRED_PARAMS.select{|a| reading[a].present? &&
          valid_float?(reading[a]) }.count == IotThermostat::Constants::Reading::REQUIRED_PARAMS.count
    end

    def format_redis_keys(serialize_hash, options)
      if serialize_hash.present?
        serialize_hash.merge!(options)
        serialize_hash.each {|key,value| serialize_hash[key] = value.to_i}
      end
    end

    def render_success_json_with_number(number, status = :created)
      render json: { reading_id: number }, status: status
    end

    # Only allow a trusted parameter "white list" through.
    def reading_params
      params.require(:reading).permit(:number, :temperature, :humidity, :battery_charge)
    end
end
