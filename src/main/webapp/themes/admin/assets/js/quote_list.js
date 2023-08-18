
 const contextPath = getContext();  


$('#exampleModalCenter').on('show.bs.modal', function (event) {
	var button = $(event.relatedTarget)
	$('#nameQuote').html("");
	$('#invoiceDescription').html("");
	$('#dynamic-table').html("");
	var id = button.data('document_id');
	var object = JSON.parse(id);
	$.ajax({
        type: "GET",
        url: contextPath +"/getDocument?id="+id,
        success: function(document){
        	$('#nameQuote').html(document.name);
        	$('#invoiceDescription').html(document.description)
           Object.keys(document.detail.detail).map((key, index)=> {
        	   $('#dynamic-table').append('<tr>'
                       +'<td >' + parseInt(index+1) + '</td>'
                       +'<td>'+document.detail.detail[index]['code']+'<input type="hidden" class="selected-item-code'+index+'" value="'+document.detail.detail[index]['code']+'"></td>'
                       +'<td >' + document.detail.detail[index]['name'] + '</td>'
                       +'<td class="number" >' + document.detail.detail[index].detail['priceQuote'] + '<input type="hidden" class="selected-item-price'+index+'" value="'+document.detail.detail[index].detail['priceQuote']+'"></td>'                      
                       +'</tr>');
           })
           totalPrice();
        },
    });
});

function totalPrice (){
	$('#totalPriceQuote').html("");
	var size = $('#talbeQuote tbody tr').length;
	var total = 0;
	if(size > 0){
		for (var i = 0; i < size; i++) {
    		const itemCode = $(".selected-item-code"+i).val();
    		if(itemCode){
        		const itemPrice = $(".selected-item-price"+i).val();
        		total = total + parseInt(itemPrice);
    		}
    	}
	} 
	var span = '<span class="number">'+ total +'</span>'
	$('#totalPriceQuote').html(span);
	formatNumberComponent.initAutoNumeric();
};