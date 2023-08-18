var FormComponent = function() {
	
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
    
    var submitForm = function() {
		$('#btnSubmit').on('click',function(e){
			$('#page').val(0);
            let goodsAttritionSupportForm = $('#goodsAttritionSupportForm');
            goodsAttritionSupportForm.attr('action', '/goodsAttritionSupport/list');
            goodsAttritionSupportForm.submit();
		});
	}
    
 // Daterange picker
    const initDatePicker = function(){
        // toDate
        let searchToDate = $('input[name="searchToDate"]');
        searchToDate.daterangepicker({
            singleDatePicker: true,
            autoUpdateInput: false,
            locale: {
                cancelLabel: 'Clear',
                format: 'DD/MM/YYYY'
            }
        });

        searchToDate.on('apply.daterangepicker', function(ev, picker) {
            $(this).val(picker.startDate.format('DD/MM/YYYY'));
        });

        searchToDate.on('cancel.daterangepicker', function(ev, picker) {
            $(this).val('');
        });

        // fromDate
        let searchFromDate = $('input[name="searchFromDate"]');
        searchFromDate.daterangepicker({
            singleDatePicker: true,
            autoUpdateInput: false,
            locale: {
                cancelLabel: 'Clear',
                format: 'DD/MM/YYYY'
            }
        });

        searchFromDate.on('apply.daterangepicker', function(ev, picker) {
            $(this).val(picker.startDate.format('DD/MM/YYYY'));
        });

        searchFromDate.on('cancel.daterangepicker', function(ev, picker) {
            $(this).val('');
        });
    }
    
    var resetFromSearch = function() {
		$('#btnReset').on('click',function(e){
			$('#stockName').val("");
			 $('#goodsAttritionDisplayPostingDate').val('');
		});
	}
    
    return {
        init: function() {
        	initForm();
        	initBootstrapSwitch();
        	initSwitchery();
        	submitForm();
        	resetFromSearch();
        	initDatePicker();
        }
    }
}();


document.addEventListener('DOMContentLoaded', function() {
	FormComponent.init();
});
