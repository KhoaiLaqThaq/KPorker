var materialcodeExisting = [];

const PREFIX = {
		SALE_PIG: "MAVIN"
};

const TYPE = {
		TEMPLATE: 'template', // TEMPLATE
		GOODS_ISSUE: 'goods_issue' // GOODS_ISSUE
};

const STATUS = {
		UNCONFIRMED: 'unconfirmed', // CHƯA XÁC NHẬN
		CONFIRMED: 'confirmed', // XÁC NHẬN 
		CANCEL: 'cancel', // HỦY
		SYNCHRONIZED:'synchronized'
};

const TRANS_TYPE = {
		DEFAULT: '5'//gia tri mac dinh khi day len sap
};

const MOVEMENT_TYPE = {
		GI_FROM_DO: '641', // XUẤT KHO TỪ PHIẾU YÊU CẦU
		GOODS_ISSUE: '201', // XUẤT KHO CHUNG
		GI_INVENTORY: 'Z09', // KIỂM KÊ
		GI_FUEL: 'Z15', // XUẤT NHIÊN LIỆU
		GI_CULLED_PIG: '551' // XUẤT HEO CHẾT
};


var FormComponent = function() {

	var flagFindMaterialCodeIsSalePig = false;
	var contextPath = getContext();
	
	var initForm = function() {
        if (!$().select2) {
            return;
        }
    	// select2
   	 	$('.select2').select2();
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
		$('#goodsissueForm').validate({
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
				"fromStockCode":{
					required: true
				}
			},
			messages: {
				"fromStockCode":{
					required:"Vui lòng chọn kho.",
				}
			}
		});
	}

    var initBootstrapSwitch = function() {
        if (!$().bootstrapSwitch) {
            return;
        }
        $('.form-check-input-switch').bootstrapSwitch();
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
		$('#goodsIssueDisplayPostingDate').on('apply.daterangepicker', function(ev, picker) {
			$(this).val(picker.startDate.format('DD-MM-YYYY'));
			var stockCode = $('#goodsIssueFromStockCode').val();
    		var postingDate = picker.startDate.format('DD-MM-YYYY');
    		var movementType = $('#goodsissueMovementType option:selected').val(); 
       	 	//MaterialSelector
       	 	MaterialSelector.init(stockCode,postingDate,movementType);
		});
	}
	
	var _checkChosenPostingDate = function() {
		var postingDateValue = $('#goodsIssueDisplayPostingDate').val();
		if (postingDateValue || postingDateValue !== '') {
			return postingDateValue;
		}
		bootbox.alert({
            title: 'Thông báo',
            message: 'Vui lòng chọn ngày xuất kho.'
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
			    message: "Bạn có xác nhận xuất kho cho ngày: <b>"+postingDate+"</b> không? Dữ liệu xác nhận này sẽ được đồng bộ lên hệ thống SAP và bạn sẽ không thể sửa được thông tin của phiếu nữa. Bạn có chắc chắn không?",
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
							// truong hop luu mot ban ghi tu template thi can set id = null va set lai type = 'pr_from_pigfarm'
							if(type === TYPE.TEMPLATE){
								$("#id").val(null);
								$("#type").val(TYPE.GOODS_ISSUE);
								$("#templateName").val(null);
							}
							$("#type").val(TYPE.GOODS_ISSUE);
							$('#status').val(STATUS.CONFIRMED);
							$('#goodsIssueFromStockCode').attr("disabled", false);
							//set lai ngay thang nam
							var str = postingDate.split('-');
							var month = Math.abs(str[1]) - 1; //// the month is 0-indexed
							document.getElementById("postingDate").value = new Date(str[2], month, str[0]).toLocaleDateString('en-GB');
							
							var valueMovementType = $('#goodsissueMovementType option:selected').val(); 
							$('#movementType').val(valueMovementType);
							
							var value = $('#goodsIssueFromStockCode').val();
							$('#stockCode').val(value);
							
							$('#tblSelectedMaterials tbody tr').find(".selected-material-code").attr("disabled", false);
							
							var licensePlate = $('#licensePlate').val();
							
							if(valueMovementType != MOVEMENT_TYPE.GI_FROM_DO){
								$('#pleaseWaitDialog').modal();
								$('#goodsissueForm').attr('action', '/goodsIssue/save');
								$('#goodsissueForm').submit();
							} else {
								if(licensePlate){
									$('#pleaseWaitDialog').modal();
									$('#goodsissueForm').attr('action', '/goodsIssue/save');
									$('#goodsissueForm').submit();
								} else {
									$('#msgForId').html("Vui lòng nhập biển số xe.");
								}
							}
						}
			    	}
			    }
			});
		});
	};
	
	var btnCancelTrans = function(){
		$('#btnCancelTrans').on('click',function(e){
			var status = $("#status").val();
			var goodsIssueId = $("#id").val();
			if(goodsIssueId) {
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
										var type = $("#type").val();
										// truong hop luu mot ban ghi tu template thi can set id = null va set lai type = 'pr_from_pigfarm'
										if(type === 'template'){
											$("#id").val(null);
											$("#type").val(TYPE.GOODS_ISSUE);
											$("#templateName").val(null);
										}
										$("#type").val(TYPE.GOODS_ISSUE);
										$('#status').val(STATUS.CANCEL);
										$('#goodsIssueFromStockCode').attr("disabled", false);
										//set lai ngay thang nam
//										var postingDate = $('#goodsIssueDisplayPostingDate').val();
//										var str = postingDate.split('-');
//										var month = Math.abs(str[1]) - 1; //// the month is 0-indexed
//										var date = new Date(str[2],month,str[0]).toLocaleDateString('en-GB');
//										document.getElementById("postingDate").value = date;
										var value = $('#goodsissueMovementType option:selected').val(); 
										$('#movementType').val(value);
										var value = $('#goodsIssueFromStockCode').val();
										$('#stockCode').val(value);
										$('#markDel').val(false);
										
										$('#tblSelectedMaterials tbody tr').find(".selected-material-code").attr("disabled", false);
										$('#goodsissueForm').attr('action', '/goodsIssue/save');
										$('#goodsissueForm').submit();
						            }
						        },
						        cancelAndBlockTrans: {
						            label: '<i class="fa fa-check"></i> Hủy và khóa',
						            className: 'btn-primary',
						            callback: function(){
						            	$('#pleaseWaitDialog').modal();
						            	formatNumberComponent.disableAutoNumeric();
										var type = $("#type").val();
										// truong hop luu mot ban ghi tu template thi can set id = null va set lai type = 'pr_from_pigfarm'
										if(type === 'template'){
											$("#id").val(null);
											$("#type").val(TYPE.GOODS_ISSUE);
											$("#templateName").val(null);
										}
										$("#type").val(TYPE.GOODS_ISSUE);
										$('#status').val(STATUS.CANCEL);
										$('#goodsIssueFromStockCode').attr("disabled", false);
										//set lai ngay thang nam
//										var postingDate = $('#goodsIssueDisplayPostingDate').val();
//										var str = postingDate.split('-');
//										var month = Math.abs(str[1]) - 1; //// the month is 0-indexed
//										var date = new Date(str[2],month,str[0]).toLocaleDateString('en-GB');
//										document.getElementById("postingDate").value = date;
										var value = $('#goodsissueMovementType option:selected').val(); 
										$('#movementType').val(value);
										var value = $('#goodsIssueFromStockCode').val();
										$('#stockCode').val(value);
										$('#markDel').val(true);
										$('#tblSelectedMaterials tbody tr').find(".selected-material-code").attr("disabled", false);
										$('#goodsissueForm').attr('action', '/goodsIssue/save');
										$('#goodsissueForm').submit();
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
				var id = $("#id").val();
				
				// truong hop tao template tu phieu yeu cau xuat kho hoac tu phieu trai da tao thi set lai type va set id.
				if(id) {
					if(type !== TYPE.TEMPLATE){
						$("#id").val(null);
						$("#transType").val(TRANS_TYPE.DEFAULT); //gia tri mac dinh khi day len sap
						var value = $('#goodsissueMovementType option:selected').val(); 
						$('#movementType').val(value);
					}
				} 
				var name = $("#templateNameModal").val();
				if(name){
					$("#templateName").val(name);
				}
				$('#status').val(STATUS.UNCONFIRMED);
				$('#type').val(TYPE.TEMPLATE);
				$('#goodsIssueFromStockCode').attr("disabled", false);
				$('#goodsIssueToStockCode').attr("disabled", false);
				
				//set lai ngay thang nam
				var postingDate = $('#goodsIssueDisplayPostingDate').val();
				var str = postingDate.split('-');
				var month = Math.abs(str[1]) - 1; //// the month is 0-indexed
				document.getElementById("postingDate").value = new Date(str[2], month, str[0]).toLocaleDateString('en-GB');
				
				
				$('#GoodIssueTransCode').val(null);
				
				var value = $('#goodsissueMovementType option:selected').val(); 
				$('#movementType').val(value);
				
				var value = $('#goodsIssueFromStockCode').val();
				$('#stockCode').val(value);
				
				$('#tblSelectedMaterials tbody tr').find(".selected-material-code").attr("disabled", false);
				
				$('#goodsissueForm').attr('action', '/goodsIssue/save');
				$('#goodsissueForm').submit();
			}
		});
	};

    var initFormSelector = function() {
    	var stockCode = $('#goodsIssueFromStockCode').val();
    	var postingDate = $('#goodsIssueDisplayPostingDate').val();
    	var movementType = $('#goodsissueMovementType option:selected').val(); 
   	 	//MaterialSelector
   	 	MaterialSelector.init(stockCode,postingDate,movementType);
	}

    var changeFromStockCode = function() {
    	$('#goodsIssueFromStockCode').on('change',function(e){
    		var stockCode = $('#goodsIssueFromStockCode').val();
    		var postingDate = $('#goodsIssueDisplayPostingDate').val();
    		var movementType = $('#goodsissueMovementType option:selected').val(); 
       	 	//MaterialSelector
       	 	MaterialSelector.init(stockCode,postingDate,movementType);
    	});
	}
    
    var changeMovementType = function() {
    	$('#goodsissueMovementType').on('change',function(e){
    		var stockCode = $('#goodsIssueFromStockCode').val();
    		var postingDate = $('#goodsIssueDisplayPostingDate').val();
    		var movementType = $('#goodsissueMovementType option:selected').val(); 
       	 	//MaterialSelector
       	 	MaterialSelector.init(stockCode,postingDate,movementType);
    	});
	}

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
        	initFormSelector();
        	changeFromStockCode();
        	changeMovementType();
        }
    }
}();

var Custom = {
		hideIcon: () => {
			$(".icon_head").hide();
			$(".icon").hide();
			$('#tblSelectedMaterials tbody tr').find("input").attr("readonly", true);
		},
		
		checkType: () => {
			var type = $("#type").val();
			if(type){
				if(type !== TYPE.GOODS_ISSUE){
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
					
					var selectedBatchId = "#selected-batch" + index;
					var valueBatch = $(selectedBatchId).val();
					if(valueBatch) {
						var arr = valueBatch.split(':/');
						var manufacturedDateId = "#selected-item-manufacturedDate" + index;
						$(manufacturedDateId).val(arr[3]);
						
						var batchId = "#selected-item-batch" + index;
						$(batchId).val(arr[0]);
						
						var expiredDateId = "#selected-item-expiredDate" + index;
						$(expiredDateId).val(arr[2]);
						
						var totalRetainedQuantityId = "#selected-item-totalRetainedQuantity" + index;
						$(totalRetainedQuantityId).val(arr[1]);
					}
				});
			}
		},
		
		checkGoodsRequisitionId: () => {
			var goodsRequisitionId = $("#goodsRequisitionId").val();
			if(goodsRequisitionId) {
				$('#tblSelectedMaterials tbody tr').each(function(index) {
					var selectedItemNumId = "#selected-item-itemNum" + index;
					var valueItemNum = $(selectedItemNumId).val();
					var selectedCodeId = "#" + index;
					var valueCode = $(selectedCodeId).val();
					var value = valueCode + ":/" + valueItemNum;
					materialcodeExisting.push(value);
				});
				
				$('#goodsIssueFromStockCode').attr("disabled", true);
				$("#goodsissueMovementType").attr("disabled", true); 
				$("#goodsIssuePoCode").attr("readonly", true);
				$("#goodsIssueDoCode").attr("readonly", true);
				$("#goodsIssueCustomer").attr("readonly", true);
				$("#goodsIssueCustomerName").attr("readonly", true);
				$("#goodsIssuePoCode").attr("readonly", true);
				$("#goodsIssuePoCode").attr("readonly", true);
			}
		},
		
		checkgoodsIssueId: () => {
			var goodsIssueId = $("#id").val();
			var type = $("#type").val();
			if(goodsIssueId && type) {
				if(type == TYPE.GOODS_ISSUE){
					$('#goodsissueForm :input').attr('readonly','readonly');
					$('#goodsIssueFromStockCode').attr("disabled", true);
					$('#goodsIssueToStockCode').attr("disabled", true);
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
	Custom.loadMaterial();
	Custom.checkGoodsRequisitionId();
	Custom.checkType();
	Custom.checkgoodsIssueId();
	formatNumberComponent.initAutoNumeric();
});

function changeBatch(index) {
	var selectedBatchId = "#selected-batch" + index;
	var valueBatch = $(selectedBatchId).val();
	var arr = valueBatch.split(':/');
	
	var manufacturedDateId = "#selected-item-manufacturedDate" + index;
	$(manufacturedDateId).val(arr[3]);
	
	var batchId = "#selected-item-batch" + index;
	$(batchId).val(arr[0]);
	
	var expiredDateId = "#selected-item-expiredDate" + index;
	$(expiredDateId).val(arr[2]);
	
	var totalRetainedQuantityId = "#selected-item-totalRetainedQuantity" + index;
	$(totalRetainedQuantityId).val(arr[1]);
}
