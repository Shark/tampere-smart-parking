class AddPolygonToParkingSpot < ActiveRecord::Migration[5.2]
  def change
    add_column :parking_spots, :polygon, :json
  end
end
