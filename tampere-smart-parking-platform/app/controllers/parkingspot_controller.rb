class ParkingspotController < ApplicationController
  def index
    @latest_parkingspot = Parkingspot.order(:created_at).last
    puts @latest_parkingspot
    render json: @latest_parkingspot
  end
end
