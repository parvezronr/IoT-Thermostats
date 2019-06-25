class Api::V1::ReadingsController < ApiBaseController
  include IotThermostat::CommonStatMethods

  before_action :find_node

  swagger_controller :readings, 'Reading Management'

  swagger_api :show do
    summary 'Display a Reading'
    notes 'Display a Reading'
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
        redis_keys_formate(eval(@thermo_stat.unsaved_readings["#{params[:reading_id]}"].to_s) , { reading_id: params[:reading_id] } )
      render json: @reading
    else
      render_error_state('Invalid Input', :bad_request)
    end
  end

  swagger_api :create do
    summary 'Reading create action'
    notes 'Builds a Reading'
    param :form, :"reading[temperature]", :number, :required, 'Temperature'
    param :form, :"reading[humidity]", :number, :required, 'Humidity'
    param :form, :"reading[battery_charge]", :number, :required, 'Battery-Charge'
    response :created
    response :unauthorized
    response :bad_request
  end

  # POST /readings
  def create
    if reading_params_check(params[:reading])
      number = @thermo_stat.reading_count.increment
      if @thermo_stat.is_accurate_sequence?(number)
        reading_data = clean_up_params(params[:reading], IotThermostat::Constants::Reading::REQUIRED_PARAMS)
        @thermo_stat.unsaved_readings["#{number}"] = reading_data
        ReadingProcessorWorker.perform_async(@thermo_stat.id, number)
        # Calculate Stats
        self.calculate_stats(@thermo_stat, number, reading_data )
        render_success_response_json_with_number(number)
      end
    else
      render_error_state('Invalid Input', :bad_request)
    end
  end


  private
    def redis_keys_formate(hash_key, options)
      if hash_key.present?
        hash_key.merge!(options)
        hash_key.each {|key,value| hash_key[key] = value.to_i}
      end
    end

    # Validates reading params.
    def reading_params_check(reading)
      reading.present? &&
        IotThermostat::Constants::Reading::REQUIRED_PARAMS.select{|a| reading[a].present? &&
          valid_float?(reading[a]) }.count == IotThermostat::Constants::Reading::REQUIRED_PARAMS.count
    end

    # Only allow a trusted parameter.
    def reading_params
      params.require(:reading).permit(:number, :temperature, :humidity, :battery_charge)
    end
    # Renders success response with number.
    def render_success_response_json_with_number(number, status = :created)
      render json: { reading_id: number }, status: status
    end
end
