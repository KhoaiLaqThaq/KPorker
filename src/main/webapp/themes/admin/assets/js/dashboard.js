// set  owlCarousel
$(document).ready(function(){
	var owl = $('.owl-carousel');
	owl.owlCarousel({
		items:3,
		loop: false,
		margin:10,
		autoplay:true,
		autoplayTimeout:2000,
		autoplayHoverPause:true,
	});
})

const contextPath = getContext();
var messages = [];
var stations=[];     
$(document).ready(function(){
	$.ajax({
       type: "GET",
       url: contextPath+"/getAllStation",
       success: function(data){ 
      	for(var i =0 ; i < data.lsStations.length ;i++){
      		stations.push(data.lsStations[i]);
      		showStationData(data.lsStations[i]);
      		
      	}
 
      	if(data.lsMonitors.length >0){
      		for(var i =0 ; i <data.lsMonitors.length;i++){
      		showStatusMonitor(data.lsMonitors[i]);	
      		}
      	}	
   		$('.owl-carousel').owlCarousel('refresh');
       },
   });
})
 // show data in carousel
 function showStationData(station) {
	 $('.owl-carousel').owlCarousel('add', '<div class="item item_'+station.id+'" >'
			+'<h4 class="station_name">'+station.name+'</h4>	'
				+'<span class="station_location text-center">'+station.location+'&nbsp;&nbsp;<span class="icon-location3"></span></span></br>'		
			+'<div class="table-responsive">'
				+'<table class="table">'
					+'</thead>'
						+'<tr class=" text-center">'
							+'<th id="title_device_stationId_'+station.id+'">Tên thiết bị</th>'
							+'<th id="title_status_stationId_'+station.id+'">Trạng thái</th>'
						+'</tr>'
					+'</thead>'
					+'<tbody class=" text-center"  id="detail_'+station.id+'" >'
					+'</tbody>' 
				+'</table>'
			+'</div>'
		+'</div>'
		);
		// if station has no device yet -> inform 
		if(station.lsDevices.length == 0){
			$('#title_device_stationId_'+station.id).remove();
			$('#title_status_stationId_'+station.id).remove();
			$('#detail_'+station.id).append(
				'<tr id ="no_device_message_id_'+station.lsDevices[i]+'">'
				+'<td><span class="no_device_message">'+'Trạm chưa có thiết bị nào'+'</span></td>'
				 +'<td ></td>'
                   +'</tr>'
			);
		}else{
		// if station has devices . show device and default device has no message yet
			for(var i =0 ; i < station.lsDevices.length ; i++){
				$('#detail_'+station.id).append(
				'<tr id ="device_code_'+station.lsDevices[i].code+'">'
				+'<td><span class="device_name">'+station.lsDevices[i].name+'</span></td>'
				 +'<td class="icon-warning22  text-center"  id ="status_deviceCode_'+station.lsDevices[i].code+'" ></td>'
                   +'</tr>'
				);
		}
		
		
		}

} 
	// show latest status of device from db
	function showStatusMonitor(monitor){
		Object.keys(monitor.detail).map( key => {
				if(monitor.detail[key] == 0){
				$("#status_deviceCode_"+key).attr("class","icon-checkmark-circle2 text-center");
			}
			if(monitor.detail[key] == 1){
			$("#status_deviceCode_"+key).attr('class','icon-cancel-circle2 text-center');
			
				}		
		}		
		)}
	// show latest status of device from db
	function showStatusMonitor1(monitor){
		Object.keys(monitor.detail).map( key => {
				console.log("code "+key+" status : "+monitor.detail[key]);
				if(monitor.detail[key] == 0){
				$("#status_deviceCode_"+key).attr("class","icon-checkmark-circle2 text-center");
			}
			if(monitor.detail[key] == 1){
			console.log("code "+key+" status : "+monitor.detail[key]);
			$("#status_deviceCode_"+key).attr('class','icon-cancel-circle2 text-center');
			
				}		
		}		
		)}
	 
// socket
// var socket = new SockJS('http://localhost:8087/websocket');
var socket = new SockJS('http://192.168.1.12:10002/websocket');
stompClient = Stomp.over(socket);  
stompClient.debug = null;
var messageSocket ;
stompClient.connect({}, function(frame) {
    stompClient.subscribe('/topic/monitors', function(messageOutput) {
    	messageSocket = JSON.parse(messageOutput.body)
 		if(messageSocket !== null){
 			loopfalse();
 			looptrue();
 			var timesRun = 0;
 			var interval = setInterval(function(){
 					 			timesRun += 1;
 				 				 if(timesRun === 60){
       				 				clearInterval(interval);
    							}
 								showStatusMonitor1(messageSocket);
 			},1000);
 		}
    });
});

function disconnect() {
    if(stompClient != null) {
        stompClient.disconnect();
    }
    setConnected(false);
    console.log("Disconnected");
}	
	
//

   
    
   function looptrue(){
	   $('.owl-carousel').data('owl.carousel').options.loop = true;
	   $('.owl-carousel').trigger( 'refresh.owl.carousel' );
   }
   function loopfalse(){
	   $('.owl-carousel').data('owl.carousel').options.loop = false;
	   $('.owl-carousel').trigger( 'refresh.owl.carousel' );
   }
   