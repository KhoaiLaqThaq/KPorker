
var PigEntryFormComponent = function() {
	
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
           }
       });
    };
    
    
	
	var validation = function(){
		var ageWeek = $('#pigentryAgeWeek').val();
		var quantity = $('#pigentryQuantity').val();
		var volumnTotal = $('#pigentryEntryVolumnTotal').val();
		var check = false;
		if(ageWeek == ""){
			$('#msgForAgeWeek').text("Vui lòng nhập tuần tuổi heo!");
			check = false;
		}else{
			check= true;
		}
		if(quantity == ""){
			$('#msgForQuantity').text("Vui lòng nhập số lượng heo!");
			check = false;
		}else{
			check = true;
		}
		if(volumnTotal == ""){
			$('#msgForEntryVolumnTotal').text("Vui lòng nhập tổng khối lượng heo!");
			check = false;
		}else{
			check =true;
		}
		
		var poStartDateStr = $('#processOrderStartDate').val().split('-');
		var entryDateStr = $('#displayPigEntryDate').val().split('-');
		var poStartDate = new Date(poStartDateStr[0], poStartDateStr[1] - 1, poStartDateStr[2]);
		var entryDate = new Date(entryDateStr[2], entryDateStr[1] - 1, entryDateStr[0]);
		console.log(poStartDate);
		console.log(entryDate);
		if(entryDate < poStartDate){
			$('#msgForEntryDate').text("Ngày nhập phải sau ngày bắt đầu lệnh: "+ poStartDateStr);
			check = false;
		} else if(entryDate > poStartDate){
			check = true;
		} else {
			check = true;
		}
		return check;
	}
	
	var clear = function(){
		document.querySelector("#pigentryAgeWeek").oninput = function(){
			$("#msgForAgeWeek").text("" );
		};
		document.querySelector("#pigentryQuantity").oninput = function(){
			var total = $('#pigentryEntryVolumnTotal').val().trim();
			var quantity = $('#pigentryQuantity').val().trim();
			$('#pigentryQuantity').val(Math.floor(quantity));
			quantity = $('#pigentryQuantity').val().trim();
			
			if(total != ""){
				averageVolume = total/quantity;
				$('#pigentryAverageVolume').val(averageVolume);
			}else{
				$('#pigentryAverageVolume').val(0);
			}
			$("#msgForQuantity").text("" );
		};
		document.querySelector("#pigentryEntryVolumnTotal").oninput = function(){
			var total = $('#pigentryEntryVolumnTotal').val().trim();
			var quantity = $('#pigentryQuantity').val().trim();
			if(quantity!= ""){
				averageVolume = total/quantity;
				$('#pigentryAverageVolume').val(averageVolume);
			}else{
				$('#pigentryAverageVolume').val(0);
			}
			$("#msgForEntryVolumnTotal").text("" );
		};
		
		$('#displayPigEntryDate').on('apply.daterangepicker', function(ev, picker) {
		    $("#msgForEntryDate").text("" );
		});
	}
		
	var submitForm = function(){
		$('#btnSubmit').on('click',function(e){
			//set lai ngay thang nam
			var pigEntryDate = $('#displayPigEntryDate').val();
			if(pigEntryDate) {
				var str = pigEntryDate.split('-');
				var month = Math.abs(str[1]) - 1; //// the month is 0-indexed
				var date = new Date(str[2],month,str[0]).toLocaleDateString('en-GB');
				document.getElementById("entryDate").value = date;
			}
			$('#pigentryForm').attr('action', '/pigEntry/save');
			if(validation()){
				$('#pleaseWaitDialog').modal();
				$('#pigentryForm').submit();
			}
		});
	};
	
	var cancel = function(){
		$('#btnCancel').on('click',function(e){
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
			    		//set lai ngay thang nam
						var pigEntryDate = $('#displayPigEntryDate').val();
						if(pigEntryDate) {
							var str = pigEntryDate.split('-');
							var month = Math.abs(str[1]) - 1; //// the month is 0-indexed
							var date = new Date(str[2],month,str[0]).toLocaleDateString('en-GB');
							document.getElementById("entryDate").value = date;
						}
						$('#pigentryForm').attr('action', '/pigEntry/cancel');
						if(validation()){
							$('#pleaseWaitDialog').modal();
							$('#pigentryForm').submit();
						}
                	}
			    }
			});
		});
	};
	
	var checkStatus = function(){
		let poStatus = $('#processOrderStatus').val().trim();
		if(poStatus != 'unconfirmed' ){
			$('#btnSubmit').hide()
			$('#pigentryAgeWeek').attr("readonly","readonly")
			$('#displayPigEntryDate').attr("disabled","disabled")
			$('#pigentrySourceFarm').attr("disabled","disabled")
			$('#pigentryQuantity').attr("readonly","readonly")
			$('#pigentryEntryVolumnTotal').attr("readonly","readonly")
			
		}
		
	}
	
    return {
        init: function() {
        	initForm();
        	initBootstrapSwitch();
        	initSwitchery();
        	pickerDate();       	        	
        	clear();
        	submitForm();
        	cancel();
        }
    }
}();


var Custom = {
		checkId: () => {
			var pigEntryId = $("#pigEntryId").val();
			if(pigEntryId){
				/*$('#btnSubmit').hide()
				$('#pigentryAgeWeek').attr("readonly","readonly")
				$('#pigentryEntryVolumnTotal').attr("readonly","readonly")
				$('#pigentrySourceFarm').attr("disabled","disabled")*/
				
				$('#materialCode').attr("disabled","disabled")
				$('#pigentryMaterialBatch').attr("readonly","readonly")
				$('#pigentryQuantity').attr("readonly","readonly")
				$('#displayPigEntryDate').attr("disabled","disabled")
				
				
			}
		}
		
}

document.addEventListener('DOMContentLoaded', function() {
	PigEntryFormComponent.init();
	Custom.checkId();
});


	
	
	
	
	
	
	
	
	