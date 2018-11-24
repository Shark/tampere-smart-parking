namespace :parking_spots do
  # rails geocode:all CLASS=ParkingSpot SLEEP=1.25 REVERSE=true

  task dump: :environment do
    parking_spots = ParkingSpot.all.map do |parking_spot|
      parking_spot.attributes.slice('friendly_name', 'latitude', 'longitude', 'address', 'polygon')
    end

    File.open(Rails.root.join('db', 'parking_spots.yml'), 'w') do |file|
      file.write(parking_spots.to_yaml)
    end
  end

  task load: :environment do
    ParkingSpot.delete_all

    parking_spots = YAML.load_file(Rails.root.join('db', 'parking_spots.yml'))
    parking_spots.each do |parking_spot_attributes|
      ParkingSpot.create(parking_spot_attributes)
    end
  end

  task load_polygons: :environment do
    ParkingSpot.delete_all

    file = File.read(Rails.root.join('db', 'tampere-dataset.json'))
    polygons = JSON.parse(file)
    polygons.each do |polygon|
      ParkingSpot.create(polygon: polygon, latitude: polygon[0][0], longitude: polygon[0][1])
    end
  end
end
