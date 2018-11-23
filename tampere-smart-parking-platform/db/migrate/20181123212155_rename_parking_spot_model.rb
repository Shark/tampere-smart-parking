class RenameParkingSpotModel < ActiveRecord::Migration[5.2]
  def self.up
    rename_table :parkingspots, :parking_spots
  end

  def self.down
    rename_table :parking_spots, :parkingspots
  end
end
