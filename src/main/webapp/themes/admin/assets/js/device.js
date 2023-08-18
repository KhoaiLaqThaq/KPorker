	
	const contextPath = getContext();
//        check Device code
        $(document).ready(function(){
	     $('#code').keyup(function(){
	       var codeDevice =  $(this).val().trim();
	       var idDevice =  $("#idDevice").val().trim();
	       if(codeDevice != ""){
		       $.ajax({
		           type: "GET",
		           url: contextPath+"/checkDeviceCode?code="+codeDevice+"&id="+idDevice,
		           success: function(check){
		              if(check == true ){
		            	  $('#messageCheckCode').html("Code đã tồn tại, vui lòng chọn code khác");
		              }
		           },
		       });
		     }
	     });
	 });
	 var codeDevice = document.querySelector('#code');
	 codeDevice.oninput = function(){
         $('#messageCheckCode').html("");	 
	 };
	 
//	show detail modal

	 
//	 validate
	 function validate(){
		 var message = $('#messageCheckCode').text();
		 if(message != ""){
			 return false
		 }else{
			 return true;
		 }
	 }
