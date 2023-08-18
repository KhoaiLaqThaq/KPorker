function changeCheckBox(index) {
	var postingDate = $('#goodsIssuePostingDate').val();
	var checkedId = "#checked" + index;
	if(postingDate || postingDate !== '') {
		var size = $('#tblSelectedProcessOrders tbody tr').length;
		if(size > 0){
			for (var i = 0; i < size; i++) {
	    		var id = i;
	    		 var uncheckedId = "#checked" + id;
	    		 $(uncheckedId).prop("checked", false);
	    	}
		}
	    $(checkedId).prop("checked", true);
	    var idProcessOrderCode = "#selected-process-order-code" + index;
	    var idProcessOrderBatch = "#selected-process-order-batch" + index;
	    var valProcessOrderCode = $(idProcessOrderCode).val();
	    var strDisplay = " : " + valProcessOrderCode + " - " + $(idProcessOrderBatch).val();
	    $('#processOrderInfo').html(strDisplay);
	    
	    var idFarmCode = "#selected-farm-code" + index;
	    var valFarmCode = $(idFarmCode).val();
	    
	    checkGoodsAttrition(valFarmCode, valProcessOrderCode, postingDate);
	    
		$.ajax({
			url: getContext() + '/api/goodsIssues/get-by-process-order',
			contextType: 'application/json',
			method: 'GET',
			data: {
				postingDate: postingDate,
				processOrderCode: valProcessOrderCode,
			},
			success: function(data) {
				if(data){
					var checkRoleDelete = $('#checkRoleDelete').val();
					$("#dataMaterials").empty();
					for (var i = 0; i < data.length; i++) {
			    		MaterialSelector.addExistedMaterial(i, data[i], checkRoleDelete);
			    	}
					formatNumberComponent.initAutoNumeric();
				}
			},
			error: function(err) {
				console.log(err)
			}
		});
	} else {
	   $(checkedId).prop("checked", false);
		bootbox.alert({
            title: 'Thông báo',
            message: 'Vui lòng chọn ngày xuất tiêu hao.'
        });
	}
}

var checkGoodsAttrition = function(stockCode, poCode, postingDate){
	$.ajax({
		url: getContext() + '/api/goodsAttritionSupport/check?postingDate='+postingDate+'&poCode='+poCode+'&stockCode='+stockCode,
		contextType: 'application/json',
		method: 'GET',
		success: function(data) {
			if(data.code != 200){
				bootbox.alert({
		            title: 'Thông báo',
		            message: data.message
		        });
			}
		},
		error: function(err) {
			console.log(err)
		}
	});
}

const MATERIAL_TYPE = {
		USED: '1',
		WATTING: '2',
		DELETE: '3'
};

const MATERIAL_STATUS = {
		WATTING: 'watting',
		SYCNCHRONIZED: 'synchronized',
		NEW: 'new'
};

const ACTION = {
		COPY: 'copy'
};

const MATERIAL_STATUS_VN = {
		WATTING: 'Chờ đồng bộ',
		SYCNCHRONIZED: 'Đã đồng bộ',
		NEW: 'tạo mới'
};

function resetModal() {
  $("#materialCode").val("");
  $("#materialName").val("");
  $("#materialUnit").val("");
  $("#materialSuggestName").val("");
  $("#materialBatch").val("");
  $("#bodySearchMaterial").empty();
}

function showModal() {
  resetModal();
  $("#searchMaterial").modal("show");
}

const CHECK_ROLE_DELETE = {
		ACTIVE: 'active', //cho phép xóa những item có trạng thái đã đồng bộ
		INACTIVE: 'inactive' //không phép xóa những item có trạng thái đã đồng bộ
};

var FormComponent = function() {
	
	var searchMaterial = function() {
		$('#btnSearchMaterial').on('click',function(e){
			var idCheckBox = $('input[class="item-check"]:checked').val();
			var postingDate = $('#goodsIssuePostingDate').val();
			if(idCheckBox || postingDate || postingDate !== '') {
				var idFarmCode = "#selected-farm-code" + idCheckBox;
		    	var farmCode = $(idFarmCode).val();
		    	var materialCode = $("#materialCode").val();
		    	var materialName = $("#materialName").val();
		    	var materialSuggestName = $("#materialSuggestName").val();
		    	var materialFastCode = $("#materialFastCode").val();
		    	var materialBatch = $("#materialBatch").val();
		    	$.ajax({
					url: getContext() + '/api/materialSupport/search',
					contextType: 'application/json',
					method: 'GET',
					data: {
						farmCode: farmCode,
						materialCode: materialCode,
						materialName: materialName,
						materialSuggestName: materialSuggestName,
						materialFastCode: materialFastCode,
						materialBatch: materialBatch,
						postingDate: postingDate
					},
					success: function(data) {
						if(data.length > 0){
							$("#bodySearchMaterial").empty();
							$("#checkAll").prop("checked", false);
							for (let i = 0; i < data.length; i++) {
								var newRow = MaterialSelector.cloneRowTableSearch(i,data[i]);
					    		newRow.appendTo('#tblMaterials tbody');
							}
						}
					},
					error: function(err) {
						console.log(err)
					}
				});
			} else {
				$("#searchMaterial").modal('hide');
				bootbox.alert({
	                title: "Thông báo:",
	                message: "Vui lòng chọn lệnh sản xuất trước khi thực hiện tìm kiếm vật tư",
	            });
			}
		});
	};
	
	var checkAll = function(){
		$('body').on('change', '#checkAll', function () {
		    var list = $(this).closest('table').find("input[name='material[]']");
		    var checked_status = this.checked;
		    $.each(list, function (i, val) {
		        list[i].checked = checked_status;
		    });
		});
	}
	
	var addMaterial = function() {
		$('#btnAddMaterial').on('click',function(e){
			var ids = [];
        	$('input[class="material-check"]:checked').each(function() {
        		ids.push(this.value);
     		});
        	if(ids.length > 0){
				for (let i = 0; i < ids.length; i++) {
					var nameId = "#selected-material-name" + ids[i];
					var suggestNameId = "#selected-material-suggestName" + ids[i];
					var unitId = "#selected-material-unit" + ids[i];
					var codeId = "#selected-material-code" + ids[i];
					var batchId = "#selected-material-batch" + ids[i];
					var totalRetainedId = "#selected-material-total-retained-quantity" + ids[i];
					var quantityId = "#selected-material-quantity" + ids[i];
					var code = $(codeId).val();
					var name = $(nameId).val();
					var suggestName = $(suggestNameId).val();
					var batch = $(batchId).val();
					var unit = $(unitId).val();
					var totalRetained = $(totalRetainedId).val();
					var quantity = $(quantityId).val();
					MaterialSelector.addRow(code,name,suggestName,batch,unit,totalRetained,quantity,MATERIAL_TYPE.USED);
				}
				formatNumberComponent.initAutoNumeric();
				resetModal();
			}
			
		});
	};
	
	var initForm = function() {
        if (!$().select2) {
            return;
        }
    	// select2
   	 	$('.select2').select2();
   	 	
   	 	let currentPosting = $("#goodsIssuePostingDate").val();
   	 	let stockCode = $("#stockCode").val();
   	 	
   	 	if(currentPosting && currentPosting != "" && stockCode && stockCode != ""){
			$('#pleaseWaitDialog').modal();
			$.ajax({
				url: getContext() + '/api/processOrder/checkGA?postingDate='+currentPosting+'&stockCode='+stockCode,
				contextType: 'application/json',
				method: 'GET',
				success: function(data) {
					var str = " ";
					str += '<div style="height: 400px;  overflow: scroll;"><table class="table table-bordered"><tbody>';
					
					data.forEach(function(item){
						str = str + '<tr><td>'+item?.barn?.farm?.name+'</td><td>'+item?.code+'</td></tr>';
					});
					
					str += '</tbody></table></div>';
					
					bootbox.alert({
			            title: 'Danh sách lệnh sản xuất chưa xuất tiêu hao ngày '+currentPosting+': '+ data.length,
			            message: str
			        });
					console.log(data);
					$('#pleaseWaitDialog').modal("hide");
				},
				error: function(err) {
					console.log(err)
				}
			});
		}
   	 	
	}
	
    // Switchery
    var initSwitchery = function() {
        if (typeof Switchery == 'undefined') {
            return;
        }
        // Initialize multiple switches
        var elems = Array.prototype.slice.call(document.querySelectorAll('.form-check-input-switchery'));
        elems.forEach(function(html) {
          var switchery = new Switchery(html);
        });
    };
    
    // Bootstrap switch
    var initBootstrapSwitch = function() {
        if (!$().bootstrapSwitch) {
            return;
        }
        // Initialize
        $('.form-check-input-switch').bootstrapSwitch();
        // bootbox
        if (typeof bootbox == 'undefined') {
            console.warn('Warning - bootbox.min.js is not loaded.');
            return;
        }
    };
    
    // Daterange picker
    var pickerDate = function() {
          if (!$().daterangepicker) {
            console.warn('Warning - daterangepicker.js is not loaded.');
            return;
        }
        // Single picker
       $('.daterange-single').daterangepicker({ 
           singleDatePicker: true,
           locale: {
        	   format: 'DD-MM-YYYY'
           },
		   autoUpdateInput: false
       });
    };
	
    var submitForm = function(){
		$('#btnSubmit').on('click',function(e){
			var action = $('#action').val();
			if(action){
				if(action == ACTION.COPY){
					bootbox.confirm({
						title: "Xác nhận:",
					    message: "Việc này đồng nghĩa với việc bạn sẽ copy dữ liệu mới từ ngày bạn đã chọn. Bạn có chắc chắn không?",
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
					    		$('#pleaseWaitDialog').modal();
					    		formatNumberComponent.disableAutoNumeric();
					    		var farmcode = $('#farmCode').val();
								$('#stockCode').val(farmcode);
								$('#fromStockCode').val(farmCode);
								//set lai ngay thang nam
								var postingDate = $('#goodsIssuePostingDate').val();
								var str = postingDate.split('-');
								var month = Math.abs(str[1]) - 1; //// the month is 0-indexed
								document.getElementById("postingDate").value = new Date(str[2], month, str[0]).toLocaleDateString('en-GB');
								$('#goodsAttritionSupportForm').attr('action', '/goodsAttritionSupport/save');
								$('#goodsAttritionSupportForm').submit();
					    	}
					    }
					});
				} else {
					var idCheckBox = $('input[class="item-check"]:checked').val();
					if(idCheckBox) {
						formatNumberComponent.disableAutoNumeric();
						var checkError = MaterialSelector.checkFormTable();
			    		if(!checkError) {
							bootbox.alert({
			                    title: "Thông báo:",
			                    message: "Có một số dữ liệu không chính xác hoặc không đúng định dạng. Vui lòng kiểm tra lại thông tin trong bảng thông tin vật tư.",
			                });
							formatNumberComponent.initAutoNumeric();
						} else {
							$('#pleaseWaitDialog').modal();
							var idFarmCode = "#selected-farm-code" + idCheckBox;
					    	var farmCode = $(idFarmCode).val();
					    	
					    	var idProcessOrderCode = "#selected-process-order-code" + idCheckBox;
					    	var processOrderCode = $(idProcessOrderCode).val();
					    	$('#processOrderCode').val(processOrderCode);
					    	//set lai ngay thang nam
							var postingDate = $('#goodsIssuePostingDate').val();
							var str = postingDate.split('-');
							var month = Math.abs(str[1]) - 1; //// the month is 0-indexed
							document.getElementById("postingDate").value = new Date(str[2], month, str[0]).toLocaleDateString('en-GB');
							
							$('#stockCode').val(farmCode);
							$('#fromStockCode').val(farmCode);
							
							$('#goodsAttritionSupportForm').attr('action', '/goodsAttritionSupport/save');
							$('#goodsAttritionSupportForm').submit();
						}
					} else {
						$("#searchMaterial").modal('hide');
						bootbox.alert({
			                title: "Thông báo:",
			                message: "Vui lòng chọn lệnh sản xuất trước bấm lưu",
			            });
					}
				}
			} else {
				bootbox.alert({
	                title: "Thông báo:",
	                message: "Có lỗi xảy ra.",
	            });
			}
		});
	};
    
	var changeDate = function(){
		$('#goodsIssuePostingDate').on('apply.daterangepicker', function(ev, picker) {
			$(this).val(picker.startDate.format('DD-MM-YYYY'));
			var postingDate = picker.startDate.format('DD-MM-YYYY');
			// var stockCode = $('#stockCode').val();
			var ids = [];
        	$('input[class="item-check"]:checked').each(function() {
        		ids.push(this.value);
     		});
        	
        	if(ids.length > 0){
        		var idProcessOrderCode = "#selected-process-order-code" + ids[0];
        	    var valProcessOrderCode = $(idProcessOrderCode).val();
        		
        		$.ajax({
        			url: getContext() + '/api/goodsIssues/get-by-process-order',
        			contextType: 'application/json',
        			method: 'GET',
        			data: {
        				postingDate: postingDate,
        				processOrderCode: valProcessOrderCode
        			},
        			success: function(data) {
        				if(data){
        					var checkRoleDelete = $('#checkRoleDelete').val();
        					$("#dataMaterials").empty();
        					for (var i = 0; i < data.length; i++) {
        			    		MaterialSelector.addExistedMaterial(i, data[i], checkRoleDelete);
        			    	}
        					formatNumberComponent.initAutoNumeric();
        				}
        			},
        			error: function(err) {
        				console.log(err)
        			}
        		});
        		
        		$.ajax({
    				url: getContext() + '/api/goodsAttritionSupport/get-process-order-codes',
    				contextType: 'application/json',
    				method: 'GET',
    				data: {
    					postingDate: postingDate
    				},
    				success: function(data) {
    					if(data){
    						var size = $('#tblSelectedProcessOrders tbody tr').length;
    						if(size > 0){
    							for (var i = 0; i < size; i++) {
    					    		var id = i;
    					    		var idProcessOrderCode = "#selected-process-order-code" + id;
    					    		var idProcessOrderStatus = "#selected-process-order-status" + id;
    					    		var valProcessOrderCode = $(idProcessOrderCode).val();
    					    		if(data.includes(valProcessOrderCode)){
    					    			$(idProcessOrderStatus).val("Đã cập nhật");
										$(idProcessOrderStatus).addClass('text-success').removeClass('text-danger');
    					    		} else {
    					    			$(idProcessOrderStatus).val("Chưa cập nhật");
										$(idProcessOrderStatus).addClass('text-danger').removeClass('text-success');
    					    		}
    					    	}
    						}
    					}
    				},
    				error: function(err) {
    					console.log(err)
    				}
    			});
        	} else {
        		$.ajax({
    				url: getContext() + '/api/goodsAttritionSupport/get-process-order-codes',
    				contextType: 'application/json',
    				method: 'GET',
    				data: {
    					postingDate: postingDate
    				},
    				success: function(data) {
    					if(data){
    						var size = $('#tblSelectedProcessOrders tbody tr').length;
    						if(size > 0){
    							for (var i = 0; i < size; i++) {
    					    		var id = i;
    					    		var idProcessOrderCode = "#selected-process-order-code" + id;
    					    		var idProcessOrderStatus = "#selected-process-order-status" + id;
    					    		var valProcessOrderCode = $(idProcessOrderCode).val();
    					    		if(data.includes(valProcessOrderCode)){
    					    			$(idProcessOrderStatus).val("Đã cập nhật");
										$(idProcessOrderStatus).addClass('text-success').removeClass('text-danger');
    					    		} else {
    					    			$(idProcessOrderStatus).val("Chưa cập nhật");
										$(idProcessOrderStatus).addClass('text-danger').removeClass('text-success');
    					    		}
    					    	}
    						}
    					}
    				},
    				error: function(err) {
    					console.log(err)
    				}
    			});
        	}
		});
	};
	

	var enterPressToAddMaterialsForTable = function() {
		document.addEventListener('keypress', function(e) {
			if (e.key === 'Enter') {
				var rowsChecked = $('input[class="material-check"]:checked') && $('input[class="material-check"]:checked').length;
				if (rowsChecked > 0) {
					$('#btnAddMaterial').click();
				} else {
					$('#btnSearchMaterial').click();
				}
			}
		});
	}
	
	var checkPoGoodsAttrition = function(){
		$('#goodsIssuePostingDate').on('apply.daterangepicker', (e, picker) => {
			$('#pleaseWaitDialog').modal();
			let postingDate = $('#goodsIssuePostingDate').val();
			$.ajax({
				url: getContext() + '/api/processOrder/checkGA?postingDate='+postingDate,
				contextType: 'application/json',
				method: 'GET',
				success: function(data) {
					if (data && Array.isArray(data)) {
						var str = " ";
						str += '<div style="height: 400px;  overflow: scroll;"><table class="table table-bordered"><tbody>';

						data.forEach(function(item){
							str = str + '<tr><td>'+item?.barn?.farm?.name+'</td><td>'+item.code+'</td></tr>';
						});

						str += '</tbody></table></div>';

						bootbox.alert({
							title: 'Danh sách lệnh sản xuất chưa xuất tiêu hao ngày hiện tại: '+ data.length,
							message: str
						});
					}
				},
				error: function(err) {
					console.log(err)
				}
			}).always(() => $('#pleaseWaitDialog').modal("hide"));
		});
	}
	
    return {
        init: function() {
        	initForm();
        	initBootstrapSwitch();
        	initSwitchery();
        	pickerDate();
        	searchMaterial();
        	checkAll();
        	addMaterial();
        	submitForm();
        	changeDate();
			enterPressToAddMaterialsForTable();
			checkPoGoodsAttrition();
        }
    }
}();

var Custom = {
		checkStatus: () => {
			var postingDate = $('#goodsIssuePostingDate').val();
			$.ajax({
				url: getContext() + '/api/goodsAttritionSupport/get-process-order-codes',
				contextType: 'application/json',
				method: 'GET',
				data: {
					postingDate: postingDate
				},
				success: function(data) {
					if(data){
						var size = $('#tblSelectedProcessOrders tbody tr').length;
						if(size > 0){
							for (var i = 0; i < size; i++) {
					    		var id = i;
					    		var idProcessOrderCode = "#selected-process-order-code" + id;
					    		var idProcessOrderStatus = "#selected-process-order-status" + id;
					    		var valProcessOrderCode = $(idProcessOrderCode).val();
					    		if(data.includes(valProcessOrderCode)){
					    			$(idProcessOrderStatus).val("Đã cập nhật");
									$(idProcessOrderStatus).addClass('text-success').removeClass('text-danger');
					    		} else {
					    			$(idProcessOrderStatus).val("Chưa cập nhật");
									$(idProcessOrderStatus).addClass('text-danger').removeClass('text-success');
					    		}
					    	}
						}
					}
				},
				error: function(err) {
					console.log(err)
				}
			});
		},
}

document.addEventListener('DOMContentLoaded', function() {
	FormComponent.init();
	Custom.checkStatus();
	formatNumberComponent.initAutoNumeric();
});
