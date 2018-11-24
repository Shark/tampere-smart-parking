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

var currentDataLayer;

var refreshDataLayer = function(map) {
  var colors = {
    free: "#567D46",
    occupied: "#Df2800",
    reserved: "#ff7400",
  };

  var style = function(feature) {
    return {
      color: colors[feature["properties"]["status"]]
    }
  };

  var onEachFeature = function(feature, layer) {
    // does this feature have a property named popupContent?
    if (feature.properties && feature.properties) {
      layer.bindPopup(`
        <strong>Friendly Name:</strong> ${feature.properties.friendlyName}<br/>
        <strong>Status:</strong> ${feature.properties.status}<br/>
        <strong>Last Confirmed Free At:</strong> ${feature.properties.lastConfirmedFreeAt}
      `);
    }
  }


  fetch('/admin/map_data')
    .then(data => data.json())
    .then(data => {
      var newDataLayer = L.geoJSON(
                           data['map_data'], {
                             style: style,
                             onEachFeature: onEachFeature
                           }).addTo(map);

      if(currentDataLayer) {
        map.removeLayer(currentDataLayer)
      }
      currentDataLayer = newDataLayer;
    })
};

$(document).on('turbolinks:load',  function () {
  var map = L.map('map').setView([61.497753, 23.760954], 14);
  var layerURL = 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png'; // OSM Maps at the moment.
  L.tileLayer(layerURL).addTo(map);


  setInterval(refreshDataLayer.bind(undefined, map), 2000);
  refreshDataLayer(map);
});
