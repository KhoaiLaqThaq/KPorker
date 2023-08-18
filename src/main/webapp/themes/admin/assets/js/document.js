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
        
        $('#documentSubmit').on('click', function() {
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
        
//        Get detail API
 
        
 const contextPath = getContext();       
        
$('#exampleModalCenter').on('show.bs.modal', function (event) {
var button = $(event.relatedTarget)
$('#dynamic-table').html("");
var id = button.data('document_id');
$.ajax({
        type: "GET",
        url: contextPath +"/getDocument?id="+id,
        success: function(document){
         
           Object.keys(document.detail).map(key=> {
        	   $('#dynamic-table').append('<tr>'
                       +'<td class="key">' + key + '</td>'
                       +'<td class="value">' + document.detail[key] + '</td>'
                       +'</tr>');
           })
        },
    });
});


//      check document code
$(document).ready(function(){
 $('#code').keyup(function(){
  $('#messageCheckCode').html("");
   var codeDocument =  $(this).val().trim();
   var idDocument =  $("#id").val().trim();
   if(codeDocument != ""){
       $.ajax({
           type: "GET",
           url: contextPath + "/checkDocumentCode?code="+codeDocument+"&id="+idDocument,
           success: function(check){
              if(check == true ){
            	  $('#messageCheckCode').html("Code đã tồn tại, vui lòng chọn code khác");
	              }
	           },
	       });
	     }
     });
     
 });
                
// download file
$('#exampleModal').on('show.bs.modal', function (event) {
	var button = $(event.relatedTarget)
	$('#dowloadFile').html("");
	console.log("upload file");
	var code = button.data('document_code');	
	$.ajax({
	        type: "GET",
	        url: contextPath + "/findAttachmentByDocumentCode?documentCode="+code,
	        success: function(listAttachment){
	           console.log(listAttachment[0]);
	           for(var i= 0; i< listAttachment.length; i++){
	        	   var index =  i +1;
	        	   $('#dowloadFile').append('<tr>'
	        			   +'<td >' +index + '</td>'
	                       +'<td >' +listAttachment[i].name  + '</td>'
	                       +'<td><a href="'+contextPath + "/" +listAttachment[i].relativePath +'">'+'Tải xuống'+'</a></td>'
	                       +'</tr>');
	           		}
	        },
	    });
	});
	
	 
