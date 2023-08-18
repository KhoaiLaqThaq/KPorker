
var Component = function() {
	
	var initForm = function() {
 		$('.select2').select2();
	}
	
	var resetSearchForm = function() {
		$('#btnReset').on('click',function(e){
			$('#poCodeInput').val("");
			$('#barnCodeInput').val("");
			$('#fromDate').val(null);
			$('#toDate').val(null);
			$('#fromCloseDate').val(null);
			$('#toCloseDate').val(null);
			$('#status').val(null).trigger('change');
		});
	}
	
	var submitForm = function() {
		$('#btnSubmit').on('click',function(e){
			$('#page').val(0);
			$('#processOrderForm').attr('action', '/processOrder/list');
			$('#processOrderForm').submit();
		});
	}

	var initDatePicker = function(){
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
		
		// toDate Close
		$('input[name="searchCloseToDate"]').daterangepicker({
			singleDatePicker: true,
			autoUpdateInput: false,
			locale: {
				cancelLabel: 'Clear',
				format: 'DD/MM/YYYY'
			}
		});

		$('input[name="searchCloseToDate"]').on('apply.daterangepicker', function(ev, picker) {
			$(this).val(picker.startDate.format('DD/MM/YYYY'));
		});

		$('input[name="searchCloseToDate"]').on('cancel.daterangepicker', function(ev, picker) {
			$(this).val('');
		});

		// fromDate Close
		$('input[name="searchCloseFromDate"]').daterangepicker({
			singleDatePicker: true,
			autoUpdateInput: false,
			locale: {
				cancelLabel: 'Clear',
				format: 'DD/MM/YYYY'
			}
		});

		$('input[name="searchCloseFromDate"]').on('apply.daterangepicker', function(ev, picker) {
			$(this).val(picker.startDate.format('DD/MM/YYYY'));
		});

		$('input[name="searchCloseFromDate"]').on('cancel.daterangepicker', function(ev, picker) {
			$(this).val('');
		});
	}
    
    function DownloadFile(urlFile) {
            $.ajax({
		    type: "GET",
		    url: urlFile,
		    xhrFields:{
		        responseType: 'blob'
		    },
		    success: function (result) {
		        console.log(result)
		        var blob = result;
		        var downloadUrl = URL.createObjectURL(blob);
		        var a = document.createElement("a");
		        a.href = downloadUrl;
		        a.download = "processOrder.xls";
		        document.body.appendChild(a);
		        a.click();
		        $('#pleaseWaitDialog').modal('hide');
		    }
		});
    };
    
    const _handleExportProcessOrder = function() {
        $('#exportProcessOrder').on('click', function(e) {
            e.preventDefault();
            $('#pleaseWaitDialog').modal();
            let poCode = $("#poCodeInput").val();
            let barn = $("#barnCodeInput").val();
            let fromDate = $("#fromDate").val();
			let toDate = $("#toDate").val();
			let fromCloseDate = $("#fromCloseDate").val();
			let toCloseDate = $("#toCloseDate").val();
            let status = $("#status").val();
            
            let apiExport = '/report/processOrder?poCode=' + poCode + '&barn=' + barn+ '&searchFromDate='+fromDate +'&searchToDate='+toDate+ '&status='+status+ '&searchFromCloseDate='+fromCloseDate+ '&searchToCloseDate='+toCloseDate;
            DownloadFile(apiExport);
            /*location.href = apiExport;
            $('#pleaseWaitDialog').modal('hide');*/
        });
    }
	
    return {
        init: function() {
        	initForm();
        	resetSearchForm();
        	submitForm();
			initDatePicker();
        	_handleExportProcessOrder();
        }
    }
}();

document.addEventListener('DOMContentLoaded', function() {
	Component.init();
});

