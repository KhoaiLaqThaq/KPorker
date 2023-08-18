var MaterialSelector = {
		initSelect2: () =>{
			// select2
	   	 	$('.typeSelect2').select2();
		},
		
		init: (stockCode) => {
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
	   	                };
	   	            },
	   	            processResults: function (data, params) {
	   	                return {
	   	                    results: $.map(data, function (item) {
	   	                        return {
	   	                        	text: item.code +": "+ item.name +" : "+ item.batch + " : "+ item.expiredDate,
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
				
				var codeId = "#" + e.target.id;
				var fi = "<option value=" + material.data.code + ">" + material.data.code + "</option>";
				$(codeId).html(fi);
				$(codeId).val(material.data.code);
				
				var nameId = "#selected-item-name" + e.target.id;
				$(nameId).val(material.data.name);
				
				var batchId = "#selected-item-batch" + e.target.id;
				var input = '<input type="text" name="materials['+e.target.id+'].batch" id="selected-item-batch'+e.target.id+'" class="form-control" value="'+material.data.batch+'">';
				$(batchId).closest('td').html(input);
				
				var requiredBatchId = "#selected-item-requiredBatch" + e.target.id;
				if(material.data.batch != null && material.data.batch != ""){
					$(requiredBatchId).val(true);
				} else {
					$(requiredBatchId).val(false);
				}
				
				var unitId = "#selected-item-unit" + e.target.id;
				var units = [];
				units = material.data.units;
				
				$(unitId).html("");
				for (let i = 0; i < units.length; i++) {
					 var fi = "<option value=" + units[i] + ">" + units[i] + "</option>";
					$(unitId).append(fi);
				}
			});
		},	
		
		cloneRow: (index) => {
			var counter = index ;
	        var newRow = $('<tr id="rec-material'+counter+'">');
	        var cols = "";

	        cols += '<td><span class="no">'+counter+'</span></td>';   
	        cols += '<td class="text-center">';
	        cols += '<div class="list-icons">';
	        cols += '<button type="button" class="btn-primary btn-xs" onclick="javascript:MaterialSelector.addRow()" title="Add Row" style="display: inline-block; float: none; border: none"><i class="fa fa-plus "></i></button>';
	        cols += '<button type="button" class="btn-danger btn-xs" onclick="javascript:MaterialSelector.removeRow('+counter+')" title="Remove Row" style="display: inline-block; float: none; border: none"><i class="fa fa-times"></i></button>';
	        cols += '</td>';
	        
	        cols += '<td><select class="form-control selected-material-code" name="materials['+counter+'].code" id="'+counter+'" data-placeholder="Chọn vật tư" data-fouc></select></td>';
	        cols += '<td><input type="text" name="materials['+counter+'].name" id="selected-item-name'+counter+'" class="form-control" value="">';   
	        cols += '<input type="hidden" name="materials['+counter+'].requiredBatch" id="selected-item-requiredBatch'+counter+'" class="form-control" value=""></td>';
	        
	        cols += '<td><input type="text" name="materials['+counter+'].batch" id="selected-item-batch'+counter+'" class="form-control" value=""></td>';
	        cols += '<td><input type="text" name="materials['+counter+'].actuallyExported" id="selected-item-actuallyExported'+counter+'" class="form-control" value="0"><input type="hidden" class="index-table" value="'+ counter +'"></td>';
	        
	        cols += '<td><select id="selected-item-unit'+counter+'" name="materials['+counter+'].unit" class="form-control select2 typeSelect2" data-placeholder="Chọn đơn vị tính"></td>';
	        
	        newRow.append(cols);
	        return newRow;
		},
		
		addRow: function(){
			var stockCode = $('#stockCode').val();
			var index = parseInt($("#tblSelectedMaterials").find(".index-table").last().val());
    		var newRow = MaterialSelector.cloneRow(index+1);
    		newRow.appendTo('#tblSelectedMaterials tbody');
    		MaterialSelector.init(stockCode);
    		MaterialSelector.initSelect2();
    		$('#tblSelectedMaterials tbody tr').each(function(index) {
			      $(this).find('span.no').html(index+1);
			});
		},
		
		removeRow: function(index){
			var size = $('#tblSelectedMaterials tbody tr').length;
			if(size == 1){
				$('#tblSelectedMaterials tbody tr').find("input:not([type=hidden])").val('');
				
			} else {
				$('#rec-material'+index).remove();
				$(this).parents(".clonableSourceRow").remove();		            
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
		
		checkFormTable: function(){
			var result = true;
			var indexLastRow = parseInt($("#tblSelectedMaterials").find(".index-table").last().val());
			for (var i = 0; i <= indexLastRow; i++) {
				var index = i;
				var itemCode = $('#'+index).val();
				let itemActuallyExported = $('#selected-item-actuallyExported'+index);
				var itemQuantity = itemActuallyExported.val();
				let itemBatchSelected = $('#selected-item-batch'+index);
				var itemBatch = itemBatchSelected.val();
				var itemRequiredBatch = $('#selected-item-requiredBatch'+index).val(); 
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
							itemActuallyExported.removeAttr('style');
						}
					} else {
						itemActuallyExported.css("color", "red");
						itemActuallyExported.css("border", "1px solid");
						result = false;
						checkRow = false;
					}
					
					if(itemRequiredBatch == 'true'){
						if(!itemBatch){
							itemBatchSelected.css("color", "red");
							itemBatchSelected.css("border", "1px solid");
							result = false;
							checkRow = false;
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
		
		regexQuantity: function(quantity){
		    var regexGoodQuantity = /^(\d*\.)?\d+$/;
		    return regexGoodQuantity.test(quantity);
		}
};
