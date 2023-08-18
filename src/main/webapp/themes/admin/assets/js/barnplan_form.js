var Component = function() {
	
	var initForm = function() {
		$('.daterange-single').daterangepicker({ 
	           singleDatePicker: true,
	           locale: {
	        	   format: 'DD-MM-YYYY'
	           }
	     });
	}
	
	var validateForm = function(){
		$('#barnPlanForm').validate({
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
				"realBarnVolumn":{
					required: true,
					number : true
				}
			},
			messages: {
				"realBarnVolumn":{
					required:"Vui lòng nhập số lượng quy mô thực tế.",
					number: "Vui lòng nhập số."
				}
			}
		});
	}
	
	 var submitForm = function(){
		$('#btnSubmit').on('click',function(e){
			var postingDate = $('#realBarnEmptyDateDisplay').val();
			//set lai ngay thang nam
			var str = postingDate.split('-');
			var month = Math.abs(str[1]) - 1; //// the month is 0-indexed
			var date = new Date(str[2],month,str[0]).toLocaleDateString('en-GB');
			document.getElementById("realBarnEmptyDate").value = date;
			
			$('#barnPlanForm').attr('action', '/barnPlan/confirm');
			$('#barnPlanForm').submit();
		});
	};
	
	
    return {
        init: function() {
        	initForm();
        	validateForm();
        	submitForm()
        }
    }
}();

// Initialize module
// ------------------------------

document.addEventListener('DOMContentLoaded', function() {
	Component.init();
});
