var Component = function() {
	
	var initForm = function() {
        if (!$().select2) {
            return;
        }
    	// select2
   	 	$('.select2').select2();
	}
	
    var pickerDate = function() {
        if (!$().daterangepicker) {
            console.warn('Warning - daterangepicker.js is not loaded.');
            return;
        }
        // Single picker
       $('.daterange-single').daterangepicker({ 
           singleDatePicker: true,
           locale: {
        	   format: 'DD-MM-YYYY'
           }
       });
       var iValue = $('#displaySyncDate').val();
       if (iValue.length > 0) {
    	   $('#syncDateStr').val(iValue);
       } else {
    	   $('#syncDateStr').val('');
       }
    };
    
    var submitForm = function() {
    	$('#btnSubmit').on('click',function(e){
    		//set lai ngay thang nam
			/*var postingDate = $('#syncDateStr').val();
			var str = postingDate.split('-');
			var month = Math.abs(str[1]) - 1; //// the month is 0-indexed
			var date = new Date(str[2],month,str[0]).toLocaleDateString('en-GB');
			document.getElementById("syncDate").value = date;*/
			$('#page').val(0);
			$('#instockBaselineForm').attr('action', '/instock-baseline/list');
			$('#instockBaselineForm').submit();
		});
    }
    
    var fileInput = function() {
		$('.file-input').fileinput({
	         browseLabel: 'Browse',
	         browseIcon: '<i class="icon-file-plus mr-2"></i>',
	         uploadIcon: '<i class="icon-file-upload2 mr-2"></i>',
	         removeIcon: '<i class="icon-cross2 font-size-base mr-2"></i>',
	     });
	};
	
	var resetFromSearch = function() {
		$('#btnReset').on('click',function(e){
			$('#syncDateStr').val('');
			$('#farmName').val('');
		});
	}
    
    return {
        init: function() {
        	initForm();
        	pickerDate();
        	submitForm();
        	fileInput();
        	resetFromSearch();
        }
    }
}();


// Initialize module
// ------------------------------

document.addEventListener('DOMContentLoaded', function() {
	Component.init();
});
