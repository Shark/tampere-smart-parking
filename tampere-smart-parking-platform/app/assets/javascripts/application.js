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

});
