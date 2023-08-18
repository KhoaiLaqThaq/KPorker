var ReportInstockPigComponent = function() {
	var listFarm;
	
	var initForm = function() {
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

		let toDate = $('input[name="toDate"]');
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
		 
 	 	$('.select2').select2();
 	 	
        // bootbox
        if (typeof bootbox == 'undefined') {
            console.warn('Warning - bootbox.min.js is not loaded.');
            return;
        };
        
        $(document).ready(function(){
			$.ajax({
				url: getContext() + '/api/farmByUsernameLogin',
				contextType: 'application/json',
				method: 'GET',
				dataType: 'json',
				
				success: function(data) {
					listFarm = data;
					initBarnSelect();
					
				},
				error: function(err) {
					console.log(err);
				}
			});
		});
		
		//apply datatable 
		try{
			var t = $('#table-report').DataTable( {
			    scrollY:        "600px",
		        scrollX:        true,
		        scrollCollapse: true,
		        paging:         false,
		        searching:		false,
		        /*fixedColumns:   {
					leftColumns: 2,
				},*/
				columnDefs: [
		            {
		                orderable: false,
		                targets: 0,
		            },
		        ],
		        order: [[1, 'asc']],
		        "fnDrawCallback": function(){
					$("#unSort").remove();
					ininSummaryRow();
				}
			});
			
			t.on('order.dt', function () {
				$("#unSort").remove();
		        let i = 1;
		 
		        t.cells(null, 0, { search: 'applied', order: 'applied' }).every(function (cell) {
		            this.data(i++);
		        });
		    }).draw()
		} catch(err){
			console.warn('Warning - datatable not loaded.');
		}
		
		$('#barnSelect').multiselect();
		
		$('#stockSelect').multiselect({
            includeSelectAllOption: true,
            enableFiltering: true,
            enableCaseInsensitiveFiltering: true
        });
        
		insertSelectOption();
	}
	
	var ininSummaryRow = function(){
		let earlyStage = $("#totalEarlyStage").val();
		let entry = $("#totalEntry").val();
		let dead = $("#totalDead").val();
		let culling = $("#totalCulling").val();
		let sell = $("#totalSell").val();
		let issue = $("#totalIssue").val();
		let issueFarm = $("#totalIssueFarm").val();
		let finalStage = $("#totalFinalStage").val();
		
		
		$("#tableHead").after(
			'<tr style="background-color: #a0f186;" id="unSort">'
				+'<th style="font-size: 10px;" class="text-center">Tổng</th>'
				+'<th class="text-center"></th>'
				+'<th class="text-center"></th>'
				+'<th class="text-center"></th>'
				+'<th class="text-center"></th>'
				+'<th class="text-center">'+ earlyStage +'</th>'
				+'<th class="text-center">'+ entry +'</th>'
				+'<th class="text-center">'+ dead +'</th>'
				+'<th class="text-center">'+ culling +'</th>'
				+'<th class="text-center">'+ sell +'</th>'
				+'<th class="text-center">'+ issue +'</th>'
				+'<th class="text-center">'+ issueFarm +'</th>'
				+'<th class="text-center">'+ finalStage +'</th>'
			+'</tr>'
		);
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
	
	var initBarnSelect = function(){
		var farmSelected = $("#stockSelect").val();
		$("#barnSelect").html('');
		listFarm.forEach((f) => {
			if(farmSelected.indexOf(f.code) >= 0){
				addBarnToOption(f);
			}
		});
		
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
		})
		
	}
	
	var _handleExportReportInstock = function() {
        $('#exportReportInstock').on('click', function(e) {
            
            var stockCode = _checkStockCodeValue();
            if (stockCode == '') return false;
            var stockCodeStr = '';
            stockCode.forEach(s => {
				stockCodeStr = stockCodeStr + s + ',';
			});
			
			var barnCodesStr = '';
			$('#barnSelect').val().forEach(b => {
				barnCodesStr = barnCodesStr + b + ',';
			})
            
            var fromDate = _checkFromDateValue();
            var toDate = _checkToDateValue();
            
            e.preventDefault();
            var apiExport;
            if(barnCodesStr != ''){
				apiExport = '/report/instock-pig-export-excel?' 
						+ 'stockCodes=' + stockCodeStr 
						+ '&fromDate=' + fromDate 
						+ '&toDate=' + toDate 
						+ '&barnCodes=' + barnCodesStr;
			} else {
				apiExport = '/report/instock-pig-export-excel?' 
						+ 'stockCodes=' + stockCodeStr 
						+ '&fromDate=' + fromDate 
						+ '&toDate=' + toDate;
			}
            location.href = apiExport;
        });
    }
    
    var resetSearchForm = function() {
		$('#btnReset').on('click',function(e){
			$('#dateStringPeriod').val(null);
			$('#stockSelect').val(null).trigger('change');
			$('#reportInstockForm').submit();
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
    
    var _handleSubmit = function() {
        $('#btnSubmit').on('click', function(e) {
            e.preventDefault();
            var stockCode = _checkStockCodeValue();
            if (stockCode == '') return false;
            var fromDate = _checkFromDateValue();
			if (fromDate == '') return false;
            var toDate = _checkToDateValue();
			if (toDate == '') return false;
            _showModalProcessing();
            $('#reportInstockForm').submit();
        })
    }
	
    return {
        init: function() {
        	initForm();
        	resetSearchForm();
        	_handleSubmit();
        	_handleExportReportInstock();
        	_handleFarmSelected();
        }
    }
}();

document.addEventListener('DOMContentLoaded', function() {
	ReportInstockPigComponent.init();
});
