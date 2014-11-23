// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require underscore
//= require_tree .

var map;

function map_json(jsonString) {
  var json = $.parseJSON(jsonString);

  var mapOptions = {
    mapTypeId: google.maps.MapTypeId.TERRAIN
  };

  map = new google.maps.Map($('#map')[0], mapOptions);

  var pathCoordinates = [],
      bounds = new google.maps.LatLngBounds(),
      infowindow = new google.maps.InfoWindow();

  // Legend
  // https://developers.google.com/maps/tutorials/customizing/adding-a-legend
  var legend = $('#legend')

  $.each(json, function(feed_id, feed) {
    var color = feed.color,
        messages = feed.messages;

    // Legend
    var div = $('<div></div>'),
        chst = 'd_map_spin&chld=0.3|0|' + color + '|10|_|',
        markImg = new google.maps.MarkerImage(
                        'http://chart.apis.google.com/' +
                        'chart?chst=' + chst),
        html = '<div><img src="' + markImg.url + '"> ' + feed.display_name + '</div>'
    legend.append(html);

    // Create path
    $.each(messages, function(idx, obj) {
      if (idx > 0) {
        p1 = new google.maps.LatLng(messages[idx-1].lat,
                                    messages[idx-1].lng);
        p2 = new google.maps.LatLng(obj.lat, obj.lng);

        var path = new google.maps.Polyline({
          path: [p1, p2],
          geodesic: true,
          strokeColor: '#' + color,
          strokeOpacity: 1.0,
          strokeWeight: 4,
          map: map
        });

        createInfoWindow(path, obj.line_info);
      }
    });

    // Create markers
    var markers = [];
    $.each(messages, function(idx, obj) {
      // doc:
      // https://developers.google.com/chart/image/docs/gallery/dynamic_icons#scalable_pins
      // chld=<scale_factor>|
      //      <rotation_deg>|
      //      <fill_color>|
      //      <font_size>|
      //      <font_style>|
      //      <text_line_1>|...|<text_line_n>
      var chst = 'd_map_spin&chld=0.5|0|' + color + '|10|_|' + idx;
      var markImg=new google.maps.MarkerImage(
        'http://chart.apis.google.com/' +
        'chart?chst=' + chst);

      var marker = new google.maps.Marker({
        map: map,
        position: new google.maps.LatLng(obj.lat, obj.lng),
        icon: markImg,
        animation: google.maps.Animation.DROP
      });

      markers.push(marker);

      bounds.extend(marker.position);

      google.maps.event.addListener(marker, 'click', (function(marker, idx) {
        return function() {
          infowindow.setContent(obj.title);
          infowindow.open(map, marker);
        }
      })(marker, idx));
    });

    //group markers; page loads a lot faster when you have many markers
    var mc = new MarkerClusterer(map, markers);
  });

  // Legend
  map.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(legend[0]);

  function createInfoWindow(poly, content) {
    google.maps.event.addListener(poly, 'click', function(event) {
      infowindow.close();
      infowindow = new google.maps.InfoWindow({
        position: event.latLng,
        content: content
      });
      infowindow.open(map);
    });
  }

  // Zoom to markers
  map.fitBounds(bounds);
}
