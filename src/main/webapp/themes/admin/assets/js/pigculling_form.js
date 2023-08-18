var PigCullingFormComponent = function() {
	const EVENTTYPE = {
		DEAD: 'pig_dead',
		CULLING: 'pig_culling'
	};
	
	var initForm = function() {
        if (!$().select2) {
            return;
        }
    	// select2
   	 	$('.select2').select2();
	}
	
    // Switchery
    var initSwitchery = function() {
        if (typeof Switchery == 'undefined') {
            return;
        }
        // Initialize multiple switches
        var elems = Array.prototype.slice.call(document.querySelectorAll('.form-check-input-switchery'));
        elems.forEach(function(html) {
          var switchery = new Switchery(html);
        });
    };

    // Bootstrap switch
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
    
    // Validate form
	var validateForm = function(){
		$('#pigcullingForm').validate({
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
				"pigCulling.materialCode":{
					required: true
				},
				"pigCulling.quantity":{
					required: true,
					number : true
				},
				"type":{
					required: true
				}
			},
			messages: {
				"pigCulling.materialCode":{
					required:"Vui lòng chọn vật tư.",
				},
				"pigCulling.quantity":{
					required:"Vui lòng nhập số.",
					number:"Số lượng phải là số"
				},
				"type":{
					required:"Vui lòng chọn loại thải loại.",
				}
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
	
	var _checkChosenQuantity = function() {
		var pigdeadQuantity = $('#pigdeadQuantity').val();
		if (pigdeadQuantity || pigdeadQuantity !== '') {
			return pigdeadQuantity;
		}
		bootbox.alert({
            title: 'Thông báo',
            message: 'Vui lòng nhập số lượng.'
        });
        return '';
	}
	
	var _checkChosenWeight = function() {
		var pigdeadWeight = $('#pigdeadWeight').val();
		if (pigdeadWeight || pigdeadWeight !== '') {
			return pigdeadWeight;
		}
		bootbox.alert({
            title: 'Thông báo',
            message: 'Vui lòng nhập khối lượng.'
        });
        return '';
	}
	
	var _checkChosenReason = function() {
		var pigdeadReason1 = $('#pigdeadReason1').val();
		var pigdeadReason2 = $('#pigdeadReason2').val();
		if (pigdeadReason1 || pigdeadReason1 !== '') {
			return pigdeadReason1;
			
		} else if( pigdeadReason2 || pigdeadReason2 !== ''){
			return pigdeadReason2;
		}
		bootbox.alert({
            title: 'Thông báo',
            message: 'Vui lòng nhập lý do chết/thải loại'
        });
        return '';
	}
	
	var submitForm = function(){
		$('#btnSubmit').on('click',function(e){
			e.preventDefault();
			var processOrderCode = $('#processOrderCode').val();
			/*var pigdeadQuantity = $('#pigdeadQuantity').val();*/
			var pigdeadQuantity = _checkChosenQuantity();
			if (pigdeadQuantity == '') return false;
			var pigdeadWeight = _checkChosenWeight();
			if (pigdeadWeight == '') return false;
			var postingDate = _checkChosenPostingDate();
			if (postingDate == '') return false;
			var reason = _checkChosenReason();
			if (reason == '') return false;
			
			if(processOrderCode != null){
				$.ajax({
					url: getContext() + '/api/production/get-total-pig-retained',
					contextType: 'application/json',
					method: 'GET',
					data: {
						processOrderCode: processOrderCode
					},
					success: function(data) {
						console.log(pigdeadQuantity);
						if(data < pigdeadQuantity) {
							bootbox.alert({
			                    title: "Thông báo:",
			                    message: "Số lượng heo nhập vào vượt quá số lượng heo còn lại trong chuồng. Số lượng heo còn lại : " + data + " con.",
			                }); 
						} else {
							bootbox.confirm({
								title: "Xác nhận:",
							    message: "Bạn có xác nhận nhập heo chết/thải loại cho ngày: <b>"+postingDate+"</b> không? Việc này sẽ lưu dữ liệu vào database đồng thời cũng gửi dữ liệu này lên hệ thống SAP. Bạn có chắc chắn không?",
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
							    	if (result) {
							    		$('#pleaseWaitDialog').modal();
							    		//set lai ngay thang nam
										var str = postingDate.split('-');
										var month = Math.abs(str[1]) - 1; //// the month is 0-indexed
										var date = new Date(str[2],month,str[0]).toLocaleDateString('en-GB');
										document.getElementById("postingDate").value = date;
							    		
							    		$("#materialCode").prop("disabled",false);
							    		$('#pigcullingForm').attr('action', '/pigCulling/save');
										$('#pigcullingForm').submit();
				                	}
							    }
							});
						}
					},
					error: function(err) {
						console.log(err)
					}
				});
			}
		});
	};
	
	var initMaterialSelector = function(){
	 	MaterialSelector.init();
	};
	
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
    
    var btnCancel = function(){
		$('#btnCancel').on('click',function(e){
			e.preventDefault();
			var processOrderCode = $('#processOrderCode').val();
			var pigdeadQuantity = $('#pigdeadQuantity').val();
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
				    	if (result) {
				    		$('#pleaseWaitDialog').modal();
				    		//set lai ngay thang nam
							var str = postingDate.split('-');
							var month = Math.abs(str[1]) - 1; //// the month is 0-indexed
							var date = new Date(str[2],month,str[0]).toLocaleDateString('en-GB');
							document.getElementById("postingDate").value = date;
				    		
				    		$('#pigcullingForm').attr('action', '/pigCulling/save');
							$('#pigcullingForm').submit();
	                	}
				    }
				});
			}
		});
	};
	
	var checkEventType = function(){
		$("#pigdeadType").on("select2:select", function(){
			let data = $("#pigdeadType").val();
			
			if(data == EVENTTYPE.CULLING){
				$("#materialCode option").each(function(){
					if(this.value.includes("MAVIN400")){
						this.setAttribute('selected', true);
					} else {
						this.removeAttribute('selected');
					}
				});
				
				$("#reason2").removeClass("hide");
				$("#reason2 select").attr("disabled", false);
				$("#reason1").addClass("hide");
				$("#reason1 input").attr("disabled", true);
				
			} else {
				$("#materialCode option").each(function(){
					if(this.value.includes("MAVIN401")){
						this.setAttribute('selected', true);
					} else {
						this.removeAttribute('selected');
					}
				});
				
				$("#reason1 input").attr("disabled", false);
				$("#reason1").removeClass("hide");
				$("#reason2").addClass("hide");
				$("#reason2 select").attr("disabled", true);
			}
			
			$("#materialCode").trigger('change');
		});
	}
	
    return {
        init: function() {
        	initForm();
        	initBootstrapSwitch();
        	initSwitchery();
        	submitForm();
        	//initMaterialSelector();
        	validateForm();
        	pickerDate();
        	btnCancel();
			chosenPostingDate();
			checkEventType();
        }
    }
}();

var Custom = {
		sliceJson: () => {
			var pigdeadReason = $("#pigdeadReason").val();
			var pigdeadPigType = $("#pigdeadPigType").val();
			if(pigdeadPigType) {
				var pigType = pigdeadPigType.slice(1, -1); 
				$("#pigdeadPigType").val(pigType);
			}
			if(pigdeadReason) {
				var reason = pigdeadReason.slice(1, -1); 
				$("#pigdeadReason").val(reason);
			}
		},
		
		loadMaterial : () =>{
			var fi = "";
			fi = "<option></option>";
			var pigCullingMaterialCode = $('#pigCullingMaterialCode').val();
			var pigCullingMaterialName = $('#pigCullingMaterialName').val();
			if(pigCullingMaterialCode && pigCullingMaterialName){
				fi = "<option value=" + pigCullingMaterialCode + ">" + pigCullingMaterialCode + ": " + pigCullingMaterialName + "</option>";
			}
			$(".selected-material-code").html(fi);
			
		},	
}


// Initialize module
// ------------------------------

document.addEventListener('DOMContentLoaded', function() {
	PigCullingFormComponent.init();
	Custom.loadMaterial();
});
