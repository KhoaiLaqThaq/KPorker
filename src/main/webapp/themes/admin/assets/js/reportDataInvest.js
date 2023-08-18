var ReportDataInvestComponent = function() {
	var listFarm;
	
	var initForm = function() {
 	 	$('input[name="stage"]').daterangepicker({
            singleDatePicker: true,
		    autoUpdateInput: false,
		    locale: {
		        cancelLabel: 'Clear',
		        format: 'DD/MM/YYYY'
		    }
		});
		  
		$('input[name="stage"]').on('apply.daterangepicker', function(ev, picker) {
            $(this).val(picker.startDate.format('DD/MM/YYYY'));
        });
      
        $('input[name="stage"]').on('cancel.daterangepicker', function(ev, picker) {
            $(this).val('');
        });
		 
 	 	$('.select2').select2();
 	 	
        // bootbox
        if (typeof bootbox == 'undefined') {
            console.warn('Warning - bootbox.min.js is not loaded.');
            return;
        };
        
		//apply datatable 
		try{
			var t = $('#table-report').DataTable( {
			    scrollY:        "600px",
		        scrollX:        true,
		        scrollCollapse: true,
		        paging:         false,
		        searching:		false,
		        fixedColumns:   {
					leftColumns: 2,
				},
				columnDefs: [
		            {
		                orderable: false,
		                targets: 0,
		            },
		        ],
		        order: [[1, 'asc']],
			});
			
			t.on('order.dt', function () {
		        let i = 1;
		 
		        t.cells(null, 0, { search: 'applied', order: 'applied' }).every(function (cell) {
		            this.data(i++);
		        });
		    }).draw()
		} catch(err){
			console.warn('Warning - datatable not loaded.');
		}
		
		$('#stockSelect').multiselect({
            includeSelectAllOption: true,
            enableFiltering: true,
            enableCaseInsensitiveFiltering: true
        });
        
		insertSelectOption();
	}
	
	var insertSelectOption = function(){
		$(document).on('keyup', '.multiselect-search', function(e){
			if(e.key === 'Enter' || e.keyCode === 13){
				let searchStr = $(this).val();
				let array = searchStr.split(",").map(function(item){
					return item.trim();
				})
				
				let list = $('#stockSelect option');
				
				list.each(function(index, item){
					if(array.includes(item.text)){
						item.selected = true;
					} else {
						item.selected = false;
					}
				})
				
				$('.multiselect-search').val(null); 
				$("#stockSelect").multiselect('rebuild');
				
			}
		})
	}
	
	var _handleExportReport = function() {
        $('#exportReportInvest').on('click', function(e) {
            
            var stockCode = _checkStockCodeValue();
            if (stockCode == '') return false;
            var stockCodeStr = '';
            stockCode.forEach(s => {
				stockCodeStr = stockCodeStr + s + ',';
			});
			
            var stage = $('#stage').val();
            e.preventDefault();
            var apiExport;
            apiExport = '/report/data-invest-export-excel?stockCodes=' + stockCodeStr + '&stage=' + stage;
            console.log(apiExport);
            location.href = apiExport;
        });
    }
    
    var resetSearchForm = function() {
		$('#btnReset').on('click',function(e){
			$('#stage').val(null);
			$('#stockSelect').val(null).trigger('change');
			$('#reportDataInvesetForm').submit();
		});
	}
	
	var _showModalProcessing = () => $('#modalLoading').addClass('d-block').removeClass('d-none');
	
	var _checkStockCodeValue = function() {
        var stockCode = $('#stockSelect').val();
        if (stockCode.length != 0) {
            return stockCode;
        }
        bootbox.alert({
            title: 'Thông báo',
            message: 'Vui lòng chọn trại.'
        });
        return '';
    }

    var _checkStageValue = function() {
        var stage = $('#stage').val();
        if (stage && stage.length > 0) {
            return stage;
        }
        bootbox.alert({
            title: 'Thông báo',
            message: 'Vui lòng chọn thời gian.'
        });
        return '';
    }
    
    var _handleSubmit = function() {
        $('#btnSubmit').on('click', function(e) {
            e.preventDefault();
            var stockCode = _checkStockCodeValue();
            if (stockCode == '') return false;
            var stage = _checkStageValue();
            if (stage == '') return false;
            _showModalProcessing();
            $('#reportDataInvesetForm').submit();
        })
    }
	
    return {
        init: function() {
        	initForm();
        	resetSearchForm();
        	_handleSubmit();
        	_handleExportReport();
        }
    }
}();

document.addEventListener('DOMContentLoaded', function() {
	ReportDataInvestComponent.init();
});
