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
//= require leaflet.draw
//= require activestorage
//= require turbolinks
//= require_tree .


function disableParkingSpots (polygon) {
  $.ajax(url: "",
    data: "", 
    method: "patch",

  )
}

$.ajax(id, {
  contentType: 'application/json',
  dataType: 'json',
  success:function(result){
    geojson.remove(e.target);
    cityData = result.feature_collection;
    datasetValues = result.city_values;
    geojson = L.geoJson(cityData, {
      style: style,
      onEachFeature: onEachCityFeature
    }).addTo(mapid);
    mapid.fitBounds(e.target.getBounds());
  }

$(document).on('turbolinks:load',  function () {

  var parkingSpots = $('.parkingSpots').data('parkingspots');

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
  L.tileLayer(layerURL).addTo(map);

  L.geoJSON(parkingSpots, {
    style: style
  }).addTo(map);

  var editableLayers = new L.FeatureGroup();
  map.addLayer(editableLayers);

  var drawPluginOptions = {
    position: 'topright',
    draw: {
      polygon: {
        allowIntersection: false, // Restricts shapes to simple polygons
        drawError: {
          color: '#e1e100', // Color the shape will turn when intersects
          message: '<strong>Oh snap!<strong> you can\'t draw that!' // Message that will show when intersect
        },
        shapeOptions: {
          color: '#97009c'
        }
      },
      // disable toolbar item by setting it to false
      polyline: false,
      circle: false, // Turns off this drawing tool
      rectangle: false,
      marker: false,
      circlemarker: false
      },
    edit: false
  };

  // Initialise the draw control and pass it the FeatureGroup of editable layers
  var drawControl = new L.Control.Draw(drawPluginOptions);
  map.addControl(drawControl);

  var editableLayers = new L.FeatureGroup();
  map.addLayer(editableLayers);

  map.on('draw:created', function(e) {
    var type = e.layerType,
    layer = e.layer;
    polygon = layer._latlngs

    window.test = polygon

    editableLayers.addLayer(layer);
  });

});
