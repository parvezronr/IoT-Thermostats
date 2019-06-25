class ThermoStat < ApplicationRecord
  #   Table "public.thermo_stats"
  #      Column      |            Type             |                         Modifiers
  # -----------------+-----------------------------+-----------------------------------------------------------
  #  id              | bigint                      | not null default nextval('thermo_stats_id_seq'::regclass)
  #  household_token | text                        | not null
  #  location        | text                        |
  #  created_at      | timestamp without time zone | not null
  #  updated_at      | timestamp without time zone | not null
  # Indexes:
  #     "thermo_stats_pkey" PRIMARY KEY, btree (id)
  #     "index_thermo_stats_on_household_token" btree (household_token)
  
  include Redis::Objects
  has_many :readings

  validates :household_token, presence: true, length: {
    minimum: IotThermostat::Constants::ThermoStat::MINIMUM, maximum: IotThermostat::Constants::ThermoStat::MAXIMUM}
  validates :location, presence: true, length: {
    minimum: IotThermostat::Constants::ThermoStat::MINIMUM, maximum: IotThermostat::Constants::ThermoStat::MAXIMUM}

  counter :reading_count
  hash_key :unsaved_readings
  hash_key :stats

  before_create do |t_stat|
    t_stat.household_token = ThermoStat.set_up_household_token
  end

  class << self
    def from_api_key(household_token)
      user = ThermoStat.find_by_household_token household_token
    end

    def set_up_household_token
      loop do
        token = SecureRandom.base64.tr('+/=', 'Qrt')
        break token unless ThermoStat.exists?(household_token: token)
      end
    end
  end

  def is_accurate_sequence?(number)
    self.readings.find_by_number(number).blank?
  end

end
