class ParkingspotController < ApplicationController
  def index
    @parkingspot = Parkingspot.order(:created_at).last
    render json: {latitude: @parkingspot.latitude, longitude: @parkingspot.longitude}
  end

  def create
    parkingspot = Parkingspot.create(parkingspot_params)

    if parkingspot.valid?
      parkingspot.save!
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private

  def parkingspot_params
    params.require(:parkingspot).permit(:latitude, :longitude)
  end
end
