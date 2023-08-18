var materialInstock;

var MaterialSelector = {
		init: (prType) => {
			var farmCode = $("#purchaserequisitionStockCode").val();
			
			if(farmCode.length > 0){
				$('.selected-material-code').select2({
		   	    	minimumInputLength: 1,
		   	    	minimumResultsForSearch: Infinity,
		   	    	ajax: {
		   	            url: getContext() + '/api/get-material-by-name',
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
		   	                        	text: item.code +": "+ item.name,
		   	                        	id: item.code,
		   	                            data: item
		   	                        };
		   	                    })
		   	                };
		   	            },
		   	        },
		   	    });
			} else {
				$('.selected-material-code').select2({
					disabled: true,
		   	    	minimumInputLength: 1,
		   	    	minimumResultsForSearch: Infinity,
		   	    	ajax: {
		   	            url: getContext() + '/api/get-material-by-name',
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
		   	                        	text: item.code +": "+ item.name,
		   	                        	id: item.code,
		   	                            data: item
		   	                        };
		   	                    })
		   	                };
		   	            },
		   	        },
		   	    });
			}
			
	   	    
			
			// tu dong day data sau khi tim kiem va chon item
			$('.selected-material-code').on('select2:select', function (e) {
				var farmCode = $("#purchaserequisitionStockCode").val();
				var prTypeSelected = $("#purchaserequisitionPrType").val();
				
				var material = e.params.data;
				if(prTypeSelected === PR_TYPE.WEEK) {
					
					var indexCode = e.target.id;
					var index = indexCode.slice(18);
					
					var codeId = "#selected-item-code" + index; // có value = selected-item-code + index
					var fi = "<option value=" + material.data.code + ">" + material.data.code + "</option>";
					$(codeId).html(fi);
					$(codeId).val(material.data.code);
					
					var nameId = "#selected-item-name" + index;
					$(nameId).val(material.data.name);
					
					var unitId = "#selected-item-unit" + index;
					$(unitId).val(material.data.unit);
					
					var purchasingGroupId = "#selected-item-purchasingGroup" + index;
					$(purchasingGroupId).val(material.data.purchasingGroup);
					
					var descriptionId = "#selected-item-description" + index;
					$(descriptionId).val(material.data.description);
					
					if(materialInstock != null){
						var result = materialInstock.filter(obj => {
						  return obj.unsignedName === material.data.unsignedName
						});
						
						if(result.length > 1){
							var total = 0;
							result.forEach((e) => {
								total = total + parseInt(e.quantity);
								$("#selected-item-retained"+index).val(total);
							});
						} else if(result.length == 1) {
							$("#selected-item-retained"+index).val(result[0].quantity);
						} else {
							$("#selected-item-retained"+index).val(0);
						}
					}
					
				} else {
					var indexCode = e.target.id;  // có value = selected-pr-type-month-item-code + index
					var index = indexCode.slice(32);
					
					var codeId = "#selected-pr-type-month-item-code" + index;
					var fi = "<option value=" + material.data.code + ">" + material.data.code + "</option>";
					$(codeId).html(fi);
					$(codeId).val(material.data.code);
					
					var nameId = "#selected-pr-type-month-item-name" + index;
					$(nameId).val(material.data.name);
					
					var unitId = "#selected-pr-type-month-item-unit" + index;
					$(unitId).val(material.data.unit);
					
					var purchasingGroupId = "#selected-pr-type-month-item-purchasingGroup" + index;
					$(purchasingGroupId).val(material.data.purchasingGroup);
					
					var descriptionId = "#selected-pr-type-month-item-description" + index;
					$(descriptionId).val(material.data.description);
					
					if(materialInstock != null){
						var result = materialInstock.find(obj => {
						  return obj.unsignedName === material.data.unsignedName
						});
						
						if(result){
							$("#selected-pr-type-month-item-amountEarlyStage"+index).val(result.amountEarlyStage);
							$("#selected-pr-type-month-item-amountFinalStage"+index).val(result.amountFinalStage);
							$("#selected-pr-type-month-item-amountGoodsReceipt"+index).val(result.amountGoodsReceipt);
							$("#selected-pr-type-month-item-amountGoodsIssue"+index).val(result.amountGoodsIssue);
							
						} else {
							$("#selected-pr-type-month-item-amountEarlyStage"+index).val(0);
							$("#selected-pr-type-month-item-amountFinalStage"+index).val(0);
							$("#selected-pr-type-month-item-amountGoodsReceipt"+index).val(0);
							$("#selected-pr-type-month-item-amountGoodsIssue"+index).val(0);
						}
					}
				}
			});
		},
		
		initdatetimepicker: () =>{
		     $('.datetimepicker').daterangepicker({ 
		           singleDatePicker: true,
		           locale: {
		               format: 'YYYY-MM-DD'
		           }
		       });
		},
		
		cloneRow: (index) => {
			var prType = $("#purchaserequisitionPrType").val();
			var counter = index + 1;
	        if(prType == PR_TYPE.WEEK) {
	        	var newRow = $('<tr id="rec-material'+counter+'">');
		        var cols = "";
		        
		        cols += '<td><span class="no">'+counter+'</span></td>';
		        cols += '<td class="text-center">';
		        cols += '<div class="list-icons">';
		        cols += '<button type="button" class="btn-primary btn-xs addRow" onclick="javascript:MaterialSelector.addRow()" title="Add Row" style="display: inline-block; float: none; border: none"><i class="fa fa-plus "></i></button>';
		        cols += '<button type="button" class="btn-danger btn-xs" onclick="javascript:MaterialSelector.removeRow('+counter+')" title="Remove Row" style="display: inline-block; float: none; border: none"><i class="fa fa-times"></i></button>';
		        cols += '</td>';
		        
	        	cols += '<td class="select2ContainerPRWeek"><select class="form-control selected-material-code" name="materialDetailTypeWeeks['+counter+'].code" id="selected-item-code'+counter+'" data-placeholder="Chọn vật tư" data-fouc></select></td>';
		        cols += '<td><input type="text" name="materialDetailTypeWeeks['+counter+'].name" id="selected-item-name'+counter+'" class="form-control" value="" readonly="readonly"></td>';
		        cols += '<td><input type="text" name="materialDetailTypeWeeks['+counter+'].retained" id="selected-item-retained'+counter+'" class="form-control float" value=""></td>';
		        cols += '<td><input type="text" name="materialDetailTypeWeeks['+counter+'].quantity" id="selected-item-quantity'+counter+'" class="form-control float" value=""></td>';
		        cols += '<td><input type="text" name="materialDetailTypeWeeks['+counter+'].unit" id="selected-item-unit'+counter+'" class="form-control" value="" readonly="readonly"></td>';
		        cols += '<td><input type="text" name="materialDetailTypeWeeks['+counter+'].deliveryDateStr" id="selected-item-deliveryDate'+counter+'" class="form-control" value="" placeholder="dd.mm.yyyy"></td>';
		        cols += '<td><input type="text" name="materialDetailTypeWeeks['+counter+'].description" id="selected-item-description'+counter+'" class="form-control" value="" readonly="readonly"></td>';
		        cols += '<td><input type="text" name="materialDetailTypeWeeks['+counter+'].purchasingGroup" id="selected-item-purchasingGroup'+counter+'" class="form-control" value="" readonly="readonly">';
		        cols += '<input type="hidden" class="index-purchasingGroup" value="'+ counter +'"><input type="hidden" class="index-table" value="'+ counter +'"></td>';
		        cols += '<td><input type="text" name="materialDetailTypeWeeks['+counter+'].note" id="selected-item-note'+counter+'" class="form-control" value=""></td>';
	        } else {
	        	
	        	var newRow = $('<tr id="rec-material-type-month'+counter+'">');
		        var cols = "";
		        
		        cols += '<td><span class="no">'+counter+'</span></td>';
		        cols += '<td class="text-center">';
		        cols += '<div class="list-icons">';
		        cols += '<button type="button" class="btn-primary btn-xs addRow" onclick="javascript:MaterialSelector.addRow()" title="Add Row" style="display: inline-block; float: none; border: none"><i class="fa fa-plus "></i></button>';
		        cols += '<button type="button" class="btn-danger btn-xs" onclick="javascript:MaterialSelector.removeRow('+counter+')" title="Remove Row" style="display: inline-block; float: none; border: none"><i class="fa fa-times"></i></button>';
		        cols += '</td>';
	        	
	        	cols += '<td class="select2ContainerPRMonth"><select class="form-control selected-material-code" name="materialDetailTypeMonths['+counter+'].code" id="selected-pr-type-month-item-code'+counter+'" data-placeholder="Chọn vật tư" data-fouc></select></td>';
		        cols += '<td><input type="text" name="materialDetailTypeMonths['+counter+'].name" id="selected-pr-type-month-item-name'+counter+'" class="form-control" value="" readonly="readonly"></td>';
		        cols += '<td><input type="text" name="materialDetailTypeMonths['+counter+'].amountEarlyStage" id="selected-pr-type-month-item-amountEarlyStage'+counter+'" class="form-control float" value=""></td>';
		        cols += '<td><input type="text" name="materialDetailTypeMonths['+counter+'].amountGoodsReceipt" id="selected-pr-type-month-item-amountGoodsReceipt'+counter+'" class="form-control float" value=""></td>';
		        cols += '<td><input type="text" name="materialDetailTypeMonths['+counter+'].amountGoodsIssue" id="selected-pr-type-month-item-amountGoodsIssue'+counter+'" class="form-control float" value=""></td>';
		        cols += '<td><input type="text" name="materialDetailTypeMonths['+counter+'].amountFinalStage" id="selected-pr-type-month-item-amountFinalStage'+counter+'" class="form-control float" value=""></td>';
		        cols += '<td><input type="text" name="materialDetailTypeMonths['+counter+'].quantity" id="selected-pr-type-month-item-quantity'+counter+'" class="form-control float" value=""></td>';
		        cols += '<td><input type="text" name="materialDetailTypeMonths['+counter+'].unit" id="selected-pr-type-month-item-unit'+counter+'" class="form-control" value="" readonly="readonly"></td>';
		        cols += '<td><input type="text" name="materialDetailTypeMonths['+counter+'].deliveryDateStr" id="selected-pr-type-month-item-deliveryDate'+counter+'" class="form-control" value="" placeholder="dd.mm.yyyy"></td>';
		        cols += '<td><input type="text" name="materialDetailTypeMonths['+counter+'].description" id="selected-pr-type-month-item-description'+counter+'" class="form-control" value="" readonly="readonly"></td>';
		        cols += '<td><input type="text" name="materialDetailTypeMonths['+counter+'].purchasingGroup" id="selected-pr-type-month-item-purchasingGroup'+counter+'" class="form-control" value="" readonly="readonly">';
		        cols += '<input type="hidden" class="index-purchasingGroup-type-month" value="'+ counter +'"><input type="hidden" class="index-table-type-month" value="'+ counter +'"></td>';
		        cols += '<td><input type="text" name="materialDetailTypeMonths['+counter+'].note" id="selected-pr-type-month-item-note'+counter+'" class="form-control" value=""></td>';
	        }
	        
	        
	        
	        newRow.append(cols);
	        return newRow;
		},
		
		addRow: function(){
			var prType = $("#purchaserequisitionPrType").val();
	        if(prType === PR_TYPE.WEEK) {
	        	var index = parseInt($("#tblSelectedMaterialPrTypeWeeks").find(".index-table").last().val());
	    		var newRow = MaterialSelector.cloneRow(index);
	    		newRow.appendTo('#tblSelectedMaterialPrTypeWeeks tbody');
	    		MaterialSelector.init(prType);
	    		MaterialSelector.initdatetimepicker();
	    		$('#tblSelectedMaterialPrTypeWeeks tbody tr').each(function(index) {
				      $(this).find('span.no').html(index+1);
				});
	    		formatNumberComponent.initAutoNumeric();
	        } else {
	        	var index = parseInt($("#tblSelectedMaterialPrTypeMonths").find(".index-table-type-month").last().val());
	    		var newRow = MaterialSelector.cloneRow(index);
	    		newRow.appendTo('#tblSelectedMaterialPrTypeMonths tbody');
	    		MaterialSelector.init(prType);
	    		MaterialSelector.initdatetimepicker();
	    		$('#tblSelectedMaterialPrTypeMonths tbody tr').each(function(index) {
				      $(this).find('span.no').html(index+1);
				});
	    		formatNumberComponent.initAutoNumeric();
	        }
		},
		
		removeRow: function(index){
			var prType = $("#purchaserequisitionPrType").val();
	        if(prType === PR_TYPE.WEEK) {
	        	var size = $('#tblSelectedMaterialPrTypeWeeks tbody tr').length;
				if(size == 1){
					$('#tblSelectedMaterialPrTypeWeeks tbody tr').find("input:not([type=hidden])").val('');
				} else {
					$('#rec-material'+index).remove();
					$('#tblSelectedMaterialPrTypeWeeks tbody tr').each(function(index) {
					      $(this).find('span.no').html(index+1);
					});
				}
	        } else {
	        	var size = $('#tblSelectedMaterialPrTypeMonths tbody tr').length;
				if(size === 1){
					$('#tblSelectedMaterialPrTypeMonths tbody tr').find("input:not([type=hidden])").val('');
				} else {
					$('#rec-material-type-month'+index).remove();
					$('#tblSelectedMaterialPrTypeMonths tbody tr').each(function(index) {
					      $(this).find('span.no').html(index+1);
					});
				}
	        }
			
			
		},
		
		getSelectedCodes: function() {
			let selectedCodes = "";
			var prType = $("#purchaserequisitionPrType").val();
	        if(prType === PR_TYPE.WEEK) {
	        	var hiddenElements = $("#tblSelectedMaterialPrTypeWeeks").find(".selected-code");
				if (hiddenElements.length > 0) {
					var s ='';
					$.each(hiddenElements, function (i, obj) {
						s += obj.value + ",";
					});
					
					selectedCodes = s.substring(0, s.length - 1);
				}
	        } else {
	        	var hiddenElements = $("#tblSelectedMaterialPrTypeMonths").find(".selected-code");
				if (hiddenElements.length > 0) {
					var s ='';
					$.each(hiddenElements, function (i, obj) {
						s += obj.value + ",";
					});
					
					selectedCodes = s.substring(0, s.length - 1);
				}
	        }
			return selectedCodes;
		}, 
		
		checkFormTable: function(){
			var result = true;
			var prType = $("#purchaserequisitionPrType").val();
	        if(prType === PR_TYPE.WEEK) {
	        	// TRƯỜNG HỢP DỰ TRÙ TUẦN
				let tblSelectedMaterialPrTypeWeeks = $("#tblSelectedMaterialPrTypeWeeks");
	        	var indexFirstRow = parseInt(tblSelectedMaterialPrTypeWeeks.find(".index-purchasingGroup").first().val());
				var purchasingGroupLine1 = $('#selected-item-purchasingGroup' + indexFirstRow).val();
				var indexLastRow = parseInt(tblSelectedMaterialPrTypeWeeks.find(".index-table").last().val());
				for (var i = 0; i <= indexLastRow; i++) {
					var index = i;
					var itemCode = $('#selected-item-code'+index).val();

					let itemQuantitySelected = $('#selected-item-quantity'+index);
					var itemQuantity = itemQuantitySelected.val();

					let itemDeliveryDateSelected = $('#selected-item-deliveryDate'+index);
					var itemDeliveryDate = itemDeliveryDateSelected.val();

					let itemPurchasingGroupSelected = $('#selected-item-purchasingGroup'+index);
					var itemPurchasingGroup = itemPurchasingGroupSelected.val();

					let itemRetainedSelected = $('#selected-item-retained'+index);
					var itemRetained = itemRetainedSelected.val();
					var itemName = $('#selected-item-name'+index).val();
					if(itemCode){
						var checkRow = true;
						// check dieu kien neu quantity < 0 hoac chua nhap quantity thi bao loi
						if(itemQuantity && itemQuantity != ""){
							if(!MaterialSelector.regexQuantity(itemQuantity)){
								itemQuantitySelected.css("color", "red");
								itemQuantitySelected.css("border", "1px solid");
								result = false;
								checkRow = false;
							} else {
								itemQuantitySelected.removeAttr('style');
							}
						} else {
							itemQuantitySelected.css("color", "red");
							itemQuantitySelected.css("border", "1px solid");
							result = false;
							checkRow = false;
						}
						
						// check dieu kien neu retained < 0 hoac chua nhap quantity thi bao loi
						if(itemRetained && itemRetained != ""){
							if(!MaterialSelector.regexQuantity(itemRetained)){
								itemRetainedSelected.css("color", "red");
								itemRetainedSelected.css("border", "1px solid");
								result = false;
								checkRow = false;
							} else {
								itemRetainedSelected.removeAttr('style');
							}
						} else {
							itemRetainedSelected.css("color", "red");
							itemRetainedSelected.css("border", "1px solid");
							result = false;
							checkRow = false;
						}
						
						// check dieu kien neu ngay giao hang khong dung dinh dang loi
						if(itemDeliveryDate && itemDeliveryDate != ""){
							if(!MaterialSelector.regexDate(itemDeliveryDate)){
								itemDeliveryDateSelected.css("color", "red");
								itemDeliveryDateSelected.css("border", "1px solid");
								result = false;
								checkRow = false;
							} else {
								itemDeliveryDateSelected.removeAttr('style');
							}
						} else {
							itemDeliveryDateSelected.css("color", "red");
							itemDeliveryDateSelected.css("border", "1px solid");
							result = false;
							checkRow = false;
						}
						
						// check dieu kien neu ngay giao hang khong dung dinh dang loi
						if(itemPurchasingGroup != purchasingGroupLine1){
							itemPurchasingGroupSelected.css("color", "red");
							itemPurchasingGroupSelected.css("border", "1px solid");
							result = false;
							checkRow = false;
						} else {
							itemPurchasingGroupSelected.removeAttr('style');
							
						}
						
						if(!checkRow){
							$('#rec-material'+index).css("border", "2px solid red");
						} else {
							$('#rec-material'+index).css("border", "unset");
						}
					}
				}
	        } else {
	        	//TRƯỜNG HỢP DỰ TRÙ THÁNG
				let tblSelectedMaterialPrTypeMonths = $("#tblSelectedMaterialPrTypeMonths");
	        	var indexFirstRow = parseInt(tblSelectedMaterialPrTypeMonths.find(".index-purchasingGroup-type-month").first().val());
				var purchasingGroupLine1 = $('#selected-pr-type-month-item-purchasingGroup' + indexFirstRow).val();
				var indexLastRow = parseInt(tblSelectedMaterialPrTypeMonths.find(".index-table-type-month").last().val());
				for (var i = 0; i <= indexLastRow; i++) {
					var index = i;
					var itemCode = $('#selected-pr-type-month-item-code'+index).val();

					let itemQuantitySelected = $('#selected-pr-type-month-item-quantity'+index);
					var itemQuantity = itemQuantitySelected.val();

					let itemDeliveryDateSelected = $('#selected-pr-type-month-item-deliveryDate'+index);
					var itemDeliveryDate = itemDeliveryDateSelected.val();

					let itemPurchasingGroupSelected = $('#selected-pr-type-month-item-purchasingGroup'+index);
					var itemPurchasingGroup = itemPurchasingGroupSelected.val();
					var itemName = $('#selected-pr-type-month-item-name'+index).val();

					let itemAmountEarlyStageSelected = $('#selected-pr-type-month-item-amountEarlyStage'+index);
					var itemAmountEarlyStage = itemAmountEarlyStageSelected.val();

					let itemAmountGoodsReceiptSelected = $('#selected-pr-type-month-item-amountGoodsReceipt'+index);
					var itemAmountGoodsReceipt = itemAmountGoodsReceiptSelected.val();

					let itemAmountGoodsIssueSelected = $('#selected-pr-type-month-item-amountGoodsIssue'+index);
					var itemAmountGoodsIssue = itemAmountGoodsIssueSelected.val();

					let itemAmountFinalStageSelected = $('#selected-pr-type-month-item-amountFinalStage'+index)
					var itemAmountFinalStage = itemAmountFinalStageSelected.val();
					
					if(itemCode){
						var checkRow = true;
						// check dieu kien neu quantity < 0 hoac chua nhap quantity thi bao loi
						if(itemQuantity && itemQuantity != ""){
							if(!MaterialSelector.regexQuantity(itemQuantity)){
								itemQuantitySelected.css("color", "red");
								itemQuantitySelected.css("border", "1px solid");
								result = false;
								checkRow = false;
							} else {
								itemQuantitySelected.removeAttr('style');
							}
						} else {
							itemQuantitySelected.css("color", "red");
							itemQuantitySelected.css("border", "1px solid");
							result = false;
							checkRow = false;
						}
						
						// check dieu kien neu itemAmountEarlyStage < 0 hoac chua nhap quantity thi bao loi
						if(itemAmountEarlyStage && itemAmountEarlyStage != ""){
							if(!MaterialSelector.regexQuantity(itemAmountEarlyStage)){
								itemAmountEarlyStageSelected.css("color", "red");
								itemAmountEarlyStageSelected.css("border", "1px solid");
								result = false;
								checkRow = false;
							} else {
								itemAmountEarlyStageSelected.removeAttr('style');
							}
						} else {
							itemAmountEarlyStageSelected.css("color", "red");
							itemAmountEarlyStageSelected.css("border", "1px solid");
							result = false;
							checkRow = false;
						}
						
						// check dieu kien neu itemAmountGoodsReceipt < 0 hoac chua nhap quantity thi bao loi
						if(itemAmountGoodsReceipt && itemAmountGoodsReceipt != ""){
							if(!MaterialSelector.regexQuantity(itemAmountGoodsReceipt)){
								itemAmountGoodsReceiptSelected.css("color", "red");
								itemAmountGoodsReceiptSelected.css("border", "1px solid");
								result = false;
								checkRow = false;
							} else {
								itemAmountGoodsReceiptSelected.removeAttr('style');
							}
						} else {
							itemAmountGoodsReceiptSelected.css("color", "red");
							itemAmountGoodsReceiptSelected.css("border", "1px solid");
							result = false;
							checkRow = false;
						}
						
						// check dieu kien neu itemAmountGoodsIssue < 0 hoac chua nhap quantity thi bao loi
						if(itemAmountGoodsIssue && itemAmountGoodsIssue != ""){
							if(!MaterialSelector.regexQuantity(itemAmountGoodsIssue)){
								itemAmountGoodsIssueSelected.css("color", "red");
								itemAmountGoodsIssueSelected.css("border", "1px solid");
								result = false;
								checkRow = false;
							} else {
								itemAmountGoodsIssueSelected.removeAttr('style');
							}
						} else {
							itemAmountGoodsIssueSelected.css("color", "red");
							itemAmountGoodsIssueSelected.css("border", "1px solid");
							result = false;
							checkRow = false;
						}
						
						// check dieu kien neu amountFinalStage < 0 hoac chua nhap quantity thi bao loi
						if(itemAmountFinalStage && itemAmountFinalStage != ""){
							if(!MaterialSelector.regexQuantity(itemAmountFinalStage)){
								itemAmountFinalStageSelected.css("color", "red");
								itemAmountFinalStageSelected.css("border", "1px solid");
								result = false;
								checkRow = false;
							} else {
								itemAmountFinalStageSelected.removeAttr('style');
							}
						} else {
							itemAmountFinalStageSelected.css("color", "red");
							itemAmountFinalStageSelected.css("border", "1px solid");
							result = false;
							checkRow = false;
						}
						
						// check dieu kien neu ngay giao hang khong dung dinh dang loi
						if(itemDeliveryDate && itemDeliveryDate != ""){
							if(!MaterialSelector.regexDate(itemDeliveryDate)){
								itemDeliveryDateSelected.css("color", "red");
								itemDeliveryDateSelected.css("border", "1px solid");
								result = false;
								checkRow = false;
							} else {
								itemDeliveryDateSelected.removeAttr('style');
							}
						} else {
							itemDeliveryDateSelected.css("color", "red");
							itemDeliveryDateSelected.css("border", "1px solid");
							result = false;
							checkRow = false;
						}
						
						// check dieu kien neu ngay giao hang khong dung dinh dang loi
						if(itemPurchasingGroup != purchasingGroupLine1){
							itemPurchasingGroupSelected.css("color", "red");
							itemPurchasingGroupSelected.css("border", "1px solid");
							result = false;
							checkRow = false;
						} else {
							itemPurchasingGroupSelected.removeAttr('style');
							
						}
						
						if(!checkRow){
							$('#rec-material'+index).css("border", "2px solid red");
						} else {
							$('#rec-material'+index).css("border", "unset");
						}
					}
				}
	        }
	        
	        if(!result){
				$('#tblSelectedMaterialPrTypeMonths').css('overflow-x','unset');
				$('#tblSelectedMaterialPrTypeWeeks').css('overflow-x','unset');
			}
			
			return result;
		},
		
		regexDate: function(date){
			var regexGoodDate = /^([0-2][0-9]|(3)[0-1])(\.)(((0)[0-9])|((1)[0-2]))(\.)\d{4}$/;
		    return regexGoodDate.test(date);
		},
		
		regexQuantity: function(quantity){
		    var regexGoodQuantity = /^(\d*\.)?\d+$/;
		    return regexGoodQuantity.test(quantity);
		},
		
		getMaterialPRWeek: function(){
			var farmCode = $("#purchaserequisitionStockCode").val();
			$('#pleaseWaitDialog').modal();
			$.ajax({
				url: getContext() + '/api/material/get-material-instock-latest?stockCode='+farmCode,
				contextType: 'application/json',
				method: 'GET',
				dataType: 'json',
				
				success: function(data) {
					materialInstock = data;
					$('.selected-material-code').prop("disabled", false);
					$('#pleaseWaitDialog').modal('hide');
				},
				error: function(err) {
					console.log(err);
					materialInstock = null;
					$('#pleaseWaitDialog').modal('hide');
					bootbox.alert({
			            title: 'Thông báo',
			            message: 'Không thể tải thông tin vật tư tồn kho. Vui lòng nhập các thông tin này.'
			        });
			        $('.selected-material-code').prop("disabled", false);
			        
				}
			});
		},
		
		getMaterialPRMonth: function(){
			var farmCode = $("#purchaserequisitionStockCode").val();
			if(farmCode != ""){
				$('#pleaseWaitDialog').modal();
				$.ajax({
					url: getContext() + '/api/material/get-material-stage?stockCode='+farmCode,
					contextType: 'application/json',                                                                                                                             
					method: 'GET',
					dataType: 'json',
					
					success: function(data) {
						materialInstock = data;
						$('.selected-material-code').prop("disabled", false);
						$('#pleaseWaitDialog').modal('hide');
					},
					error: function(err) {
						console.log(err);
						materialInstock = null;
						$('#pleaseWaitDialog').modal('hide');
						bootbox.alert({
				            title: 'Thông báo',
				            message: 'Không thể tải thông tin vật tư tồn kho. Vui lòng nhập các thông tin này.'
				        });
				        $('.selected-material-code').prop("disabled", false);
					}
				});
			}
		}
};
