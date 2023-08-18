var ComUser = function() {
	
    // Uniform
    var initUniform = function() {
        if (!$().uniform) {
            console.warn('Warning - uniform.min.js is not loaded.');
            return;
        }

        // Default initialization
        $('.form-check-input-styled').uniform();


        //
        // Contextual colors
        //

        // Primary
        $('.form-check-input-styled-primary').uniform({
            wrapperClass: 'border-primary-600 text-primary-800'
        });

        // Danger
        $('.form-check-input-styled-danger').uniform({
            wrapperClass: 'border-danger-600 text-danger-800'
        });

        // Success
        $('.form-check-input-styled-success').uniform({
            wrapperClass: 'border-success-600 text-success-800'
        });

        // Warning
        $('.form-check-input-styled-warning').uniform({
            wrapperClass: 'border-warning-600 text-warning-800'
        });

        // Info
        $('.form-check-input-styled-info').uniform({
            wrapperClass: 'border-info-600 text-info-800'
        });

        // Custom color
        $('.form-check-input-styled-custom').uniform({
            wrapperClass: 'border-indigo-600 text-indigo-800'
        });
    };

    // Switchery
    var initSwitchery = function() {
        if (typeof Switchery == 'undefined') {
            console.warn('Warning - switchery.min.js is not loaded.');
            return;
        }

        // Initialize multiple switches
        var elems = Array.prototype.slice.call(document.querySelectorAll('.form-check-input-switchery'));
        elems.forEach(function(html) {
          var switchery = new Switchery(html);
        });
    };

    // Bootstrap switch
    var initBootstrapSwitch = function() {
        if (!$().bootstrapSwitch) {
            console.warn('Warning - switch.min.js is not loaded.');
            return;
        }

        // Initialize
        $('.form-check-input-switch').bootstrapSwitch();
    };

    // Bootbox extension
    var initBootbox = function() {
        if (typeof bootbox == 'undefined') {
            console.warn('Warning - bootbox.min.js is not loaded.');
            return;
        }
    };

    
	var initEventHandler = function() {
		$('#btn-add-group-cage').prop("disabled", true);
		
		$('#cbo-farms').on('change', function() {
			const contextPath = getContext();
			const farmValue = $('#cbo-farms').val();
			if (farmValue) {
				 $.ajax({
					 url: contextPath + '/api/group-cages',
					 contextType: 'application/json',
					 method: 'GET',
					 data: {fic:farmValue},
					 success: function (data) {
						 var option = '';
						 if (data != null && data != '') {
							data.forEach((item) => {
								//console.log(item.id);
								option += '<option value="'+ item.id +'">'+ item.name +'</option>';
							});
							//console.log(option);
							$("#cbo-group-cages").html(option);
							$('#btn-add-group-cage').prop("disabled", false);
						 }
					 }, 
					 error: function (err) {
						 $("#cbo-group-cages").html('<option></option>');
						 console.log("error:", err)
					 }
				 });
			}
		});
		
		$('#btn-add-group-cage').on('click', function(e) {
            //stop submitting the form to confirm first
            e.preventDefault();

			const farmIdentityCode = $("#cbo-farms option:selected").val();
			const farmName = $("#cbo-farms option:selected").text();
			const groupCageId = $("#cbo-group-cages option:selected").val();
			const groupCageName = $("#cbo-group-cages option:selected").text();

			const rowCount = $('#tblSelectedGroupCages > tbody > tr').length;
			var newRow = Privilege.createRow(rowCount, groupCageId, farmIdentityCode, farmName, groupCageName);
			newRow.appendTo('#tblSelectedGroupCages tbody');
		});
	};
    
    
    //
    // Return objects assigned to module
    //
    return {
        init: function() {
            initUniform();
            initSwitchery();
            initBootstrapSwitch();
            initBootbox();
            initEventHandler();
        }
    }
}();


var User = {
	check: (path, id) => {
		if (id) {
			location.href = path + "?id=" + id;
		} else {
            bootbox.alert({
            	title: 'Thông báo:',
                message: 'Thông tin người dùng chưa được tạo !'
            });
		}
	}
}

var Privilege = {
	createRow: (index, groupCageId, farmIdentityCode, farmName, groupCageName) => {
		var counter = index + 1;
        var newRow = $('<tr id="rec-'+counter+'">');
        var cols = "";

        cols += '<td><span class="no">'+counter+'</span><input id="groupCageId'+index+'" type="hidden" name="groupCageIds['+index+']" value="'+groupCageId+'"></td>';
        cols += '<td>'+farmIdentityCode+'</td>';
        cols += '<td>'+farmName+'</td>';
		cols += '<td>'+groupCageName+'</td>';
		cols += '<td><button type="button" class="btn btn-dange btn-remove" data-popup="tooltip" title="Xóa" onclick="Privilege.removeRow('+counter+')"><i class="icon-cross2"></i></button></td>';
        newRow.append(cols);
        return newRow;
	},
	
	removeRow: (rowIndex) => {
		bootbox.confirm({
		    title: "Xác nhận",
		    message: "Bạn có chắc chắn muốn xóa không?",
		    buttons: {
		        cancel: {
		            label: '<i class="fa fa-times"></i> Cancel'
		        },
		        confirm: {
		            label: '<i class="fa fa-check"></i> Confirm'
		        }
		    },
		    callback: function (result) {
				if (result) {
					$('#rec-'+rowIndex).remove();
			    	$('#tblSelectedGroupCages > tbody > tr').each(function(ind){
			    		var counter = ind + 1;
			    		$(this).attr("id", "rec-" + counter);
			    		$(this).find('span.no').html(counter);
			    		$(this).find('button').attr('onclick', 'javascript:Privilege.removeRow('+counter+')');
			    	});
				}
		    }
		});		
	},
	
	load: () => {
		const contextPath = getContext();
		const userId = $("#userId").val();
		if (userId) {
			$.ajax({
				url: contextPath + '/api/load-group-cages-by-user',
				method:'GET',
				data:{userId:userId},
				success: function(data) {
					for (i=0; i<data.length; i++) {
						var newRow = Privilege.createRow(i, data[i].groupCageId, data[i].farmIdentityCode, data[i].farmName, data[i].groupCageName);
						newRow.appendTo('#tblSelectedGroupCages tbody');	
					}
				},
				error: function (e) {
					console.log("error: ",e);
				}
			});
		}
	}
}

// Initialize module
// ------------------------------
document.addEventListener('DOMContentLoaded', function() {
	ComUser.init();
	Privilege.load();
});
const contextPath = getContext();
 $(document).ready(function(){
 		$('#btnSubmit').attr("disabled", false);
 		  $('#messageCheckName').html("");
	     $('#username').keyup(function(){
	       $('#messageCheckName').html("");
	       var username =  $(this).val().trim();
	     if(username != "" && ($('#id').val() == '')){
		       $.ajax({
		           type: "GET",
		           url: contextPath+"/user/checkUsername?username="+username,
		           success: function(check){
		              if(check == true ){
			           	  $('#messageCheckName').html("Tên đã tồn tại , vui lòng chọn tên khác");
			           	   $('#btnSubmit').attr("disabled", true);
		              }
		           },
		       });
		     }
	     });
	 });