class AddLastConfirmedFreeAtToParkingSpots < ActiveRecord::Migration[5.2]
  def change
    add_column :parking_spots, :last_confirmed_free_at, :datetime
  end
end
