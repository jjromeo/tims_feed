var map;
function initMap() {
  STATUS_COLOURS = {
    'Active': 'red',
    'Active Long Term': 'purple',
    'Scheduled': 'green',
    'Recurring Works': 'brown',
    'Recently Cleared': 'green'
  };

  $.get('/disruptions', function(disruptions) {
    map = new google.maps.Map(document.getElementById('map'), {
      center: { lat: 51.5060624, lng: -0.1332773 },
      zoom: 10
    });
    var markers = [];

    disruptions.map(function(disruption) {
      disruption.display_points.map(function(latlng) {
        var infoWindow = createInfoWindow(disruption);
        var icon = 'images/markers/' + STATUS_COLOURS[disruption.status] + '_MarkerA.png'
        var marker = new google.maps.Marker({ position: latlng, icon: icon })
        marker.addListener('click', function() {
          infoWindow.open(map, marker);
        })
        markers.push(marker);
      });
    });

    var markerCluster = new MarkerClusterer(map, markers,
    { maxZoom: 15, gridSize: 50, imagePath: 'https://raw.githubusercontent.com/googlemaps/v3-utility-library/master/markerclustererplus/images/m' });
  });

  function createInfoWindow(disruption) {
    // Set up infoWindow on each pin
    var statusText = '<h3><b>' + disruption.status + '</b></h3>';
    var startTimeText = '<p><b>Started:</b> ' + disruption.start_time + '</p>';
    var endTimeText = disruption.end_time ? '<p><b>Enjing:</b> ' + disruption.end_time + '</p>' : "";
    var content = statusText + startTimeText + endTimeText + '<p>' + disruption.commentary + '</p>';
    return new google.maps.InfoWindow({ content: content });
  }
}
