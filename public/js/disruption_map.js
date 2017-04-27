var map;
function initMap() {
  $.get('/disruptions', function(disruptions) {
    map = new google.maps.Map(document.getElementById('map'), {
      center: { lat: 51.5060624, lng: -0.1332773 },
      zoom: 10
    });
    var markers = [];

    disruptions.map(function(disruption) {
      var infoWindow = new google.maps.InfoWindow({ content: disruption.commentary })
      disruption.display_points.map(function(latlng) {
        var marker = new google.maps.Marker({ position: latlng })
        marker.addListener('click', function() {
          infoWindow.open(map, marker);
        })
        markers.push(marker);
      });
    });

    var markerCluster = new MarkerClusterer(map, markers,
    { gridSize: 30, imagePath: 'https://raw.githubusercontent.com/googlemaps/v3-utility-library/master/markerclustererplus/images/m' });
    console.log('gridding')
  });
}
