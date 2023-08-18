$(document).ready(function(){
	$(function() {
	const dateValue =  $('#postingDateSearchInputValue').val() ;
	console.log(dateValue)
	$('#postingDateSearchInput').val(dateValue);	
	});
   	$('.select2').select2();
   	$('input[name="postingDateSearch"]').on('cancel.daterangepicker', function(ev, picker) {
    $('#postingDateSearchInput').val(null);	
 	 });




  	
})