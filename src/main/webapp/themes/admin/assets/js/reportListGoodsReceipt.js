const ReportGoodsReceiptComponent = function() {
	let purchasingGroup;
	
	const init = function(){
		let prGr = $("#purchasingGroupCode").val();
		console.log(prGr);
		if(prGr && prGr.length > 0){
			purchasingGroup = '';
			prGr.forEach(p => {
				purchasingGroup = purchasingGroup + p +',';
			});
			$('#material').prop("disabled", false);
			console.log(purchasingGroup);
		}
		
		$('#material').select2({
   	    	minimumInputLength: 1,
   	    	minimumResultsForSearch: Infinity,
   	    	ajax: {
   	            url: getContext() + '/api/material/get-by-purchasing-group',
   	            type: 'GET',
   	            dataType: 'json',
   	            data: function (params) {
   	                return {
						purchasingGroups: purchasingGroup,
   	                    code: params.term,
   	                };
   	            },
   	           processResults: function (data, params) {
				   $('#material').html('');
   	                return {
   	                    results: $.map(data, function (item) {
   	                        return {
   	                        	text: item.code +": "+ item.name,
   	                        	id: item.code,
   	                            data: item
   	                        };
   	                    })
   	                };
   	            },
   	        },
   	    });
	}

	const _eventListenClick = function() {
		$('#material').on('change', function() {
			$("input[name='materialName']").val(this.innerText);
		})
	}

    const initDatePicker = function(){
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

    const _checkStockCodeValue = function() {
        var stockCode = $('#stockSelect').val();
        if (stockCode || stockCode != '') {
            return stockCode;
        }
        bootbox.alert({
            title: 'Thông báo',
            message: 'Vui lòng chọn trại.'
        });
        return '';
    }

	const _checkFromDateValue = function(type) {
		var fromDate = $('#fromDate').val();
        if (fromDate && fromDate.length > 0) {
            return fromDate;
        }
        bootbox.alert({
            title: 'Thông báo',
            message: 'Vui lòng chọn giai đoạn đầu.'
        });
        return '';
	}

	const _checkToDateValue = function(type) {
		var toDate = $('#toDate').val();
        if (toDate && toDate.length > 0) {
            return toDate;
        }
        bootbox.alert({
            title: 'Thông báo',
            message: 'Vui lòng chọn giai đoạn cuối.'
        });
        return '';
	}

    /**
     * Hàm này để export 
     */
     const _handleExportReportInstock = function() {
        $('#exportListGoodsReceipt').on('click', function(e) {
            
            var stockCode = _checkStockCodeValue();
            if (stockCode == '') return false;
            var fromDate = _checkFromDateValue();
            var toDate = _checkToDateValue();
            let prGr = $("#purchasingGroupCode").val();
            e.preventDefault();
            
            var apiExport = '/report/listGoodsReceipt-export-excel?'
						+ 'stockCode=' + stockCode 
						+ '&purchasingGroupCode=' + prGr 
						+ '&fromDate=' + fromDate
						+ '&toDate=' + toDate;
            location.href = apiExport;
        });
    }

    const _handleSubmit = function() {
        $('#btnSubmit').on('click', function(e) {
            e.preventDefault();
            var stockCode = _checkStockCodeValue();
            if (stockCode == '') return false;
			var fromDate = _checkFromDateValue();
            if (fromDate == '') return false;
            var toDate = _checkToDateValue();
            if (toDate == '') return false;
            $('#reportListGoodsReceiptForm').submit();
        })
    }
    
    const _handleLoadMaterialByPurchasingGroup = function(){
		$("#purchasingGroupCode").on('change', function(){
			let prGr = $("#purchasingGroupCode").val();
			purchasingGroup = '';
			if(prGr && prGr.length > 0){
				$('#material').prop("disabled", false);
				prGr.forEach(p => {
					purchasingGroup = purchasingGroup + p +',';
				});
				console.log(purchasingGroup);
			} else {
				$('#material').val(null).trigger('change');
				$('#material').prop("disabled", true);
			}
		});
	}

    return {
        init: function() {
			init();
            initDatePicker();
			_eventListenClick();
            _handleSubmit();
            _handleExportReportInstock();
            _handleLoadMaterialByPurchasingGroup();
        }
    }
}();

document.addEventListener('DOMContentLoaded', function() {
    ReportGoodsReceiptComponent.init();
});