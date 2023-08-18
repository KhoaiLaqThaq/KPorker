var arrayChart = [];
var tempBeforeSelectChange;

$(document).ready(function(){
	arrayChart = generateDataSource();
	init();
	
	$(".selected-item-quantity").each(function(index, element){
		if($(this).val() == ""){
			$(this).val(0);
		}
	});
	
	$(document).on("change", ".selected-item-quantity", function(){
		caculateAvgWeight();
	});
	
	$(document).on("select2:opening", ".selected-weight-range", function(e){
		tempBeforeSelectChange = $(this).val();
	});
	
	$(document).on("select2:select", ".selected-weight-range", function(e){
		var selectElementId = $(this)[0].id;
		var selectText = e.params.data.text;
		
		getAvgFromString(selectText);
		
		$(".selected-weight-range").each(function(e){
			var id = $(this)[0].id;
			if(selectElementId != id){
				console.log($(this))
				$(this).find("option").each(function(index, element){
					if(element.value == selectText){
						element.remove();
					}
				});
				
				var newOption = new Option(tempBeforeSelectChange);
				$(this).append(newOption).trigger('change');
			}
		});
		caculateAvgWeight();
	});
});

function initSelect2(){
 	$('.select2').select2();
}

function cloneRow(index){
	var counter = index + 1;
    var newRow = $('<tr id="rec-note'+counter+'">');
    var cols = "";
    
    cols += '<td><span class="no">'+counter+'</span><input type="hidden" class="index-table" value="'+ counter +'"></td>';
    cols += '<td><select class="form-control selected-weight-range" name="contentProposals['+counter+'].range" id="select2'+counter+'" data-placeholder="Chọn khối lượng" data-fouc></select></td>';
    cols += '<td><input type="number" name="contentProposals['+counter+'].quantity" id="selected-item-quantity'+counter+'" class="form-control selected-item-quantity" value="0"></td>';
    cols += '<td><input type="text id="selected-item-note'+counter+'" name="contentProposals['+counter+'].note" class="form-control" data-placeholder="Ghi chú">';
   
    cols += '<td class="text-center">';
    cols += '<div class="list-icons">';
    cols += '<button type="button" class="btn-primary btn-xs" onclick="addRow()" title="Add Row" style="display: inline-block; float: none; border: none"><i class="fa fa-plus "></i></button>';
    cols += '<button type="button" class="btn-danger btn-xs" onclick="removeRow('+counter+')" title="Remove Row" style="display: inline-block; float: none; border: none"><i class="fa fa-times"></i></button>';
    cols += '</div>';
    cols += '</td>';
    cols += '</tr>';
    newRow.append(cols);
    return newRow;
}

function addRow(){
	var index = parseInt($("#tblSelectedNote").find(".index-table").last().val());
	var newRow = cloneRow(index);
	newRow.appendTo('#tblSelectedNote tbody');
	/*initSelect2();*/
	initAfterAdd();
	$('#tblSelectedNote tbody tr').each(function(index) {
	      $(this).find('span.no').html(index+1);
	});
}

function removeRow(index){
	var deleteRow = $("#select2"+index).val();
	
	var size = $('#tblSelectedNote tbody tr').length;
	if(size == 1){
		$('#tblSelectedNote tbody tr').find("input:not([type=hidden])").val('');
		
	} else {
		$('#rec-note'+index).remove();
		$(this).parents(".clonableSourceRow").remove();		            
		$('#tblSelectedNote tbody tr').each(function(index) {
		      $(this).find('span.no').html(index+1);
		});
	}
	
	var newOption = new Option(deleteRow);
	$('.selected-weight-range').append(newOption).trigger('change');
}

function init(){
	/*var dataSource = generateDataSource();*/
	var dataSource = arrayChart;
	var size = $('.selected-weight-range').length;
	
	for(var i = 0;i<size;i++){
		var exist = $("#select2"+i).val();
		var index = arrayChart.indexOf(exist);
		if(index > -1){
			arrayChart.splice(index, 1);
		};
		
		$("#select2"+i).select2({
			data : dataSource
		})
	}
	
	$(".selected-weight").each(function(e){
		var id = $(this)[0].id.substring(12);
		var existValue = $(this).val();
		if(existValue != ""){
			$("#select2"+id).val(existValue);
			$("#select2"+id).trigger('change'); 
		}
	});
	
	caculateAvgWeight();
}

function initAfterAdd(){
	var dataSource = arrayChart;
	var size = $(".selected-weight-range").length;
	
	$('.selected-weight-range').each(function(e){
		var exist = $(this).val();
		var index = arrayChart.indexOf(exist);
		if(index > -1){
			arrayChart.splice(index, 1);
		};
	});
	
	$(".selected-weight-range").last().select2({
		data : dataSource
	})
	
	$(".selected-weight").each(function(e){
		var id = $(this)[0].id.substring(12);
		var existValue = $(this).val();
		if(existValue != ""){
			$("#select2"+id).val(existValue);
			$("#select2"+id).trigger('change'); 
		}
	});
	
	var lastSelect = $(".selected-weight-range").last().val();
	$(".selected-weight-range").each(function(index, element){
		if(index != size-1){
			$(this).find("option").each(function(index2, element2){
				if(element2.value == lastSelect){
					element2.remove();
				}
			});
		}
	});
	
	caculateAvgWeight();
}

function refreshSelectOption(){
	var size = $('.selected-weight-range').length;
	if(size > 1){
		$('.selected-weight-range').each(function(index1){
			var tempArray = generateDataSource();
			$('.selected-weight-range').each(function(index2){
				if(index2 != index1){
					var text = $(this).val();
					var locate = tempArray.indexOf(text);
					if(locate > -1){
						tempArray.splice(locate, 1);
					}
				}
			});
			$(this).empty();
			$(this).select2({
				data : tempArray
			});
		})
	}
	
}

function generateDataSource(){
	var array = [];
	array.push("Vấn đề(Què, liệt, ...)");
	array.push("<70 kg");
	array.push("70-80 kg");
	for (var i = 80; i<= 120; i+=10){
		var numberParsed = parseInt(i+10);
		var item = i + "-" + numberParsed + " kg";
		array.push(item);
	}
	array.push(">130 kg");
	return array;
}

function caculateAvgWeight(){
	var totalQuantity = 0;
	var totalWeight = 0;
	var avgWeight = 0;
		
	$('.selected-weight-range').each(function(index, element){
		var id = element.id.substring(7);
		var textWeight = $("#select2"+id).val();
		var textQuantity = $("#selected-item-quantity"+id).val();
		
		var weight = getAvgFromString(textWeight);
		var quantity = textQuantity.length > 0 ? parseInt(textQuantity) : 0;
		
		totalQuantity = totalQuantity + quantity;
		totalWeight = totalWeight + (weight*quantity);
	});
	
	if(totalQuantity != 0){
		avgWeight = totalWeight/totalQuantity;
	};
	
	$("#totalProposal").val(totalQuantity);
	$("#avgProposalWeight").val(avgWeight);
	
}

function getAvgFromString(text){
	if(text == "Vấn đề(Què, liệt, ...)") return 0;
	if(text == "<70 kg") return 60;
	if(text == ">130 kg") return 135;
	var numArr = (text.split(" ")[0]).split("-");
	var num1 = parseInt(numArr[0]);
	var num2 = parseInt(numArr[1]);
	return (num1+num2)/2;
}

function validateInput(num){
	var number = parseInt(num);
	console.log(number);
	if(number >= 0){
		return true;
	}
	return false;
}