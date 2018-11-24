class AddStatusToParkingSpots < ActiveRecord::Migration[5.2]
  def change
    add_column :parking_spots, :status, :string
  end
end
