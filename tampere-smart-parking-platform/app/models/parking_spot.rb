class ParkingSpot < ApplicationRecord
  extend Enumerize
    enumerize :status, in: %w(free ocupied reserved)
end
