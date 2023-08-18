/* ------------------------------------------------------------------------------
 *
 *  # Custom JS code
 *
 *  Place here all your custom js. Make sure it's loaded after app.js
 *
 * ---------------------------------------------------------------------------- */
/* ------------------------------------------------------------------------------
 *
 *  # Form validation
 *
 *  Demo JS code for form_validation.html page
 *
 * ---------------------------------------------------------------------------- */


// Setup module
// ------------------------------

var AgentForm = function() {
	//check code agent
	var _componentCheckCode = function() {
		$('#code').on('change', function(e){
			var code = $(this).val();
			var contextPath = getContext();
			var messageCheckCode = document.getElementById('messageCheckCode');
			
			$.ajax({
				url: contextPath + '/admin/agent/checkCode',
				contextType: 'application/json',
				method: 'POST',
				data: {
					code: code
				},
				success: function(data) {
					messageCheckCode.style.display = 'block';
					if(data) {
						messageCheckCode.style.color = 'red';
						$('#agentSubmit').attr("disabled","disabled");
						$('#messageCheckCode').html('\u004d\u00e3 \u0073\u1ea3\u006e \u0070\u0068\u1ea9\u006d \u0111\u00e3 \u0074\u1ed3\u006e \u0074\u1ea1\u0069\u002e')
					} else {
						console.log(document.getElementById('code').value.length)
						if(document.getElementById('code').value.length != 0){
							messageCheckCode.style.color = 'green';
							$('#agentSubmit').removeAttr('disabled');
							$('#messageCheckCode').html('\u004d\u00e3 \u0073\u1ea3\u006e \u0070\u0068\u1ea9\u006d \u0074\u0068\u00ed\u0063\u0068 \u0068\u1ee3\u0070\u0021')
						} else {
							messageCheckCode.style.color = 'red';
							$('#agentSubmit').attr("disabled","disabled");
							$('#messageCheckCode').html('\u004d\u00e3 \u0073\u1ea3\u006e \u0070\u0068\u1ea9\u006d \u006b\u0068\u00f4\u006e\u0067 \u0070\u0068\u00f9 \u0074\u0068\u00ed\u0063\u0068 \u0068\u1ee3\u0070\u0021')
						}
						
					}
					
				},
				error: function(err) {
					console.log(err)
				}
			});
		});
	};
	
    // Validation config
    var componentValidation = function() {
        if (!$().validate) {
            console.warn('Warning - validate.min.js is not loaded.');
            return;
        }
        if (!$().select2) {
            console.warn('Warning - select2.js is not loaded.');
            return;
        }
        if (!$().uniform) {
            console.warn('Warning - uniform.min.js is not loaded.');
            return;
        }

        
    	// select2
   	 	$('.select-search').select2();
   	 	$('.select').select2();

        // Success
        $('.form-check-input-styled-success').uniform({
            wrapperClass: 'border-success-600 text-success-800'
        });

        // Custom color
        $('.form-check-input-styled-custom').uniform({
            wrapperClass: 'border-indigo-600 text-indigo-800'
        });
        
   	 	
        // Initialize
        var validator = $('.form-validate-jquery').validate({
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
            success: function(label) {
                label.addClass('validation-valid-label').text('Success.'); // remove to hide Success message
            },

            // Different components require proper error label placement
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
            },
            messages: {
            	name: {
                    required: 'T\u00EAn b\u1EAFt bu\u1ED9c ph\u1EA3i nh\u1EADp'
                },
                address: {
                	required: '<fmt:message key="error.address.required"/>'
                }
            }
        });

        // Reset form
        $('#reset').on('click', function() {
            validator.resetForm();
        });
    };

	var ajaxCall = function() {
		$("#city").change(function () {
			agentComponent.showDistrict();
		});
	};


    //
    // Return objects assigned to module
    //
    return {
        init: function() {
        	_componentCheckCode();
			componentValidation();
			ajaxCall();
        }
    }
}();


var agentComponent = {
	showDistrict: function() {
		var contextPath = getContext();
		var agentDistrict = getAgentDistrict();
		var cityId = $("#city").val();
		$.ajax({
			url: contextPath + '/dist/load',
			method:'GET',
			data:{cityId : cityId},
			success: function(data) {
				var s ='';
				
				for(i=0; i<data.length; i++) {
					if(data[i].id == agentDistrict){
						s += '<option selected value=' + data[i].id + '>' + data[i].name + '</option>';
						continue;
					} else {
						s += '<option value=' + data[i].id + '>' + data[i].name + '</option>';
					}
				}
				$("#district").html(s);
			},
			error: function (e) {
				console.log("error: ",e);
			}
		});
	}
}

// Initialize module
// ------------------------------
document.addEventListener('DOMContentLoaded', function() {
	AgentForm.init();
});
