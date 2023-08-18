
// Google Maps

// init Maps
function initMap() {
	var location = $('#location').val();
	$('#address').val(location);
	var lat = Number($('#latitude').val());
	var lng = Number($('#longitude').val());	
    const map = new google.maps.Map(document.getElementById("map"), {
      zoom: 14,
      center: {lat:lat, lng:lng},
    });
    marker = new google.maps.Marker({
        map: map,
        position: {lat:lat, lng:lng}
      }); 
    const geocoder = new google.maps.Geocoder();
    $("#address").keyup(function(){   	
    	
    	 geocodeAddress(geocoder, map);
         marker.setMap(null);
    });
    document.getElementById("mapSubmit").addEventListener("click", () => {
      geocodeAddress(geocoder, map);
      marker.setMap(null);
    });
}
// find lat and lng by address	
function geocodeAddress(geocoder, resultsMap) {	
    const address = document.getElementById("address").value;
    geocoder.geocode({ address: address }, (results, status) => {
    	if (status === "OK") {    	
	    resultsMap.setCenter(results[0].geometry.location);
	    marker.setMap(null);
	    marker = new google.maps.Marker({
	    	map: resultsMap,
	    	position: results[0].geometry.location,
	    });
	    lat = marker.getPosition().lat();
	    lng = marker.getPosition().lng();
	    $('#latitude').val(lat);
	  	$('#longitude').val(lng);
	  	$('#location-error').html(" ");
	  	$('#location').val(address);
    	}
    	});
  	}
// End google Map



// Validate form
$("#statForm").validate({
	
    rules: {
      "code":{
    	  required: true,
    	  maxlength: 255
      },
      "name":{
    	  required: true,
    	  maxlength: 255
      },     
      "location":{
    	  required: true,    	  
      },     
    },

    messages: {
    	"name": {
			required: "\u0056\u0075\u0069 \u006c\u00f2\u006e\u0067 \u006e\u0068\u1ead\u0070 \u0074\u00ea\u006e \u0074\u0072\u1ea1\u006d\u002e",
			maxlength: "\u0054\u00ea\u006e \u0071\u0075\u00e1 \u0064\u00e0\u0069\u002c \u006e\u0068\u1ead\u0070 \u006c\u1ea1\u0069 \u0074\u00ea\u006e \u006d\u1edb\u0069\u002e"
		},
		"code": {
			required: "\u0056\u0075\u0069 \u006c\u00f2\u006e\u0067 \u006e\u0068\u1ead\u0070 \u006d\u00e3 \u0074\u0072\u1ea1\u006d\u002e",
			maxlength: "\u004d\u00e3 \u0071\u0075\u00e1 \u0064\u00e0\u0069\u002c \u006e\u0068\u1ead\u0070 \u006c\u1ea1\u0069\u002e"
		},
		"location": {
			required: "\u0056\u0075\u0069 \u006c\u00f2\u006e\u0067 \u0063\u0068\u1ecd\u006e \u0076\u1ecb \u0074\u0072\u00ed \u0074\u0072\u1ea1\u006d \u0074\u0072\u00ea\u006e \u004d\u0061\u0070\u0073\u002e",			
		},		
    },
    submitHandler: function(form) {   	
    	form.submit();
    }
 });

//check Station code
const contextPath = getContext();
$(document).ready(function(){
 $('#code').keyup(function(){
   var codeStation =  $(this).val().trim();
   var idStation =  $("#idStation").val().trim();
   if(codeStation != ""){
       $.ajax({
           type: "GET",
           url: contextPath+"/checkStationCode?code="+codeStation+"&id="+idStation,
           success: function(check){
              if(check == true ){
            	  $('#messageCheckCode').html("Code đã tồn tại, vui lòng chọn code khác");
              }
           },
       });
     }
 });
});
var nameStation = document.querySelector('#code');
nameStation.oninput = function(){
 $('#messageCheckCode').html("");	 
};
