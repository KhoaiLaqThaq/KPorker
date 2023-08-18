const BOOTBOX = {
	TITLE: "Thông báo"
};

const MESSAGE = {
	DATE_REQUIRED: "Yêu cầu chọn ngày xuất",
	FARM_NAME_REQUIRED: "Yêu cầu nhập tên trại",
	PROCESS_ORDER_REQUIRED: "Yêu cầu nhập lệnh sản xuất"
}

const Component = function() {
	const initForm = function() {
        if (!$().select2) {
            return;
        }
    	// select2
   	 	$('.select2').select2();
   	 	
		// toDate
		$('input[name="toDate"]').daterangepicker({
			singleDatePicker: true,
		    autoUpdateInput: false,
	      	locale: {
	          	cancelLabel: 'Clear',
	          	format: 'DD/MM/YYYY'
	      	}
	  	});
	  	
	  	$('input[name="toDate"]').on('apply.daterangepicker', function(ev, picker) {
	      	$(this).val(picker.startDate.format('DD/MM/YYYY'));
	  	});
		
	  	$('input[name="toDate"]').on('cancel.daterangepicker', function(ev, picker) {
	      	$(this).val('');
	  	});

        // fromDate
        $('input[name="fromDate"]').daterangepicker({
			singleDatePicker: true,
		    autoUpdateInput: false,
	      	locale: {
	          	cancelLabel: 'Clear',
	          	format: 'DD/MM/YYYY'
	      	}
	  	});
	  	
	  	$('input[name="fromDate"]').on('apply.daterangepicker', function(ev, picker) {
	      	$(this).val(picker.startDate.format('DD/MM/YYYY'));
	  	});
		
	  	$('input[name="fromDate"]').on('cancel.daterangepicker', function(ev, picker) {
	      	$(this).val('');
	  	});
	}

	const _checkRequired = function(fieldId, message) {
		let selectorVal = $(`#${fieldId}`).val();
		if (selectorVal && selectorVal !== '') return selectorVal;
		bootbox.alert({ title: BOOTBOX.TITLE, message: message });
		return '';
	}
    
    const submitForm = function() {
    	$('#btnSubmit').on('click',function(e){
			// TODO: Validate form before submit
			let fromDate = _checkRequired('fromDate', MESSAGE.DATE_REQUIRED);
			if (fromDate === '') return false;
			let toDate = _checkRequired('toDate', MESSAGE.DATE_REQUIRED);
			if (toDate === '') return false;
			$('#page').val(0);

			// TODO: Submit form
			let formSelector = $('#salesForm');
			formSelector.attr('action', '/sales/list');
			formSelector.submit();
		});
    }
    
	const resetFromSearch = function() {
		$('#btnReset').on('click',function(e){
			$('#fromDate').val('');
			$('#toDate').val('');
			$('#farmName').val('');
			$('#processOrderCode').val('');
		});
	}

	const exportToFile = function(){
		$("#btnSubmitToExport").on('click', function(e){
			e.preventDefault();
			_showLoading();
			let farmName = $('#farmName').val();
			let processOrderCode = $('#processOrderCode').val();
			let fromDate = $('#fromDate').val();
			let toDate = $('#toDate').val();

			let url = "/sales/export-excel";
			if (farmName && farmName !== '') url +='?stockName=' + farmName;
			url += `${farmName !== '' ? '&fromDate=' : '?date'}${fromDate}`;
			url += `&toDate=${toDate}`;
			url += `&processOrder=${processOrderCode}`;
			DownloadFile(url);
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
				let downloadUrl = URL.createObjectURL(result);
		        let a = document.createElement("a");
		        a.href = downloadUrl;
		        a.download = "saleExport.xls";
		        document.body.appendChild(a);
		        a.click();
		        $('#pleaseWaitDialog').modal('hide');
		    }
		}).always(() => _hideLoading());
    }

	const _showLoading = () => $('#modalLoading').addClass('d-block').removeClass('d-none');
	const _hideLoading = () => $('#modalLoading').addClass('d-none').removeClass('d-block');
    
    return {
        init: function() {
        	initForm();
        	submitForm();
        	resetFromSearch();
        	exportToFile();
        }
    }
}();


// Initialize module
// ------------------------------

document.addEventListener('DOMContentLoaded', function() {
	Component.init();
});
