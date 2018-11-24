class ParkingSpotsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @parking_spot = ParkingSpot.order(:created_at).last
    render json: {latitude: @parking_spot.latitude, longitude: @parking_spot.longitude}
  end

  def create
    parking_spot = ParkingSpot.create(parking_spot_params)

    if parking_spot.valid?
      parking_spot.save!
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private

  def parking_spot_params
    params.require(:parking_spot).permit(:latitude, :longitude)
  end
end
