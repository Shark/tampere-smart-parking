class ParkingSpot < ApplicationRecord
  extend Enumerize
  enumerize :status, in: %w(free occupied reserved)

  # reverse geocoding is stored in the address attribute
  reverse_geocoded_by :latitude, :longitude do |parking_spot, results|
    if geo = results.first
      if road = geo.data.dig('address', 'road')
        if house_number = geo.data.dig('address', 'house_number')
          parking_spot.address = "#{road} #{house_number}"
        else
          parking_spot.address = "#{road}"
        end
      end
    end
  end

  # after_validation :reverse_geocode

  scope :recently_confirmed_free, -> {
    where(status: 'free').
    where.
    not(last_confirmed_free_at: nil).
    order('last_confirmed_free_at DESC') }
end
