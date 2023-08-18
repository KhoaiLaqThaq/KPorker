const BOOTBOX = {
	TITLE: "Thông báo"
};

const MESSAGE = {
	DATE_REQUIRED: "Yêu cầu chọn giai đoạn",
	FARM_REQUIRED: "Yêu cầu chọn trại"
};

const ReportSaleEstimateComponent = function() {
	let listFarm;
	
	const initForm = function() {
		let toDate = $('input[name="toDate"]');
		// toDate
		toDate.daterangepicker({
			singleDatePicker: true,
			autoUpdateInput: false,
			locale: {
				cancelLabel: 'Clear',
				format: 'DD/MM/YYYY'
			}
		});

		toDate.on('apply.daterangepicker', function(ev, picker) {
			$(this).val(picker.startDate.format('DD/MM/YYYY'));
		});

		toDate.on('cancel.daterangepicker', function(ev, picker) {
			$(this).val('');
		});

		// fromDate
		let fromDate = $('input[name="fromDate"]');
		fromDate.daterangepicker({
			singleDatePicker: true,
			autoUpdateInput: false,
			locale: {
				cancelLabel: 'Clear',
				format: 'DD/MM/YYYY'
			}
		});

		fromDate.on('apply.daterangepicker', function(ev, picker) {
			$(this).val(picker.startDate.format('DD/MM/YYYY'));
		});

		fromDate.on('cancel.daterangepicker', function(ev, picker) {
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
		
		/*$('#barnSelect').multiselect();*/
		
		$('#stockSelect').multiselect({
            includeSelectAllOption: true,
            enableFiltering: true,
            enableCaseInsensitiveFiltering: true
        });
        
		insertSelectOption();
	}
	
	const insertSelectOption = function(){
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
	
	const _handleExportReportInstock = function() {
        $('#exportReportInstock').on('click', function(e) {
			e.preventDefault();
            let stockCode = _checkRequired("stockSelect", MESSAGE.FARM_REQUIRED);
            if (stockCode === '') return false;
            let stockCodeStr = '';
            stockCode.forEach(s => stockCodeStr += s + ',');
            
            let fromDate = _checkRequired('fromDate', MESSAGE.DATE_REQUIRED);
			if (fromDate === '') return false;
			let toDate = _checkRequired('toDate', MESSAGE.DATE_REQUIRED);
			if (toDate === '') return false;
            location.href = `/report/prod-result-export-excel?stockCodes=${stockCodeStr}&fromDate=${fromDate}&toDate=${toDate}`;
        });
    }
    
    const resetSearchForm = function() {
		$('#btnReset').on('click',function(e){
			$('#fromDate').val('');
			$('#toDate').val('');
			$('#stockSelect').val(null).trigger('change');
			$('#reportForm').submit();
		});
	}
	
	const _showModalProcessing = () => $('#modalLoading').addClass('d-block').removeClass('d-none');

    const _checkRequired = function(fieldId, message) {
        let fieldSelector = $(`#${fieldId}`).val();
        if (fieldSelector && fieldSelector !== '') return fieldSelector;
        bootbox.alert({ title: BOOTBOX.TITLE, message: message });
        return '';
    }
    
    const _handleSubmit = function() {
        $('#btnSubmit').on('click', function(e) {
            e.preventDefault();
            let stockCode = _checkRequired("stockSelect", MESSAGE.FARM_REQUIRED);
            if (stockCode === '') return false;
            let fromDate = _checkRequired('fromDate', MESSAGE.DATE_REQUIRED);
			if (fromDate === '') return false;
			let toDate = _checkRequired('toDate', MESSAGE.DATE_REQUIRED);
			if (toDate === '') return false;
            _showModalProcessing();
            $('#reportForm').submit();
        })
    }
	
    return {
        init: function() {
        	initForm();
        	resetSearchForm();
        	_handleSubmit();
        	_handleExportReportInstock();
        }
    }
}();

document.addEventListener('DOMContentLoaded', function() {
	ReportSaleEstimateComponent.init();
});
