var FormComponent = function() {
	
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
    
    // Validate form
	var validateForm = function(){
		$('#siloForm').validate({
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
				"amount":{
					required: true,
					number: true
				}
			},
			messages: {
				"amount":{
					required:"Vui lòng điền số lượng tồn.",
					number:"Số lượng tồn phải là số."
				}
			}
		});
	}
	
	var submitForm = function(){
		$('#btnSubmit').on('click',function(e){
			var regexGoodQuantity = /^(\d*\.)?\d+$/;
			var amount = $('#amountId').val();
			if(regexGoodQuantity.test(amount)){
				$('#siloForm').attr('action', '/silo/save');
				$('#siloForm').submit();
			} else {
				$('#msgForId').html("Số lượng tồn phải là lớn hơn 0.");
			}
		});
	};
	
	
    return {
        init: function() {
        	initSwitchery();
        	validateForm();
        	submitForm();
        }
    }
}();

// Initialize module
// ------------------------------

document.addEventListener('DOMContentLoaded', function() {
	FormComponent.init();
});
