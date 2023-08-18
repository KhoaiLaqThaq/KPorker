var Component = function() {
	
	// Daterange picker
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
       
       var iValue = $('#displayPostingDate').val();
       if (iValue.length > 0) {
    	   $('#postingDateStr').val(iValue);
       } else {
    	   $('#postingDateStr').val('');
       }
    };
    
    var submitForm = function() {
    	$('#btnSubmit').on('click',function(e){
    		//set lai ngay thang nam
			/*var postingDate = $('#postingDateStr').val();
			if(postingDate){
				var str = postingDate.split('-');
				var month = Math.abs(str[1]) - 1; //// the month is 0-indexed
				var date = new Date(str[2],month,str[0]).toLocaleDateString('en-GB');
				document.getElementById("postingDate").value = date;
			}*/
			$('#page').val(0);
			$('#stockCountForm').attr('action', '/stockCount/list');
			$('#stockCountForm').submit();
		});
    }
    
    var resetFromSearch = function() {
		$('#btnReset').on('click',function(e){
			$('#postingDateStr').val('');
			$('#farmName').val('');
		});
	}
    
    return {
        init: function() {
        	pickerDate();
        	submitForm();
        	resetFromSearch();
        }
    }
}();


// Initialize module
// ------------------------------

document.addEventListener('DOMContentLoaded', function() {
	Component.init();
});
