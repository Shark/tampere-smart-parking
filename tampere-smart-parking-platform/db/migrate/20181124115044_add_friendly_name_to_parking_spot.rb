class AddFriendlyNameToParkingSpot < ActiveRecord::Migration[5.2]
  def change
    add_column :parking_spots, :friendly_name, :string
    add_index :parking_spots, :friendly_name, unique: true
  end
end
