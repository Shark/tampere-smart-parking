module Admin
  class DashboardController < ApplicationController
    def index
      feature_collection = {
        "type": "FeatureCollection",
        "totalFeatures": 1013,
        "features": [],
        "crs":{"type":"name","properties":{"name":"urn:ogc:def:crs:EPSG::3878"}}
      }
      spots = ParkingSpot.all.pluck(:feature)
      feature_collection[:features] = spots
      @parking_spots = feature_collection
    end
  end
end
