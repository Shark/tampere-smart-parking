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
  Box(friendly_name='india-x-ray-whiskey', x1=75,  y1=150, x2=345,  y2=275, occupied=False),
  Box(friendly_name='india-papa-lima',     x1=350, y1=140, x2=620,  y2=260, occupied=False),
  Box(friendly_name='india-papa-sierra',   x1=625, y1=115, x2=905,  y2=240, occupied=False),
  Box(friendly_name='kilo-hotel-lima',     x1=905, y1=100, x2=1175, y2=220, occupied=False),
  Box(friendly_name='charlie-papa-alpha',  x1=20,  y1=660, x2=315,  y2=825, occupied=False),
  Box(friendly_name='mike-mike-zulu',      x1=335, y1=645, x2=640,  y2=810, occupied=False),
  Box(friendly_name='quebec-foxtrot-mike', x1=645, y1=635, x2=965,  y2=800, occupied=False),
  Box(friendly_name='quebec-bravo-lima',   x1=965, y1=625, x2=1265, y2=800, occupied=False)
]

def box_contains(outer_box, object_coordinates):
  object_box = Box(x1=object_coordinates[0], y1=object_coordinates[1], x2=object_coordinates[2], y2=object_coordinates[3], occupied=False)

  return object_box.x1 >= outer_box.x1 and object_box.y1 >= outer_box.y1 and object_box.x2 <= outer_box.x2 and object_box.y2 <= outer_box.y2

execution_path = os.getcwd()

camera = cv2.VideoCapture(1)
ret, frame = camera.read()
# cv2.imshow("CaptureImage", frame)
cv2.imwrite("test.jpg", frame)
# cv2.waitKey(0)

execution_path = os.getcwd()
detector = ObjectDetection()
detector.setModelTypeAsRetinaNet()
detector.setModelPath( os.path.join(execution_path , "models/resnet50_coco_best_v2.0.1.h5"))
detector.loadModel()
custom = detector.CustomObjects(car=True, motorcycle=True, bus=True, truck=True)
detections = detector.detectCustomObjectsFromImage(custom_objects=custom, input_image=os.path.join(execution_path , 'test.jpg'), output_image_path=os.path.join(execution_path , 'test-detected.jpg'), minimum_percentage_probability=40)

print(len(detections))
for eachObject in detections:
  print(eachObject["name"] , " : ", eachObject["percentage_probability"], " : ", eachObject["box_points"] )
  print("--------------------------------")

  for box in boxes:
    if (box_contains(box, eachObject["box_points"])):
      box.occupied = True

new_image = cv2.imread("test-detected.jpg")

for box in boxes:
  print(box.occupied)

  if not box.occupied:
    new_image = cv2.rectangle(new_image, (box.x1, box.y1), (box.x2, box.y2), (0,255,0), 3)
  
  status = 'occupied' if box.occupied else 'free'
  result = requests.post(f'https://tampere.sh4rk.pw/parking_spots?parking_spot%5Bfriendly_name%5D={box.friendly_name}&parking_spot%5Bstatuts%5D={status}')
  print(result.status_code)

cv2.imshow("FinalImage", new_image)
cv2.waitKey(0)


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