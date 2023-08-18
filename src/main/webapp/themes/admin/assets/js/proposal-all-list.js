
var Component = function() {
	var initForm = function() {
 		$('.select2').select2();
	}
	
	var resetSearchForm = function() {
		$('#btnReset').on('click',function(e){
			$('#poCodeInput').val("");
			$('#farmSelectBox').val(null).trigger('change');
		});
	}
	
	var submitForm = function() {
		$('#btnSubmit').on('click',function(e){
			$('#page').val(0);
			$('#proposalForm').attr('action', '/proposal/confirm/list');
			$('#proposalForm').submit();
		});
	}
	
    
    return {
        init: function() {
        	resetSearchForm();
        	submitForm();
        	initForm();
        }
    }
}();

document.addEventListener('DOMContentLoaded', function() {
	Component.init();
});

