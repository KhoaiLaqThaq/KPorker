var FormComponent = function() {
	
	var initForm = function() {
        if (!$().select2) {
            return;
        }
    	// select2
   	 	$('.select2').select2();
	}
	
    return {
        init: function() {
        	initForm();
        }
    }
}();


var Custom = {
		hideIcon: () => {
			$(".icon_head").hide();
			$(".icon").hide();
			$('#tblSelectedMaterials tbody tr').find("input").attr("readonly", true);
		},
		
		setReadonlySelect: () => {
			$('#goodsIssueFromStockCode').attr("disabled", true); 
			$('#goodsIssueToStockCode').attr("disabled", true); 
		},
}
// Initialize module
// ------------------------------

document.addEventListener('DOMContentLoaded', function() {
	FormComponent.init();
	Custom.hideIcon();
	Custom.setReadonlySelect();
	formatNumberComponent.initAutoNumeric();
});
