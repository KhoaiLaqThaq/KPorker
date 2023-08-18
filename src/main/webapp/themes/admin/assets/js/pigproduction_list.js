var Component = function() {
	
	var _handleExportFarm = function() {
		$('#exportReport').on('click', function(e) {
			let poCode = $("#processOrderCode").val();
            
            e.preventDefault();
            var apiExport = '/pigProduction/export?poCode='+poCode;
            location.href = apiExport;
        });
	}
	
    return {
        init: function() {
        	_handleExportFarm();
        }
    }
}();

// Initialize module
// ------------------------------

document.addEventListener('DOMContentLoaded', function() {
	Component.init();
});