const TYPE = {
		TEMPLATE: 'template', // TEMPLATE
		GOODS_RECEIPT: 'goods_receipt' // GOODS_RECEIPT
};

const STATUS = {
		UNCONFIRMED: 'unconfirmed', // CHƯA XÁC NHẬN
		CONFIRMED: 'confirmed', // XÁC NHẬN 
		CANCEL: 'cancel', // HỦY
		SYNCHRONIZED:'synchronized' //ĐỒNG BỘ
};

const TRANS_TYPE = {
		DEFAULT: '4'//gia tri mac dinh khi day len sap
};

const MOVEMENT_TYPE = {
		INVENTORY: 'Z07', // KIỂM KÊ
		GOODS_RECEIPT: '101' // NHẬP KHO
};

var FormComponent = function() {
	
	var initForm = function() {
        if (!$().select2) {
            return;
        }
    	// select2
   	 	$('.select2').select2();
   	 	
   	 	//MaterialSelector
   	 	MaterialSelector.init();
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
    
	var validateForm = function(){
		$('#goodsreceiptForm').validate({
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
				"toStockCode":{
					required: true
				}
			},
			messages: {
				"toStockCode":{
					required:"Vui lòng chọn kho.",
				}
			}
		});
	}

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
           },
		   autoUpdateInput: false
       });
    };

	var chosenPostingDate = function() {
		$('#goodsReceiptDisplayPostingDate').on('apply.daterangepicker', function(ev, picker) {
			$(this).val(picker.startDate.format('DD-MM-YYYY'));
		});
	}

	var _checkChosenPostingDate = function() {
		var postingDateValue = $('#goodsReceiptDisplayPostingDate').val();
		if (postingDateValue || postingDateValue !== '') {
			return postingDateValue;
		}
		bootbox.alert({
            title: 'Thông báo',
            message: 'Vui lòng chọn ngày thực hiện.'
        });
        return '';
	}
    
    var submitForm = function(){
		$('#btnSubmit').on('click',function(e){
			e.preventDefault();
			
			var postingDate = _checkChosenPostingDate();
			if (postingDate == '') return false;
			bootbox.confirm({
				title: "Xác nhận:",
			    message: "Bạn có xác nhận nhập kho cho ngày: <b>"+postingDate+"</b> không? Dữ liệu xác nhận này sẽ được đồng bộ lên hệ thống SAP và bạn sẽ không thể sửa được thông tin của phiếu nữa. Bạn có chắc chắn không?",
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
							$('#pleaseWaitDialog').modal();
							var type = $("#type").val();
							// truong hop luu mot ban ghi tu template thi can set id = null va set lai type = 'pr_from_pigfarm'
							if(type === TYPE.TEMPLATE){
								$("#goodsReceiptId").val(null);
								$("#templateName").val(null);
							}
				    		
							//set lai ngay thang nam
							if(postingDate) {
								var str = postingDate.split('-');
								var month = Math.abs(str[1]) - 1; //// the month is 0-indexed
								document.getElementById("postingDate").value = new Date(str[2], month, str[0]).toLocaleDateString('en-GB');
							}
							var stockCode = $('#goodsReceiptToStockCode option:selected').val(); 
							$('#stockCode').val(stockCode); 
							
							$('#type').val(TYPE.GOODS_RECEIPT);
							$('#status').val(STATUS.CONFIRMED);
							
							$('#tblSelectedMaterials tbody tr').find(".selected-material-code").attr("disabled", false);
							$("#goodsReceiptFromStockCode").attr("disabled", false);
							$("#goodsReceiptToStockCode").attr("disabled", false);
							
							$('#goodsreceiptForm').attr('action', '/goodsReceipt/save');
							$('#goodsreceiptForm').submit();
						}
			    	}
			    }
			});
		});
	};
	
	var btnCancelTrans = function(){
		$('#btnCancelTrans').on('click',function(e){
			var status = $("#status").val();
			var goodsReceiptId = $("#goodsReceiptId").val();
			if(goodsReceiptId) {
				if(status) {
					if(status === STATUS.CONFIRMED || status === STATUS.SYNCHRONIZED){
						$("#modalCancel").modal('hide');
						bootbox.dialog({
						    title: "Xác nhận:",
						    message: "Bạn chọn hình thức <b>Hủy</b> hay <b>Hủy và khóa</b>?",
						    buttons: {
						    	cancel: {
						            label: "Hủy",
						            callback: function(){
						                console.log('Custom cancel clicked');
						            }
						        },
						        cancelTrans: {
						            label: '<i class="fa fa-check"></i> Hủy',
						            className: 'btn-primary',
						            callback: function(){
						            	$('#pleaseWaitDialog').modal();
						            	formatNumberComponent.disableAutoNumeric();
										//set lai ngay thang nam
//										var postingDate = $('#goodsReceiptDisplayPostingDate').val();
//										if(postingDate) {
//											var str = postingDate.split('-');
//											
//											var month = Math.abs(str[1]) - 1; //// the month is 0-indexed
//											var date = new Date(str[2],month,str[0]).toLocaleDateString('en-GB');
//											document.getElementById("postingDate").value = date;
//										}
										var stockCode = $('#goodsReceiptToStockCode option:selected').val(); 
										$('#stockCode').val(stockCode); 
										
										$('#type').val(TYPE.GOODS_RECEIPT);
										$('#status').val(STATUS.CANCEL);
										$('#markDel').val(false);
										$('#tblSelectedMaterials tbody tr').find(".selected-material-code").attr("disabled", false);
										$("#goodsReceiptFromStockCode").attr("disabled", false);
										$("#goodsReceiptToStockCode").attr("disabled", false);
										
										$('#goodsreceiptForm').attr('action', '/goodsReceipt/save');
										$('#goodsreceiptForm').submit();
						            }
						        },
						        cancelAndBlockTrans: {
						            label: '<i class="fa fa-check"></i> Hủy và khóa',
						            className: 'btn-primary',
						            callback: function(){
						            	$('#pleaseWaitDialog').modal();
										formatNumberComponent.disableAutoNumeric();
										//set lai ngay thang nam
//										var postingDate = $('#goodsReceiptDisplayPostingDate').val();
//										if(postingDate) {
//											var str = postingDate.split('-');
//											
//											var month = Math.abs(str[1]) - 1; //// the month is 0-indexed
//											var date = new Date(str[2],month,str[0]).toLocaleDateString('en-GB');
//											document.getElementById("postingDate").value = date;
//										}
										var stockCode = $('#goodsReceiptToStockCode option:selected').val(); 
										$('#stockCode').val(stockCode); 
										
										$('#type').val(TYPE.GOODS_RECEIPT);
										$('#status').val(STATUS.CANCEL);
										$('#markDel').val(true);
										$('#tblSelectedMaterials tbody tr').find(".selected-material-code").attr("disabled", false);
										$("#goodsReceiptFromStockCode").attr("disabled", false);
										$("#goodsReceiptToStockCode").attr("disabled", false);
										
										$('#goodsreceiptForm').attr('action', '/goodsReceipt/save');
										$('#goodsreceiptForm').submit();
						            }
						        },
						    },
						});   
					} else {
						$("#modalCancel").modal('hide');
						bootbox.alert({
			                title: 'Thông báo:',
			                message: 'Có lỗi xảy ra, trạng thái phiếu không hợp lệ.'
			            });
					}
				} else {
					$("#modalCancel").modal('hide');
					bootbox.alert({
		                title: 'Thông báo:',
		                message: 'Có lỗi xảy ra, trạng thái phiếu không hợp lệ.'
		            });
				}
			} else {
				$("#modalCancel").modal('hide');
				bootbox.alert({
	                title: 'Thông báo:',
	                message: 'Phiếu xác nhận nhập kho này không tồn tại.'
	            });
			}
		});
	};
	
	var saveTemplate = function(){
		$('#btnSaveTemplate').on('click',function(e){
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
				var type = $("#type").val();
				var goodsReceiptId = $("#goodsReceiptId").val();
				
				// truong hop tao template tu phieu yeu cau nhap kho hoac tu phieu trai da tao thi set lai type va set id.
				if(goodsReceiptId) {
					if(type !== TYPE.TEMPLATE){
						$("#goodsReceiptId").val(null);
						$("#transType").val(TRANS_TYPE.DEFAULT);
						$("#movementType").val(MOVEMENT_TYPE.INVENTORY);
					}
				} 
				
				var name = $("#templateNameModal").val();
				if(name){
					$("#templateName").val(name);
				}
				$('#status').val(STATUS.UNCONFIRMED);
				$('#type').val(TYPE.TEMPLATE);
				
				//set lai ngay thang nam
				var postingDate = $('#goodsReceiptDisplayPostingDate').val();
				if(postingDate) {
					var str = postingDate.split('-');
					var month = Math.abs(str[1]) - 1; //// the month is 0-indexed
					document.getElementById("postingDate").value = new Date(str[2], month, str[0]).toLocaleDateString('en-GB');
				}
				var stockCode = $('#goodsReceiptToStockCode option:selected').val(); 
				$('#stockCode').val(stockCode); 
				
				$('#goodsReceiptTransCode').val(null);
				
				$('#tblSelectedMaterials tbody tr').find(".selected-material-code").attr("disabled", false);
				$("#goodsReceiptFromStockCode").attr("disabled", false);
				$("#goodsReceiptToStockCode").attr("disabled", false);
				
				$('#goodsreceiptForm').attr('action', '/goodsReceipt/save');
				$('#goodsreceiptForm').submit();
			}
		});
	};
	
    return {
        init: function() {
			chosenPostingDate();
        	initForm();
        	initBootstrapSwitch();
        	initSwitchery();
        	pickerDate();
        	submitForm();
        	saveTemplate();
        	btnCancelTrans();
        }
    }
}();

var tblLenght = 0; //lay so luong phan tu co trong bang luc dau khi load trang
var Custom = {
		getLenghtTables: () =>{
			tblLenght = $('#tblSelectedMaterials tbody tr').length;
		},
		
		checkType: () => {
			var type = $("#type").val();
			if(type){
				if(type !== TYPE.GOODS_RECEIPT){
					$("#btnSubmit").show();
				} else {
					$("#btnSubmit").hide();
				}
			} else {
				$("#btnSubmit").show();
			}
		},
		
		loadMaterial : () =>{
			var codes = MaterialSelector.getSelectedCodes();
			if(codes != null && codes != ''){
				var arrayCode = codes.split(',');
				$('#tblSelectedMaterials tbody tr').each(function(index) {
					var fi = "";
					fi = "<option></option>";
					if(arrayCode[index] != null && arrayCode[index] != ''){
						fi = "<option value=" + arrayCode[index] + ">" + arrayCode[index] + "</option>";
					}
					$(this).find(".selected-material-code").html(fi);
					$(this).find(".selected-material-code").prop('readonly',true);
				});
			}
		},
		
		checkGoodsRequisitionId: () => {
			var goodsRequisitionId = $("#goodsRequisitionId").val();
			if(goodsRequisitionId) {
				$("#goodsreceiptTransType").attr("disabled", true);
				$('#tblSelectedMaterials tbody tr').find(".selected-material-code").attr("disabled", true);
				$("#goodsReceiptFromStockCode").attr("disabled", true);
				$("#goodsReceiptToStockCode").attr("disabled", true);
				$("#goodsReceiptPoCode").prop('readonly',true);
				$("#goodsReceiptDoCode").prop('readonly',true);
				$("#goodsReceiptVendor").prop('readonly',true);
				$("#goodsReceiptVendorName").prop('readonly',true);
				$("#goodsReceiptCreatedPerson").prop('readonly',true);
			}
		},
		
		checkgoodsReceiptId: () => {
			var goodsReceiptId = $("#goodsReceiptId").val();
			var type = $("#type").val();
			if(goodsReceiptId) {
				if(type == TYPE.GOODS_RECEIPT){
					$('#goodsreceiptForm :input').attr('readonly','readonly');
					//$('#goodsReceiptDisplayPostingDate').attr("disabled", true);
					$('#goodsReceiptFromStockCode').attr("disabled", true);
					$('#goodsReceiptToStockCode').attr("disabled", true);
					$('#tblSelectedMaterials tbody tr').find(".selected-material-code").attr("disabled", true);
					$('#tblSelectedMaterials tbody tr').find("input").attr('readonly','readonly');
					$(".icon_head").hide();
					$('#templateNameModal').attr("readonly", false);
				}
			}
		}
		
}

// Initialize module
// ------------------------------

document.addEventListener('DOMContentLoaded', function() {
	FormComponent.init();
	Custom.getLenghtTables(); //lay size cua table khi load trang de kiem tra so luong truoc khi submit
	Custom.checkGoodsRequisitionId();
	Custom.loadMaterial();
	Custom.checkType();
	Custom.checkgoodsReceiptId();
																																																																																																																																									
});
