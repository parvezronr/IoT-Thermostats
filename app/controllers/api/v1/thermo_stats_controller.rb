class Api::V1::ThermoStatsController < ApiBaseController

  before_action :set_thermo_stat, only: [:show]
  before_action :find_node, only: [:my_stats]

  swagger_controller :thermo_stats, 'ThermoStats management'

  swagger_api :index do
    summary 'Returns all Thermostats'
    notes 'Returns all Thermostats'
  end

  # GET /thermo_stats
  def index
    # "Need more work"
    @thermo_stats = ThermoStat.all
    render json: @thermo_stats, status: :ok
  end

  swagger_api :create do
    summary 'Thermo-stat create action'
    notes 'Creates a Thermo-stat'
    param :form, :"thermo_stat[location]", :string, :required, 'Message of the micro-blog'
    response :created
    response :bad_request
  end

  # POST /thermo_stats
  def create
    # p "Yet to work on this"
    @thermo_stat = ThermoStat.new(thermo_stat_params)
    @thermo_stat.household_token = ThermoStat.generate_household_token
    if @thermo_stat.save
      render json: @thermo_stat, status: :created
    else
      render json: @thermo_stat.errors, status: :bad_request
    end
  end

  swagger_api :show do
    summary 'Shows a micro-blog'
    notes 'Shows a thermo-stat with token and possible actions'
    param :path, :id, :integer, :required, 'Thermo-stat ID'
    response :ok
    response :bad_request
  end

  # GET /thermo_stats/1
  def show
    render json: @thermo_stat
  end

  swagger_api :my_stats do
    summary 'Display thermostat min, max, avg values for temperature, humidity, battery charge'
    notes 'Get min, max, avg values for temperature, humidity, battery charge'
    response :ok
    response :unauthorized
    response :bad_request
  end

  # GET /thermo_stats/my_stats
  def my_stats
    render json: serialize(@thermo_stat.stats.all) , status: :ok
  end

  private
  def set_thermo_stat
    @thermo_stat = ThermoStat.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def thermo_stat_params
    params.require(:thermo_stat).permit(:household_token, :location)
  end
end
