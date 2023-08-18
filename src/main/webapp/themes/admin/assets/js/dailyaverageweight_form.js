var totalPig;
var inputQuantity = 0;
var arrayChart = [];
var tempBeforeSelectChange;

$(document).ready(function(){
	arrayChart = generateDataSource();
	
	$("#eventWeight").on("change",function(){
		var weight = parseInt($("#eventWeight").val());
		if(weight <= 0){
			$("#msgForWeight").text("Giá trị nhập không hợp lệ");
			document.getElementById("btnSubmit").disabled = true;
		} else {
			$("#msgForWeight").text("");
			document.getElementById("btnSubmit").disabled = false;
		}
	});
	
	init();
	submit();
	
	$(".selected-item-quantity").each(function(index, element){
		if($(this).val() == ""){
			$(this).val(0);
		}
	});
	
	$(document).on("change", ".selected-item-quantity", function(){
		calculateAvgWeight();
	});
	
	$(document).on("select2:opening", ".selected-weight-range", function(e){
		tempBeforeSelectChange = $(this).val();
	});
	
	$(document).on("select2:select", ".selected-weight-range", function(e){
		console.log("gfa");
		var selectElementId = $(this)[0].id;
		var selectText = e.params.data.text;
		
		
		$(".selected-weight-range").each(function(e){
			var id = $(this)[0].id;
			if(selectElementId != id){
				$(this).find("option").each(function(index, element){
					if(element.value == selectText){
						element.remove();
					}
				});
				
				var newOption = new Option(tempBeforeSelectChange);
				$(this).append(newOption).trigger('change');
			}
		});
		calculateAvgWeight();
	});
	
	var currentDate = getCurrentDate();
	$('input[name="stage"]').daterangepicker({
		maxDate: currentDate,
		singleDatePicker: true,
      	locale: {
          	cancelLabel: 'Clear',
          	format: 'DD/MM/YYYY'
      	}
  	});
  	
  	let eventId = $("#eventId").val();
  	if(eventId){
		$("#stage").attr("disabled", true);
	}
	let stage = $('input[name="stage"]');
  	stage.on('apply.daterangepicker', function(ev, picker) {
      	$(this).val(picker.startDate.format('DD/MM/YYYY'));
      	totalPig = getTotalPigRetained();
  	});
	
  	stage.on('cancel.daterangepicker', function(ev, picker) {
      	$(this).val('');
  	});
	
	totalPig = getTotalPigRetained();
	$(document).on("keyup",".selected-item-quantity",function(){
		var id = event.target.id;
		var input = document.getElementById(id).value;
		var checkInput = validateInput(input);
		var checkQuantity = validatePigNumber(totalPig);
		if(checkInput){
			if(checkQuantity){
				$("#msgForQuantity").text("");
				document.getElementById("btnSubmit").disabled = false;
			} else {
				$("#msgForQuantity").text("Tổng số lượng không bằng lượng tồn heo. Số lượng = "+inputQuantity+" con");
				document.getElementById("btnSubmit").disabled = true;
			}
		} else {
			$("#msgForQuantity").text("Giá trị nhập không hợp lệ");
			document.getElementById("btnSubmit").disabled = true;
		}
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
    cols += '<td><select class="form-control selected-weight-range" name="weightNote.weightCharts['+counter+'].range" id="select2'+counter+'" data-placeholder="Chọn khối lượng" data-fouc></select><input type="hidden" class="selected-weight" id="select-range'+counter+'"/></td>';
    cols += '<td><input type="number" name="weightNote.weightCharts['+counter+'].quantity" id="selected-item-quantity'+counter+'" class="form-control selected-item-quantity" value="0"></td>';
    
    cols += '<td class="text-center">';
    cols += '<div class="list-icons">';
    cols += '<button type="button" class="btn-primary btn-xs" onclick="addRow()" title="Add Row" style="display: inline-block; float: none; border: none"><i class="fa fa-plus "></i></button>';
    cols += '<button type="button" class="btn-danger btn-xs" onclick="removeRow('+counter+')" title="Remove Row" style="display: inline-block; float: none; border: none"><i class="fa fa-times"></i></button>';
    cols += '</div>';
    cols += '</td>';
    newRow.append(cols);
    return newRow;
}

function addRow(){
	var index = parseInt($("#tblSelectedNote").find(".index-table").last().val());
	var newRow = cloneRow(index);
	newRow.appendTo('#tblSelectedNote tbody');
	initAfterAdd();
	$('#tblSelectedNote tbody tr').each(function(index) {
	      $(this).find('span.no').html(index+1);
	});
}

function removeRow(index){
	var deleteRow = $("#select2"+index).val();
	console.log(deleteRow);
	
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

	var checkQuantity = validatePigNumber(totalPig);
	if(checkQuantity){
		$("#msgForQuantity").text("");
		document.getElementById("btnSubmit").disabled = false;
	} else {
		$("#msgForQuantity").text("Tổng số lượng không bằng lượng tồn heo. Số lượng = "+inputQuantity+" con");
		document.getElementById("btnSubmit").disabled = true;
	}
}

function init(){
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
	
	calculateAvgWeight();
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
	
	calculateAvgWeight();
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
	for (var i = 0; i<= 125; i+=5){
		var numberParsed = parseInt(i+5);
		var item = i + "Kg" + "-" + numberParsed + "Kg";
		array.push(item);
	}
	
	for (var i = 130; i<= 190; i+=10){
		var numberParsed = parseInt(i+10);
		var item = i + "Kg" + "-" + numberParsed + "Kg";
		array.push(item);
	}
	
	/*for (var i = 0; i<= 120; i+=10){
		var numberParsed = parseInt(i+10);
		var item = i + "Kg" + "-" + numberParsed + "Kg";
		array.push(item);
	}*/
	return array;
}

function calculateAvgWeight(){
	var excludeArray = [];
	for (var i = 0; i<= 120; i+=10){
		var numberParsed = parseInt(i+10);
		var item = i + "Kg" + "-" + numberParsed + "Kg";
		excludeArray.push(item);
	}
	
	var rowCount = $(".index-table").length;
	let avgWeight = 0;
	let totalWeight = 0;
	let totalQUantity = 0;
	
	if(rowCount >= 1){
		for(let i = 0; i< rowCount; i++){
			let rangeStr = $("#select2"+i).val();
			
			if(rangeStr == null) continue;
			
			let array = rangeStr.split("-");
			if(array.length > 0){
				let firstValue = parseInt(array[0].substring(0, array[0].indexOf("Kg")));
				let secondValue = parseInt(array[1].substring(0, array[1].indexOf("Kg")));
				let avgValue = (firstValue + secondValue)/2;
				let pigQuantity = parseInt($("#selected-item-quantity"+i).val());
				totalQUantity = totalQUantity + pigQuantity;
				
				totalWeight = totalWeight + (avgValue*pigQuantity);
			}
		}
	
	avgWeight = totalWeight/totalQUantity;
	$("#averageWeight").val(avgWeight);
	}
}

function getTotalPigRetained(){
	$('#pleaseWaitDialog').modal();
	var total;
	var poCode = $("#poCode").val();
	var stage = $("#stage").val();
	$.ajax({
		type : "GET",
		url: getContext() + '/production/totalPigRetained?poCode='+poCode+'&stage='+stage,
		async: false,
		datatype:"json",
		success : function(response){
			total = response;
			$("#pigRetain").val(total);
			$('#pleaseWaitDialog').modal('hide');
		},    
		error : function(err){
			$('#pleaseWaitDialog').modal();
			console.log(err);
		}   
	});
	return total;
}

function validatePigNumber(totalPig){
	var total = 0;

	$('.selected-weight-range').each(function(index, item){
		let id = item.id.substring(7);
		let quantity = parseInt($("#selected-item-quantity"+id).val());
		total = total + quantity;
	});

	inputQuantity = total;
	if(total == totalPig){
		return true;
	} else {
		return false;
	}
}

function validateInput(num){
	var number = parseInt(num);
	if(number >= 0){
		return true;
	}
	return false;
}

function getCurrentDate(){
	var today = new Date();
	var dd = String(today.getDate()).padStart(2, '0');
	var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
	var yyyy = today.getFullYear();
	
	today = dd + '/' + mm + '/' + yyyy;
	
	return today;
}

function submit(){
	$("#btnSubmit").on('click', function(e){
		e.preventDefault();
		var total = $("#pigRetain").val();
		var checkQuantity = validatePigNumber(total);
		if(checkQuantity){
			$('#pleaseWaitDialog').modal();
			$("#msgForQuantity").text("");
			document.getElementById("btnSubmit").disabled = false;
			$("#stage").attr("disabled", false);
			$("#dailyAverageWeightForm").submit();
		} else{
			$("#msgForQuantity").text("Tổng số lượng không bằng lượng tồn heo. Số lượng = "+inputQuantity+" con");
			document.getElementById("btnSubmit").disabled = true;
		}
		
	});
}

