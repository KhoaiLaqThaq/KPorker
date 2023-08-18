const STATUS = {
		UNCONFIRMED: 'unconfirmed', // CHƯA XÁC NHẬN
		CONFIRMED: 'confirmed', // XÁC NHẬN 
		CLOSED: 'closed' // ĐÓNG LỆNH 
};

var Component = function() {
	
	var initForm = function() {
        if (!$().select2) {
            console.warn('Warning - select2.js is not loaded.');
            return;
        }
   	 	$('.select2').select2();
        $('.datepicker').datepicker({
          dateFormat: 'dd/mm/yy',
          changeMonth: true,
          changeYear: true
        });
        if (typeof bootbox == 'undefined') {
            console.warn('Warning - bootbox.min.js is not loaded.');
            return;
        }

	}

	var _resetModalToClose = () => {
		$('#openModalToClosePo').on('click', () => {
			$('#confirmToClose').find("input:not([type='submit'])").val('');
			$('.form-item__inner').removeClass('error');
		});
	}

	var _resetModalToEvaluate = () => {
		$('#openModalForEvaluate').on('click', () => {
			$('#confirmForEvaluate').find("input:not([type='submit'])").val('');
			$('.form-item__inner').removeClass('error');
		});
	}
	
	var confirmPO = function(){
		$('#processOrderConfirm').on('click',function(e){
			bootbox.confirm({
				title: "Xác nhận:",
			    message: "Việc này sẽ gửi thông tin lên hệ thống SAP. Bạn có chắc chắn không?",
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
			    	if(result) {
			    		//set lai ngay thang nam
						var realStartDate = $('#processOrderRealStartDate').val();
						var strS = realStartDate.split('/');
						var monthS = Math.abs(strS[1]) - 1; //// the month is 0-indexed
						var startdate = new Date(strS[2],monthS,strS[0]).toLocaleDateString('en-GB');
						document.getElementById("realStartDate").value = startdate;
						//set lai ngay thang nam
						var realEndDate = $('#processOrderRealEndDate').val();
						var strE = realEndDate.split('/');
						var monthE = Math.abs(strE[1]) - 1; //// the month is 0-indexed
						var enddate = new Date(strE[2],monthE,strE[0]).toLocaleDateString('en-GB');
						document.getElementById("realEndDate").value = enddate;
						$('#processOrderStatus').val(STATUS.CONFIRMED);
						$('#processOrderForm').attr('action', '/processOrder/confirmed');
						$('#processOrderForm').submit();
			    	}
			    }
			});
		});
	}

	var confirmRealValueForReport = function(){
		$('#btnRealValueConfirm').on('click', function() {
			var realAmount =  $('#confirmToClose').find("#realAmount").val();
			var realWeigh = $('#confirmToClose').find('#realWeigh').val();
			if (realAmount === '' || realWeigh === '') {
				var $input_fields = $('#confirmToClose').find('.form-item__inner input:not([type="submit"])');
				for (var j = 0; j < $input_fields.length; j++) {
					var $input_field = $($input_fields[j]);
 
					var $field = $input_field.closest('.form-item__inner');
					var val = $input_field.val().trim();
 
					if (val !== '') {
						$field.removeClass('error');
					} else {
						$field.addClass('error');
					}
				}
				return false;
			}
			formatNumberComponent.disableAutoNumeric();
			$('#realAmountPO').val($('#confirmToClose').find('#realAmount').val());
			$('#realWeighPO').val($('#confirmToClose').find('#realWeigh').val());
			$("#confirmType").val("CONFIRM_VALUE_REAL");
			$('#processOrderForm').attr('action', '/processOrder/confirmed');
			$('#processOrderForm').submit();
		});
	}

	var evaluateToUpdatePO = function() {
		$('#btnEvaluate').on('click', function(e) {
			var evaluateAmount = $('#evaluateAmount').val();
			var evaluateWeigh = $('#evaluateWeigh').val();
			if (evaluateAmount === '' || evaluateWeigh === '') {
				var $input_fields = $('#confirmForEvaluate').find('.form-item__inner input:not([type="submit"])');
				for (var j = 0; j < $input_fields.length; j++) {
					var $input_field = $($input_fields[j]);
 
					var $field = $input_field.closest('.form-item__inner');
					var val = $input_field.val().trim();
 
					if (val !== '') {
						$field.removeClass('error');
					} else {
						$field.addClass('error');
					}
				}
				return false;
			}
			formatNumberComponent.disableAutoNumeric();
			$('#evaluateAmountPO').val($('#evaluateAmount').val());
			$('#evaluateWeighPO').val($('#evaluateWeigh').val());
			$('#processOrderForm').attr('action', '/processOrder/confirmed');
			$('#processOrderForm').submit();
		})
	}
	
	var confirmOther = function(){
		$('#btnOther').on('click', function() {
			var pigLevel =  $('#inputPigLevel').val();
			var prodVer = $('#inputProdVer').val();
			
			if(pigLevel && pigLevel != ''){
				$('#pigLevel').val(pigLevel);
			}
			if(prodVer && prodVer != ''){
				$('#processOrderProductionVer').val(prodVer);
			}
			$("#confirmType").val("CONFIRM_VALUE_REAL");
			$('#processOrderForm').attr('action', '/processOrder/confirmed');
			$('#processOrderForm').submit();
		});
	}
	
	//kiểm tra dữ liệu nhập thực tế trước khi đóng lệnh để hiển thị cảnh báo
	var checkBeforeClose = function(){
		let realAmount = $("#realAmount").val();
		let realWeight = $("#realWeigh").val();
		
		if(realAmount || realAmount != '' || realWeight || realWeight != ''){
			return true;
		} else {
			$("#realAmount").css('border-color', 'red');
			$("#realWeigh").css('border-color', 'red');
			return false;
		}
	}
	
	var closePO = function(){
		$('#processOrderClose').on('click',function(e){
			e.preventDefault();
			var realEndDate = $('#processOrderRealEndDate').val();
			if(checkBeforeClose()){
				bootbox.confirm({
					title: "Xác nhận:",
				    message: "Bạn có xác nhận đóng lệnh sản xuất ngày: <b>"+realEndDate+"</b> không? Việc này sẽ gửi thông tin lên hệ thống SAP. Bạn có chắc chắn không?",
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
				    	if(result) {
				    		// //set lai ngay thang nam
							var realStartDate = $('#processOrderRealStartDate').val();
							var strS = realStartDate.split('/');
							var monthS = Math.abs(strS[1]) - 1; //// the month is 0-indexed
							var startdate = new Date(strS[2],monthS,strS[0]).toLocaleDateString('en-GB');
							document.getElementById("realStartDate").value = startdate;
							//set lai ngay thang nam
							var strE = realEndDate.split('/');
							var monthE = Math.abs(strE[1]) - 1; //// the month is 0-indexed
							var enddate = new Date(strE[2],monthE,strE[0]).toLocaleDateString('en-GB');
							document.getElementById("realEndDate").value = enddate;
							$('#processOrderStatus').val(STATUS.CLOSED);
							$('#processOrderForm').attr('action', '/processOrder/confirmed');
							$('#processOrderForm').submit();
				    	}
				    }
				});
			} else {
				bootbox.alert({
					message: 'Lệnh sản xuất chưa nhập <span style="color:red;">số lượng xuất thực tế</span>. Vui lòng nhập số liệu trước khi đóng lệnh',
					className: 'alert-style',
					callback: function () {
						setTimeout(function(){
							$("#realAmount").removeAttr("style");
							$("#realWeigh").removeAttr("style");
						}, 5000);
					}
				});
			}
			
		});
	}
	
	var hideTable = function(){
		$('#hideTblQuotas').on('click',function(e){
			var x = document.getElementById("tableQuota");
			  if (x.style.display === "none") {
			    x.style.display = "block";
			  } else {
			    x.style.display = "none";
			  }
		});
	}
	
    return {
        init: function() {
        	initForm();
        	confirmPO();
        	closePO();
        	hideTable();
			confirmRealValueForReport();
			_resetModalToClose();
			_resetModalToEvaluate();
			evaluateToUpdatePO();
			confirmOther();
        }
    }
}();

var Custom = {
		checkStatus: () => {
			var status = $('#processOrderStatus').val().toLowerCase();
			if(status == STATUS.UNCONFIRMED) {
				$("#processOrderQuantity").attr("readonly", false);
				$("#processOrderStartDate").attr("readonly", false);
				$("#processOrderEndDate").attr("readonly", false);
				$("#processOrderRealStartDate").attr("readonly", false);
				$("#processOrderRealEndDate").attr("readonly", false);
			}
		},
		
		hideTable: () => {
			var x = document.getElementById("tableQuota");
			x.style.display = "none";
		},
}

// Initialize module
// ------------------------------

document.addEventListener('DOMContentLoaded', function() {
	Component.init();
	Custom.checkStatus();
	Custom.hideTable();
});
