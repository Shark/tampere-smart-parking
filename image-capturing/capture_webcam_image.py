from shapedetector import ShapeDetector
import argparse
import imutils
import cv2

def color_for_shape(shabe):
  if shabe == "triangle":
    return (0, 255, 0)
  return (0, 0, 255)

cam = cv2.VideoCapture(0)

cv2.namedWindow("CaptureImage")
# cv2.namedWindow("DetectedImage")

img_counter = 0

while True:
  ret, frame = cam.read()
  cv2.imshow("CaptureImage", frame)
  if not ret:
    break

  k = cv2.waitKey(1)

  if k%256 == 27:
    # ESC pressed
    print("Closing...")
    break
  elif k%256 == 32:
    # SPACE pressed
    image = frame
    resized = imutils.resize(image, width=300)
    ratio = image.shape[0] / float(resized.shape[0])

    # convert the resized image to grayscale, blur it slightly,
    # and threshold it
    gray = cv2.cvtColor(resized, cv2.COLOR_BGR2GRAY)
    blurred = cv2.GaussianBlur(gray, (5, 5), 0)
    thresh = cv2.threshold(blurred, 60, 255, cv2.THRESH_BINARY)[1]
    # find contours in the thresholded image and initialize the
    # shape detector
    contours = cv2.findContours(thresh.copy(), cv2.RETR_LIST, cv2.CHAIN_APPROX_SIMPLE)
    contours = contours[0] if imutils.is_cv2() else contours[1]
    shape_detector = ShapeDetector()

    for contour in contours:
      shape = shape_detector.detect(contour)
      if shape in ["triangle", "rectangle", "square"]:
        color = color_for_shape(shape)
        contour = contour.astype("float")
        contour *= ratio
        contour = contour.astype("int")
        cv2.drawContours(image, [contour], -1, color, 2)
        cv2.imshow("CaptureImage", image)
    
    cv2.waitKey(0)

cam.release()

cv2.destroyAllWindows()