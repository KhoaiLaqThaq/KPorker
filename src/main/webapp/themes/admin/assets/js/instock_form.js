var FormComponent = function() {
	var init = function(){
		var today = new Date();
		var dd = String(today.getDate()).padStart(2, '0');
		var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
		var yyyy = today.getFullYear();
		
		today = dd + '/' + mm + '/' + yyyy;
		
		$('.daterange-single').daterangepicker({ 
			maxDate: today,
        	singleDatePicker: true,
          	locale: {
				format: 'DD-MM-YYYY'
          	}
       	});
       
       	$('.daterange-single').on('apply.daterangepicker', function(ev, picker){
			ev.preventDefault();
			_showModalProcessing();
			setTimeout(() => {
		      getInstock();
		    }, 300);
			
			
		});
	}
	
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
    
    var _showModalProcessing = () => $('#modalLoading').addClass('d-block').removeClass('d-none');
    var _hideModalProcessing = () => $('#modalLoading').addClass('d-none').removeClass('d-block');
    
    var getInstock = function(){
		let farmName = $("#instockStockname").val();
		let postingDate = $("#instockSyncDate").val();
		console.log(farmName);
		console.log(postingDate);
		$.ajax({
			type : "GET",
			url: getContext() + '/api/instock/getLatestInstock?postingDate='+postingDate+'&farmName='+farmName,
			async: false,
			datatype:"json",
			success : function(response){
				console.log(response);
				refreshData(response);
				_hideModalProcessing();
			},    
			error : function(err){
				console.log(err);
			}   
		});
	}
	
	var refreshData = function(instock){
		$("#dataMaterials").empty();
		instock.materialDetails.forEach((item, index) =>{
			let newRow = cloneNewRow(index, item);
			newRow.appendTo("#dataMaterials");
		});

	}
	
	var cloneNewRow = function(index, data){
		let counter = index;
        var newRow = $('<tr id="rec-material'+counter+'" class="tr">');
        var cols = "";

        cols += '<td><span class="no">'+counter+'</span></td>';   
        cols += '<td>'+data.code+'</td>';
        cols += '<td>'+data.name+'</td>';
        cols += '<td>'+data.quantity+'</td>';
        cols += '<td>'+data.unit+'</td>';
        if(data.batch != null){
			cols += '<td>'+data.batch +'</td>';
		} else {
			cols += '<td></td>';
		}
        cols += '<td>'+data.groupCode+'</td>';
        cols += '<td>'+data.groupName+'</td>';
        cols += '<td>'+data.purchasingGroup+'</td>';
        if(data.manufacturedDateStr != null){
			cols += '<td>'+data.manufacturedDateStr+'</td>';
		} else {
			cols += '<td></td>';
		}
		if(data.expiredDateStr != null){
			cols += '<td>'+data.expiredDateStr+'</td>';
		} else {
			cols += '<td></td>';
		}
        
        
        
        newRow.append(cols);
        newRow.append('</tr>')
        return newRow;
	}
    
    return {
        init: function() {
			init();
        	search();
        }
    }
}();

// Initialize module
// ------------------------------

document.addEventListener('DOMContentLoaded', function() {
	FormComponent.init();
});
