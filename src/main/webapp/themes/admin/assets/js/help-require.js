var HelpRequireFormComponent = function() {
	var initForm = function() {
        if (!$().select2) {
            return;
        }
    	// select2
   	 	$('.select2').select2();
   	 	
   	 	var id = $("#formId").val();
   	 	if(id){
			$(document).ready(function(){
				 ClassicEditor
					 .create( document.querySelector( '#editorSetValue' ))
					 .then( editor => {
						editor.setData($("#desCriptionValue").val());
					 })
					 .catch( error => {
					     console.error( error );
					 });
				console.log($("#desCriptionValue").val());
				
			});
		} else {
			ClassicEditor
				 .create( document.querySelector( '#editor' ),{
					removePlugins: ['CKFinderUploadAdapter', 'CKFinder', 'EasyImage', 'Image', 'ImageCaption', 'ImageStyle', 'ImageToolbar',
					'MediaEmbed','ImageUpload'],
				 })
				 .catch( error => {
				     console.error( error );
				 } );
		}
   	 	
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
    
    var categoryInit = function(){
		$(document).ready(function(){
			var category = $("#category").val();
			var subcategory = $("#subCategory").val();
			
			if(category != null){
				var url = getContext() + '/sdpitems?category='+category;
				if(subcategory != undefined && subcategory != null){
					url = url + '&subcategory='+subcategory;
				}
				
				$.ajax({
					url: url,
					contextType: 'application/json',
					method: 'GET',
					dataType: 'json',
					
					success: function(data) {
						console.log(data);
						data.forEach((e) => {
							$("#subCategory").append('<option value="'+e+'">'+e+'</option>');
						});
					},
					error: function(err) {
						console.log(err);
					}
				});
			}
		})
		
	}
    
    var subCategorySelected = function(){
		$("#subCategory").on('change', function(e){
			var category = $("#category").val();
			var subcategory = $("#subCategory").val();
			
			if(category != null){
				var url = getContext() + '/sdpitems?category='+category;
				if(subcategory != undefined && subcategory != null){
					url = url + '&subcategory='+subcategory;
				}
				
				$.ajax({
					url: url,
					contextType: 'application/json',
					method: 'GET',
					dataType: 'json',
					
					success: function(data) {
						$("#item").find("option").each(function(index, element){
							element.remove();
						});
						data.forEach((e) => {
							$("#item").append('<option value="'+e+'">'+e+'</option>');
						});
					},
					error: function(err) {
						console.log(err);
					}
				});
			}
		})
	}
	
	function validate(){
		var pigGroup = $('#pigCullingPigGroup').val();
		var materialCode = $('#materialCode').val();
		var quantity = $('#pigdeadQuantity').val();
		var date = $('#date').val();
		var check = false;
		
		if(pigGroup == ''){
			$('#msgForPigGroup').text("Vui lòng chọn mã nhóm heo");
			check = false;
		} else {
			check = true;
		}
		if(materialCode == ''){
			$('#msgForMaterialCode').text("Vui lòng chọn mã vật tư");
			check = false;
		} else {
			check = true;
		}
		if(quantity == ''){
			$('#msgForQuantity').text("Vui lòng nhập số lượng");
			check = false;
		} else {
			check = true;
		}
		if(date == ''){
			$('#msgForDate').text("Vui lòng chọn ngày sự kiện");
			check = false;
		} else {
			check = true;
		}
		return check;
	}
	
	
	return {
        init: function() {
        	initForm();
        	initBootstrapSwitch();
        	initSwitchery();
        	categoryInit();
        	subCategorySelected();
        }
    }
}();

// Initialize module
// ------------------------------

document.addEventListener('DOMContentLoaded', function() {
	HelpRequireFormComponent.init();
});
