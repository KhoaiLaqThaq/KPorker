'use strict';

var isGetTree = false;

const STRING_COUNT = {
	ZERO: '0',
	ONE: '1',
	TWO: '2',
	THREE: '3'
};

var UserComponent = function() {
	var contextPath = getContext();

	var _componentSelect2 = function() {
        if (!$().select2) {
            console.warn('Warning - select2.js is not loaded.');
            return;
        }
        $('.multiselect-select-all-filtering').multiselect({
	         includeSelectAllOption: true,
	         enableFiltering: true,
	         enableCaseInsensitiveFiltering: true
	     });
    	// select2
   	 	$('.select2').select2();
   	 	// Reacting to external value changes
        $('.select-access-multiple-value').select2();
	};
	
	var _componentDualListbox = function() {
        if (!$().bootstrapDualListbox) {
            console.warn('Warning - duallistbox.min.js is not loaded.');
            return;
        }
	}

	var _componentModalBootbox = function() {
		bootbox.alert({
			title: "Thông báo!",
			message: "Yêu cầu tạo tên đăng nhập cho người dùng trước khi phân quyền",
		}); 
	}

	// Basic example
	$('.listbox').bootstrapDualListbox();
	var _componentFancytree = function() {
		  if (!$().fancytree) {
	            console.warn('Warning - fancytree_all.min.js is not loaded.');
	            return;
	      }

		  const username = $("#username").val();
		  const apiUrl = getContext() + "/api/get-tree" + (username ?  ("/" + username) : "");
		  console.log("apiUrl get tree", apiUrl);

		 // Hierarchical select
		 $('.tree-checkbox-hierarchical').fancytree({
        	activeVisible: true,
        	autoScroll: true,
            checkbox: true,
            selectMode: 3,
            ajax: {
                type: "GET",
                contentType: "application/json"
            },
            source: {
            	 url: apiUrl
            },
            init: function(event, data) {
                var selNodes = data.tree.getSelectedNodes();
                var selKeys = $.map(selNodes, function(node) {
                	return node.key;
                });
                $("#selectedFarmCodes").val(selKeys);
                console.log("selKeys :" + $("#selectedFarmCodes").val());
				isGetTree = true;
			},            
            select: function(event, data) {             
            	var selNodes = data.tree.getSelectedNodes();
				var selKeys = $.map(selNodes, function(node) {
                	return node.key;
                });
                $("#selectedFarmCodes").val(selKeys);
            }, 
        });
	 };

	var _userAuthClicked = function() {
		$("#userAuth").on('click', function() {
			if ($("#appUserId").val())
				_componentFancytree();
			else {
				_componentModalBootbox();
				return false;
			}
		});
	};

	var _checkMessage = function(idMessage, classAdd, classRemove, message) {
		$('#' + idMessage).addClass(classAdd).removeClass(classRemove).html(message);
	};

	var _usernameChange = function() {
		$('#username').on('change', function(e) {
			var username = this.value;
			$.ajax({
				url: contextPath + '/api/user/' + username,
				contextType: 'application/json',
				method: 'GET',
				success: function(data) {
					if (data) {
						// Tồn tại người dùng
						_checkMessage('uMessage', 'text-danger', 'text-success', 'Đã tồn tại tên người dùng!');
					} else {
						// Người dùng phù hợp
						_checkMessage('uMessage', 'text-success', 'text-danger', 'Tên người dùng phù hợp!');
					}
				},
				error: function(error) {
					console.log('error:', error);
				}
			});
		});
	};

	var _emailChecking = function() {
		$('#email').keyup(function(e) {
			var emailValue = $(this).val();
			if (emailValue.length < STRING_COUNT.ONE) {
				_checkMessage('eMessage', '', ['text-danger', 'text-success'], '');
				return;
			} else {
				if (!emailValue.includes('@')) {
					_checkMessage('eMessage', 'text-danger', 'text-success', 'Định dạng email không đúng!');
					return;
				} else {
					var emailSplit = emailValue.split('@');
					console.log('emailSplit[1]', emailSplit[1]);
					if (emailSplit[1]){
						console.log('emailSplit[1]', emailSplit[1]);
						if (emailSplit[1].length < STRING_COUNT.THREE)
							_checkMessage('eMessage', 'text-danger', 'text-success', 'Định dạng email không đúng!');
						else {
							$.ajax({
								url: contextPath + '/api/user/checkEmail/' + emailValue,
								contextType: 'application/json',
								method: 'GET',
								success: function(data) {
									if (data) {
										// Tồn tại người dùng
										_checkMessage('eMessage', 'text-danger', 'text-success', 'Đã tồn tại email người dùng!');
									} else {
										// Người dùng phù hợp
										_checkMessage('eMessage', 'text-success', 'text-danger', 'Email người dùng phù hợp!');
									}
								},
								error: function(error) {
									console.log('error:', error);
								}
							});
						}
					} else {
						_checkMessage('eMessage', 'text-danger', 'text-success', 'Định dạng email không đúng!');
					}
				}
			}
		})
	}

    // Return objects assigned to module
    return {
        init: function() {
        	_componentSelect2 ();
        	_componentDualListbox();
			_userAuthClicked();
			_usernameChange();
			_emailChecking();
        }
    }
}();



var UserForm = {
	check: (path, Id) => {
		if (Id) {
			location.href = path + "?Id=" + Id;
		} else {
            bootbox.alert({
            	title: 'Thông báo:',
                message: 'Thông tin User chưa được tạo !'
            });
		}
	},
}

document.addEventListener('DOMContentLoaded', function() {
	UserComponent.init();
});
