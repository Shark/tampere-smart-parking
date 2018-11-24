from imageai.Detection import ObjectDetection
import os
import cv2
import time
import numpy as np
import requests

class Box:
  def __init__(self, friendly_name='Alpha', x1=0,y1=0, x2=0, y2=0, occupied=False):
    self.friendly_name = friendly_name
    self.x1 = x1
    self.y1 = y1
    self.x2 = x2
    self.y2 = y2
    self.occupied = occupied

boxes = [
  Box(friendly_name='juliett-echo-bravo', x1=75,  y1=150, x2=345,  y2=275, occupied=False),
  Box(friendly_name='echo-quebec-whiskey',     x1=350, y1=140, x2=620,  y2=260, occupied=False),
  Box(friendly_name='papa-delta-uniform',   x1=625, y1=115, x2=905,  y2=240, occupied=False),
  Box(friendly_name='whiskey-juliett-yankee',     x1=905, y1=100, x2=1175, y2=220, occupied=False),
  Box(friendly_name='india-delta-echo',  x1=20,  y1=660, x2=315,  y2=825, occupied=False),
  Box(friendly_name='victor-quebec-mike',      x1=335, y1=645, x2=640,  y2=810, occupied=False),
  Box(friendly_name='juliett-hotel-whiskey', x1=645, y1=635, x2=965,  y2=800, occupied=False),
  Box(friendly_name='bravo-whiskey-zulu',   x1=965, y1=625, x2=1265, y2=800, occupied=False)
]

def box_contains(outer_box, object_coordinates):
  object_box = Box(x1=object_coordinates[0], y1=object_coordinates[1], x2=object_coordinates[2], y2=object_coordinates[3], occupied=False)

  return (
    (outer_box.x1 <= object_box.x2 <= outer_box.x2 and outer_box.y1 <= object_box.y2 <= outer_box.y2) or
    (outer_box.x1 <= object_box.x1 <= outer_box.x2 and outer_box.y1 <= object_box.y2 <= outer_box.y2) or
    (outer_box.x1 <= object_box.x2 <= outer_box.x2 and outer_box.y1 <= object_box.y1 <= outer_box.y2) or
    (outer_box.x1 <= object_box.x1 <= outer_box.x2 and outer_box.y1 <= object_box.y1 <= outer_box.y2)
  )

def detect_cars():
  detector = ObjectDetection()
  detector.setModelTypeAsRetinaNet()
  detector.setModelPath( os.path.join(execution_path , "models/resnet50_coco_best_v2.0.1.h5"))
  detector.loadModel()
  custom = detector.CustomObjects(car=True, motorcycle=True, bus=True, truck=True)
  return detector.detectCustomObjectsFromImage(custom_objects=custom, input_image=os.path.join(execution_path , 'test.jpg'), output_image_path=os.path.join(execution_path , 'test-detected.jpg'), minimum_percentage_probability=40)

def print_detected_cars(cars):
  for eachObject in cars:
    print(eachObject["name"] , " : ", eachObject["percentage_probability"], " : ", eachObject["box_points"] )
    print("--------------------------------")

def set_occupation(cars, parking_spots):
  for spot in parking_spots:
    spot.occupied = False

  for eachObject in cars:
    for spot in parking_spots:
      if (box_contains(spot, eachObject["box_points"])):
        spot.occupied = True

def update_status_backend(parking_spots, last_boxes):
  for index, spot in enumerate(parking_spots):
    #if spot.occupied == last_boxes[index].occupied:
      #break
    status = 'occupied' if spot.occupied else 'free'
    result = requests.post(f'https://tampere.sh4rk.pw/parking_spots?parking_spot%5Bfriendly_name%5D={spot.friendly_name}&parking_spot%5Bstatus%5D={status}')
    print(f'Send Update {spot.friendly_name}({index + 1}) to {status}')

def take_photo():
  ret, frame = camera.read()
  cv2.imwrite("test.jpg", frame)

def print_occupation(parking_spots):
  for spot in parking_spots:
    print(f'Box: {spot.friendly_name}:{spot.occupied}')

execution_path = os.getcwd()
camera = cv2.VideoCapture(1)
last_boxes = boxes.copy()
try:
  while True:
    take_photo()
    detected_cars = detect_cars()
    print_detected_cars(detected_cars)
    set_occupation(detected_cars, boxes)
    print_occupation(boxes)
    update_status_backend(boxes, last_boxes)
    last_boxes = boxes.copy()
except KeyboardInterrupt:
    print('interrupted!')


# Calibration Mode
# cap = cv2.VideoCapture(1)

# while(True):
#   # Capture frame-by-frame
#   ret, frame = cap.read()

#   # Our operations on the frame come here
#   # gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
#   for box in boxes:
#     spots = cv2.rectangle(frame, (box.x1, box.y1), (box.x2, box.y2), (0,255,0), 3)

#   # Display the resulting frame
#   cv2.imshow('frame',spots)
#   if cv2.waitKey(1) & 0xFF == ord('q'):
#       break

# # When everything done, release the capture
# cap.release()
# cv2.destroyAllWindows()