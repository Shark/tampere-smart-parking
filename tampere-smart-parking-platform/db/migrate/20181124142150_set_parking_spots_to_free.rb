class SetParkingSpotsToFree < ActiveRecord::Migration[5.2]
  def up
    reversible do |dir|
      dir.up do
        ParkingSpot.where(status: nil).update_all(status: 'free')
      end
    end

    change_column_default :parking_spots, :status, 'free'
  end
end
