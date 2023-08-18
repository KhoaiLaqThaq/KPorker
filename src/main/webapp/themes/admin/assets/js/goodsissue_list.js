var Component = function() {
	
	var initForm = function() {
        if (!$().select2) {
            return;
        }
    	// select2
   	 	$('.select2').select2();
   	 	
   	 	// Switchery
	   	 if (typeof Switchery == 'undefined') {
	         return;
	     }
	     // Initialize multiple switches
	     var elems = Array.prototype.slice.call(document.querySelectorAll('.form-check-input-switchery'));
	     elems.forEach(function(html) {
	       var switchery = new Switchery(html);
	     });
	     
	     // Bootstrap switch
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
	}
	
	var resetFromSearch = function() {
		$('#btnReset').on('click',function(e){
			$('#transCode').val("");
			$('#stockName').val("");
			$('#doCode').val("");
			$('#poCode').val("");
			$('#status').val(null).trigger('change');
			$('#goodsIssueDisplayPostingDate').val('');
		});
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
	
	var viewTemplate = function(){
		$('#btnView').on('click',function(e){
			var valueSelected = $('#selectTemplate option:selected').val(); 
			if(valueSelected) {
				window.location.href = getContext() + "/goodsIssue/form?id=" + valueSelected;
			} else {
				$("#modal_template").modal('hide');
				bootbox.alert({
	                title: 'Thông báo:',
	                message: 'Vui lòng chọn template.'
	            });
			}
		});
	}
	
	var deleteTemplate = function(){
		$('#btnDelete').on('click',function(e){
			var valueSelected = $('#selectTemplate option:selected').val();
			var name = $('#selectTemplate option:selected').text(); 
			if(valueSelected) {
				$("#modal_template").modal('hide');
				bootbox.confirm({
					title: "Xác nhận:",
				    message: "Bạn có chắc chắn muốn xóa template: " + name + " không?",
				    buttons: {
				        confirm: {
				            label: 'Xác nhận',
				            className: 'btn-success'
				        },
				        cancel: {
				            label: 'Từ chối',
				            className: 'btn-danger'
				        }
				    },
				    callback: function (result) {
				    	if(result){
							window.location.href = getContext() + "/goodsIssue/delete/" + valueSelected;
				    	}
				    }
				});
			} else {
				$("#modal_template").modal('hide');
				bootbox.alert({
	                title: 'Thông báo:',
	                message: 'Vui lòng chọn template.'
	            });
			}
		});
	}
	
	var submitForm = function() {
		$('#btnSubmit').on('click',function(e){
			$('#page').val(0);
			$('#goodsissueForm').attr('action', '/goodsIssue/list');
			$('#goodsissueForm').submit();
		});
	}
    
    return {
        init: function() {
        	initForm();
        	resetFromSearch();
        	viewTemplate();
        	deleteTemplate();
        	initDatePicker();
        	submitForm();
        }
    }
}();

// Initialize module
// ------------------------------

document.addEventListener('DOMContentLoaded', function() {
	Component.init();
});
