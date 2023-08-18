		contextPath = getContext();
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
        
        $('#assetSubmit').on('click', function() {
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
        	var price = parseInt(($('#price').val()).replace(/[^0-9.-]+/g,""));
        	console.log("price "+typeof(price))
        	if(price != ""){
        		var object = {};
        		object["price"] = price;
        		
        		detailJson.push(object);
        	}
        	var quotePrice = parseInt(($('#quotePrice').val()).replace(/[^0-9.-]+/g,""));
        	console.log("quoteprice "+quotePrice)
        	if(quotePrice != ""){
        		var object = {};
        		object["priceQuote"] = quotePrice;
        		detailJson.push(object);
        	}
        	var imported_date = $('#imported_date').val();
        	if(imported_date != ""){
        		var object = {};
        		object["imported_date"] = imported_date;
        		detailJson.push(object);
        	}
        	var depreciation_rate = $('#depreciation_rate').val();
        	if(depreciation_rate != ""){
        		var object = {};
        		object["depreciation_rate"] = depreciation_rate;
        		detailJson.push(object);
        	}
        	var depreciation_period = $('#depreciation_period').val();
        	if(depreciation_period != ""){
        		var object = {};
        		object["depreciation_period"] = depreciation_period;
        		detailJson.push(object);
        	}
        	var guarantee = $('#guarantee').val();
        	if(guarantee != ""){
        		var object = {};
        		object["guarantee"] = guarantee;
        		detailJson.push(object);
        	}
        	document.getElementById("detail").value = JSON.stringify(detailJson);
//        	console.log($('#detail').val());
        })
	 
//	show detail modal
	
//	 Validate
	 function validate(){
		var message = $('#messageCheckQuotePrice').text();
		if(message != ""){
			return false
		}else{
			return true;
		}
	 }
	 
	 
	 
	 $("#price, #quotePrice, #assetHistoryPrice").keyup(function(){
		 this.value = this.value.replace(/[^0-9\.]/g,'');		 
		 var asset = document.querySelector('#price');
		 asset.oninput = function(){
	         $('#messageCheckQuotePrice').html("");	 
		 };
		 var asset1 = document.querySelector('#quotePrice');
		 asset1.oninput = function(){
	         $('#messageCheckQuotePrice').html("");	 
		 };
	 });
	 
	 $("#price, #quotePrice").blur(function(){	
		 var priceAsset =  parseInt(($('#price').val()).replace(/[^0-9.-]+/g,""));	
		 var priceQuoteAsset =  parseInt(($('#quotePrice').val()).replace(/[^0-9.-]+/g,""));
		 $('#price').val(formatMoney(priceAsset));
		 $('#quotePrice').val(formatMoney(priceQuoteAsset));
		 if( $("#quotePrice").val() != "" && $("#price").val() != "" ){
			 if(priceQuoteAsset < priceAsset){
				 $('#messageCheckQuotePrice').html("Vui lòng nhập giá bán cao hơn giá mua.");
			 }
		 }
	 });
	 
	 $("#depreciation_rate, #depreciation_period, #guarantee, #assetHistoryPrice").keyup(function(){
		 this.value = this.value.replace(/[^0-9\.]/g,'');
	 });
	 
	function formatMoney(amount, decimalCount = 0, decimal = ".", thousands = ",") {
	  try {
	    decimalCount = Math.abs(decimalCount);
	    decimalCount = isNaN(decimalCount) ? 0 : decimalCount;

	    const negativeSign = amount < 0 ? "-" : "";

	    let i = parseInt(amount = Math.abs(Number(amount) || 0).toFixed(decimalCount)).toString();
	    let j = (i.length > 3) ? i.length % 3 : 0;

	    return negativeSign + (j ? i.substr(0, j) + thousands : '') + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + thousands) + (decimalCount ? decimal + Math.abs(amount - i).toFixed(decimalCount).slice(0) : "");
	  } catch (e) {
	    console.log(e)
	  }
	};
	$(document).ready(function(){
		$("#name").keyup(function(){
		 $("#assetSubmit").attr("disabled",false);
		 $('#messageCheckName').html("");
		  var assetCode =  $("#code").val().trim();
		  var assetName =  $(this).val().trim();
		
		if(assetName != ""){
       $.ajax({
           type: "GET",
           url: contextPath + "/asset/checkAssetName?name="+assetName+"&code="+assetCode,
           success: function(check){
             	   if(check == false ){
            	  $('#messageCheckName').html("Tên đã tồn tại , vui lòng chọn tên khác");
            	    $("#assetSubmit").attr("disabled",true);
	              }
	           },
	       });
	     };
     });	
		
		});
	
	

	 