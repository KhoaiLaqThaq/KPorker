
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
        
        // Select All and Filtering features
	    $('.multiselect-select-all-filtering').multiselect({
	         includeSelectAllOption: true,
	         enableFiltering: true,
	         enableCaseInsensitiveFiltering: true
	    });
	}
	
	// Daterange picker
    var pickerDate = function() {
        if (!$().daterangepicker) {
            console.warn('Warning - daterangepicker.js is not loaded.');
            return;
        }
        
        // Basic initialization
        $('.daterange-basic').daterangepicker({
            applyClass: 'bg-slate-600',
            cancelClass: 'btn-light',
            locale: {
         	   format: 'DD/MM/YYYY'
            }
        });
    };
    
    var cancelDate = function() {
    	$('#goodsIssuePostingDate').on('cancel.daterangepicker', function(ev, picker) {
    		$('#goodsIssuePostingDate').val(null);	
 	 	});  	
	}
    
    
    var submitForm = function(){
    	$('#btnSubmit').on('click',function(e){
    		var farmCode = $('#selectFarmCode').val();
    		if(farmCode) {
            	var dateVal = $('#goodsIssuePostingDate').val();
            	if(dateVal) {
            		$('#postingDateSearch').val(dateVal);
            	}
            	$('#goodsAttritionSupportExportForm').attr('action', '/goodsAttritionSupport/export');
    			$('#goodsAttritionSupportExportForm').submit();
    		} else {
    			bootbox.alert({
	                title: "Thông báo:",
	                message: "Vui lòng chọn trại muốn export file",
	            });
    		}
    	});
    }
	
    return {
        init: function() {
        	initForm();
        	pickerDate();
        	cancelDate();
        	submitForm();	
        }
    }
}();


document.addEventListener('DOMContentLoaded', function() {
	Component.init();
});
