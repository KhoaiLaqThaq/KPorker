var PigEntryListComponent = function() {    
    var submitForm = function(){
		$('#btnSubmit').on('click',function(e){
			//set lai ngay thang nam
			var fromDate = $('#displayFromDate').val();
			var toDate = $('#displayToDate').val();
			if(fromDate) {
				var date = new Date(fromDate).toLocaleDateString('en-GB');				
				document.getElementById("fromDate").value = date;
			}
			if(toDate) {
				var date = new Date(toDate).toLocaleDateString('en-GB');
				document.getElementById("toDate").value = date;
			}
			$('#pigEntryForm').submit();
		});
		$('#btn_reset').click(function(){
			$("#fromDate").val("");
			$("#toDate").val("");
			$('#pigEntryForm').submit();
		})
	};

    return {
        init: function() {
        	submitForm();
        }
    }
}();
document.addEventListener('DOMContentLoaded', function() {
	PigEntryListComponent.init();
    PigEntryListComponent.checkPoStatus;
});
