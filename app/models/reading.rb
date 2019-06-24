class Reading < ApplicationRecord
  #   Table "public.readings"
  #      Column     |            Type             |                       Modifiers
  # ----------------+-----------------------------+-------------------------------------------------------
  #  id             | bigint                      | not null default nextval('readings_id_seq'::regclass)
  #  thermo_stat_id | integer                     | not null
  #  number         | integer                     |
  #  temperature    | double precision            | not null
  #  humidity       | double precision            | not null
  #  battery_charge | double precision            | not null
  #  created_at     | timestamp without time zone | not null
  #  updated_at     | timestamp without time zone | not null
  # Indexes:
  #     "readings_pkey" PRIMARY KEY, btree (id)
  
  include Redis::Objects

  belongs_to :thermo_stat

  validates :temperature, presence: true, numericality: { only_float: true }
  validates :humidity, presence: true, numericality: { only_float: true }
  validates :battery_charge, presence: true, numericality: { only_float: true }
  validates :number, uniqueness: { scope: :thermo_stat_id }

  class << self
  end
end
