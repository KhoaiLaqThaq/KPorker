var materialcodeExisting = [];

const STATUS = {
		UNCONFIRMED: 'unconfirmed', // CHƯA XÁC NHẬN
		CONFIRMED: 'confirmed', // XÁC NHẬN 
		CANCEL: 'cancel' // HỦY 
};

var formComponent = function() {

	var contextPath = getContext();
	
	var initForm = function() {
        if (!$().select2) {
            return;
        }
    	// select2
   	 	$('.select2').select2();
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
    
    // Validate form
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
       });
    };

    var submitForm = function(){
		$('#btnSubmit').on('click',function(e){
			bootbox.confirm({
				title: "Xác nhận:",
			    message: "Bạn sẽ không thể sửa được thông tin của phiếu nữa. Bạn có chắc chắn không?",
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
							
							var postingDateValue = $('#instockAdjustmentDisplayPostingDate').val();
							var str = postingDateValue.split('-');
							var month = Math.abs(str[1]) - 1; //// the month is 0-indexed
							document.getElementById("postingDate").value = new Date(str[2], month, str[0]).toLocaleDateString('en-GB');
							
							$('#status').val(STATUS.CONFIRMED);
							$('#tblSelectedMaterials tbody tr').find(".selected-material-code").attr("disabled", false);
							$('#instockAdjustmentType').attr("disabled", false);
							$('#instockAdjustmentFromStockCode').attr("disabled", false);
							
							$('#instockAdjustmentForm').attr('action', '/instockAdjustment/save');
							$('#instockAdjustmentForm').submit();
							
						}
			    	}
			    }
			});
		});
	};
	
	var btnCancelTrans = function(){
		$('#btnCancelTrans').on('click',function(e){
			var status = $("#status").val();
			var instockAdjustmentId = $("#id").val();
			if(instockAdjustmentId) {
				if(status) {
					$('#pleaseWaitDialog').modal();
					formatNumberComponent.disableAutoNumeric();
					$('#instockAdjustmentType').attr("disabled", false);
					$('#instockAdjustmentFromStockCode').attr("disabled", false);
					$('#status').val(STATUS.CANCEL);
					$('#tblSelectedMaterials tbody tr').find(".selected-material-code").attr("disabled", false);
					$('#instockAdjustmentForm').attr('action', '/instockAdjustment/save');
					$('#instockAdjustmentForm').submit();
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
	                message: 'Phiếu điều chỉnh tồn kho này không tồn tại.'
	            });
			}
		});
	};
	
	var changeFromStockCode = function() {
    	$('#instockAdjustmentFromStockCode').on('change',function(e){
    		var stockCode = $('#instockAdjustmentFromStockCode').val();
    		var type = $("#instockAdjustmentType").val();
    		var postingDate = $("#instockAdjustmentDisplayPostingDate").val();
       	 	//MaterialSelector
       	 	MaterialSelector.init(stockCode,type,postingDate);
    	});
	}

	var changeType = function() {
    	$('#instockAdjustmentType').on('change',function(e){
    		var stockCode = $('#instockAdjustmentFromStockCode').val();
    		var type = $("#instockAdjustmentType").val();
    		var postingDate = $("#instockAdjustmentDisplayPostingDate").val();
       	 	//MaterialSelector
       	 	MaterialSelector.init(stockCode,type,postingDate);
    	});
	}
	
    var initFormSelector = function() {
    	var stockCode = $('#instockAdjustmentFromStockCode').val();
    	var type = $("#instockAdjustmentType").val();
    	var postingDate = $("#instockAdjustmentDisplayPostingDate").val();
   	 	//MaterialSelector
   	 	MaterialSelector.init(stockCode,type,postingDate);
	}
    
    var changeDate = function() {
   	    $('#instockAdjustmentDisplayPostingDate').on('change',function(e){
   	    	var stockCode = $('#instockAdjustmentFromStockCode').val();
   	    	var type = $("#instockAdjustmentType").val();
   	    	var postingDate = $("#instockAdjustmentDisplayPostingDate").val();
   	   	 	//MaterialSelector
   	   	 	MaterialSelector.init(stockCode,type,postingDate);
 	    });
	}
    
    return {
        init: function() {
        	initForm();
        	initBootstrapSwitch();
        	initSwitchery();
        	submitForm();
        	btnCancelTrans();
        	initFormSelector();
        	changeFromStockCode();
        	changeType();
        	pickerDate();
        	changeDate();
        }
    }
}();


var Custom = {
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
				});
			}
		},
		
		checkInstockAdjustmentId: () => {
			var instockAdjustmentId = $("#id").val();
			if(instockAdjustmentId) {
				$('#instockAdjustmentType').attr("disabled", true);
				$('#instockAdjustmentFromStockCode').attr("disabled", true);
				$('#tblSelectedMaterials tbody tr').find(".selected-material-code").attr("disabled", true);
				$('#tblSelectedMaterials tbody tr').find("input").attr('readonly','readonly');
				$('#templateNameModal').attr("readonly", false);
			}
		}
}
// Initialize module
// ------------------------------

document.addEventListener('DOMContentLoaded', function() {
	formComponent.init();
	Custom.loadMaterial();
	Custom.checkInstockAdjustmentId();
	formatNumberComponent.initAutoNumeric();
});
