module Admin
  class DashboardController < ApplicationController
    def index
      spots = ParkingSpot.all.pluck(:polygon)
      better_spots = spots.map do |spot|
        {
          "type": "Feature",
          "geometry": {
            "type": "Polygon",
            "coordinates": [spot.reverse.map(&:reverse)]
          },
          "properties": {
            "status": "occupied"
          },
        }
      end

      feature_collection = {
        "type": "FeatureCollection",
        "features": better_spots,
      }
      @parking_spots = feature_collection
    end
  end
end
