# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
file = File.read('/Users/johanneskimmeyer/Coding/tampere-smart-parking/tampere-smart-parking-platform/db/parking_spots.json')
data_hash = JSON.parse(file)
data_hash["features"].each do |f|
  ParkingSpot.create(feature: f)
end
