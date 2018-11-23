class ParkingspotController < ApplicationController
  def index
    @latest_parkingspot = Parkingspot.last
    render :json => @parkingspot
  end
end
