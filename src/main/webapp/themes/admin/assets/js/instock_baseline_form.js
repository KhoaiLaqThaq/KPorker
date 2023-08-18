var FormComponent = function() {
    var search = function() {
		$('#btnSearch').on('click',function(e){
			var stockCode = $('#instockStockCode').val();
			var materialName = $('#materialName').val().toLowerCase();
			var materialPurchasingGroup = $('#materialPurchasingGroup').val();
			
			var table = document.getElementById("dataMaterials");
		    var tr = table.getElementsByTagName("tr");
			var materialNameValueIntable;
			var materialPurchasingGroupValueIntable;
			var materialNameIntable;
			var materialPurchasingGroupIntable;
			
			$("#dataMaterials tr").css("display", "table-row");
			
			for (i = 0; i < tr.length; i++) {
				materialNameIntable = tr[i].getElementsByTagName("td")[2];
				materialPurchasingGroupIntable = tr[i].getElementsByTagName("td")[8];
			    if (materialNameIntable && materialPurchasingGroupIntable) {
			    	materialNameValueIntable = materialNameIntable.textContent || materialNameIntable.innerText;
			    	materialPurchasingGroupValueIntable = materialPurchasingGroupIntable.textContent || materialPurchasingGroupIntable.innerText;
			    	if(materialName && materialName != "" && materialPurchasingGroup && materialPurchasingGroup != ""){
			    		if (materialNameValueIntable.toLowerCase().indexOf(materialName) > -1 && materialPurchasingGroupValueIntable.indexOf(materialPurchasingGroup) > -1 ) {
				    		// khong thao tac gi
				    	} else {
				    		var index = i;
				    		$("#rec-material"+index).css("display", "none");
				    	}
			    	} else if(materialName && materialName != "") {
			    		if (materialNameValueIntable.toLowerCase().indexOf(materialName) > -1) {
				    		// khong thao tac gi
				    	} else {
				    		var index = i;
				    		$("#rec-material"+index).css("display", "none");
				    	}
			    	} else if(materialPurchasingGroup && materialPurchasingGroup != ""){
			    		if (materialPurchasingGroupValueIntable.indexOf(materialPurchasingGroup) > -1) {
				    		// khong thao tac gi
				    	} else {
				    		var index = i;
				    		$("#rec-material"+index).css("display", "none");
				    	}
			    	} else {
			    		var index = i;
			    		$("#rec-material"+index).css("display", "table-row");
			    	}
			    }       
			  }
		});
    };
    
    return {
        init: function() {
        	search();
        }
    }
}();

// Initialize module
// ------------------------------

document.addEventListener('DOMContentLoaded', function() {
	FormComponent.init();
});
