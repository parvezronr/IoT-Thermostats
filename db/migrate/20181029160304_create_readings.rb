class CreateReadings < ActiveRecord::Migration[5.2]
  def change
    create_table :readings do |t|
      t.integer :thermostat_id, null: false
      t.integer :number
      t.float :temperature, null: false
      t.float :humidity, null: false
      t.float :battery_charge, null: false

      t.timestamps
    end
  end
end
