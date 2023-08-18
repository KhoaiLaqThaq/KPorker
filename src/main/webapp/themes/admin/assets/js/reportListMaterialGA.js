var ReportListMaterialGAComponent = function() {
	var purchasingGroup;

    var _showModalProcessing = () => $('#modalLoading').addClass('d-block').removeClass('d-none');
    var _hideModalProcessing = () => $('#modalLoading').addClass('d-none').removeClass('d-block');
    
    var init = function(){
		let prGr = $("#purchasingGroupCode").val();
		if(prGr && prGr.length > 0){
			purchasingGroup = '';
			prGr.forEach(p => {
				purchasingGroup = purchasingGroup + p +',';
			});
			$('#material').prop("disabled", false);
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
   	    
   	    $(document).ready(function(){
			_showModalProcessing();
			$.ajax({
				url: getContext() + '/api/farmByUsernameLogin',
				contextType: 'application/json',
				method: 'GET',
				dataType: 'json',
				
				success: function(data) {
					listFarm = data;
					initBarnSelect();
					_hideModalProcessing();
					
				},
				error: function(err) {
					console.log(err);
				}
			});
		});
		
		$('#barnSelect').multiselect();
	}
	
	var initBarnSelect = function(){
		var farmSelected = $("#stockSelect").val();
		$("#barnSelect").html('');
		listFarm.forEach((f) => {
			if(farmSelected.indexOf(f.code) >= 0){
				addBarnToOption(f);
			}
		});
		
		$("#barnSelect").multiselect('rebuild');
	}
	
	var _handleFarmSelected = function() {
		$("#stockSelect").on('change', function(e){
			$("#barnSelect").html('');
			var farmSelected = $("#stockSelect").val();
			listFarm.forEach((f) => {
				if(farmSelected.indexOf(f.code) >= 0){
					addBarnToOption(f);
				}
			});
			$("#barnSelect").multiselect('rebuild');
		})
	}
	
	var addBarnToOption = function(item){
		var barnSelected = $("#barnCodeStrSelected").val();
		item.barns.forEach((b) => {
			if(barnSelected.indexOf(b.code) >= 0){
				$("#barnSelect").append("<option selected value='"+b.code+"'>"+b.name+"</option>'")
			} else {
				$("#barnSelect").append("<option value='"+b.code+"'>"+b.name+"</option>'")
			}
		});
	}

    var initDatePicker = function(){
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

    var _checkStockCodeValue = function() {
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

    var _checkPurchasingGroupValue = function() {
        var purchaseGroup = $('#purchasingGroupCode').val();
        if (purchaseGroup && purchaseGroup.length > 0) {
			
            return purchaseGroup;
        }
        bootbox.alert({
            title: 'Thông báo',
            message: 'Vui lòng chọn mã nhóm vật tư.'
        });
        return '';
    }

    var _checkFromDateValue = function(type) {
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

	var _checkToDateValue = function(type) {
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
     var _handleExportReportInstock = function() {
        $('#exportListMaterialGA').on('click', function(e) {
            
            var stockCode = _checkStockCodeValue();
            if (stockCode == '') return false;
            var fromDate = _checkFromDateValue();
            var toDate = _checkToDateValue();
            var purchasingGroups = _checkPurchasingGroupValue();
            if (purchasingGroups == '') return false;
            e.preventDefault();
            
            var apiExport = '/report/listMaterialGA-export-excel?'
                        + 'stockCode=' + stockCode 
                        + '&fromDate=' + fromDate 
                        + '&toDate=' + toDate 
                        + '&purchasingGroups=' + purchasingGroups;
            location.href = apiExport;
        });
    }

    var _handleSubmit = function() {
        $('#btnSubmit').on('click', function(e) {
            e.preventDefault();
            var stockCode = _checkStockCodeValue();
            if (stockCode == '') return false;
            var purchasingGroups = _checkPurchasingGroupValue();
            if (purchasingGroups == '') return false;
            var fromDate = _checkFromDateValue();
            if (fromDate == '') return false;
            var toDate = _checkToDateValue();
            if (toDate == '') return false;
            _showModalProcessing();
            $('#reportListMaterialGAForm').submit();
        })
    }
    
    var _handleLoadMaterialByPurchasingGroup = function(){
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
            initBootstrapSwitch();
            _handleExportReportInstock();
            _handleSubmit();
            _handleLoadMaterialByPurchasingGroup();
            _handleFarmSelected();
        }
    }
}();

document.addEventListener("DOMContentLoaded", function() {
    ReportListMaterialGAComponent.init();
});