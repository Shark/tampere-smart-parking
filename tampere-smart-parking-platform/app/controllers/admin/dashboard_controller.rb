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
            "friendlyName": spot.friendly_name,
            "status": spot.status,
            "lastConfirmedFreeAt": spot.last_confirmed_free_at
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
