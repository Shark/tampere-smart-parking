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
