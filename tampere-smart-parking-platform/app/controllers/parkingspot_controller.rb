class ParkingspotController < ApplicationController
  def index
    @latest_parkingspot = Parkingspot.last
    render :json => @parkingspot
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
