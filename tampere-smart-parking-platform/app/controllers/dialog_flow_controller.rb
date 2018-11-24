class DialogFlowController < ApplicationController
  def webhook
    parking_spot = ParkingSpot.order(:created_at).last
    render json: {
      fulfillmentMessages: [
        {
          "uri": "https://maps.google.com"
        }
      ]
    }
  end
end