class CreateParkingspots < ActiveRecord::Migration[5.2]
  def change
    create_table :parkingspots do |t|
      t.decimal :latitude, precision: 9, scale: 6
      t.decimal :longitude, precision: 9, scale: 6
      t.timestamps
    end
  end
end
