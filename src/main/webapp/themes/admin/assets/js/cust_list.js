const contextPath = getContext();
$('#exampleModalCenter').on('show.bs.modal', function (event) {
	var button = $(event.relatedTarget)

	$('#dynamic-table').html("");
	var id = button.data('customer_id');
	
//	console.log(id);
	
	$.ajax({
        type: "GET",
        url: contextPath+"/getCustomer?id="+id,
        success: function(customer){
//           console.log((customer.detail));
           Object.keys(customer.detail).map(key=> {
        	   $('#dynamic-table').append('<tr>'
                       +'<td class="key">' + key + '</td>'
                       +'<td class="value ">' + customer.detail[key] + '</td>'
                       +'</tr>');
           })
        },
    });
});


