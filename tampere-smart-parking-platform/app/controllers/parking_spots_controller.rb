class ParkingSpotsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @parking_spot = ParkingSpot.
                    where.
                    not(last_confirmed_free_at: nil).
                    order('last_confirmed_free_at DESC').
                    first
    render json: {
      friendly_name: @parking_spot.friendly_name,
      latitude: @parking_spot.latitude,
      longitude: @parking_spot.longitude
    }
  end

  def create
    parking_spot = ParkingSpot.find_by!(friendly_name: friendly_name)
    parking_spot.touch(:last_confirmed_free_at)
    head :ok
  end

  private

  def friendly_name
    params.require(:parking_spot).require(:friendly_name)
  end
end
