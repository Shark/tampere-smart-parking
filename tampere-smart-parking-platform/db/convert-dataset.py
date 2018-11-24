from pyproj import Proj, transform
import json
from pprint import pprint
import json

def to_wgs84(coords):
  inProj = Proj(init='epsg:3878')
  outProj = Proj(init='epsg:4326')
  x2,y2 = transform(inProj,outProj,coords[0],coords[1])
  return [y2, x2]

with open('dataset.json') as f:
  dataset = json.load(f)

parking_spots = []
for parking_spot in dataset['features']:
  if isinstance(parking_spot['geometry']['coordinates'][0], list):
    converted_coords = map(to_wgs84, parking_spot['geometry']['coordinates'][0])
  else:
    converted_coords = [to_wgs84(parking_spot['geometry']['coordinates'])]

  parking_spots.append(converted_coords)

import json
with open('dataset-converted.json', 'w') as outfile:
    json.dump(parking_spots, outfile)