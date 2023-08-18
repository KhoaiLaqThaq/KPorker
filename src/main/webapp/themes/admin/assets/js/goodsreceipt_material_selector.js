var MaterialSelector = {
		initdatetimepicker: () =>{
			$('.datetimepicker').daterangepicker({ 
		           singleDatePicker: true,
		           locale: {
		               format: 'YYYY-MM-DD'
		           }
		       });
		},
		
		initSelect2: () =>{
			// select2
	   	 	$('.typeSelect2').select2();
		},
		
		init: () => {
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
			
			// tu dong day data sau khi tim kiem va chon item
			$('.selected-material-code').on('select2:select', function (e) {
				var material = e.params.data;
				
				var codeId = "#" + e.target.id;
				var fi = "<option value=" + material.data.code + ">" + material.data.code + "</option>";
				$(codeId).html(fi);
				$(codeId).val(material.data.code);
				
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
	        cols += '<input type="hidden" name="materialDetails['+counter+'].quantity" id="selected-item-quantity'+counter+'" class="form-control float" value=""></td>';
	        
	        cols += '<td><input type="text" name="materialDetails['+counter+'].batch" id="selected-item-batch'+counter+'" class="form-control" value=""></td>';
	       
	        
	        cols += '<td><input type="text" name="materialDetails['+counter+'].actuallyImported" id="selected-item-actuallyImported'+counter+'" class="form-control float" value=""></td>';
	        cols += '<td><input type="text" name="materialDetails['+counter+'].unit" id="selected-item-unit'+counter+'" class="form-control" value=""></td>';
	        cols += '<td><input type="text" name="materialDetails['+counter+'].grossWeight" id="selected-item-grossWeight'+counter+'" class="form-control float" value=""></td>';
	        cols += '<td><input type="text" name="materialDetails['+counter+'].weightUnit" id="selected-item-weightUnit'+counter+'" class="form-control" value=""></td>';
	        
	        cols += '<td><select id="selected-item-type'+counter+'" name="materialDetails['+counter+'].type" class="form-control select2 typeSelect2" data-placeholder="Phân loại vật tư">';
	        cols += '<option value="1">Được sử dụng</option>';
	        cols += '<option value="2">Chờ xử lý</option></select></td>';
	        
	        cols += '<td><input type="text" name="materialDetails['+counter+'].manufacturedDateStr" id="selected-item-manufacturedDate'+counter+'" class="form-control" placeholder="dd.mm.yyyy"></td>';
	        cols += '<td><input type="text" name="materialDetails['+counter+'].expiredDateStr" id="selected-item-expiredDate'+counter+'" class="form-control" placeholder="dd.mm.yyyy"><input type="hidden" class="index-table" value="'+ counter +'"></td>';
	        cols += '<td><input type="text" name="materialDetails['+counter+'].note" id="selected-item-note'+counter+'" class="form-control" value=""></td>';
	        cols += '<td><input type="text" name="materialDetails['+counter+'].purchasingGroup" id="selected-item-purchasingGroup'+counter+'" class="form-control" value=""</td>';
	        
	        newRow.append(cols);
	        return newRow;
		},
		
		addRow: function(){
			var index = parseInt($("#tblSelectedMaterials").find(".index-table").last().val());
    		var newRow = MaterialSelector.cloneRow(index);
    		newRow.appendTo('#tblSelectedMaterials tbody');
    		MaterialSelector.init();
    		MaterialSelector.initSelect2();
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
		
		getSelectedNames: function() {
			let selectedNames = "";
			var hiddenElements = $("#tblSelectedMaterials").find(".selected-name");
			if (hiddenElements.length > 0) {
				var s ='';
				$.each(hiddenElements, function (i, obj) {
					s += obj.value + ",";
				});
				
				selectedNames = s.substring(0, s.length - 1);
			}
			return selectedNames;
		}, 
		
		checkFormTable: function(){
			var result = true;
			var indexLastRow = parseInt($("#tblSelectedMaterials").find(".index-table").last().val());
			var goodsRequisitionId = $('#goodsRequisitionId').val();
			for (var i = 0; i <= indexLastRow; i++) {
				var index = i;
				var itemCode = $('#'+index).val();
				var itemName = $('#selected-item-name'+index).val();

				let itemActuallyImportedSelected = $('#selected-item-actuallyImported'+index);
				var itemActuallyImported = itemActuallyImportedSelected.val();

				let itemGrossWeightSelected = $('#selected-item-grossWeight'+index);
				var itemGrossWeight = itemGrossWeightSelected.val();
				var itemQuantityRetained = $('#selected-item-retained'+index).val();

				let itemBatchSelected = $('#selected-item-batch'+index);
				var itemBatch = itemBatchSelected.val();
				var itemRequiredBatch = $('#selected-item-requiredBatch'+index).val();

				let itemManufacturedDateSelected = $('#selected-item-manufacturedDate'+index);
				var itemManufacturedDate = itemManufacturedDateSelected.val();

				let itemExpiredDateSelected = $('#selected-item-expiredDate'+index);
				var itemExpiredDate = itemExpiredDateSelected.val();

				let itemWeightUnitSelected = $('#selected-item-weightUnit'+index);
				var itemWeightUnit = itemWeightUnitSelected.val();
				
				if(itemCode){
					var checkRow = true;
					
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
					
					// check dieu kien neu quantity < 0 hoac chua nhap quantity thi bao loi
					if(itemActuallyImported && itemActuallyImported != ""){
						if(!MaterialSelector.regexQuantity(itemActuallyImported)){
							itemActuallyImportedSelected.css("color", "red");
							itemActuallyImportedSelected.css("border", "1px solid");
							result = false;
							checkRow = false;
						} else {
							
							// truong hop nhap kho tu phieu thi phai check tiep so luong con lai trong phieu
							if(goodsRequisitionId){
								var absQuantity = Math.abs(itemActuallyImported); //lay gia tri tuyet doi
								var absQuantityRetained = Math.abs(itemQuantityRetained); //lay gia tri tuyet doi
								
								// neu so luong nhap vao vuot qua so luong con lai trong phieu thi bao loi
								if(absQuantity > absQuantityRetained){
									itemActuallyImportedSelected.css("color", "red");
									itemActuallyImportedSelected.css("border", "1px solid");
									result = false;
									checkRow = false;
								} else {
									itemActuallyImportedSelected.removeAttr('style');
								}
							} else {
								// truong hop kiem ke
								itemActuallyImportedSelected.removeAttr('style');
							}
						}
					} else {
						itemActuallyImportedSelected.css("color", "red");
						itemActuallyImportedSelected.css("border", "1px solid");
						result = false;
						checkRow = false;
					}
					
					// check dieu kien neu grossWeight < 0
					if(itemCode.includes('MAVIN')){
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
