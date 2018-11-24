module Admin
  class DashboardController < ApplicationController
    def index
      @parking_spots = ParkingSpot.all
    end
  end
end
