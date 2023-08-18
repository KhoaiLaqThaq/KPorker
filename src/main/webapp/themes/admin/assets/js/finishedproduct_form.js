var FinishedProductFormComponent = function() {
	
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
	
	var sendData = function(){
		$('#btnSendData').on('click',function(e){
			$('#finishedproductForm').attr('action', '/finishedProduct/sendData');
			$('#finishedproductForm').submit();
		});
	};
    
    return {
        init: function() {
        	initForm();
        	initBootstrapSwitch();
        	initSwitchery();
        	sendData();
        }
    }
}();

// Initialize module
// ------------------------------

document.addEventListener('DOMContentLoaded', function() {
	FinishedProductFormComponent.init();
});
