var AssetSelector = {
	init: () => {
   	 	const contextPath = getContext();
   	 	console.log(contextPath);
   	    $('.select2-asset-items').select2({
   	    	minimumInputLength: 1,
   	    	minimumResultsForSearch: Infinity,
   	    	ajax: {
   	            url: contextPath + '/asset/load-asset-items',
//   	            url: contextPath + '/asset/load-asset-available',
   	            type: 'GET',
   	            dataType: 'json',
   	            data: function (params) {
   	                return {
   	                    q: params.term,
   	                };
   	            },
   	            processResults: function (data, params) {
   	                return {
   	                    results: $.map(data, function (item) {
   	                        return {
   	                            text: item.code + ": " + item.name,
   	                            id: item.id + "-/" + item.code.trim() + "-/" + item.name.trim() + "-/" + JSON.stringify(item.detail) + "-/" + item.type.trim()+ "-/" + item.categoryCode.trim() + "-/" + item.status.trim() ,
   	                            data: item
   	                        };
   	                    })
   	                };
   	            }
   	        },
   	    });
   	    
   	   $('.select-asset-items').select2({
	    	minimumInputLength: 1,
	    	minimumResultsForSearch: Infinity,
	    	ajax: {
//	            url: contextPath + '/asset/load-asset-items',
	            url: contextPath + '/asset/load-asset-available',
	            type: 'GET',
	            dataType: 'json',
	            data: function (params) {
	                return {
	                    q: params.term,
	                };
	            },
	            processResults: function (data, params) {
	                return {
	                    results: $.map(data, function (item) {
	                        return {
	                            text: item.code + ": " + item.name,
	                            id: item.id + "-/" + item.code.trim() + "-/" + item.name.trim() + "-/" + JSON.stringify(item.detail) + "-/" + item.type.trim() + "-/" + item.categoryCode.trim()+ "-/" + item.status.trim(),
	                            data: item
	                        };
	                    })
	                };
	            }
	        },
	    });	   	

	   	var codeInvoice = document.querySelector('#code');
	   	codeInvoice.oninput = function(){
	   	    $('#messageCheckCode').html("");	 
	   	};
	
	   	var nameInvoice = document.querySelector('#name');
	   	nameInvoice.oninput = function(){
	   	    $('#messageCheckName').html("");	 
	   	};

   	   /*Clear báo giá*/
   	    
	   	 $('#btnClear').on('click', function(){
	 		console.log("btnclear clicked")
	 		AssetSelector.clear();
	 		AssetSelector.totalPrice();
	 	}),
	 	
	 	 /*check code document*/
	 	$(document).ready(function(){
		     $('#code').keyup(function(){
		      $('#messageCheckCode').html("");
		       var codeDocument =  $(this).val().trim();
		       var idDocument =  $("#id").val().trim();
		       if(codeDocument != ""){
			       $.ajax({
			           type: "GET",
			           url: contextPath+ "/checkDocumentCode?code="+codeDocument+"&id="+idDocument,
			           success: function(check){
			              if(check == true ){
			            	  $('#messageCheckCode').html("Code đã tồn tại, vui lòng chọn code khác");
			              }
			           },
			       });
			     }
		     });
		     
		 	});
	   	/*end check code document*/
	 	
	   	 $("#btn-seclect-asset-items").on("click", (e) => {
//	   		formatNumberComponent.disableAutoNumeric();
    		var value = $(".select2-asset-items").val();
    		
    		var selectItem = $('#selectItem').val();
    		if (value && value.length > 0) {
    			for(i = 0; i < value.length ; i++){
        			var size = $('#tblSelectedAssets tbody tr').length;
        			var arr = value[i].split("-/");
        			var itemName = arr[2];
        			var itemCode = arr[1];
        			var itemId = arr[0];
        			var detail = JSON.parse(arr[3]);
        			var strDetail = arr[3];
        			var itemType = arr[4];
        			var itemCategory_code = arr[5]
        			var itemStatus = arr[6];
        			var itemPrice = '';
        			if(detail['PriceQuote']){
        				itemPrice = detail['PriceQuote'];
        			}else {
        				itemPrice = detail['priceQuote'];
        			}
        			
        			var newRow = AssetSelector.createRow(size,itemId,itemCode, itemName,itemType,itemPrice,strDetail,itemCategory_code, itemStatus );
         			newRow.appendTo('#tblSelectedAssets tbody');
         			
         			AssetSelector.totalPrice();
         			
//        			if(itemId != null && itemId != selectItem){
//        				var newRow = AssetSelector.createRow(size,itemCode, itemName);
//            			newRow.appendTo('#tblSelectedFoodItemRelateds tbody');	
//        			}
        		}
    		}
    		AssetSelector.clearSelect2();
	   	 });
	   	 
	   	$("#btn-seclect-asset-available-items").on("click", (e) => {
//	   		formatNumberComponent.disableAutoNumeric();
    		var value = $(".select-asset-items").val();    		
    		var selectItem = $('#selectItem').val();
    		if (value && value.length > 0) {
    			for(i = 0; i < value.length ; i++){
        			var size = $('#tblSelectedAssets tbody tr').length;
        			var arr = value[i].split("-/");
        			var itemName = arr[2];
        			var itemCode = arr[1];
        			var itemId = arr[0];
        			var detail = JSON.parse(arr[3]);
        			var strDetail = arr[3];
        			var itemType = arr[4];
        			var itemCategory_code = arr[5]
        			var itemStatus = arr[6];
        			var itemPrice = '';
        			if(detail['PriceQuote']){
        				itemPrice = detail['PriceQuote'];
        			}else {
        				itemPrice = detail['priceQuote'];
        			}
        			
        			var newRow = AssetSelector.createRow(size,itemId,itemCode, itemName,itemType,itemPrice,strDetail, itemCategory_code, itemStatus);
         			newRow.appendTo('#tblSelectedAssets tbody');
         			
         			AssetSelector.totalPrice();
         			
//        			if(itemId != null && itemId != selectItem){
//        				var newRow = AssetSelector.createRow(size,itemCode, itemName);
//            			newRow.appendTo('#tblSelectedFoodItemRelateds tbody');	
//        			}
        		}
    		}
    		AssetSelector.clearSelect2();
	   	 });	 
	  },
		
	  
	createRow: (index, itemId,itemCode, itemName, itemType, itemPrice, strDetail, itemCategory_code, itemStatus) => {
		var counter = index + 1;
        var newRow = $('<tr id="rec-fi-re'+counter+'">');
        var cols = "";
        
        cols += '<td><span class="no">'+counter+'</span></td>';
        cols += '<td>'+itemCode+'<input type="hidden" class="selected-item-code'+counter+'" value="'+itemCode+'"><input type="hidden" class="selected-item-id'+counter+'" value="'+itemId+'"></td>';
        cols += '<td>'+itemName+'<input type="hidden" class="selected-item-name'+counter+'" value="'+itemName+'"><input type="hidden" class="selected-item-category_code'+counter+'" value="'+itemCategory_code+'"></td>';
        cols += '<td>'+itemType+'<input type="hidden" class="selected-item-type'+counter+'" value="'+itemType+'"><input type="hidden" class="selected-item-status'+counter+'" value="'+itemStatus+'"></td>';
        cols += '<td><span class="number ">'+itemPrice+'</span><input type="hidden" class="selected-item-price'+counter+'" value="'+itemPrice+'"><span class="d-none selected-item-detail'+counter+'">'+ strDetail +'</span></td>';
        cols += '<td class="text-center">';
        cols += '<div class="list-icons">';
        cols += '<a href="javascript:AssetSelector.showModal('+counter+')" class="detail-record list-icons-item text-primary-600" title="Detail" data-id="'+counter+'" style="color:#d8201c;"><i class="icon-file-text"></i></a>';
        cols += '<a href="javascript:AssetSelector.removeRow('+counter+')" class="delete-record list-icons-item text-danger-600" title="Remove" data-id="'+counter+'" style="color:#d8201c;"><i class="icon-trash"></i></a>';
        cols += '</td>';
        
        newRow.append(cols);
        return newRow;
	},
	
	showModal: (index) => {
		var detail = JSON.parse($('.selected-item-detail'+ index).text());
		$('#dynamic-table').html("");		
    	$('#dynamic-table').append('<tr>'
                +'<td  >' + 'Giá ' + '</td>'
                +'<td>' + detail['priceQuote'] + ' VND'+'</td>'
                +'</tr>');
    	$('#dynamic-table').append('<tr>'
                +'<td >' + 'Ngày nhập khẩu' + '</td>'
                +'<td >' + detail['imported_date'] + '</td>'
                +'</tr>');
    	$('#dynamic-table').append('<tr>'
                +'<td >' + 'Tỷ lệ khấu hao' + '</td>'
                +'<td >' + detail['depreciation_rate'] +' %' + '</td>'
                +'</tr>');
    	$('#dynamic-table').append('<tr>'
                +'<td >' + 'Chu kỳ khấu hao' + '</td>'
                +'<td >' + detail['depreciation_period'] +' năm' + '</td>'
                +'</tr>');
    	$('#dynamic-table').append('<tr>'
                +'<td >' + 'Thời gian bảo hành' + '</td>'
                +'<td >' +detail['guarantee'] +' năm' + '</td>'
                +'</tr>');
       Object.keys(detail).map(key=> {
    	   if(key != 'price' && key != 'priceQuote' && key != 'imported_date' && key !='depreciation_rate' && key != 'depreciation_period' && key != 'guarantee' ){
    		   $('#dynamic-table').append('<tr>'
                       +'<td >' + key + '</td>'
                       +'<td >' + detail[key] + '</td>'
                       +'</tr>');
    	   }
    	  
       })
		$('#exampleModalCenter').modal('show');
		
	},
	
	deleteRow: (counter,itemCode, itemName, itemType, itemPrice, strDetail, icon) => {
		var deleteRow = $('#rec-fi-re'+counter);
        var cols = "";

        var spanIcon = '';
        if (icon) {
        	spanIcon = '<span class="badge bg-warning-300 rounded-circle badge-icon"><i class="'+icon+'"></i></span>';
        }

        cols += '<td><span class="no">'+counter+'</span>&nbsp;'+spanIcon+'</td>';
        cols += '<td>'+itemCode+'<input type="hidden" class="selected-item-id'+counter+'" value=""><input type="hidden" class="selected-item-code'+counter+'" value=""></td>';
        cols += '<td>'+itemName+'<input type="hidden" class="selected-item-name'+counter+'" value=""></td>';
        cols += '<td>'+itemType+'<input type="hidden" class="selected-item-type'+counter+'" value=""></td>';
        cols += '<td><span class="number">'+itemPrice+'<input type="hidden" class="selected-item-price'+counter+'" value=""><span class="d-none selected-item-detail'+counter+'"></span></td>';
        cols += '<td class="text-center">';
        cols += '<div class="list-icons">';
        cols += '<a class="detail-record list-icons-item text-primary-600" data-popup="tooltip" data-container="body"><i class="icon-file-text"></i></a>';
        cols += '<a class="delete-record list-icons-item text-danger-600" title="Remove" data-id="'+counter+'" style="color:#d8201c;"><i class="icon-trash"></i></a>';
        cols += '</td>';
        
        deleteRow.html(cols);
//        formatNumberComponent.disableAutoNumeric();
        AssetSelector.totalPrice();
        
	},
	
	totalPrice : () =>{
		$('#totalPrice').html("");
		var size = $('#tblSelectedAssets tbody tr').length;
		var total = 0;
		if(size > 0){
			for (var i = 0; i < size; i++) {
	    		var index = i + 1;
	    		const itemCode = $(".selected-item-code"+index).val();
	    		if(itemCode){
	        		const itemPrice = $(".selected-item-price"+index).val();
	        		total = total + parseInt(itemPrice);
//	        		console.log("total " + total);
//	        		console.log("itemPrice "+ itemPrice);
	    		}
	    	}
		} 
		var span = '<span class="number">'+ total +'</span>'
		$('#totalPrice').html(span);
		formatNumberComponent.initAutoNumeric();
	},
	
	convertToJson: () =>{
		var size = $('#tblSelectedAssets tbody tr').length;
		var detailJson = {};
		var objects = [];
		if(size > 0){
			for (var i = 0; i < size; i++) {
	    		var index = i + 1;
	    		const itemCode = $(".selected-item-code"+index).val();
	    		if(itemCode){
	    			const itemId = $(".selected-item-id"+index).val();
	        		const itemName = $(".selected-item-name"+index).val();
	        		const itemType = $(".selected-item-type"+index).val();
	        		const itemPrice = $(".selected-item-price"+index).val();
	        		const strDetail = $('.selected-item-detail'+ index).text();
	        		const itemCategory_code = $(".selected-item-category_code"+index).val();
	        		const itemStatus =  $('.selected-item-status'+ index).text();
	        		/*var detail = JSON.parse($('.selected-item-detail'+ index).text());*/
	        		
	        		var object = {}
	        		object['id'] = itemId;
	        		object['type'] = itemType;
	        		object['name'] = itemName;
	        		object['code'] = itemCode;
	        		object['categoryCode'] = itemCategory_code;
	        		object['detail'] = JSON.parse(strDetail);
	        		object['status'] =  itemStatus;
	        		objects.push(object);
	    		}
	    	}
			detailJson['detail'] = objects;
	    	$('#detail').val(JSON.stringify(detailJson));
	    	$('#listAsset').val(JSON.stringify(objects));
		} else {
			$('#detail').val(null);
		}
	},
	
	removeRow: (index) => {
		if (index) {
    		const itemCode = $(".selected-item-code"+index).val();
    		const itemName = $(".selected-item-name"+index).val();
    		const itemType = $(".selected-item-type"+index).val();
    		const itemPrice = $(".selected-item-price"+index).val();
    		var strDetail = $('.selected-item-detail'+ index).text();
    		const icon = 'icon-cross2';
    		AssetSelector.deleteRow(index,itemCode, itemName, itemType,itemPrice,strDetail,icon);
		}
		
	},
	
	clear: function() {
		$('.select2-asset-items').html("");
		$('.select-asset-items').html("");
		$('#tblSelectedAssets tbody').html("");
		
	},
	
	clearSelect2: function() {
		$('.select2-asset-items').html("");
		$('.select-asset-items').html("");
	},
	
	
	
	loadExistingAssets: function(quoteId) {
		var contextPath = getContext();
		$.ajax({
			url: contextPath + '/quote/get-existing-asset',
			method:'GET',
			data:{quoteId : quoteId},
			success: function(data) {
				for (i=0; i<data.length; i++) {
					
					var itemPrice = '';
					if(data[i].detail['Price']){
        				itemPrice = data[i].detail['PriceQuote'];
        			}else {
        				itemPrice = data[i].detail['priceQuote'];
        			}
					var strDetail = JSON.stringify(data[i].detail);
					
					var newRow = AssetSelector.createRow(i,data[i].id,data[i].code, data[i].name,data[i].type,itemPrice,strDetail);
         			newRow.appendTo('#tblSelectedAssets tbody');
				}
				AssetSelector.totalPrice();
				
			},
			error: function (e) {
				console.log("error: ",e);
			}
		});
	},
	
};

function validateForm(){
	  var codeInvoice =  $('#code').val();
	  var nameInvoice = $('#name').val();
	  if(codeInvoice == ""){
		  $('#messageCheckCode').html("Vui lòng nhập mã hóa đơn");
		  return false;
	  }else if(nameInvoice == ""){
		  $('#messageCheckName').html("Vui lòng nhập tên hóa đơn");
		  return false;
	  }else if(codeInvoice == "" && nameInvoice == "" ){
		  $('#messageCheckCode').html("Vui lòng nhập mã hóa đơn");
		  $('#messageCheckName').html("Vui lòng nhập tên hóa đơn");
		  return false;
	  }else{
		  $('#exampleModal').modal('show');
		  return false;
	  }
}



