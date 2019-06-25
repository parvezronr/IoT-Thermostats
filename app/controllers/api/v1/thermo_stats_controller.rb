class Api::V1::ThermoStatsController < ApiBaseController

  before_action :thermo_stat_set, only: [:show]
  before_action :find_node, only: [:my_stats]

  swagger_controller :thermo_stats, 'ThermoStats management'

  # GET /thermo_stats
  def index
    @thermo_stats = ThermoStat.all
    render json: @thermo_stats, status: :ok
  end

  # POST /thermo_stats
  def create
    @thermo_stat = ThermoStat.new(thermo_stat_params)
    @thermo_stat.household_token = ThermoStat.set_up_household_token
    if @thermo_stat.save
      render json: @thermo_stat, status: :created
    else
      render json: @thermo_stat.errors, status: :bad_request
    end
  end

  # GET /thermo_stats/1
  def show
    render json: @thermo_stat
  end

  # GET /thermo_stats/my_stats
  def my_stats
    render json: serialize(@thermo_stat.stats.all) , status: :ok
  end

  private
  # Allows trusted parameter "white list" through.
  def thermo_stat_params
    params.require(:thermo_stat).permit(:household_token, :location)
  end

  # Set thermostat.
  def thermo_stat_set
    @thermo_stat = ThermoStat.find(params[:id])
  end
end
