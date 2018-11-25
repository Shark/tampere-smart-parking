# Tampere Smart Parking Platform

## Description and Purpose

When visiting a city, you do not always think about where to park your car before arriving to your location. Very often, you just arrive at the location and then, the “fun” part begins. You have to drive around the blocks trying to find a spot to leave your car - which can be very exhausting and time-consuming.

Wouldn't it be awesome to open an app and get directions to the nearest parking lot free of any charge? But would it really as you are driving your car? Your hands should be at the steering wheel!

Here comes our solution: You only need to say, “Hey Google, ask Awesome Parking for a parking spot”. Your smartphone will quickly pick up what you just said and open Google Maps to navigate you immediately. It's that simple.

We are using visual recognition technologies backed by machine learning to empower smart devices on the street to detect free parking spots. These smart devises can be easily mounted on lamp posts all around the city and give birds eye over the city, without using drones. The city of Tampere already has smart sensors with internet connectivity on 400 lamp posts.

The location of the detected parking spots are pushed to the Awesome Parking Platform from where the city representatives are able to govern the traffic flow by defining areas where visitors and citizens should preferably park. This could be used during big events, for instance, when the city is expecting lots of visitors.

From the user's point view, it's just an invocation of the Google Assistant. The best spot depending his location will be shown to him directly on Google Maps. No new app required. 

**In short:**
We use visual recognition technologies backed by machine learning to empower smart devices on the street to detect free parking spots and publish this information to a platform accessible to the public on their mobile devices.

## API

### GET /parking_spots

Response:

```json
{
  "latitude": 1.234,
  "longitude": 5.678
}
```

### POST /parking_spots

Request:

```
{
  "parking_spot": {
    "friendly_name": "",
    "status": "free|occupied|reserved"
  }
}
```

See [`db/parking_spots.yml`](db/parking_spots.yml) for a list of friendly names.

Response:

200 OK

## Deploy

The platform is deployed at https://tampere.sh4rk.pw.

```
git remote add deploy ...
git subtree push --prefix tampere-smart-parking-platform deploy master
```
