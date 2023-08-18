var FormComponent = function() {
    
    // Validate form
	var validateForm = function(){
		$('#documentTypeForm').validate({
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
				"code":{
					required: true
				},
				"name":{
					required: true
				}
			},
			messages: {
				"code":{
					required:"Vui lòng nhập giá trị.",
				},
				"name":{
					required:"Vui lòng nhập giá trị.",
				}
			}
		});
	}
    
    var initForm = function() {
        if (!$().select2) {
            return;
        }
   	 	$('.select2').select2();
	}
    
    return {
        init: function() {
            validateForm();
            initForm();
        }
    }
}();

// Initialize module
// ------------------------------

document.addEventListener('DOMContentLoaded', function() {
	FormComponent.init();
});
