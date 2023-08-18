$(document).ready(function(){
	var currentDate = getCurrentDate();
	var myModal = new bootstrap.Modal(document.getElementById('exampleModal'));
	
	var poStatus = $('#processOrderStatus').val();
	if(poStatus == 'closed' ){
		$('#addDailyAverageWeightButton').hide()		
	}	
	
	
	
	$(".openModal").on("click", function(){
		var eventId = event.target.id.substring(5);
		getEventDetail(eventId);
		myModal.show();
	})
	
	$("#closeModal").on("click",function(){
		myModal.hide();
	})
	
	$('#fromDate').daterangepicker({ 
       singleDatePicker: true,
       showDropdowns: true,
       maxDate: currentDate,
       autoUpdateInput: false,
       locale: {
           format: 'DD-MM-YYYY'
       }
	}, function(start,end,label){
		$("#fromDate").val(start.format('DD-MM-YYYY'))
	});
	
	$('#toDate').daterangepicker({ 
       singleDatePicker: true,
       maxDate: currentDate,
       autoUpdateInput: true,
       locale: {
           format: 'DD-MM-YYYY'
       }
	}, function(start,end,label){
		$("#toDate").val(start.format('DD-MM-YYYY'))
	});
	
	$('#fromDate').on('apply.daterangepicker', function(ev, picker) {
		validate();
	});
	
	$('#toDate').on('apply.daterangepicker', function(ev, picker) {
		validate();
	});
	
	$("#resetButton").on("click",function(){
		document.getElementById('fromDate').value = "";
		document.getElementById('toDate').value = "";
	})
});

function getCurrentDate(){
	var today = new Date();
	var currentDay = today.getDate();
	var currentMonth = today.getMonth()+1;
	var currentYear = today.getFullYear();
	if(currentDay<10){
		currentDay='0'+currentDay
	} 
	if(currentMonth<10){
		currentMonth='0'+currentMonth
	} 
	var currentDate = currentDay+"-"+currentMonth+"-"+currentYear;
	return currentDate;
};

function validate(){
	var fromDateValue = $("#fromDate").val().split("-");
	var toDateValue = $("#toDate").val().split("-");
	
	var fromDateConverted = new Date(fromDateValue[2],fromDateValue[1]-1,fromDateValue[0]);
	var toDateConverted = new Date(toDateValue[2],toDateValue[1]-1,toDateValue[0]);
	
	if($("#fromDate").val() != ""){
		if(fromDateConverted <= toDateConverted){
			document.getElementById("submitButton").disabled = false;
		} else {
			document.getElementById("submitButton").disabled = true;
		}
	} else {
		document.getElementById("submitButton").disabled = false;
	}
}

function getEventDetail(eventId){
	$.ajax({
		type : "GET",
		url: 'http://localhost:8082/dailyAverageWeight/detail/'+eventId,
		datatype:"json",
		success : function(response){
			$("#detailTableBody").html("");
			response.content['weightNote'].forEach(function(item, i){
				fillDataDetailTable(Number.parseInt(i), item);
			})
		},       
	});
}

function fillDataDetailTable(index, item){
	var no = index + 1;
	$("#detailTableBody").append(
			'<tr>'
			+'<td class="text-center">'+no+'</td>'
			+'<td class="text-center">'+item.weightRange+'</td>'
			+'<td class="text-center">'+item.quantity+'</td>'
			+'</tr>'
	);
}







