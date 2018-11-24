class AddAddressToParkingSpots < ActiveRecord::Migration[5.2]
  def change
    add_column :parking_spots, :address, :text
  end
end
