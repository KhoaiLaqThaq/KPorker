var Component = function() {
	
	var initForm = function() {
        if (!$().select2) {
            return;
        }
   	 	$('.select2').select2();
	}
	
	var btnReset = function() {
		$('#btnReset').on('click',function(e){
			$('#code').val("");
			$('#name').val("");
			$('#status').val(null).trigger('change');
		});
	}
	
	var submitForm = function() {
		$('#btnSubmit').on('click',function(e){
			$('#page').val(0);
			$('#documentTypeForm').attr('action', '/documentType/list');
			$('#documentTypeForm').submit();
		});
	}
    
    return {
        init: function() {
        	initForm();
        	btnReset();
        	submitForm();
        }
    }
}();

// Initialize module
// ------------------------------

document.addEventListener('DOMContentLoaded', function() {
	Component.init();
});
