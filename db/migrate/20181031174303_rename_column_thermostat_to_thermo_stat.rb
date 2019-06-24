class RenameColumnThermostatToThermoStat < ActiveRecord::Migration[5.2]
   def self.up
    rename_column :readings, :thermostat_id, :thermo_stat_id
  end

  def self.down
    rename_column :readings, :thermo_stat_id, :thermostat_id
  end
end
