var map;
function initMap() {
  $.get('/disruptions', function(disruptions) {
    map = new google.maps.Map(document.getElementById('map'), {
      center: { lat: 51.5060624, lng: -0.1332773 },
      zoom: 10
    });
    var markers = [];

    disruptions.map(function(disruption) {
      disruption.display_points.map(function(latlng) {
        markers.push(new google.maps.Marker({position: latlng}));
      });
    });

    var markerCluster = new MarkerClusterer(map, markers,
    { imagePath: 'https://raw.githubusercontent.com/googlemaps/v3-utility-library/master/markerclustererplus/images/m' });
  });
}
