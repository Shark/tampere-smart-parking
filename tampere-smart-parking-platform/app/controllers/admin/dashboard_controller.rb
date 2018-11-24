module Admin
  class DashboardController < ApplicationController
    def index
    end

    def map_data
      spots = ParkingSpot.all.pluck(:polygon)

      features = ParkingSpot.all.map do |spot|
        {
          "type": "Feature",
          "geometry": {
            "type": "Polygon",
            "coordinates": [spot.polygon.reverse.map(&:reverse)]
          },
          "properties": {
            "status": spot.status
          }
        }
      end

      feature_collection = {
        "type": "FeatureCollection",
        "features": features,
      }

      render json: { map_data: feature_collection }
    end
  end
end
