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


function toggleParkingSpots (polygon, mode) {
  $.ajax({
    url: "/parking_spots/toggle_blocked",
    type: "PATCH",
    data: {
      parking_spot: {
        polygon: JSON.stringify(polygon)
      },
      mode: mode
    }
  })
};

var currentDataLayer;

var colors = {
  unblocked: {
    free: "#567D46",
    occupied: "#Df2800",
    reserved: "#ff7400",
  },
  blocked: {
    free: "#cccccc",
    occupied: "#000000",
    reserved: "#cccccc",
  },
  mostRecentlyConfirmedFree: "#76D6FF",
};

var refreshDataLayer = function(map) {
  var style = function(feature) {
    if(feature['properties']['isMostRecentlyConfirmedFree']) {
      return { color: colors['mostRecentlyConfirmedFree'] }
    } else {
      blocked_status = feature["properties"]["blocked"] ? 'blocked' : 'unblocked'
      return {
        color: colors[blocked_status][feature["properties"]["status"]]
      }
    }
  };

  var onEachFeature = function(feature, layer) {
    // does this feature have a property named popupContent?
    if (feature.properties && feature.properties) {
      layer.bindPopup(`
        <strong>Friendly Name:</strong> ${feature.properties.friendlyName}<br/>
        <strong>Status:</strong> ${feature.properties.status}<br/>
        <strong>Blocked?</strong> ${feature.properties.blocked ? 'Yes' : 'No' }<br/>
        <strong>Last Confirmed Free At:</strong> ${feature.properties.lastConfirmedFreeAt}<br/>
        <strong>Address:</strong> ${feature.properties.address}
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

  var editableLayers = new L.FeatureGroup();
  map.addLayer(editableLayers);

  var legend = L.control({position: 'bottomleft'});
  legend.onAdd = function (map) {

  var div = L.DomUtil.create('div', 'info legend');
  labels = ['<strong>Unblocked</strong>'],
  categories = ['free','reserved','occupied'];

  for (var i = 0; i < categories.length; i++) {
    div.innerHTML += 
    labels.push(
        '<span class="circle" style="color:' + colors['unblocked'][categories[i]] + '"></i> ' +
    (categories[i] ? categories[i] : '+'));

  }
  
  div.innerHTML += 
  labels.push('<br/><strong style="color: #000000 !important;">Blocked</strong>');
  for (var i = 0; i < categories.length; i++) {
    labels.push('<span class="circle" style="color:' + colors['blocked'][categories[i]] + '"></i> ' +
    (categories[i] ? categories[i] : '+'));
  }

  labels.push('<br/><span class="circle" style="color:' + colors['mostRecentlyConfirmedFree'] + '"><strong>Most Recently Free</strong></i> ')

  div.innerHTML = labels.join('<br>');
  return div;
  };
  legend.addTo(map);

  var drawPluginOptions = {
    position: 'topright',
    draw: {
      polygon: {
        allowIntersection: false,
        drawError: {
          color: '#e1e100',
          message: '<strong>Oh snap!<strong> you can\'t draw that!'
        },
        shapeOptions: {
          color: '#97009c'
        }
      },
      polyline: false,
      circle: false,
      rectangle: false,
      marker: false,
      circlemarker: false
      },
    edit: false
  };

  // Initialise the draw control and pass it the FeatureGroup of editable layers
  var drawControlEnable = new L.Control.Draw(drawPluginOptions);
  map.addControl(drawControlEnable);
  $(drawControlEnable.getContainer()).addClass("enable-spots");

  var drawControlDisable = new L.Control.Draw(drawPluginOptions);
  map.addControl(drawControlDisable);
  $(drawControlDisable.getContainer()).addClass("disable-spots");

  $(window).on('load', function() {
    $('.disable-spots').find('.leaflet-draw-draw-polygon').click(function() {
      $('#map').data('mode', 'disable');
    });

    $('.enable-spots').find('.leaflet-draw-draw-polygon').click(function() {
      $('#map').data('mode', 'enable');
    });
  });

  var editableLayers = new L.FeatureGroup();
  map.addLayer(editableLayers);

  map.on('draw:created', function(e) {
    var mode = $('#map').data('mode');
    var type = e.layerType,
    layer = e.layer;
    polygon = layer._latlngs;
    polygonAsArray = polygon[0].map( function(value, index) {
      return new Array(value.lat, value.lng);
    });
    toggleParkingSpots(polygonAsArray, mode);
  });

});
