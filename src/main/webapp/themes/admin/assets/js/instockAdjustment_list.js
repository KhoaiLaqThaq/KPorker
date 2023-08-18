var Component = function() {
	var submitForm = function() {
		$('#btnSubmit').on('click',function(e){
			$('#page').val(0);
			$('#instockAdjustmentForm').attr('action', '/instockAdjustment/list');
			$('#instockAdjustmentForm').submit();
		});
	}
	
    return {
        init: function() {
        	submitForm();
        }
    }
}();


// Initialize module
// ------------------------------

document.addEventListener('DOMContentLoaded', function() {
	Component.init();
});
