var Component = function() {
	
	var intForm = function(){
		
		$("#closePeriod").on("click", function(){
			bootbox.confirm({
				title: "Xác nhận:",
			    message: "Bước tiếp theo sẽ đóng kì tháng trước. Sau khi đóng kì sẽ không thể thực hiện thực hiện nhập kho, xuất kho các tháng trước đó. Bạn có muốn tiếp tục?",
			    buttons: {
			        confirm: {
			            label: 'Xác nhận',
			            className: 'btn-success'
			        },
			        cancel: {
			            label: 'Từ chối',
			            className: 'btn-danger'
			        }
			    },
			    callback: function (result) {
			    	if(result){
						window.location.href = getContext() + '/periodClose';
			    	}
			    }
			});
		});
		
		$(".deleteException").on("click", function(e){
			var id = this.id.substring(7);
			bootbox.confirm({
				title: "Xác nhận:",
			    message: "Bạn có muốn xóa ngoại lệ của trại?",
			    buttons: {
			        confirm: {
			            label: 'Xác nhận',
			            className: 'btn-success'
			        },
			        cancel: {
			            label: 'Từ chối',
			            className: 'btn-danger'
			        }
			    },
			    callback: function (result) {
			    	if(result){
						let funcType = $("#funcType").val();
						window.location.href = getContext() + '/periodClose/delete?id='+id+'&funcType='+funcType
			    	}
			    }
			});
		})
	}
	
    return {
        init: function() {
        	intForm();
        }
    }
}();

document.addEventListener('DOMContentLoaded', function() {
	Component.init();
});