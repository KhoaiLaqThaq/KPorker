
const contextPath = getContext();
$('#exampleModalCenter').on('show.bs.modal', function (event) {
	var button = $(event.relatedTarget)

	$('#dynamic-table').html("");
	var id = button.data('monitor_id');
	
	console.log(id);
	
	$.ajax({
        type: "GET",
        url: contextPath+"/getMonitor?id="+id,
        success: function(monitor){
           console.log((monitor.detail));
           Object.keys(monitor.detail).map(key=> {
        	   if(monitor.detail[key] == 01){
        		   $('#dynamic-table').append('<tr>'
                           +'<td class="key">' + key + '</td>'
                           +'<td class="icon-checkmark-circle2 text-center key " ></td>'
                           +'</tr>');
        	   }else{
        		   $('#dynamic-table').append('<tr>'
                           +'<td class="key">' + key + '</td>'
                           +'<td class="icon-cancel-circle2 text-center key"   ></td>'
                           +'</tr>');
        	   }
        	   
           })
        },
    });
});