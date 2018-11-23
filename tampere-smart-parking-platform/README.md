# Tampere Smart Parking Platform

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
    "latitude": 1.234,
    "longitude": 5.678
  }
}
```

Response:

200 OK

## Deploy

```
git remote add deploy ...
git subtree push --prefix tampere-smart-parking-platform deploy master
```