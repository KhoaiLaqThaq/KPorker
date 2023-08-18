'use strict';

var GroupComponent = function() {

	var _onSubmit = function() {
		$('#groupSubmit').on('click', function(e) {
			e.preventDefault();
			$('#formSubmit').submit();
		})
	}

	return {
		init: function() {
			_onSubmit();
		}
	}
}();

document.addEventListener('DOMContentLoaded', function() {
	GroupComponent.init();
});