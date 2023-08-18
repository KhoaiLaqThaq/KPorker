const contextPath = getContext();
//        check category code
        $(document).ready(function(){
	     $('#code').keyup(function(){
	       var codeCategory =  $(this).val().trim();
	       var idCategory =  $("#idCategory").val().trim();
	       if(codeCategory != ""){
		       $.ajax({
		           type: "GET",
		           url: contextPath+"/checkCategoryCode?code="+codeCategory+"&id="+idCategory,
		           success: function(check){
		              if(check == true ){
		            	  $('#messageCheckCode').html("Code đã tồn tại, vui lòng chọn code khác");
		              }
		           },
		       });
		     }
	     });
	 });
	 var codeCategory = document.querySelector('#code');
	 codeCategory.oninput = function(){
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