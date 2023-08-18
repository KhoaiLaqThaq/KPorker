var MaterialList = function() {
	var exportFile = function() {
		$('#exportFile').on('click',function(e){
			window.location.href = getContext() + "/materialSupport/export";
		});
	};
	
	var fileInput = function() {
		$('.file-input').fileinput({
	         browseLabel: 'Browse',
	         browseIcon: '<i class="icon-file-plus mr-2"></i>',
	         uploadIcon: '<i class="icon-file-upload2 mr-2"></i>',
	         removeIcon: '<i class="icon-cross2 font-size-base mr-2"></i>',
	     });
	};
	
	return {
		init: function() {
			exportFile();
			fileInput();
		}
	}
}();

document.addEventListener('DOMContentLoaded', function() {
	MaterialList.init();
});
