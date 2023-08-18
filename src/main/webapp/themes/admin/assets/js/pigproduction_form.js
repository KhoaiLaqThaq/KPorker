var FinishProductionFormComponent = function() {
	
	// Validate form
	var validateForm = function(){
		$('#pigProductionForm').validate({
			ignore: 'input[type=hidden], .select2-search__field', // ignore hidden fields
		    errorClass: 'validation-invalid-label',
		    successClass: 'validation-valid-label',
		    validClass: 'validation-valid-label',
		    highlight: function(element, errorClass) {
		        $(element).removeClass(errorClass);
		    },
		    unhighlight: function(element, errorClass) {
		        $(element).removeClass(errorClass);
		    },
		    errorPlacement: function(error, element) {

		        // Unstyled checkboxes, radios
		        if (element.parents().hasClass('form-check')) {
		            error.appendTo( element.parents('.form-check').parent() );
		        }

		        // Input with icons and Select2
		        else if (element.parents().hasClass('form-group-feedback') || element.hasClass('select2-hidden-accessible')) {
		            error.appendTo( element.parent() );
		        }

		        // Input group, styled file input
		        else if (element.parent().is('.uniform-uploader, .uniform-select') || element.parents().hasClass('input-group')) {
		            error.appendTo( element.parent().parent() );
		        }

		        // Other elements
		        else {
		            error.insertAfter(element);
		        }
		    },
			rules: {
				"pigProd.materialCode":{
					required: true
				},
				"pigProd.quantity":{
					required: true,
					number : true
				},
				"pigProd.weight":{
					required: true,
					number : true
				},
		    
			},
			messages: {
				"pigProd.materialCode":{
					required:"Vui lòng chọn kho.",
				},
				"pigProd.quantity":{
					required:"Vui lòng nhập số.",
					number:"Số lượng phải là số"
				},
				"pigProd.weight":{
					required:"Vui lòng nhập số.",
					number:"Khối Lượng phải là số"
				},
			}
		});
	}
	
	var chosenPostingDate = function() {
		$('#displayCreatedDate').on('apply.daterangepicker', function(ev, picker) {
			$(this).val(picker.startDate.format('DD-MM-YYYY'));
		});
	}

	var _checkChosenPostingDate = function() {
		var postingDateValue = $('#displayCreatedDate').val();
		if (postingDateValue || postingDateValue !== '') {
			return postingDateValue;
		}
		bootbox.alert({
            title: 'Thông báo',
            message: 'Vui lòng chọn ngày ghi nhận.'
        });
        return '';
	}
	
	var submitForm = function(){
		$('#btnSubmit').on('click',function(e){
			e.preventDefault();
			var postingDate = _checkChosenPostingDate();
			if (postingDate == '') return false;
			bootbox.confirm({
			    message: 'Bạn đã nhập heo chết ngày '+postingDate+' chưa?',
			    buttons: {
			        confirm: {
			            label: 'Đã nhập',
			            className: 'btn-success'
			        },
			        cancel: {
			            label: 'Chưa nhập',
			            className: 'btn-danger'
			        }
			    },
			    callback: function (result) {
			        var processOrderCode = $('#processOrderCode').val();
					var pigProdQuantity = $('#pigProdQuantity').val();
					if(processOrderCode != null){
						$.ajax({
							url: getContext() + '/api/production/get-total-pig-retained',
							contextType: 'application/json',
							method: 'GET',
							dataType: 'json',
							data: {
								processOrderCode: processOrderCode
							},
							success: function(data) {
								console.log(pigProdQuantity);
								if(data < pigProdQuantity) {
									bootbox.alert({
					                    title: "Thông báo:",
					                    message: "Số lượng heo nhập vào vượt quá số lượng heo còn lại trong chuồng. Số lượng heo còn lại : " + data + " con.",
					                }); 
								} else {
									bootbox.confirm({
										title: "Xác nhận:",
									    message: "Bạn có xác nhận nhập heo thành phẩm loại cho ngày: <b>"+postingDate+"</b> không? Việc này sẽ lưu dữ liệu vào database đồng thời cũng gửi dữ liệu này lên hệ thống SAP. Bạn có chắc chắn không?",
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
									    	if(result){
									    		$('#pleaseWaitDialog').modal();
									    		//set lai ngay thang nam
												var str = postingDate.split('-');
												var month = Math.abs(str[1]) - 1; //// the month is 0-indexed
												var date = new Date(str[2],month,str[0]).toLocaleDateString('en-GB');
												document.getElementById("postingDate").value = date;
									    		
									    		$('#pigProductionForm').attr('action', '/pigProduction/save');
												$('#pigProductionForm').submit();
									    	}
									    	
									    }
									});
								}
							},
							error: function(err) {
								console.log(err)
								bootbox.alert({
				                    title: "Thông báo:",
				                    message: "Có lỗi xảy ra trong quá trình thực hiện. Vui lòng thử lại.",
				                }); 
							}
						});
					}
			    }
			});
		});
	};
	
	var clear = function(){
		document.querySelector("#pigProdQuantity").oninput = function(){
			$("#msgQuantity").text("" );
		}
		document.querySelector("#pigProdType").oninput = function(){
			$("#msgPigType").text("" );
		}
		document.querySelector("#pigProdWeight").oninput = function(){
			$("#msgWeight").text("" );
		}
		document.querySelector("#pigProdReason").oninput = function(){
			$("#msgReason").text("" );
		}
	}
	
	 // Daterange picker
    var pickerDate = function() {
        if (!$().daterangepicker) {
            console.warn('Warning - daterangepicker.js is not loaded.');
            return;
        }
        // Single picker
       $('.daterange-single').daterangepicker({ 
           singleDatePicker: true,
           locale: {
        	   format: 'DD-MM-YYYY'
           },
		   autoUpdateInput: false
       });
    };
	
	var initForm = function() {
        if (!$().select2) {
            return;
        }
    	// select2
   	 	$('.select2').select2();
	}
	
	var btnCancel = function(){
		$('#btnCancel').on('click',function(e){
			e.preventDefault();
			var processOrderCode = $('#processOrderCode').val();
			var pigProdQuantity = $('#pigProdQuantity').val();
			var postingDate = _checkChosenPostingDate();
			if (postingDate == '') return false;
			if(processOrderCode != null){
				bootbox.confirm({
					title: "Xác nhận:",
				     message: "Bạn có chắc chắn muốn hủy giao dịch này không",
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
				    	if(result){
				    		$('#pleaseWaitDialog').modal();
				    		//set lai ngay thang nam
							var str = postingDate.split('-');
							var month = Math.abs(str[1]) - 1; //// the month is 0-indexed
							var date = new Date(str[2],month,str[0]).toLocaleDateString('en-GB');
							document.getElementById("postingDate").value = date;
				    		
				    		$('#pigProductionForm').attr('action', '/pigProduction/save');
							$('#pigProductionForm').submit();
				    	}
				    	
				    }
				});
			}
		});
	};
	
    return {
        init: function() {
        	validateForm();
			//clear();
        	submitForm();
        	initForm();
        	pickerDate();
			chosenPostingDate();
			btnCancel();
        }
    }
}();

var Custom = {
		loadMaterial : () =>{
			var fi = "";
			fi = "<option></option>";
			var pigProdMaterialCode = $('#pigProdMaterialCode').val();
			var pigProdMaterialName = $('#pigProdMaterialName').val();
			if(pigProdMaterialCode && pigProdMaterialName){
				fi = "<option value=" + pigProdMaterialCode + ">" + pigProdMaterialCode + ": " + pigProdMaterialName + "</option>";
			}
			$(".selected-material-code").html(fi);
			
		},	
};

document.addEventListener('DOMContentLoaded', function() {
	FinishProductionFormComponent.init();
	Custom.loadMaterial();
});

