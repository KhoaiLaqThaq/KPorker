var GoodsIssuesFormComponent = function() {
	
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
        	   format: 'DD/MM/YYYY'
           }
       });
       
    };
    
    var initFormSelector = function() {
    	var stockCode = $('#stockCode').val();
   	 	//MaterialSelector
   	 	MaterialSelector.init(stockCode);
	};
	
	 var submitForm = function(){
		$('#btnSubmit').on('click',function(e){
			bootbox.confirm({
				title: "Xác nhận:",
			    message: "Dữ liệu xác nhận này sẽ được đồng bộ lên hệ thống SAP và bạn sẽ không thể sửa được thông tin về xuất tiêu hao nữa. Bạn có chắc chắn không?",
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
			    		var checkError = MaterialSelector.checkFormTable();
			    		if(!checkError) {
							bootbox.alert({
			                    title: "Thông báo:",
			                    message: "Có một số dữ liệu không chính xác hoặc không đúng định dạng. Vui lòng kiểm tra lại thông tin trong bảng thông tin vật tư.",
			                });
						} else {
							$('#eventForm').attr('action', '/goodsAttrition/save');
							$('#eventForm').submit();
						}
			    	}
			    	
			    }
			});
		});
	};
    
    
    	
    return {
        init: function() {
        	initForm();
        	initBootstrapSwitch();
        	initSwitchery();
        	pickerDate();
        	initFormSelector();
        	submitForm();
        }
    }
}();


var Custom = {
		loadMaterial : () =>{
			var codes = MaterialSelector.getSelectedCodes();
			if(codes != null && codes != ''){
				var arrayCode = codes.split(',');
				$('#tblSelectedMaterials tbody tr').each(function(index) {
					var fi = "";
					fi = "<option></option>";
					if(arrayCode[index] != null && arrayCode[index] != ''){
						fi = "<option value=" + arrayCode[index] + ">" + arrayCode[index] + "</option>";
					}
					$(this).find(".selected-material-code").html(fi);
				});
			}
		}
}
// Initialize module
// ------------------------------


// Initialize module
// ------------------------------

document.addEventListener('DOMContentLoaded', function() {
	GoodsIssuesFormComponent.init();
	Custom.loadMaterial();
});
