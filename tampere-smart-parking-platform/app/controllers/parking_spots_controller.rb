class ParkingSpotsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @parking_spot = ParkingSpot.recently_confirmed_free.first

    render json: {
      friendly_name: @parking_spot.friendly_name,
      latitude: @parking_spot.latitude,
      longitude: @parking_spot.longitude
    }
  end

  def toggle_spots
    ParkingSpot.find_each do |parking_spot|
      parking_spot.update(status: (params[:mode] == 'enable' ? 'free' : 'blocked')) if parking_spot.in_polygon?(JSON.parse(polygon_params))
    end
  end

  def create
    parking_spot = ParkingSpot.find_by!(friendly_name: friendly_name)
    parking_spot.assign_attributes(parking_spot_params) unless parking_spot.status == 'blocked'

    if parking_spot.status == 'free' && parking_spot.status_was != 'free'
      parking_spot.last_confirmed_free_at = Time.now
    end

    if parking_spot.valid?
      ParkingSpot.transaction do
        Cache.where(key: 'map_data').delete_all
        parking_spot.save!
      end
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private

  def friendly_name
    params.require(:parking_spot).require(:friendly_name)
  end

  def polygon_params
    params.require(:parking_spot).require(:polygon)
  end

  def parking_spot_params
    params.require(:parking_spot).permit(:status)
  end
end
