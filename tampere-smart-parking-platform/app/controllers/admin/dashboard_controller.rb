module Admin
  class DashboardController < ApplicationController
    def index
    end

    def map_data
      if cache = Cache.find_by(key: 'map_data', invalidated: false)
        return render json: { map_data: cache.content }
      end

      last_confirmed_free_id = ParkingSpot.recently_confirmed_free.first&.id
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
            "blocked": spot.blocked,
            "address": spot.address,
            "lastConfirmedFreeAt": spot.last_confirmed_free_at,
            "isMostRecentlyConfirmedFree": spot.id == last_confirmed_free_id
          }
        }
      end

      feature_collection = {
        "type": "FeatureCollection",
        "features": features,
      }

      Cache.where(key: 'map_data').update_all(content: feature_collection, invalidated: false)

      render json: { map_data: feature_collection }
    end
  end
end
