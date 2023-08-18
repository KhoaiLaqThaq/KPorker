var MaterialSelector = {
		initSelect2: () =>{
			// select2
	   	 	$('.typeSelect2').select2();
		},
		
		cloneNewRow: (index) => {
			var counter = index + 1;
	        var newRow = $('<tr id="rec-material'+counter+'">');
	        var cols = "";

	        cols += '<td><span class="no">'+counter+'</span></td>';   
	        cols += '<td class="text-center">';
	        cols += '<div class="list-icons">';
//	        cols += '<button type="button" class="btn-primary btn-xs" onclick="javascript:MaterialSelector.addNewRow('+counter+')" data-toggle="modal" style="display: inline-block; float: none; border: none"><i class="fa fa-plus "></i></button>';
	        cols += '<button type="button" class="btn-danger btn-xs" onclick="javascript:MaterialSelector.removeRow('+counter+')" title="Remove Row" style="display: inline-block; float: none; border: none"><i class="fa fa-times"></i></button>';
	        cols += '</td>';
	        cols += '<td><input type="text" class="form-control" name="materials['+counter+'].code" id="'+counter+'" value="" readonly="readonly"></input></td>';
	        cols += '<td><input type="text" name="materials['+counter+'].suggestName" id="selected-item-suggestName'+counter+'" class="form-control" value="" readonly="readonly">';
	        cols += '<input type="hidden" name="materials['+counter+'].name" id="selected-item-name'+counter+'" class="form-control" value=""></td>';
	        cols += '<td><input type="text" name="materials['+counter+'].batch" id="selected-item-batch'+counter+'" class="form-control" value="" readonly="readonly"></td>';
	        cols += '<td><input type="text" name="materials['+counter+'].actuallyExported" id="selected-item-actuallyExported'+counter+'" class="form-control" value="0"><input type="hidden" class="index-table" value="'+ counter +'"></td>';
	        cols += '<td><input type="text" class="form-control" name="materials['+counter+'].unit" value="" readonly="readonly"></input></td>';
	        
	        newRow.append(cols);
	        return newRow;
		},
		
		addNewRow: function(){
			var index = parseInt($("#tblSelectedMaterials").find(".index-table").last().val());
    		var newRow = MaterialSelector.cloneNewRow(index);
    		newRow.appendTo('#tblSelectedMaterials tbody');
    		$('#tblSelectedMaterials tbody').find(".showTr").each(function(index) {
			      $(this).find('span.no').html(index+1);
			});
		},
		
		cloneRow: (index,code,name,batch,unit,suggestName,totalRetained,quantity,type) => {
			var counter = index ;
	        var newRow = $('<tr id="rec-material'+counter+'" class="showTr">');
	        var cols = "";

	        cols += '<td><span class="no">'+counter+'</span></td>';   
	        cols += '<td class="text-center">';
	        cols += '<div class="list-icons">';
//	        cols += '<button type="button" class="btn-primary btn-xs" onclick="javascript:MaterialSelector.addNewRow('+counter+')" data-toggle="modal" style="display: inline-block; float: none; border: none"><i class="fa fa-plus "></i></button>';
	        cols += '<button type="button" class="btn-danger btn-xs" onclick="javascript:MaterialSelector.removeRow('+counter+')" title="Remove Row" style="display: inline-block; float: none; border: none"><i class="fa fa-times"></i></button>';
	        cols += '</td>';
	     
	        cols += '<td><input type="text" class="form-control" name="materialDetails['+counter+'].code" id="'+counter+'" value="'+code+'" readonly="readonly"></input></td>';
	        cols += '<td><input type="text" name="materialDetails['+counter+'].suggestName" id="selected-item-suggestName'+counter+'" class="form-control" value="'+suggestName+'" readonly="readonly">';
	        cols += '<input type="hidden" name="materialDetails['+counter+'].name" id="selected-item-name'+counter+'" class="form-control" value="'+name+'"></td>';
	        cols += '<td><input type="text" name="materialDetails['+counter+'].batch" id="selected-item-batch'+counter+'" class="form-control" value="'+batch+'" readonly="readonly"></td>';
	        cols += '<td><input type="text" name="materialDetails['+counter+'].actuallyExported" id="selected-item-actuallyExported'+counter+'" class="form-control float" value="' + quantity + '"><input type="hidden" class="index-table" value="'+ counter +'"></td>';
	        cols += '<td><input type="text" name="materialDetails['+counter+'].totalRetainedQuantity" id="selected-item-totalRetainedQuantity'+counter+'" class="form-control float" value="'+totalRetained+'" readonly="readonly"></td>';
	        cols += '<td><input type="text" class="form-control" name="materialDetails['+counter+'].unit" value="'+unit+'" readonly="readonly"></input>';
	        cols += '<input type="hidden" class="form-control" name="materialDetails['+counter+'].type" id="selected-item-type'+counter+'" value="'+type+'" readonly="readonly"></input></td>';
	        cols += '<td><input type="text" class="form-control" name="materialDetails['+counter+'].status" value="'+MATERIAL_STATUS_VN.NEW+'" readonly="readonly"></input>';
	        cols += '<input type="hidden" class="form-control" name="materialDetails['+counter+'].transCodeItem" id="selected-item-transCodeItem'+counter+'" value=""></input></td>'
	        
	        newRow.append(cols);
	        return newRow;
		},
		
		addRow: function(code, name,suggestName,batch,unit,totalRetained,quantity,type){
			var index = parseInt($("#tblSelectedMaterials").find(".index-table").last().val());
    		var newRow = MaterialSelector.cloneRow(index+1,code,name,batch,unit,suggestName,totalRetained,quantity,type);
    		newRow.appendTo('#tblSelectedMaterials tbody');
    		
    		var materialCodeRow0 = $('#0').val();
    		if(!materialCodeRow0){
    			$('#rec-material'+0).remove();
    		}
    		$('#tblSelectedMaterials tbody').find(".showTr").each(function(index) {
			      $(this).find('span.no').html(index+1);
			});
		},
		
		removeRow: function(index){
			var size = $('#tblSelectedMaterials tbody tr').length;
			var itemType = $('#selected-item-type'+index).val();
			if(size == 1){
				// voi trang thai la 'cho xu ly' == '2' (tức là đã trừ tồn kho thì set type = '3' == 'delete'
				if(itemType === MATERIAL_TYPE.WATTING) {
					bootbox.confirm({
						title: "Xác nhận:",
					    message: "Dữ liệu vật tư này đã được ghi nhận tồn kho, việc xóa vật tư này sẽ revert lại số lượng trong tồn kho. Bạn có chắc chắn không?",
					    buttons: {
					        confirm: {
					            label: 'Xác nhận',
					            className: 'btn-success'
					        },
					        cancel: {
					            label: 'Từ chối',
					            className: 'btn-danger'
					        }
					    },
					    callback: function (result) {
					    	if(result){
					    		$('#rec-material'+index).removeClass("showTr").addClass("hideTr");
					    		$('#selected-item-type'+index).val(MATERIAL_TYPE.DELETE);
					    		$('#rec-material'+index).hide();
					    		$('#tblSelectedMaterials tbody').find(".showTr").each(function(index) {
									$(this).find('span.no').html(index+1);
								});
					    	}
					    }
					});
				} else {
					$('#tblSelectedMaterials tbody tr').find("input:not([type=hidden])").val('');
				}
			} else {
				// voi trang thai la 'cho xu ly' == '2' (tức là đã trừ tồn kho thì set type = '3' == 'delete'
				if(itemType === MATERIAL_TYPE.WATTING) {
					bootbox.confirm({
						title: "Xác nhận:",
					    message: "Dữ liệu vật tư này đã được ghi nhận tồn kho, việc xóa vật tư này sẽ revert lại số lượng trong tồn kho. Bạn có chắc chắn không?",
					    buttons: {
					        confirm: {
					            label: 'Xác nhận',
					            className: 'btn-success'
					        },
					        cancel: {
					            label: 'Từ chối',
					            className: 'btn-danger'
					        }
					    },
					    callback: function (result) {
					    	if(result){
					    		$('#rec-material'+index).removeClass("showTr").addClass("hideTr");
					    		$('#selected-item-type'+index).val(MATERIAL_TYPE.DELETE);
					    		$('#rec-material'+index).hide();
					    		$('#tblSelectedMaterials tbody').find(".showTr").each(function(index) {
									$(this).find('span.no').html(index+1);
								});
					    	}
					    }
					});
				} else {
					$('#rec-material'+index).remove();
					$(this).parents(".clonableSourceRow").remove();		            
					$('#tblSelectedMaterials tbody').find(".showTr").each(function(index) {
					      $(this).find('span.no').html(index+1);
					});
				}
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
			for (var i = 0; i <= indexLastRow; i++) {
				var index = i;
				var itemCode = $('#'+index).val();
				let itemActuallyExported = $('#selected-item-actuallyExported'+index);
				var itemQuantity = itemActuallyExported.val();
				var itemTotalRetainedQuantity = $('#selected-item-totalRetainedQuantity'+index).val();
				var itemType = $('#selected-item-type'+index).val();
				if(itemCode){
					var checkRow = true;
					// check dieu kien neu quantity < 0 hoac chua nhap quantity thi bao loi
					if(itemQuantity && itemQuantity !== ""){
						if(!MaterialSelector.regexQuantity(itemQuantity)){
							itemActuallyExported.css("color", "red");
							itemActuallyExported.css("border", "1px solid");
							result = false;
							checkRow = false;
						} else {
							if(itemType === MATERIAL_TYPE.USED){
								if(parseFloat(itemQuantity) > 0){
									if(parseFloat(itemTotalRetainedQuantity) >= parseFloat(itemQuantity)){
										itemActuallyExported.removeAttr('style');
									} else {
										itemActuallyExported.css("color", "red");
										itemActuallyExported.css("border", "1px solid");
										result = false;
										checkRow = false;
									}
								} else {
									itemActuallyExported.css("color", "red");
									itemActuallyExported.css("border", "1px solid");
									result = false;
									checkRow = false;
								}
							} else {
								if(parseFloat(itemQuantity) > 0){
									itemActuallyExported.removeAttr('style');
								} else {
									itemActuallyExported.css("color", "red");
									itemActuallyExported.css("border", "1px solid");
									result = false;
									checkRow = false;
								}
							}
						}
					} else {
						itemActuallyExported.css("color", "red");
						itemActuallyExported.css("border", "1px solid");
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
		
		regexQuantity: function(quantity){
		    var regexGoodQuantity = /^(\d*\.)?\d+$/;
		    return regexGoodQuantity.test(quantity);
		},
		
		cloneRowTableSearch: (index,data) => {
			var counter = index ;
	        var newRow = $('<tr id="rec-material-search'+counter+'">');
	        var cols = "";
	        cols += '<td><input type="checkbox" class="material-check" name="material[]" id="materialChecked'+counter+'" value="'+counter+'"></td>';   
	        cols += '<td><input type="text" id="selected-material-code'+counter+'" class="form-control" value="'+data.code+'" readonly="readonly"></td>';
	        cols += '<td><input type="text" id="selected-material-suggestName'+counter+'" class="form-control" value="'+data.suggestName+'" readonly="readonly"></td>';
	        cols += '<td><input type="text" id="selected-material-fastCode'+counter+'" class="form-control" value="'+data.fastCode+'" readonly="readonly"></td>';
	        cols += '<td><input type="text" id="selected-material-batch'+counter+'" class="form-control" value="'+data.batch+'" readonly="readonly"></td>';
	        cols += '<td><input type="text" id="selected-material-quantity'+counter+'" class="form-control float"></td>';	
	        cols += '<td><input type="text" id="selected-material-total-retained-quantity'+counter+'" class="form-control" value="'+data.totalRetainedQuantity+'" readonly="readonly"></td>';
	        cols += '<td><input type="text" id="selected-material-unit'+counter+'" class="form-control" value="'+data.unit+'" readonly="readonly"></td>';
	        cols += '<td><input type="text" id="selected-material-name'+counter+'" class="form-control" value="'+data.name+'" readonly="readonly"></td>';
	        
	        newRow.append(cols);
	        return newRow;
		},
		
		addExistedMaterial: (index,data, roleDelete) => {
			var counter = index;
	        var newRow = $('<tr id="rec-material'+counter+'" class="showTr">');
	        var cols = "";

	        cols += '<td><span class="no">'+counter+'</span></td>';   
	        cols += '<td class="text-center">';
	        cols += '<div class="list-icons">';
	        
	        if(data.status !== MATERIAL_STATUS.SYCNCHRONIZED || roleDelete === CHECK_ROLE_DELETE.ACTIVE){
	        	cols += '<button type="button" class="btn-danger btn-xs" onclick="javascript:MaterialSelector.removeRow('+counter+')" title="Remove Row" style="display: inline-block; float: none; border: none"><i class="fa fa-times"></i></button>';
	        }
        	cols += '</td>';
	        
	        cols += '<td><input type="text" class="form-control" name="materialDetails['+counter+'].code" id="'+counter+'" value="'+data.code+'" readonly="readonly"></input></td>';
	        cols += '<td><input type="text" name="materialDetails['+counter+'].suggestName" id="selected-item-suggestName'+counter+'" class="form-control" value="'+data.suggestName+'" readonly="readonly">';
	        cols += '<input type="hidden" name="materialDetails['+counter+'].name" id="selected-item-name'+counter+'" class="form-control" value="'+data.name+'" readonly="readonly"></td>';
	        cols += '<td><input type="text" name="materialDetails['+counter+'].batch" id="selected-item-batch'+counter+'" class="form-control" value="'+data.batch+'" readonly="readonly"></td>';
	        cols += '<td><input type="text" name="materialDetails['+counter+'].actuallyExported" id="selected-item-actuallyExported'+counter+'" class="form-control float" value="'+data.actuallyExported+'" readonly="readonly"><input type="hidden" class="index-table" value="'+ counter +'"></td>';
	        if(data.totalRetainedQuantity > 0){
	        	cols += '<td><input type="text" name="materialDetails['+counter+'].totalRetainedQuantity" id="selected-item-totalRetainedQuantity'+counter+'" class="form-control float" value="'+data.totalRetainedQuantity+'" readonly="readonly"></td>';
	        } else {
	        	cols += '<td><input type="text" name="materialDetails['+counter+'].totalRetainedQuantity" id="selected-item-totalRetainedQuantity'+counter+'" class="form-control float" value="" readonly="readonly"></td>';
	        }
	        cols += '<td><input type="text" class="form-control" name="materialDetails['+counter+'].unit" value="'+data.unit+'" readonly="readonly"></input>';
	        cols += '<input type="hidden" class="form-control" name="materialDetails['+counter+'].type" id="selected-item-type'+counter+'" value="'+data.type+'"></input></td>'
	        
	        if(data.status === MATERIAL_STATUS.SYCNCHRONIZED){
	        	cols += '<td><input type="text" class="form-control" name="materialDetails['+counter+'].status" value="'+MATERIAL_STATUS_VN.SYCNCHRONIZED+'" readonly="readonly"></input>';
	        } else  if(data.status === MATERIAL_STATUS.WATTING){
	        	cols += '<td><input type="text" class="form-control" name="materialDetails['+counter+'].status" value="'+MATERIAL_STATUS_VN.WATTING+'" readonly="readonly"></input>';
	        } else {
	        	cols += '<td><input type="text" class="form-control" name="materialDetails['+counter+'].status" value="'+MATERIAL_STATUS_VN.NEW+'" readonly="readonly"></input>';
	        }
	        cols += '<input type="hidden" class="form-control" name="materialDetails['+counter+'].transCodeItem" id="selected-item-transCodeItem'+counter+'" value="'+data.transCodeItem+'"></input></td>';
	        
	        newRow.append(cols);
	        newRow.appendTo('#tblSelectedMaterials tbody');
	        $('#tblSelectedMaterials tbody').find(".showTr").each(function(index) {
			      $(this).find('span.no').html(index+1);
			});
		},
		
		
		addProcessOrder: (index,data) => {
			var counter = index ;
	        var newRow = $('<tr id="rec-process-order'+counter+'" class="tr showable">');
	        var cols = "";
	        cols += '<td><input type="checkbox" class="item-check" name="item[]" id="checked'+counter+'" value="'+counter+'" onchange="changeCheckBox('+counter+')"></td>';   
	        cols += '<td><input type="text" id="selected-farm-code'+counter+'" class="form-control" value="'+data.farmCode+'" readonly="readonly"></td>';
	        cols += '<td><input type="text" id="selected-farm-name'+counter+'" class="form-control" value="'+data.farmName+'" readonly="readonly"></td>';
	        cols += '<td><input type="text" id="selected-process-order-batch'+counter+'" class="form-control" value="'+data.batch+'" readonly="readonly"></td>';
	        cols += '<td><input type="text" id="selected-process-order-code'+counter+'" class="form-control" value="'+data.code+'" readonly="readonly"></td>';
	        if(data.status == MATERIAL_STATUS.SYCNCHRONIZED) {
	        	cols += '<td><input type="text" id="selected-process-order-status'+counter+'" class="form-control text-success" value="Đã cập nhật" readonly="readonly"></td>';
	        } else {
	        	cols += '<td><input type="text" id="selected-process-order-status'+counter+'" class="form-control text-danger" value="Chưa cập nhật" readonly="readonly"></td>';
	        }
	        newRow.append(cols);
	        newRow.appendTo('#tblSelectedProcessOrders tbody');
	        $('#tblSelectedProcessOrders tbody').each(function(index) {
			      $(this).find('span.no').html(index+1);
			});
		},
};
