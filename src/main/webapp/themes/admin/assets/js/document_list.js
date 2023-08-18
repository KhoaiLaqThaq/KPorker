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
	
	const _initDatePicker = function() {
    /*
     * Initialize the date picker
     */
    $('input[name="searchFromDateStr"]').daterangepicker({
			singleDatePicker: true,
		    autoUpdateInput: false,
				locale: {
					cancelLabel: 'Clear',
					format: 'DD-MM-YYYY'
				}
		});
	  	
		$('input[name="searchFromDateStr"]').on('apply.daterangepicker', function(ev, picker) {
				$(this).val(picker.startDate.format('DD-MM-YYYY'));
		});
	
		$('input[name="searchFromDateStr"]').on('cancel.daterangepicker', function(ev, picker) {
				$(this).val('');
		});

		$('input[name="searchToDateStr"]').daterangepicker({
		singleDatePicker: true,
			autoUpdateInput: false,
				locale: {
						cancelLabel: 'Clear',
						format: 'DD-MM-YYYY'
				}
		});
		
		$('input[name="searchToDateStr"]').on('apply.daterangepicker', function(ev, picker) {
				$(this).val(picker.startDate.format('DD-MM-YYYY'));
		});
	
		$('input[name="searchToDateStr"]').on('cancel.daterangepicker', function(ev, picker) {
				$(this).val('');
		});
	};

	var resetFromSearch = function() {
		$('#btnReset').on('click',function(e){
			$('#farmCode').val("");
			$('#farmName').val("");
			$('#from__date').val("");
			$('#to__date').val("");
			$('#status').val(null).trigger('change');
		});
	}

	const showModal = () => $('#modalLoading').addClass('d-block').removeClass('d-none');
	
	var submitForm = function() {
		$('#btnSubmit').on('click',function(e){
			$("#farmName").val($("#farmName").val().trim())
			$("#farmCode").val($("#farmCode").val().trim())
			$('#page').val(0);
			$('#documentForm').attr('action', '/document/list');
			$('#documentForm').submit();
		});
	}
	
    return {
        init: function() {
       		_initDatePicker();
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