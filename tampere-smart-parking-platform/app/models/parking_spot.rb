class ParkingSpot < ApplicationRecord
  STATUS = %w(free occupied reserved blocked)
  extend Enumerize
  enumerize :status, in: STATUS

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

  def block
    return if blocked
    update blocked: true
  end

  def unblock
    update blocked: false
  end

  STATUS.each do |status|
    define_method(:"#{status}?") do
      self.status == status
    end
  end

  # after_validation :reverse_geocode
  def point_in_polygon?(point, polygon)
    polygon_points = polygon.map do |coord|
      Geokit::LatLng.new(*coord)
    end
    polygon = Geokit::Polygon.new polygon_points
    point = Geokit::LatLng.new(*point)
    polygon.contains? point
  end

  def in_polygon?(polygon)
    self.polygon.each do |point|
      return true if point_in_polygon?(point, polygon)
    end
    return false
  end

  scope :recently_confirmed_free, -> {
    where(status: 'free', blocked: false).
    where.
    not(last_confirmed_free_at: nil).
    order('last_confirmed_free_at DESC') }
end
