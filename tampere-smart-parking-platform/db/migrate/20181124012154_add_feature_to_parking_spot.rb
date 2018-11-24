class AddFeatureToParkingSpot < ActiveRecord::Migration[5.2]
  def change
    add_column :parking_spots, :feature, :json
  end
end
