var ProcessOrderSelector = {
		
		cloneRowTableSearch: (index,data) => {
			var counter = index ;
	        var newRow = $('<tr id="rec-process-order'+counter+'">');
	        var cols = "";
	        cols += '<td><input type="checkbox" class="item-check" id="processOrderChecked'+counter+'" value="'+data.code+'" checked="true"></td>';   
	        cols += '<td><input type="text" id="selected-process-order-code'+counter+'" class="form-control" value="'+data.code+'" readonly="readonly"></td>';
	        cols += '<td><input type="text" id="selected-process-order-batch'+counter+'" class="form-control" value="'+data.batch+'" readonly="readonly"></td>';
	        
	        newRow.append(cols);
	        newRow.appendTo('#tblSelectedProcessOrders tbody');
		},
};
