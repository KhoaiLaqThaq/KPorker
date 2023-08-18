const PR_TYPE = {
		WEEK: 'Z1', // dự trù tuần
		MONTH: 'Z6' // dữ trù tháng
};

const TYPE = {
		TEMPLATE: 'template', // TEMPLATE
		PR_FROM_APP: 'pr_from_pigfarm' // PR TỪ APP
};

const STATUS = {
		UNCONFIRMED: 'unconfirmed', // CHƯA XÁC NHẬN
		CONFIRMED: 'confirmed', // XÁC NHẬN 
		CANCEL: 'cancel' // HỦY 
};

var Component = function() {
	var initForm = function() {
        if (!$().select2) {
            return;
        }
    	// select2
   	 	$('.select2').select2();
   	 	
	  	//Kiểm tra thông tin chọn mã kho và ngày dự kiến
	  	$(document).on('click', '.select2ContainerPRWeek', function(e){
			var select2 = $(this).find(".selected-material-code").last();
			if(select2.is(':disabled')){
				bootbox.alert({
		            title: 'Thông báo',
		            message: 'Vui lòng chọn mã kho'
		        });
			}
		});
		
		$(document).on('click', '.select2ContainerPRMonth', function(e){
			var select2 = $(this).find(".selected-material-code").last();
			if(select2.is(':disabled')){
				bootbox.alert({
		            title: 'Thông báo',
		            message: 'Vui lòng chọn mã kho'
		        });
			}
		});
		
		//load thông tin tồn kho sau khi chọn kho
		$("#purchaserequisitionStockCode").on('change', function(e){
			var prTypeSelected = $("#purchaserequisitionPrType").val();
			if(prTypeSelected == PR_TYPE.WEEK){
				MaterialSelector.getMaterialPRWeek();
			} else {
				MaterialSelector.getMaterialPRMonth();
			}
		});
		
		//kiểm tra trạng thái tạo mới hay chỉnh sửa
		var id = $("#prId").val();
		if(id != null && id != ''){
			var prTypeSelected = $("#purchaserequisitionPrType").val();
			if(prTypeSelected == PR_TYPE.WEEK){
				MaterialSelector.getMaterialPRWeek();
			} else {
				MaterialSelector.getMaterialPRMonth();
			}
		}
	}
	
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
           }
       });
    };
    
    var initSelector = function() {
    	var prType = $("#purchaserequisitionPrType").val();
    	MaterialSelector.init(prType);
    };
    
	var validateForm = function(){
		$('#purchaserequisitionForm').validate({
			ignore: 'input[type=hidden], .select2-search__field', // ignore hidden fields
		    errorClass: 'validation-invalid-label',
		    successClass: 'validation-valid-label',
		    validClass: 'validation-valid-label',
		    highlight: function(element, errorClass) {
		        $(element).removeClass(errorClass);
		    },
		    unhighlight: function(element, errorClass) {
		        $(element).removeClass(errorClass);
		    },
		    errorPlacement: function(error, element) {

		        // Unstyled checkboxes, radios
		        if (element.parents().hasClass('form-check')) {
		            error.appendTo( element.parents('.form-check').parent() );
		        }

		        // Input with icons and Select2
		        else if (element.parents().hasClass('form-group-feedback') || element.hasClass('select2-hidden-accessible')) {
		            error.appendTo( element.parent() );
		        }

		        // Input group, styled file input
		        else if (element.parent().is('.uniform-uploader, .uniform-select') || element.parents().hasClass('input-group')) {
		            error.appendTo( element.parent().parent() );
		        }

		        // Other elements
		        else {
		            error.insertAfter(element);
		        }
		    },
			rules: {
				"stock.code":{
					required: true
				}
			},
			messages: {
				"stock.code":{
					required:"Vui lòng chọn kho.",
				}
			}
		});
	}
    
//    var submitModal = function(){
//		$('#btnSubmitModal').on('click',function(e){
//    		MaterialSelector.updateMaterialInfo();
//		});
//	};
	
	var submitForm = function(){
		$('#btnSubmit').on('click',function(e){
			formatNumberComponent.disableAutoNumeric();
			var checkError = MaterialSelector.checkFormTable();
			if(!checkError) {
				bootbox.alert({
                    title: "Thông báo:",
                    message: "Có một số dữ liệu không chính xác hoặc không đúng định dạng. Vui lòng kiểm tra lại thông tin trong bảng thông tin vật tư.",
                });
				formatNumberComponent.initAutoNumeric();
			} else {
				var type = $("#type").val();
				// TRƯỜNG HỢP TẠO MỚI BẢN GHI TỪ TEMPLATE THÌ CẦN SET ID = NULL VÀ TYPE = PR_FROM_PIGFARM
				if(type == TYPE.TEMPLATE){
					$("#prId").val(null);
					$("#type").val(TYPE.PR_FROM_APP);
					$("#templateName").val(null);
				}
				
				$('#status').val(STATUS.UNCONFIRMED);
				var value = $('#purchaserequisitionPrType option:selected').val(); 
				$('#prType').val(value); 
				$('#purchaserequisitionForm').attr('action', '/purchaseRequisition/save');
				$('#purchaserequisitionForm').submit();
			}
		});
	};
	
	var confirmedForm = function(){
		$('#btnConfirmed').on('click',function(e){
			bootbox.confirm({
				title: "Xác nhận:",
			    message: "Dữ liệu xác nhận này sẽ được đồng bộ lên hệ thống SAP và bạn sẽ không thể sửa được thông tin của phiếu nữa. Bạn có chắc chắn không?",
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
			    		formatNumberComponent.disableAutoNumeric();
			    		var checkError = MaterialSelector.checkFormTable();
						if(!checkError) {
							bootbox.alert({
			                    title: "Thông báo:",
			                    message: "Có một số dữ liệu không chính xác hoặc không đúng định dạng. Vui lòng kiểm tra lại thông tin trong bảng thông tin vật tư.",
			                });
							formatNumberComponent.initAutoNumeric();
						} else {
							var type = $("#type").val();
							// TRƯỜNG HỢP TẠO MỚI BẢN GHI TỪ TEMPLATE THÌ CẦN SET ID = NULL VÀ TYPE = PR_FROM_PIGFARM
							if(type == TYPE.TEMPLATE){
								$("#prId").val(null);
								$("#type").val(TYPE.PR_FROM_APP);
								$("#templateName").val(null);
							}
				    		
				    		$('#status').val(STATUS.CONFIRMED);
							var value = $('#purchaserequisitionPrType option:selected').val(); 
							$('#prType').val(value); 
							$('#purchaserequisitionForm').attr('action', '/purchaseRequisition/save');
							$('#purchaserequisitionForm').submit();
						}
			    	}
			    }
			});
		});
	};
	
	var cancelPR = function(){
		$('#btnCancel').on('click',function(e){
			bootbox.confirm({
				title: "Xác nhận:",
			    message: "Hủy phiếu yêu cầu này sẽ tương đương với việc dữ liệu ở phiếu yêu cầu mua hàng này sẽ không được đồng bộ lên hệ thống SAP. Bạn có chắc chắn không?",
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
			    		formatNumberComponent.disableAutoNumeric();
			    		$('#status').val(STATUS.CANCEL);
						var value = $('#purchaserequisitionPrType option:selected').val(); 
						$('#prType').val(value); 
						$('#purchaserequisitionForm').attr('action', '/purchaseRequisition/save');
						$('#purchaserequisitionForm').submit();
			    	}
			    	
			    }
			});
		});
	};
	
	var saveTemplate = function(){
		$('#btnSaveTemplate').on('click',function(e){
			var type = $("#type").val();
			var prId = $("#prId").val();
			
			// truong hop tao template tu phieu yeu cau mua hang hoac tu phieu trai da tao thi set lai type va set id.
			if(prId) {
				if(type != TYPE.TEMPLATE){
					$("#prId").val(null);
				}
			} 
			
			var name = $("#templateNameModal").val();
			if(name){
				$("#templateName").val(name);
			}
			formatNumberComponent.disableAutoNumeric();
			var checkError = MaterialSelector.checkFormTable();
			if(!checkError) {
				bootbox.alert({
                    title: "Thông báo:",
                    message: "Có một số dữ liệu không chính xác hoặc không đúng định dạng. Vui lòng kiểm tra lại thông tin trong bảng thông tin vật tư.",
                });
				formatNumberComponent.initAutoNumeric();
			} else {
				$('#purchaserequisitionTransCode').val(null);
				$('#status').val(STATUS.UNCONFIRMED);
				$('#type').val(TYPE.TEMPLATE);
				var value = $('#purchaserequisitionPrType option:selected').val(); 
				$('#prType').val(value); 
				$('#purchaserequisitionForm').attr('action', '/purchaseRequisition/save');
				$('#purchaserequisitionForm').submit();
			}
		});
	};
	
	var changeStockCode = function(){
		$('#purchaserequisitionStockCode').on('change',function(e){
			var value = $('#purchaserequisitionStockCode option:selected').text(); 
			var str = value.split(' - ');
			var valueSelected = $('#purchaserequisitionStockCode option:selected').val(); 
			var strVal = valueSelected.split('.');
			$('#stockCode').val(strVal[0]); 
			$('purchaserequisitionPlant').attr('readonly', false); 
			$('#purchaserequisitionPlant').val(strVal[1]); 
			$('purchaserequisitionPlant').attr('readonly', true); 
		});
	};
	
	var changePurchaserequisitionPrType = function(){
		$('#purchaserequisitionPrType').on('change',function(e){
			bootbox.confirm({
				title: "Xác nhận:",
			    message: "Việc thay đổi loại yêu cầu này sẽ dẫn đến việc xóa các thông tin vật tư đã tạo trước đó. Bạn có muốn tiếp tục không?",
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
						$('#purchaserequisitionStockCode').val(null).trigger('change');
			    		var prType = $("#purchaserequisitionPrType").val();
						if(prType == PR_TYPE.WEEK) {
							$("#tblSelectedMaterialPrTypeWeeks").show();
							$("#tblSelectedMaterialPrTypeMonths").hide();
							var indexLastRow = parseInt($("#tblSelectedMaterialPrTypeMonths").find(".index-table-type-month").last().val());
							for (var i = 0; i < indexLastRow; i++) {
								$('#rec-material-type-month'+i).remove();
								$('#tblSelectedMaterialPrTypeMonths tbody tr').each(function(i) {
								      $(this).find('span.no').html(i+1);
								});
							}
							$('#tblSelectedMaterialPrTypeMonths tbody tr').find("input:not([type=hidden])").val('');
							$('#tblSelectedMaterialPrTypeMonths tbody tr').find(".selected-material-code").val('');
				        } else {
				        	$("#tblSelectedMaterialPrTypeMonths").show();
							$("#tblSelectedMaterialPrTypeWeeks").hide();
							
							var indexLastRow = parseInt($("#tblSelectedMaterialPrTypeWeeks").find(".index-table").last().val());
							for (var i = 0; i < indexLastRow; i++) {
								$('#rec-material'+i).remove();
								$('#tblSelectedMaterialPrTypeWeeks tbody tr').each(function(i) {
								      $(this).find('span.no').html(i+1);
								});
							}
							$('#tblSelectedMaterialPrTypeWeeks tbody tr').find("input:not([type=hidden])").val('');
							$('#tblSelectedMaterialPrTypeWeeks tbody tr').find(".selected-material-code").val('');
				        }
						MaterialSelector.init(prType);
			    	}
			    }
			});
		});
	};
	
    return {
        init: function() {
        	initForm();
        	initSelector();
//        	submitModal();
        	submitForm();
        	confirmedForm();
        	changeStockCode();
            initSwitchery();
            initBootstrapSwitch();
            pickerDate();
            validateForm();
            saveTemplate();
            cancelPR();
            changePurchaserequisitionPrType();
        }
    }
}();

var Custom = {
		checkStatus: () => {
			var status = $("#status").val().toLowerCase();
			if(status == STATUS.UNCONFIRMED) {
				$("#btnSubmit").show();
				$("#btnConfirmed").show();
			} else {
				$("#btnSubmit").hide();
				$("#btnConfirmed").hide();
			}
			
			//neu phieu co trang thai la template thi bo readonly = true o prGroupCode
			$("#purchaserequisitionPrGroupCode").attr("readonly", false);
		},
		
		loadMaterial : () =>{
			var codes = MaterialSelector.getSelectedCodes();
			var prType = $("#purchaserequisitionPrType").val();
			MaterialSelector.init(prType);
			if(prType == PR_TYPE.WEEK) {
				if(codes != null && codes != ''){
					var arrayCode = codes.split(',');
					$('#tblSelectedMaterialPrTypeWeeks tbody tr').each(function(index) {
						var fi = "";
						fi = "<option></option>";
						if(arrayCode[index] != null && arrayCode[index] != ''){
							fi = "<option value=" + arrayCode[index] + ">" + arrayCode[index] + "</option>";
						}
						$(this).find(".selected-material-code").html(fi);
					});
				}
				$("#tblSelectedMaterialPrTypeMonths").hide();
	        } else {
	        	if(codes != null && codes != ''){
					var arrayCode = codes.split(',');
					$('#tblSelectedMaterialPrTypeMonths tbody tr').each(function(index) {
						var fi = "";
						fi = "<option></option>";
						if(arrayCode[index] != null && arrayCode[index] != ''){
							fi = "<option value=" + arrayCode[index] + ">" + arrayCode[index] + "</option>";
						}
						$(this).find(".selected-material-code").html(fi);
					});
				}
	        	$("#tblSelectedMaterialPrTypeWeeks").hide();
	        }
		},
		
		checkPrId: () => {
			var prId = $("#prId").val();
			if(prId) {
				$("#purchaserequisitionPrType").attr("disabled", true); 
			}
			
		},
}

// Initialize module
// ------------------------------

document.addEventListener('DOMContentLoaded', function() {
	Component.init();
	Custom.checkStatus();
	Custom.loadMaterial();
	Custom.checkPrId();
	formatNumberComponent.initAutoNumeric();
});
