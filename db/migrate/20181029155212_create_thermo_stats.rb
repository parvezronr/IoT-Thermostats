class CreateThermoStats < ActiveRecord::Migration[5.2]
  def self.up
    create_table :thermo_stats do |t|
      t.text :household_token, null: false
      t.text :location
      t.timestamps
    end

    add_index :thermo_stats, :household_token
  end

  def self.down
    drop_table :thermo_stats
  end
end
