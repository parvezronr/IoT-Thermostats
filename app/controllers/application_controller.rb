class ApplicationController < ActionController::API

  include ActionController::Serialization

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  protected

  def forbidden_access
    render_error_state 'Access forbidden', :forbidden
  end

  def record_not_found
    render_error_state 'Not found', :not_found
  end

  def render_error_state(err_msg, status)
    render json: { error: err_msg }, status: status
  end

  def render_success_json(status = :ok)
    render json: { success: true }, status: status
  end

  def clean_up_params(params, filter)
    new_params = {}
    filter.collect{ |key| new_params[key.to_s] = params[key] }
    new_params
  end

  def serialize(params)
    params.map{|key, value| { key => eval(value.to_s) } }
  end

  def find_node
    @thermo_stat = ThermoStat.from_api_key(request.env["HTTP_X_API_KEY"])
    render_error_state('Unauthorized', :unauthorized) if @thermo_stat.blank?
  end

  def valid_float?(num)
    # The double negation turns this into an actual boolean true - if you're
    # okay with "truthy" values (like 0.0), you can remove it.
    !!Float(num) rescue false
  end

end
