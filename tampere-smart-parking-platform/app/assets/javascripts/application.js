// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery
//= require leaflet
//= require activestorage
//= require turbolinks
//= require_tree .

$(document).on('turbolinks:load',  function (){

var parkingSpots = {
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {
        "status": "reserved"
      },
      "geometry": {
        "type": "Polygon",
        "coordinates": [
          [
            [
              23.75493586063385,
              61.49794082556758
            ],
            [
              23.75506728887558,
              61.49794082556758
            ],
            [
              23.75506728887558,
              61.497962584272116
            ],
            [
              23.75493586063385,
              61.497962584272116
            ],
            [
              23.75493586063385,
              61.49794082556758
            ]
          ]
        ]
      }
    },
    {
      "type": "Feature",
      "properties": {
        "status": "free"
      },
      "geometry": {
        "type": "Polygon",
        "coordinates": [
          [
            [
              23.755080699920654,
              61.49795490473106
            ],
            [
              23.75523090362549,
              61.49795490473106
            ],
            [
              23.75523090362549,
              61.49797026381124
            ],
            [
              23.755080699920654,
              61.49797026381124
            ],
            [
              23.755080699920654,
              61.49795490473106
            ]
          ]
        ]
      }
    },
    {
      "type": "Feature",
      "properties": {
        "status": "occupied"
      },
      "geometry": {
        "type": "Polygon",
        "coordinates": [
          [
            [
              23.755255043506622,
              61.49796642404192
            ],
            [
              23.755402565002438,
              61.49796642404192
            ],
            [
              23.755402565002438,
              61.49798050319382
            ],
            [
              23.755255043506622,
              61.49798050319382
            ],
            [
              23.755255043506622,
              61.49796642404192
            ]
          ]
        ]
      }
    }
  ]
};

var reserved = "#ff7400";
var occupied = "#Df2800";
var free = "#567D46"
var colors = {
  free: free,
  occupied: occupied,
  reserved: reserved,
}

function style(feature) {
  return {
    color: colors[feature["properties"]["status"]]
  }
}


  var map = L.map('map').setView([61.497753, 23.760954], 14);
  var layerURL = 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png'; // OSM Maps at the moment.
  L.tileLayer.wms(layerURL).addTo(map);

  L.geoJSON(parkingSpots, {
    style: style
  }).addTo(map);
});
