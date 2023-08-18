var MaterialSelector = {
		initdatetimepicker: () =>{
			$('.datetimepicker').daterangepicker({ 
		           singleDatePicker: true,
		           locale: {
		               format: 'YYYY-MM-DD'
		           }
		       });
		},
		
		initBootBox: () =>{
			if (typeof bootbox == 'undefined') {
	            console.warn('Warning - bootbox.min.js is not loaded.');
	            return;
	        }
		},
		
		init: (stockCode,postingDate, movementType) => {
			$('.selected-material-code').select2({
	   	    	minimumInputLength: 1,
	   	    	minimumResultsForSearch: Infinity,
	   	    	ajax: {
	   	            url: getContext() + '/api/get-material-instock-by-name',
	   	            type: 'GET',
	   	            dataType: 'json',
	   	            data: function (params) {
	   	                return {
	   	                    q: params.term,
	   	                    stockCode: stockCode,
	   	                    postingDate: postingDate,
	   	                    movementType: movementType
	   	                };
	   	            },
	   	            processResults: function (data, params) {
	   	                return {
	   	                    results: $.map(data, function (item) {
	   	                        return {
	   	                        	text: item.code +": "+ item.name +" : "+ item.batch + " : "+ item.expiredDateStr,
	   	                        	id: item.code +": "+ item.batch,
	   	                            data: item
	   	                        };
	   	                    })
	   	                };
	   	            },
	   	        },
	   	    });
			
			// tu dong day data sau khi tim kiem va chon item
			$('.selected-material-code').on('select2:select', function (e) {
				var material = e.params.data;
				var materialCode = material.data.code;
				
				var codeId = "#" + e.target.id;
				var fi = "<option value=" + material.data.code + ">" + material.data.code + "</option>";
				$(codeId).html(fi);
				$(codeId).val(materialCode);
				
				var nameId = "#selected-item-name" + e.target.id;
				$(nameId).val(material.data.name);
				
				var unitId = "#selected-item-unit" + e.target.id;
				$(unitId).val(material.data.unit);
				
				var groupCodeId = "#selected-item-groupCode" + e.target.id;
				$(groupCodeId).val(material.data.groupCode);
				
				var groupNameId = "#selected-item-groupName" + e.target.id;
				$(groupNameId).val(material.data.groupName);
				
				var purchasingGroupId = "#selected-item-purchasingGroup" + e.target.id;
				$(purchasingGroupId).val(material.data.purchasingGroup);
				
				var requiredBatchId = "#selected-item-requiredBatch" + e.target.id;
				if(material.data.batch != null && material.data.batch != ""){
					$(requiredBatchId).val(true);
				} else {
					$(requiredBatchId).val(false);
				}
				
				var totalRetainedQuantityId = "#selected-item-totalRetainedQuantity" + e.target.id;
				$(totalRetainedQuantityId).val(material.data.quantity);
				
				var manufacturedDateId = "#selected-item-manufacturedDate" + e.target.id;
				$(manufacturedDateId).val(material.data.manufacturedDateStr);
				
				var expiredDateId = "#selected-item-expiredDate" + e.target.id;
				$(expiredDateId).val(material.data.expiredDateStr);
				
				var batchId = "#selected-item-batch" + e.target.id;
				var input = '<input type="text" name="materialDetails['+e.target.id+'].batch" id="selected-item-batch'+e.target.id+'" class="form-control" value="'+material.data.batch+'">';
				$(batchId).closest('td').html(input);
				
				var goodsRequisitionId = $("#goodsRequisitionId").val();
				if(goodsRequisitionId) {
					var itemNumId = "#selected-item-itemNum" + e.target.id;
					for (var i = 0; i < materialcodeExisting.length; i++) {
						if(materialcodeExisting[i].includes(materialCode)){
							var arr = materialcodeExisting[i].split(':/');
							$(itemNumId).val(arr[1]);
						}
					}
				}
				
			});
		},
		
		cloneRow: (index) => {
			var counter = index + 1;
	        var newRow = $('<tr id="rec-material'+counter+'">');
	        var cols = "";
	        
	        cols += '<td><span class="no">'+counter+'</span></td>';
	        cols += '<td class="text-center">';
	        cols += '<div class="list-icons">';
	        cols += '<button type="button" class="btn-primary btn-xs" onclick="javascript:MaterialSelector.addRow()" title="Add Row" style="display: inline-block; float: none; border: none"><i class="fa fa-plus "></i></button>';
	        cols += '<button type="button" class="btn-danger btn-xs" onclick="javascript:MaterialSelector.removeRow('+counter+')" title="Remove Row" style="display: inline-block; float: none; border: none"><i class="fa fa-times"></i></button>';
	        cols += '</td>';
	        
	        cols += '<td><select class="form-control selected-material-code" name="materialDetails['+counter+'].code" id="'+counter+'" data-placeholder="Chọn vật tư" data-fouc></select></td>';
	        cols += '<td><input type="text" name="materialDetails['+counter+'].name" id="selected-item-name'+counter+'" class="form-control" value="">';
	        cols += '<input type="hidden" name="materialDetails['+counter+'].groupCode" id="selected-item-groupCode'+counter+'" class="form-control" value="">';
	        cols += '<input type="hidden" name="materialDetails['+counter+'].itemNum" id="selected-item-itemNum'+counter+'" class="form-control" value="">';
	        cols += '<input type="hidden" name="materialDetails['+counter+'].groupName" id="selected-item-groupName'+counter+'" class="form-control" value="">';
	        cols += '<input type="hidden" name="materialDetails['+counter+'].requiredBatch" id="selected-item-requiredBatch'+counter+'" class="form-control" value="">';
	        cols += '<input type="hidden" name="materialDetails['+counter+'].weight" id="selected-item-weight'+counter+'" class="form-control float" value="0">';
	        cols += '<input type="hidden" name="materialDetails['+counter+'].quantity" id="selected-item-quantity'+counter+'" class="form-control float" value="0"></td>';
	        
	        cols += '<td><input type="text" name="materialDetails['+counter+'].batch" id="selected-item-batch'+counter+'" class="form-control" value=""></td>';
	        
	        cols += '<td><input type="text" name="materialDetails['+counter+'].actuallyExported" id="selected-item-actuallyExported'+counter+'" class="form-control float" value=""></td>';
	        cols += '<td><input type="text" name="materialDetails['+counter+'].totalRetainedQuantity" id="selected-item-totalRetainedQuantity'+counter+'" class="form-control float" value=""></td>';
	        cols += '<td><input type="text" name="materialDetails['+counter+'].unit" id="selected-item-unit'+counter+'" class="form-control" value=""></td>';
	        cols += '<td><input type="text" name="materialDetails['+counter+'].grossWeight" id="selected-item-grossWeight'+counter+'" class="form-control float" value=""></td>';
	        cols += '<td><input type="text" name="materialDetails['+counter+'].weightUnit" id="selected-item-weightUnit'+counter+'" class="form-control" value=""></td>';
	       
	        cols += '<td><input type="text" name="materialDetails['+counter+'].manufacturedDateStr" id="selected-item-manufacturedDate'+counter+'" class="form-control" placeholder="dd.mm.yyyy"></td>';
	        cols += '<td><input type="text" name="materialDetails['+counter+'].expiredDateStr" id="selected-item-expiredDate'+counter+'" class="form-control" placeholder="dd.mm.yyyy"><input type="hidden" class="index-table" value="'+ counter +'"></td>';
	        cols += '<td><input type="text" name="materialDetails['+counter+'].purchasingGroup" id="selected-item-purchasingGroup'+counter+'" class="form-control" value=""</td>';
	        
	        newRow.append(cols);
	        return newRow;
		},
		
		addRow: function(){
			var stockCode = $('#goodsIssueFromStockCode').val();
			var index = parseInt($("#tblSelectedMaterials").find(".index-table").last().val());
    		var newRow = MaterialSelector.cloneRow(index);
    		newRow.appendTo('#tblSelectedMaterials tbody');
    		var postingDate = $('#goodsIssueDisplayPostingDate').val();
	    	var movementType = $('#goodsissueMovementType option:selected').val(); 
   	 		MaterialSelector.init(stockCode,postingDate,movementType);
    		MaterialSelector.initdatetimepicker();
    		$('#tblSelectedMaterials tbody tr').each(function(index) {
			      $(this).find('span.no').html(index+1);
			});
    		formatNumberComponent.initAutoNumeric();
		},
		
		removeRow: function(index){
			var size = $('#tblSelectedMaterials tbody tr').length;
			if(size == 1){
				$('#tblSelectedMaterials tbody tr').find("input:not([type=hidden])").val('');
				
			} else {
				$('#rec-material'+index).remove();
				$('#tblSelectedMaterials tbody tr').each(function(index) {
				      $(this).find('span.no').html(index+1);
				});
			}
		},
		
		convertToJson: () =>{
			var size = $('#tblSelectedMaterials tbody tr').length;
			var materialJson = {};
			var objects = [];
			if(size > 0){
				for (var i = 0; i < size; i++) {
		    		var index = i + 1;
		    		const itemCode = $("#selected-item-code"+index).val();
		    		const itemName = $("#selected-item-name"+index).val();
		    		const itemBatch = $("#selected-item-batch"+index).val();
	        		const itemQuantity = $("#selected-item-quantity"+index).val();
	        		const itemUnit = $("#selected-item-unit"+index).val();
	        		const itemManufacturedDate = $("#selected-item-manufactured-date"+index).val();
	        		const itemExpiredDate = $('#selected-item-expired-date'+ index).val();
	        		
	        		var object = {}
	        		object['code'] = itemCode;
	        		object['name'] = itemName;
	        		object['quantity'] = itemQuantity;
	        		object['unit'] = itemUnit;
	        		object['batch'] = itemBatch;
	        		object['manufacturedDate'] = itemManufacturedDate;
	        		object['expiredDate'] = itemExpiredDate;
	        		objects.push(object);
	        		
		    	}
				materialJson['materials'] = objects;
		    	return JSON.stringify(materialJson);
			} else {
				console.log("json is null");
				return null;
			}
		},
		
		getSelectedCodes: function() {
			let selectedCodes = "";
			var hiddenElements = $("#tblSelectedMaterials").find(".selected-code");
			if (hiddenElements.length > 0) {
				var s ='';
				$.each(hiddenElements, function (i, obj) {
					s += obj.value + ",";
				});
				
				selectedCodes = s.substring(0, s.length - 1);
			}
			return selectedCodes;
		}, 
		
		checkFormTable: function(){
			var result = true;
			var indexLastRow = parseInt($("#tblSelectedMaterials").find(".index-table").last().val());
			var goodsRequisitionId = $('#goodsRequisitionId').val();
			var movementType = $('#goodsissueMovementType option:selected').val(); 
			var stockCode = $('#stockCode').val();
			for (var i = 0; i <= indexLastRow; i++) {
				var index = i;
				var itemCode = $('#'+index).val();

				let itemNameSelected = $('#selected-item-name'+index);
				var itemName = itemNameSelected.val();

				let itemActuallyExportedSelected = $('#selected-item-actuallyExported'+index);
				var itemActuallyExported = itemActuallyExportedSelected.val();

				let itemGrossWeightSelected = $('#selected-item-grossWeight'+index);
				var itemGrossWeight = itemGrossWeightSelected.val();
				var itemQuantityRetained = $('#selected-item-retained'+index).val();

				var itemTotalRetained = $('#selected-item-totalRetainedQuantity'+index).val();

				let itemBatchSelected = $('#selected-item-batch'+index);
				var itemBatch = itemBatchSelected.val();
				var itemRequiredBatch = $('#selected-item-requiredBatch'+index).val();

				let itemManufacturedDateSelected = $('#selected-item-manufacturedDate'+index);
				var itemManufacturedDate = itemManufacturedDateSelected.val();

				let itemExpiredDateSelected = $('#selected-item-expiredDate'+index);
				var itemExpiredDate = itemExpiredDateSelected.val();
				var itemNum = $('#selected-item-itemNum'+index).val();

				let itemWeightUnitSelected = $('#selected-item-weightUnit'+index);
				var itemWeightUnit = itemWeightUnitSelected.val();
				
				if(itemCode){
					var checkRow = true;
					if(goodsRequisitionId) {
						if(!itemNum){
							itemNameSelected.css("color", "red");
							itemNameSelected.css("border", "1px solid");
							result = false;
							checkRow = false;
						} else {
							itemNameSelected.removeAttr('style');
						}
					}
					//check neu itemRequiredBatch = true thi bat buoc nhap ma lo, ngay san xuat, ngay het han
					if(itemRequiredBatch == 'true'){
						if(!itemCode.includes('MAVIN')){
							if(!MaterialSelector.regexDate(itemManufacturedDate)){
								itemManufacturedDateSelected.css("color", "red");
								itemManufacturedDateSelected.css("border", "1px solid");
								result = false;
								checkRow = false;
							} else {
								itemManufacturedDateSelected.removeAttr('style');
							}
							
							if(!MaterialSelector.regexDate(itemExpiredDate)){
								itemExpiredDateSelected.css("color", "red");
								itemExpiredDateSelected.css("border", "1px solid");
								result = false;
								checkRow = false;
							} else {
								itemExpiredDateSelected.removeAttr('style');
							}
						}
						if(!itemBatch.trim()){
							itemBatchSelected.css("color", "red");
							itemBatchSelected.css("border", "1px solid");
							result = false;
							checkRow = false;
						}
					} else {
						if(itemExpiredDate && itemExpiredDate != ""){
							if(!MaterialSelector.regexDate(itemExpiredDate)){
								itemExpiredDateSelected.css("color", "red");
								itemExpiredDateSelected.css("border", "1px solid");
								result = false;
								checkRow = false;
							} else {
								itemExpiredDateSelected.removeAttr('style');
							}
						} 
						
						if(itemManufacturedDate && itemManufacturedDate != ""){
							if(!MaterialSelector.regexDate(itemManufacturedDate)){
								itemManufacturedDateSelected.css("color", "red");
								itemManufacturedDateSelected.css("border", "1px solid");
								result = false;
								checkRow = false;
							} else {
								itemManufacturedDateSelected.removeAttr('style');
							}
						} 
					}
					
					// check dieu kien neu GrossWeight < 0 va movementType != GI_CULLED_PIG: '551' // XUẤT HEO CHẾT
					if(itemCode.includes('MAVIN') && movementType != MOVEMENT_TYPE.GI_CULLED_PIG) {
						if(itemGrossWeight && itemGrossWeight != ""){
							if(!MaterialSelector.regexQuantity(itemGrossWeight)){
								itemGrossWeightSelected.css("color", "red");
								itemGrossWeightSelected.css("border", "1px solid");
								result = false;
								checkRow = false;
							} else {
								var absGrossWeight = Math.abs(itemGrossWeight); //lay gia tri tuyet doi
								if(absGrossWeight > 0){
									itemGrossWeightSelected.removeAttr('style');
								} else {
									itemGrossWeightSelected.css("color", "red");
									itemGrossWeightSelected.css("border", "1px solid");
									result = false;
									checkRow = false;
								}
							}			
						} else {
							itemGrossWeightSelected.css("color", "red");
							itemGrossWeightSelected.css("border", "1px solid");
							result = false;
							checkRow = false;
						}
						
						//check itemWeightUnit
						if(!itemWeightUnit){
							itemWeightUnitSelected.css("color", "red");
							itemWeightUnitSelected.css("border", "1px solid");
							result = false;
							checkRow = false;		
						} 
					} else {
						if(itemGrossWeight && itemGrossWeight != ""){
							if(!MaterialSelector.regexQuantity(itemGrossWeight)){
								itemGrossWeightSelected.css("color", "red");
								itemGrossWeightSelected.css("border", "1px solid");
								result = false;
								checkRow = false;
							} else {
								itemGrossWeightSelected.removeAttr('style');
							}			
						}
					}
					
					// check dieu kien neu quantity < 0 hoac chua nhap quantity thi bao loi
					if(itemActuallyExported && itemActuallyExported != ""){
						if(!MaterialSelector.regexQuantity(itemActuallyExported)){
							itemActuallyExportedSelected.css("color", "red");
							itemActuallyExportedSelected.css("border", "1px solid");
							result = false;
							checkRow = false;
						} else {
							var absTotalRetained = Math.abs(itemTotalRetained);
							var absQuantity = Math.abs(itemActuallyExported); //lay gia tri tuyet doi
							// truong hop nhap kho tu phieu thi phai check tiep so luong con lai trong phieu
							if(goodsRequisitionId){
								var absQuantityRetained = Math.abs(itemQuantityRetained); //lay gia tri tuyet doi
								
								// neu so luong nhap vao vuot qua so luong con lai trong phieu thi bao loi
								if(absQuantity > absQuantityRetained){
									itemActuallyExportedSelected.css("color", "red");
									itemActuallyExportedSelected.css("border", "1px solid");
									result = false;
									checkRow = false;
								} else {
									if(absQuantity > absTotalRetained){
										itemActuallyExportedSelected.css("color", "red");
										itemActuallyExportedSelected.css("border", "1px solid");
										result = false;
										checkRow = false;
									} else {
										itemActuallyExportedSelected.removeAttr('style');
									}
								}
							} else {
								//truong hop xuat kho vat tu binh thuong
								if(absQuantity > absTotalRetained){
									itemActuallyExportedSelected.css("color", "red");
									itemActuallyExportedSelected.css("border", "1px solid");
									result = false;
									checkRow = false;
								} else {
									itemActuallyExportedSelected.removeAttr('style');
								}
							}
						}
					} else {
						itemActuallyExportedSelected.css("color", "red");
						itemActuallyExportedSelected.css("border", "1px solid");
						result = false;
						checkRow = false;
					}
					
					
					if(!checkRow){
						$('#rec-material'+index).css("border", "2px solid red");
					} else {
						$('#rec-material'+index).css("border", "unset");
					}
				}
				
			}
			if(!result){
				$('#tblSelectedMaterials').css('overflow-x','unset');
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
		}
};
