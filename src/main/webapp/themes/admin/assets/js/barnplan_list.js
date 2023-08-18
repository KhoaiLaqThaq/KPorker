var Component = function() {
	var initForm = function() {
        if (!$().select2) {
            return;
        }
    	// select2
   	 	$('.select2').select2();
	}
	
	// Daterange picker
	const initDatePicker = function(){
		// toDate
		$('input[name="searchToDate"]').daterangepicker({
			singleDatePicker: true,
			autoUpdateInput: false,
			locale: {
				cancelLabel: 'Clear',
				format: 'DD/MM/YYYY'
			}
		});

		$('input[name="searchToDate"]').on('apply.daterangepicker', function(ev, picker) {
			$(this).val(picker.startDate.format('DD/MM/YYYY'));
		});

		$('input[name="searchToDate"]').on('cancel.daterangepicker', function(ev, picker) {
			$(this).val('');
		});

		// fromDate
		$('input[name="searchFromDate"]').daterangepicker({
			singleDatePicker: true,
			autoUpdateInput: false,
			locale: {
				cancelLabel: 'Clear',
				format: 'DD/MM/YYYY'
			}
		});

		$('input[name="searchFromDate"]').on('apply.daterangepicker', function(ev, picker) {
			$(this).val(picker.startDate.format('DD/MM/YYYY'));
		});

		$('input[name="searchFromDate"]').on('cancel.daterangepicker', function(ev, picker) {
			$(this).val('');
		});
	}
	
	var resetFromSearch = function() {
		$('#btnReset').on('click',function(e){
			$('#farmName').val("");
			$('#barnCode').val("");
			$('#barnEmptyDateSearchPeriod').val("");
			$('#status').val(null).trigger('change');
		});
	}
	
	var submitForm = function() {
		$('#btnSubmit').on('click',function(e){
			$('#page').val(0);
			$('#barnPlanForm').attr('action', '/barnPlan/list');
			$('#barnPlanForm').submit();
		});
	}
	
    return {
        init: function() {
        	initForm();
        	resetFromSearch();
        	submitForm();
        	initDatePicker();
        }
    }
}();


// Initialize module
// ------------------------------

document.addEventListener('DOMContentLoaded', function() {
	Component.init();
});

