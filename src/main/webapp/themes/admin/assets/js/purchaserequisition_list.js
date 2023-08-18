var Component = function() {
	var initForm = function() {
        if (!$().select2) {
            return;
        }
    	// select2
   	 	$('.select2').select2();
   	 	
   	 	// bootbox
        if (typeof bootbox == 'undefined') {
            console.warn('Warning - bootbox.min.js is not loaded.');
            return;
        }
	}
	
	var resetFromSearch = function() {
		$('#btnReset').on('click',function(e){
			$('#transCode').val("");
			$('#stockName').val("");
			$('#status').val(null).trigger('change');
			$('#type').val(null).trigger('change');
			$('#purchaserequisitionPrType').val(null).trigger('change');
		});
	}
	
	var viewTemplate = function(){
		$('#btnView').on('click',function(e){
			var valueSelected = $('#selectTemplate option:selected').val(); 
			if(valueSelected) {
				var url = getContext() + "/purchaseRequisition/form?id=" + valueSelected;
				window.location.href = url;
			} else {
				$("#modal_template").modal('hide');
				bootbox.alert({
	                title: 'Thông báo:',
	                message: 'Vui lòng chọn template.'
	            });
			}
		});
	}
	
	var deleteTemplate = function(){
		$('#btnDelete').on('click',function(e){
			var valueSelected = $('#selectTemplate option:selected').val();
			var name = $('#selectTemplate option:selected').text(); 
			if(valueSelected) {
				$("#modal_template").modal('hide');
				bootbox.confirm({
					title: "Xác nhận:",
				    message: "Bạn có chắc chắn muốn xóa template: " + name + " không?",
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
				    		var url = getContext() + "/purchaseRequisition/delete/" + valueSelected;
							window.location.href = url;
				    	}
				    }
				});
			} else {
				$("#modal_template").modal('hide');
				bootbox.alert({
	                title: 'Thông báo:',
	                message: 'Vui lòng chọn template.'
	            });
			}
		});
	}
	
	var submitForm = function() {
		$('#btnSubmit').on('click',function(e){
			$('#page').val(0);
			$('#purchaserequisitionForm').attr('action', '/purchaseRequisition/list');
			$('#purchaserequisitionForm').submit();
		});
	}
	
    return {
        init: function() {
        	initForm();
        	resetFromSearch();
        	viewTemplate();
        	deleteTemplate();
        	submitForm();
        }
    }
}();


// Initialize module
// ------------------------------

document.addEventListener('DOMContentLoaded', function() {
	Component.init();
});


// function Xóa phiếu yêu cầu mua hàng
function checkDelete(id) {
	bootbox.confirm({
		title: "Xác nhận:",
	    message: "Bạn có chắc chắn muốn xóa phiếu yêu cầu mua hàng này không?",
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
	    		var url = getContext() + "/purchaseRequisition/delete/" + id;
				window.location.href = url;
	    	}
	    }
	});
}