from imageai.Detection import ObjectDetection
import os
import cv2
import time
import numpy as np
import requests
import collections
import imutils

Detection = collections.namedtuple('Detection', 'x1 y1 x2 y2')

class ParkingSpot:
  def __init__(self, friendly_name='Alpha', x1=0,y1=0, x2=0, y2=0, occupied=False):
    self.friendly_name = friendly_name
    self.x1 = x1
    self.y1 = y1
    self.x2 = x2
    self.y2 = y2
    self.occupied = occupied

  def to_payload(self):
    status = 'occupied' if self.occupied else 'free'
    return f'parking_spots%5B{self.friendly_name}%5D={status}'

def set_parking_spots():
  return [
    ParkingSpot(friendly_name='juliett-echo-bravo',     x1=75,  y1=150, x2=345,  y2=275, occupied=False),
    ParkingSpot(friendly_name='echo-quebec-whiskey',    x1=350, y1=140, x2=620,  y2=260, occupied=False),
    ParkingSpot(friendly_name='papa-delta-uniform',     x1=625, y1=115, x2=905,  y2=240, occupied=False),
    ParkingSpot(friendly_name='whiskey-juliett-yankee', x1=905, y1=100, x2=1175, y2=220, occupied=False),
    ParkingSpot(friendly_name='india-delta-echo',       x1=20,  y1=660, x2=315,  y2=825, occupied=False),
    ParkingSpot(friendly_name='victor-quebec-mike',     x1=335, y1=645, x2=640,  y2=810, occupied=False),
    ParkingSpot(friendly_name='juliett-hotel-whiskey',  x1=645, y1=635, x2=965,  y2=800, occupied=False),
    ParkingSpot(friendly_name='bravo-whiskey-zulu',     x1=965, y1=625, x2=1265, y2=800, occupied=False)
  ]

def intersect(spot, detection_coordinates):
  detection = Detection(x1=detection_coordinates[0], y1=detection_coordinates[1], x2=detection_coordinates[2], y2=detection_coordinates[3])

  return (
    (spot.x1 <= detection.x2 <= spot.x2 and spot.y1 <= detection.y2 <= spot.y2) or
    (spot.x1 <= detection.x1 <= spot.x2 and spot.y1 <= detection.y2 <= spot.y2) or
    (spot.x1 <= detection.x2 <= spot.x2 and spot.y1 <= detection.y1 <= spot.y2) or
    (spot.x1 <= detection.x1 <= spot.x2 and spot.y1 <= detection.y1 <= spot.y2)
  )

def detect_cars():
  detector = ObjectDetection()
  detector.setModelTypeAsTinyYOLOv3()
  detector.setModelPath( os.path.join(execution_path , "models/yolo-tiny.h5"))
  detector.loadModel()
  custom = detector.CustomObjects(car=True)
  return detector.detectCustomObjectsFromImage(
    custom_objects=custom, input_image=os.path.join(execution_path , 'test.jpg'),
    output_image_path=os.path.join(execution_path , 'test-detected.jpg'),
    minimum_percentage_probability=15,
    display_percentage_probability=False
  )

def set_occupation(cars, parking_spots):
  for car in cars:
    for spot in parking_spots:
      if (intersect(spot, car["box_points"])):
        spot.occupied = True

def update_status_backend(parking_spots):
  payload = []
  for spot in parking_spots:
    payload.append(spot.to_payload())

  payload = '&'.join(payload)
  result = requests.post(f'https://tampere.sh4rk.pw/parking_spots/bulk_update?{payload}')
  print('Send Bulk Update!')

def take_photo():
  ret, frame = camera.read()
  cv2.imwrite("test.jpg", frame)
  print('took photo')
  print('--')

def print_occupation(parking_spots):
  for spot in parking_spots:
    print(f'Box: {spot.friendly_name}:{spot.occupied}')
  print('--')

def detection_preview(parking_spots):
  cv2.destroyAllWindows()
  img = cv2.imread('test-detected.jpg')
  resized = imutils.resize(img, width=640)
  ratio = resized.shape[0] / float(img.shape[0])
  for spot in parking_spots:
    cv2.rectangle(resized, (int(spot.x1 * ratio), int(spot.y1 * ratio)), (int(spot.x2 * ratio), int(spot.y2 * ratio)), (0,255,0), 3) if not spot.occupied else 0
  cv2.imshow('detection preview', resized)
  cv2.waitKey(500)

execution_path = os.getcwd()
camera = cv2.VideoCapture(1)
try:
  while True:
    take_photo()
    detected_cars = detect_cars()
    print(f'detected {len(detected_cars)} cars')
    parking_spots = set_parking_spots()
    set_occupation(detected_cars, parking_spots)
    print_occupation(parking_spots)
    update_status_backend(parking_spots)
    print('===========')
    detection_preview(parking_spots)
except KeyboardInterrupt:
  print('interrupted')


# # Calibration Mode
# cap = cv2.VideoCapture(1)
# parking_spots = set_parking_spots()

# while(True):
#   # Capture frame-by-frame
#   ret, frame = cap.read()

#   for spot in parking_spots:
#     cv2.rectangle(frame, (spot.x1, spot.y1), (spot.x2, spot.y2), (0,255,0), 3)

#   cv2.imshow('frame',frame)
#   if cv2.waitKey(1) & 0xFF == ord('q'):
#       break

# cap.release()
# cv2.destroyAllWindows()