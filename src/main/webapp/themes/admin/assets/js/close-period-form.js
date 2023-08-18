var PeriodCloseFormComponent = function() {
	
	var initForm = function() {
        $('input[name="periodCloseStage"]').daterangepicker({
		    autoUpdateInput: false,
	      	locale: {
	          	cancelLabel: 'Clear',
	          	format: 'DD/MM/YYYY'
	      	}
	  	});
	  	
	  	$('input[name="periodCloseStage"]').on('apply.daterangepicker', function(ev, picker) {
	      	$(this).val(picker.startDate.format('DD/MM/YYYY') + ' - ' + picker.endDate.format('DD/MM/YYYY'));
	  	});
		
	  	$('input[name="periodCloseStage"]').on('cancel.daterangepicker', function(ev, picker) {
	      	$(this).val('');
	  	});
	}
	
    return {
        init: function() {
			initForm();
        }
    }
}();


// Initialize module
// ------------------------------

document.addEventListener('DOMContentLoaded', function() {
	PeriodCloseFormComponent.init();
});
