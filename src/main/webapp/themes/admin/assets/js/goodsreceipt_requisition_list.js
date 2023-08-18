var Component = function() {
	
	var initForm = function() {
        if (!$().select2) {
            return;
        }
    	// select2
   	 	$('.select2').select2();
   	 	
   	 	// Switchery
	   	 if (typeof Switchery == 'undefined') {
	         return;
	     }
	     // Initialize multiple switches
	     var elems = Array.prototype.slice.call(document.querySelectorAll('.form-check-input-switchery'));
	     elems.forEach(function(html) {
	       var switchery = new Switchery(html);
	     });
	     
	     // Bootstrap switch
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
	}
	
	var submitForm = function() {
		$('#btnSubmit').on('click',function(e){
			$('#page').val(0);
			$('#goodsreceiptForm').attr('action', '/goodsReceipt-Requisition/list');
			$('#goodsreceiptForm').submit();
		});
	}
	
	var resetFromSearch = function() {
		$('#btnReset').on('click',function(e){
			$('#stockName').val("");
			$('#doCode').val("");
			$('#status').val(null).trigger('change');
			$('#poCode').val("");
		});
	}
    
    return {
        init: function() {
        	initForm();
        	resetFromSearch();
        	submitForm();
        }
    }
}();

// Initialize module
// ------------------------------

document.addEventListener('DOMContentLoaded', function() {
	Component.init();
});

function checkDelete(id) {
	bootbox.confirm({
		title: "Xác nhận:",
	    message: "Bạn có chắc chắn muốn xóa phiếu yêu cầu nhập kho này không?",
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
				window.location.href = getContext() + "/goodsReceipt-Requisition/delete/" + id;
	    	}
	    }
	});
}