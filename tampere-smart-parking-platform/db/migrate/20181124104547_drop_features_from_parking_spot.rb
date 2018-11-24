class DropFeaturesFromParkingSpot < ActiveRecord::Migration[5.2]
  def change
    remove_column :parking_spots, :feature, :json
  end
end
