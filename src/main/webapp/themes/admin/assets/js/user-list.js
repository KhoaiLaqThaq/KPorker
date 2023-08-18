var contextPath = getContext();

function update(userId){
	$('#pleaseWaitDialog').modal('show');
	var id = userId;
	var pass = '#password_'+ id; 
	var password = $(pass).val();
	var data = {
        "id" : id,
        "password" : password
    };
    $('#changePass_'+id).modal('hide');
	$.ajax({
	   url: getContext() + "/user/set-password",
	   method: "POST",
	   data: data,
	   success: function(data){
	   	$('#pleaseWaitDialog').modal('hide');
	   	$('#password_'+id).val('');
	   	$('#message_content').attr('class','alert bg-success text-white alert-styled-left alert-dismissible');
		$('#message_success').html('Reset mật khẩu thành công');
    	},
	   error : function(e) {
			alert("false");
		}
   });
};

function resetPassword(userId) {
	console.log('userid', userId);
	bootbox.confirm({
		message: "Hành vi này sẽ gửi mail thông báo cho chủ tài khoản. Đồng ý thực hiện?",
		buttons: {
			confirm: {
				label: 'Đồng ý',
				className: 'btn-success'
			},
			cancel: {
				label: 'Hủy',
				className: 'btn-danger'
			}
		},
		callback: function(result) {
			if (result) {
				window.location.href = contextPath  + "/user/resetpw/" + userId;
			}
		}
	})
}
