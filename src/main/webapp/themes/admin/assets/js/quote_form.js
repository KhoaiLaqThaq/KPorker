
var quoteForm = function() {
	/*var _componentCheckCode = function() {
		$('#codeFeature').on('keyup', function(e){
			var code = $('#codeFeature').val();
			var contextPath = getContext();
			var messageCheckCode = document.getElementById('messageCheckCode');
			if(code != ''){
				$.ajax({
					url: contextPath + '/feature/checkCode',
					contextType: 'application/json',
					method: 'POST',
					data: {
						code: code
					},
					success: function(data) {
						messageCheckCode.style.display = 'block';
						if(data) {
							messageCheckCode.style.color = 'red';
							$('#btnSubmit').attr("disabled","disabled");
							$('#messageCheckCode').html('\u004d\u00e3 \u0063\u006f\u0064\u0065 \u0111\u00e3 \u0074\u1ed3\u006e \u0074\u1ea1\u0069')
						} else {
							console.log(document.getElementById('codeFeature').value.length)
							if(document.getElementById('codeFeature').value.length != 0){
								messageCheckCode.style.color = 'green';
								$('#btnSubmit').removeAttr('disabled');
								$('#messageCheckCode').html('\u004d\u00e3 \u0063\u006f\u0064\u0065 \u0074\u0068\u00ed\u0063\u0068 \u0068\u1ee3\u0070\u0021')
							} else {
								messageCheckCode.style.color = 'red';
								$('#btnSubmit').attr("disabled","disabled");
								$('#messageCheckCode').html('\u0059\u00ea\u0075 \u0063\u1ea7\u0075 \u006e\u0068\u1ead\u0070 \u006d\u00e3 \u0063\u006f\u0064\u0065')
							}
							
						}
					},
					error: function(err) {
						console.log(err)
					}
				});
			} else {
				messageCheckCode.style.color = 'red';
				$('#messageCheckCode').html('\u0059\u00ea\u0075 \u0063\u1ea7\u0075 \u006e\u0068\u1ead\u0070 \u006d\u00e3 \u0063\u006f\u0064\u0065')
			}
		});
	};*/
	
	// Validate form
	/*var validateForm = function(){
		$('#coFoodItemForm').validate({
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
				"kalo": {
					number : true,
					required: true,
					maxlength: 5,
					minlength: 1
				},
				"maxPerTransaction": {
					number : true,
					required: true,
					maxlength: 5,
					minlength: 1
				},
				"maxForKitchen": {
					number : true,
					required: true,
					maxlength: 5,
					minlength: 1
				},
				"foodItem.id":{
					required: true
				},
				"nameEn": {
					maxlength: 512,
				},
				"descVn": {
					maxlength: 512,
				},
				"descEn": {
					maxlength: 512,
				},
				"price": {
					number : true,
					required: true,
					maxlength: 10,
				},
				"positionNumber": {
					number : true,
					required: true,
					maxlength: 5,
				},
				"bufferLabel": {
					maxlength: 256,
				},
			},
			messages: {
				"kalo": {
					number : "Kalo phải là số",
					required: "Bắt buộc nhập kalo",
					maxlength: "Hãy nhập tối đa 5 ký tự"
				},
				"maxPerTransaction": {
					number : "Số lượng tối đa trên 1 lượt phải là số",
					required: "Bắt buộc nhập số lượng tối đa trên 1 lượt",
					maxlength: "Hãy nhập tối đa 5 ký tự"
				},
				"maxForKitchen": {
					number : "Số lượng tối đa vào bếp phải là số",
					required: "Bắt buộc nhập số lượng tối đa vào bếp",
					maxlength: "Hãy nhập tối đa 5 ký tự"
				},
				"foodItem.id":{
					required:"Bắt buộc chọn món ăn",
				},
				"price": {
					number : "Giá món ăn phải là số",
					required: "Bắt buộc nhập giá",
					maxlength: "Hãy nhập tối đa 5 ký tự",
				},
				"descVn": {
					maxlength: "Hãy nhập tối đa 512 ký tự",
				},
				"descEn": {
					maxlength: "Hãy nhập tối đa 512 ký tự",
				},
				"nameEn": {
					maxlength: "Hãy nhập tối đa 512 ký tự",
				},
				"positionNumber": {
					number : "Vị trí của món phải là số",
					required: "Bắt buộc nhập vị trí của món",
					maxlength: "Hãy nhập tối đa 5 ký tự"
				},
				"bufferLabel": {
					maxlength: "Hãy nhập tối đa 256 ký tự",
				},
			}
		});
	}*/

    //
    // Return objects assigned to module
    //

    
    
    // Dual Listbox
    var initDualListbox = function() {
        if (!$().bootstrapDualListbox) {
            console.warn('Warning - duallistbox.min.js is not loaded.');
            return;
        }
        
        $('.listbox-related-items').bootstrapDualListbox({
            selectorMinimalHeight: 300,
            moveOnSelect:false
        });
        
        $('.listbox-modifier-items').bootstrapDualListbox({
            selectorMinimalHeight: 300,
            moveOnSelect:false
        });
        
        $('.listbox-feature-items').bootstrapDualListbox({
            selectorMinimalHeight: 300,
            moveOnSelect:false
        });
        
    };
    
   
    var initSelector = function() {
    	AssetSelector.init();
    }
    
    
   /* var submitForm = function(){
    	$('#btnSubmitForm').on('click', function(){
    		var selectedModifiers = ModifierSelector.getSelectedModifiers();
    		var infoFoodItem = FoodItemInfo.getInfoFoodItems();
    		var selectedRelatedFICodes = FoodItemRelatedSelector.getSelectedFoodItemRelatedCode();
    		var selectedRelatedFINames = FoodItemRelatedSelector.getSelectedFoodItemRelatedName();
    		$('#listModifierIds').val(selectedModifiers);
    		$('#infoFoodItem').val(infoFoodItem);
    		$('#relatedFCodes').val(selectedRelatedFICodes);
    		$('#relatedFNames').val(selectedRelatedFINames);
			$('#coFoodItemForm').submit();
		})
    }*/
    
    var initForm = function() {
        if (!$().select2) {
            console.warn('Warning - select2.js is not loaded.');
            return;
        }
    	// select2
   	 	$('.select2').select2();
	}
    
    var submitForm = function(){
    	$('#btnSubmit').on('click', function() {
    		AssetSelector.convertToJson();
        	$('#quoteForm').submit();
        })
    }
    
    return {
        init: function() {
        	initForm();
        	initSelector();
        	initDualListbox();
        	submitForm();
        }
    }
}();

var coFoodItemComponent = {
		initPhotos : function(){
			var coFoodItemId = $("#coFoodItemId").val();
			var contextPath = getContext();
			$.ajax({
				url : contextPath + '/coFoodItem/loadPhotos',
				method : 'GET',
				data : {id : coFoodItemId},
				success : function(dataList){
					var s ='';
					dataList.forEach((item, index) => {
						s += '<div class="col-sm-6 col-xl-3">';
						s += '<div class="card">';
						s += '<div class="card-img-actions mx-1 mt-1"><img class="card-img img-fluid" src="'+ contextPath + item.url +'" alt=""></div>';
						s += '<div class="card-body">';
						s += '<div class="d-flex align-items-start flex-nowrap">';
						s += '<div class="list-icons list-icons-extended ml-auto"><a class="list-icons-item" onclick="delPhoto('+ item.id +');"><i class="icon-bin top-0"></i></a></div>';				
						s += '</div>';			
						s += '</div>';
						s += '</div>';
						s += '</div>';
						
					});
					
					console.log(s);
					$("#existingPhotos").html(s);
				},
				error : function(e){
					console.log(e);
					console.log("lỗi kĩ thuật");
				}
			})
		},
		
		delPhoto : function(aId) {
			var contextPath = getContext();
			$.ajax({
				url : contextPath + '/del/photo',
				method : 'POST',
				data : {aId : aId},
				success : function(res){
					coFoodItemComponent.initPhotos();
				},
				error : function(e){
					console.log(e);
				}
			})
		}
}


var Modifier = {
		loadExistingAssets: () => {
			var quoteId = $('#id').val();
			AssetSelector.loadExistingAssets(quoteId);
		},
		
		loadExistingModifiers: () => {
			var coId = $("#coFoodItemId").val();
			ModifierSelector.loadExistingModifiers(coId);
		},
		loadExistingFoodItemRelateds: () => {
			var coId = $("#coFoodItemId").val();
			FoodItemRelatedSelector.loadExistingFoodItemRelateds(coId);
		},
		loadExistingFoodItemSizes: () => {
			var coId = $("#coFoodItemId").val();
			FoodItemSizeSelector.loadExistingFoodItemSizes(coId);
		},
		loadExistingInfoFoodItems: () => {
			var coId = $("#coFoodItemId").val();
			FoodItemInfo.loadExistingInfoFoodItems(coId);
		},
		loadExistingToppings: () => {
			var coFoodItemId = $("#coFoodItemId").val();
			FoodItemToppingSelector.loadExistingFoodItemToppings(coFoodItemId);
		},
		
		loadExtraFoodItem : () =>{
			var coFId = $("#coFoodItemId").val();
			if(coFId != null && coFId != ''){
				$.ajax({
					url: getContext() + '/api/load-extraFoodItem',
					data : {coFId : coFId
					},
					method:'GET',
					success: function(data) {
						var extra = "";
						extra = "<option></option>";
						if(data.extraFoodItem != null && data.extraFoodItem != ''){
							extra = "<option value=" + data.extraFoodItem + ">" + data.extraFoodItem + "</option>";
						}
						$(".select2-items-extra").html(extra);
					},
					error: function (e) {
						console.log("error: ",e);
					}
				});
			}
			
		},
		
		loadFoodItem : () =>{
			var coFId = $("#coFoodItemId").val();
			if(coFId != null && coFId != ''){
				$.ajax({
					url: getContext() + '/api/load-foodItem-in-cfi',
					data : {coFId : coFId
					},
					method:'GET',
					success: function(data) {
						var fi = "";
						fi = "<option></option>";
						if(data.id != null && data.id != ''){
							fi = "<option value=" + data.id + ">" + data.code + ": " + data.name + "</option>";
						}
						$(".select2-co-food-item-cata").html(fi);
					},
					error: function (e) {
						console.log("error: ",e);
					}
				});
			}
			
		},
		
		loadFeatures: () => {
			var coFoodItemId = $("#coFoodItemId").val();
			$(".listbox-feature-items").html("");
			$('.listbox-feature-items').bootstrapDualListbox('refresh', true);
			$.ajax({
				url: getContext() + '/cag/co/get-features',
				method:'GET',
				data : {id : coFoodItemId},
				success: function(data) {
					let str = "";
					data.forEach((item) => {
						var selected = '';
						if(item.selected){
							selected = 'selected';
						}
						str += "<option value='" + item.id + "'" + selected + ">" + item.code + "</option>";
					});
					
					$(".listbox-feature-items").html(str);
					$('.listbox-feature-items').bootstrapDualListbox('refresh', true);
			        
			        
				},
				error: function (e) {
					console.log("error: ",e);
				}
			});
		},
		
	}


// Initialize module
// ------------------------------
document.addEventListener('DOMContentLoaded', function() {
	quoteForm.init();
	Modifier.loadExistingAssets();
});