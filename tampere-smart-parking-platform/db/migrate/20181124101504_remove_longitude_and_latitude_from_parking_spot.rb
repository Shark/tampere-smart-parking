class RemoveLongitudeAndLatitudeFromParkingSpot < ActiveRecord::Migration[5.2]
  def change
    remove_column :parking_spots, :latitude
    remove_column :parking_spots, :longitude
  end
end
