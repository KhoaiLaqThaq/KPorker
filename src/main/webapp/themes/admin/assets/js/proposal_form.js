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
    };
	
    var submitForm = function(){
		$('#btnSubmit').on('click',function(e){
			$('#pleaseWaitDialog').modal();
			var check = checkData();
			var check2 = checkDate();
			if(check && check2){
				//set lai ngay thang nam
				var postingDate = $('#displayRecordDate').val();
				var str = postingDate.split('-');
				var month = Math.abs(str[1]) - 1; //// the month is 0-indexed
				var date = new Date(str[2],month,str[0]).toLocaleDateString('en-GB');
				document.getElementById("recordDate").value = date;
				
				$('#proposalForm').attr('action', '/proposal/save');
				$('#proposalForm').submit();
			} else {
				$('#pleaseWaitDialog').modal('hide');
			}
		});
	};
	
	var confirmForm = function(){
		$('#btnConfirm').on('click',function(e){
			$('#pleaseWaitDialog').modal();
			//set lai ngay thang nam
			var check = checkData();
			var check2 = checkDate();
			if(check && check2){
				var postingDate = $('#displayRecordDate').val();
				var str = postingDate.split('-');
				var month = Math.abs(str[1]) - 1; //// the month is 0-indexed
				var date = new Date(str[2],month,str[0]).toLocaleDateString('en-GB');
				document.getElementById("recordDate").value = date;
				
				$('#proposalForm').attr('action', '/proposal/confirm');
				$('#proposalForm').submit();
			} else {
				$('#pleaseWaitDialog').modal('hide');
			}
		});
	};
	
	var cancelForm = function(){
		$('#btnCancel').on('click',function(e){
			$('#pleaseWaitDialog').modal();
			//set lai ngay thang nam
			var check = checkData();
			var check2 = checkDate();
			if(check && check2){
				var postingDate = $('#displayRecordDate').val();
				var str = postingDate.split('-');
				var month = Math.abs(str[1]) - 1; //// the month is 0-indexed
				var date = new Date(str[2],month,str[0]).toLocaleDateString('en-GB');
				document.getElementById("recordDate").value = date;
				
				$('#proposalForm').attr('action', '/proposal/cancel');
				$('#proposalForm').submit();
			} else {
				$('#pleaseWaitDialog').modal('hide');
			}
		});
	};
	
	var checkData = function(){
		var quantity = $("#totalProposal").val();
		if(quantity != "" && !isNaN(quantity) && quantity != 0){
			var pigRetained = $("#pigRetained").val();
			
			var pigRetainedInt = parseInt(pigRetained);
			var quantityInt = parseInt(quantity);
			
			console.log(pigRetainedInt);
			console.log(quantityInt);
			
			
			if(pigRetainedInt >= quantityInt){
				return true;
			} else {
				bootbox.alert({
		            title: 'Thông báo',
		            message: 'Số lượng bán lớn hơn số lượng heo tồn.'
		        });
		        return false;
			}
		}
		
		bootbox.alert({
            title: 'Thông báo',
            message: 'Vui lòng nhập số lượng.'
        });
        return false;
	}
	
	var checkDate = function(){
		var postingDate = $('#displayRecordDate').val();
		var str1 = postingDate.split('-');
		var month1 = Math.abs(str1[1]) - 1; //// the month is 0-indexed
		var recordDate = new Date(str1[2],month1,str1[0]).toLocaleDateString('en-GB');
		
		var estimate = $('#saleEstimate').val();
		var str2 = estimate.split('-');
		var month2 = Math.abs(str2[1]) - 1; //// the month is 0-indexed
		var estimateDate = new Date(str2[2],month2,str2[0]).toLocaleDateString('en-GB');
		if(estimateDate >= recordDate){
			return true;
		} else {
			bootbox.alert({
	            title: 'Thông báo',
	            message: 'Vui lòng nhập thời gian dự kiến lớn hơn hiện tại.'
	        });
			return false;
		}
	}
    
    return {
        init: function() {
        	initForm();
        	initBootstrapSwitch();
        	initSwitchery();
        	pickerDate();
        	submitForm();
        	confirmForm();
        	cancelForm();
        }
    }
}();

// ------------------------------

document.addEventListener('DOMContentLoaded', function() {
	FormComponent.init();
});

