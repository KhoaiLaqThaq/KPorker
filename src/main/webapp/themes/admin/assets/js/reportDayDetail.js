'use strict';

const ReportDayDetailComponent = function() {
	const contextPath = getContext();
	const init = function(){
		// toDate
		$('input[name="endDateStr"]').daterangepicker({
			singleDatePicker: true,
		    autoUpdateInput: false,
	      	locale: {
	          	cancelLabel: 'Clear',
	          	format: 'DD/MM/YYYY'
	      	}
	  	});
	  	
	  	$('input[name="endDateStr"]').on('apply.daterangepicker', function(ev, picker) {
	      	$(this).val(picker.startDate.format('DD/MM/YYYY'));
            _findAllProcessOrder();
	  	});
		
	  	$('input[name="endDateStr"]').on('cancel.daterangepicker', function(ev, picker) {
	      	$(this).val('');
	  	});

        // fromDate
        $('input[name="startDateStr"]').daterangepicker({
			singleDatePicker: true,
		    autoUpdateInput: false,
	      	locale: {
	          	cancelLabel: 'Clear',
	          	format: 'DD/MM/YYYY'
	      	}
	  	});
	  	
	  	$('input[name="startDateStr"]').on('apply.daterangepicker', function(ev, picker) {
	      	$(this).val(picker.startDate.format('DD/MM/YYYY'));
              _findAllProcessOrder();
	  	});
		
	  	$('input[name="startDateStr"]').on('cancel.daterangepicker', function(ev, picker) {
	      	$(this).val('');
	  	});
		 
		 initDateProcessOrder();
		 
		 //apply datatable 
		try{
			var t = $('#table-report').DataTable( {
			    scrollY:        "600px",
		        scrollX:        true,
		        scrollCollapse: true,
		        paging:         false,
		        searching:		false,
		        fixedColumns:   {
					leftColumns: 3,
				},
				columnDefs: [
		            {
		                orderable: false,
		                targets: 0,
		            },
		        ],
		        /*order: [[1, 'asc']],*/
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
		
		$('#poSelect').multiselect({
            includeSelectAllOption: true,
            enableFiltering: true,
            enableCaseInsensitiveFiltering: true
        });
		
		$('#stockSelect').multiselect({
            includeSelectAllOption: true,
            enableFiltering: true,
            enableCaseInsensitiveFiltering: true
        });
	}
	
	const initDateProcessOrder = function(){
		if(_checkCondition()){
			let stockCode = $("#stockSelect").val();
	        let startDate = $("#startDateStr").val();
            let endDate = $("#endDateStr").val();
	        let poCode = $("#searchingProcessOrder").val();
	        
	        _callApiToGetProcessOrders(stockCode, startDate, endDate, poCode);
	        $("#poSelect").removeAttr("disabled");
		}
	}

	const _showLoading = () => $('#modalLoading').addClass('d-block').removeClass('d-none');
	const _hideLoading = () => $('#modalLoading').addClass('d-none').removeClass('d-block');

    const _checkStockCodeValue = function() {
        let stockCode = $('#stockSelect').val();
        if (stockCode || stockCode !== '')
            return stockCode;
        bootbox.alert({
            title: 'Thông báo',
            message: 'Vui lòng chọn trại.'
        });
        return '';
    }
    
    const stockOnChange = function(){
		$("#stockSelect").on('change', function(){
			_findAllProcessOrder();
		});
	}
    
    const _findAllProcessOrder = function() {
        if(_checkCondition()){
			$("#poSelect").removeAttr("disabled");
            let stockCode = $("#stockSelect").val();
            let startDate = $("#startDateStr").val();
            let endDate = $("#endDateStr").val();
            
            _callApiToGetProcessOrders(stockCode, startDate, endDate);
		} else {
			$("#poSelect").prop("disabled", true);
		}
    }
    
    const _checkCondition = function(){
		let stockCode = $("#stockSelect").val();
		if(stockCode === '') return false;
		
		let startDate = $("#startDateStr").val();
		if(startDate === '') return false;

        let endDate = $("#endDateStr").val();
		if (endDate === '') return false;
		
		return true;
	}
    
    const _callApiToGetProcessOrders = function(farmCode, startDate, endDate, poCode) {
        let apiURL = contextPath + '/report/processOrderAllForReport?farmCode=' + farmCode+'&startDate='+startDate+'&endDate='+endDate;
        $.ajax({
            url: apiURL,
            method: 'GET',
            contentType: 'application/json',
            success: function(response) {
                if (response) {
                    _generateProcessOrderCodeTempl(response, poCode);
                }
            }, error: function(err) {
                console.error(err.toString());
            }
        })
    }
    
    const _generateProcessOrderCodeTempl = function(data, poCode) {
        let template = '';
        /*template += '<option value=" ">Chọn lệnh sản xuất</option>';*/
        for (let i = 0; i < data.length; i++) {
            const element = data[i];
            if(poCode && poCode !==''){
				template += '<option value='+ element.code +' '+ (poCode.includes(element.code) ? 'selected' : ' ') +'>' + element.barn?.farm?.name + ' - ' + element.code + '</option>';
			} else {
				template += '<option value='+ element.code +' '+ (poCode === element.code ? 'selected' : ' ') +'>' + element.barn.farm?.name + ' - ' + element.code + '</option>';
			}
            
        }
        $('#poSelect').html(template);
        $("#poSelect").multiselect('rebuild');
    }

    /**
     * Export report day detail
     */
    const _handleExportReportDayDetail = function() {
        $('#exportReportDayDetail').on('click', function(e) {
            e.preventDefault();
            let stockCode = _checkStockCodeValue();
            if (stockCode === '') return false;
            let startDate = $("#startDateStr").val();
            let endDate = $("#endDateStr").val();
            let poCode = $("#searchingProcessOrder").val();

			location.href = '/report/dayDetail?stockCode=' + stockCode + '&startDate=' + startDate + '&endDate=' + endDate + '&poCode=' + poCode;
        });
    }

    const onSubmit = function() {
        $('#btnSubmit').on('click', function(e) {
            let stockCode = _checkStockCodeValue();
            if (stockCode === '') return false;
            _showLoading()
            $('#reportDayDetailForm').submit();
        });
    }

    return {
        init: function() {
			init();
            onSubmit();
            _handleExportReportDayDetail();
            stockOnChange();
        }
    }
}();

document.addEventListener('DOMContentLoaded', function() {
    ReportDayDetailComponent.init();
});
