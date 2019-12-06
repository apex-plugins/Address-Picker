/*
 * 0integration Address Picker
 * Plug-in Type: Item
 * Summary: Google map address picker and autocomplete for address item plugin used to easily select address.
 *
 * ^^^ Contact information ^^^
 * Developed by 0integration
 * http://www.zerointegration.com
 * apex@zerointegration.com
 *
 * ^^^ License ^^^
 * Licensed Under: GNU General Public License, version 3 (GPL-3.0) -
http://www.opensource.org/licenses/gpl-3.0.html
 *
 * @author Kartik Patel - kartik.patel@zerointegration.com
 */
 
var map;
var markers = [];
var vs_loc="",vs_lat="",vs_lng="",locJsonData="";

function addressPicker(pItemID, pItemVal, pCountryRestrict, pShowMap, pZoom, pPosition, pLat, pLng) 
{
  var countryRestrict = {'country': pCountryRestrict};

  if (pShowMap=='Y')
  {
    map = new google.maps.Map(document.getElementById('map-canvas'), 
    {
      zoom: pZoom,
      center: new google.maps.LatLng(pLat,pLng),
      mapTypeId: google.maps.MapTypeId.ROADMAP
    });
    if (pItemVal) {
    	var obj = JSON.parse(pItemVal); 
  		setMarker(new google.maps.LatLng(obj.ADDRESS_DATA.LATITUDE,obj.ADDRESS_DATA.LONGITUDE), false, pItemID);
	}
	else if (pPosition == 'Y')
    {
      // Try HTML5 geolocation.
      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function(position) {
          var pos = {
            lat: position.coords.latitude,
            lng: position.coords.longitude
          };
          map.setCenter(pos);
        });
      } else {
        alert("Browser doesn't support Geolocation");
      }
    }
      
    // Create the search box and link it to the UI element.
    var input = document.getElementById('pac-input-map');
    var searchBox = new google.maps.places.SearchBox(input);
    map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);

    // Bias the SearchBox results towards current map viewport.
    map.addListener('bounds_changed', function() {
      searchBox.setBounds(map.getBounds());
    });
    
    // Listen for the event fired when the user selects a prediction and retrieve
    // more details for that place.
    searchBox.addListener('places_changed', function() {
      var places = searchBox.getPlaces();
      if (places.length == 0) {
        return;
      }
      places.forEach(function(place) {
        if (!place.geometry) {
          console.log("Returned place contains no geometry");
          return;
        }
      setMarker(place.geometry.location, true, pItemID);
      });
    });
    google.maps.event.addListener(map, 'click', function(event) {
      setMarker(event.latLng, false, pItemID);
    });
  }
  else
  {
    var input = (document.getElementById('pac-input'));
   
    var autocomplete = new google.maps.places.Autocomplete(input,
      {
        componentRestrictions: countryRestrict
      });
  
  
  google.maps.event.addListener(autocomplete, 'place_changed', function() {
    var place = autocomplete.getPlace();
    if (!place.geometry) {
      return;
    }
    vs_loc = place.formatted_address;
	vs_lat = place.geometry.location.lat();
	vs_lng = place.geometry.location.lng();
	locJsonData = '{"ADDRESS_DATA" : {"LATITUDE" : "'+vs_lat+'", "LONGITUDE" : "'+vs_lng+'", "ADDRESS" : "'+vs_loc+'"}}';
    $s(pItemID,locJsonData);
   } );
   }
}
function setMarker(latlng, applyBound, pItemID)
{
  var geocoder = new google.maps.Geocoder;
  var infowindow = new google.maps.InfoWindow;
  
  for (var i = 0; i < markers.length; i++) 
  {
    markers[i].setMap(null);
  }
  geocoder.geocode({'location': latlng}, function(results, status) {
  if (status === 'OK') {
    if (results[0]) {
      if (applyBound)
      {
        map.setZoom(17);
        map.setCenter(latlng);
      }
      var marker = new google.maps.Marker({
        position: latlng,
        map: map,
        draggable: true
      });
      infowindow.setContent(results[0].formatted_address);
      infowindow.open(map, marker);
      markers.push(marker);
      marker.addListener('click', function() {
        infowindow.open(map, marker);
      });
      vs_loc = results[0].formatted_address;
	  vs_lat = latlng.lat();
	  vs_lng = latlng.lng();
	  locJsonData = '{"ADDRESS_DATA" : {"LATITUDE" : "'+vs_lat+'", "LONGITUDE" : "'+vs_lng+'", "ADDRESS" : "'+vs_loc+'"}}';

      $s(pItemID,locJsonData);
          
      google.maps.event.addListener(marker, 'dragend', function(event) {
        setMarker(marker.position, false, pItemID);
      });
      
    } else {
      window.alert('No results found');
    }
  } else {
    window.alert('Geocoder failed due to: ' + status);
  }
  });
}