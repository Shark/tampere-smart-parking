class AddBlockedToParkingSpots < ActiveRecord::Migration[5.2]
  def change
    add_column :parking_spots, :blocked, :boolean, null: false, default: false
  end
end
