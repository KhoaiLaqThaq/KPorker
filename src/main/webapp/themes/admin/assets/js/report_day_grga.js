var ReportDayGRGAComponent = function() {
	var _showModalProcessing = () => $('#modalLoading').addClass('d-block').removeClass('d-none');

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
	var init = function(){

		//apply datatable
		try{
			var t = $('#table-report').DataTable( {
				scrollY:        "600px",
				scrollX:        true,
				scrollCollapse: true,
				paging:         false,
				searching:		false,

				fixedColumns:   {
					leftColumns: 4,
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

	const _checkRequired = function(fieldId) {
		let selector = $(`#${fieldId}`).val();
		if (selector || selector != '') {
			return selector;
		}
		bootbox.alert({
			title: 'Thông báo',
			message: 'Vui lòng chọn giai đoạn báo cáo.'
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

	/**
	 * Hàm này để export
	 */
	const _handleExportReportInstock = function() {
		$('#exportReportInstock').on('click', function(e) {

			let stockCode = _checkStockCodeValue();
			if (stockCode === '') return false;
			let fromDate = _checkRequired("fromDate");
			if(fromDate === '') return false;
			let toDate = _checkRequired("toDate");
			if(toDate === '') return false;
			let purchasingGroups = _checkPurchasingGroupValue();
			if (purchasingGroups === '') return false;
			e.preventDefault();
			location.href = '/report/day-detail-grga-export-excel?farmCode=' + stockCode + '&fromDate=' + fromDate + '&toDate=' + toDate + '&purchaseGroups=' + purchasingGroups;
		});
	}

	var _handleSubmit = function() {
		$('#btnSubmit').on('click', function(e) {
			e.preventDefault();
			var stockCode = _checkStockCodeValue();
			if (stockCode == '') return false;

			let fromDate = _checkRequired("fromDate");
			if(fromDate === '') return false;
			let toDate = _checkRequired("toDate");
			if(toDate === '') return false;
			var purchasingGroups = _checkPurchasingGroupValue();
			if (purchasingGroups == '') return false;
			_showModalProcessing();
			$('#reportInstockForm').submit();
		})
	}

	return{
		init: function() {
			init();
			initBootstrapSwitch();
			_handleExportReportInstock();
			_handleSubmit();
			initDatePicker();
		}
	}
}();

document.addEventListener("DOMContentLoaded", function() {
	ReportDayGRGAComponent.init();
});
