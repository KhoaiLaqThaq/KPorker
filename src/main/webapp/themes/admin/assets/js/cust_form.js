		if($(".clonableProductRow").length == 1) {
        	$("button.removeProductRow").attr('disabled', 'disabled');
        }
    	
        function addProductRow() {
//        	disableAutoNumeric();
        	if ($(".clonableProductRow").length >= 1) {
        		$("button.removeProductRow").removeAttr('disabled');
            }
        	
            $("#foundationStateForm").data('bootstrapValidator', null);
            var regex = /^(products\[)(?:[0-9]\d?|100)(\].*)$/i;
            
            var tableBody = this.closest('tbody');
            
            $lastClonableRow = $(tableBody.lastElementChild);

            var cloneProductIndex = parseInt($lastClonableRow.attr('cloneProductIndex')) + 1;
            
            //alert(cloneProductIndex);
            $lastClonableRow.clone(true).attr('cloneProductIndex', cloneProductIndex)
                .insertAfter($lastClonableRow)
                
                .find("*")
                    .each(function() {
                        $.each(this.attributes, function(i, attrib){
                            var value = attrib.value || "";
                            var match = value.match(regex) || [];
                            if (match.length == 3) {
                                this.value = match[1] + (cloneProductIndex) + match[2];
                                / alert(this.value); /
                            }
                         })
                    })
                    
                    .find('input').val('');
            
            // set value for last record
            //alert($lastClonable.html());
//            initAutoNumeric();
        }
        
        function removeProductRow() {
            //var tableBody = this.closest('tbody');
            if ($(".clonableProductRow").length > 1) {
                $(this).parents(".clonableProductRow").remove();
            }
            
            if ($(".clonableProductRow").length == 1) {
            	$("button.removeProductRow").attr('disabled', 'disabled');
            }
            
            /* if (tableBody.children.length > 1) {
                $(this).parents(".clonableProductRow").remove();
            } */
        }
        
        $("button.addProductRow").on("click", addProductRow);
        $("button.removeProductRow").on("click", removeProductRow);
        
        
//      create JsonArray
        
        $('#custSubmit').on('click', function() {
        	var keyElements = document.getElementsByClassName("keyDetail");
        	var valueElements =  document.getElementsByClassName("valueDetail");
        	var detailJson = [];
        	for (var i = 0; i < keyElements.length; i++) {
        		var object = {}
        		if(keyElements[i].value != "" && valueElements[i].value != ""){
        			object[keyElements[i].value] = valueElements[i].value;
            		detailJson.push(object);
        		}
        	  }
        	document.getElementById("detail").value = JSON.stringify(detailJson);
//        	console.log($('#detail').val());
        })
//        end create JsonArray
        const contextPath = getContext();     
//        check Customer code
        $(document).ready(function(){
	     $('#code').keyup(function(){
	       var codeCustomer =  $(this).val().trim();
	       var idCustomer =  $("#idCust").val().trim();
	       if(nameCustomer != ""){
		       $.ajax({
		           type: "GET",
		           url:contextPath+"/checkCustomerCode?code="+codeCustomer+"&id="+idCustomer,
		           success: function(check){
		              if(check == true ){
		            	  $('#messageCheckCode').html("Code đã tồn tại, vui lòng chọn code khác");
		              }
		           },
		       });
		     }
	     });
	 });
	 var nameCustomer = document.querySelector('#code');
	 nameCustomer.oninput = function(){
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


	 