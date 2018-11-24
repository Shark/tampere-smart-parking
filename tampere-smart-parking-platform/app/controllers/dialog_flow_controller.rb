class DialogFlowController < ApplicationController
  skip_before_action :verify_authenticity_token
  include ActionView::Helpers::DateHelper

  def webhook
    parking_spot = ParkingSpot.order(:created_at).last
    escaped_destination = CGI.escape("#{parking_spot.latitude},#{parking_spot.longitude}")
    render json: {
      payload: {
        google: {
          expectUserResponse: true,
          richResponse: {
            items: [
              {
                simpleResponse: {
                  textToSpeech: "We found a parking spot!"
                }
              },
              {
                basicCard: {
                  title: "Parking Spot at #{parking_spot.address}" || 'Available Parking Spot',
                  subtitle: "This empty spot was found #{time_ago_in_words(parking_spot.created_at)} ago.",
                  buttons: [{
                    title: 'Navigate',
                    openUrlAction: {
                      url: "https://www.google.com/maps/dir/?api=1&destination=#{escaped_destination}&travelmode=driving&dir_action=navigate"
                    }
                  }]
                }
              }
            ]
          }
        }
      }
    }
  end
end