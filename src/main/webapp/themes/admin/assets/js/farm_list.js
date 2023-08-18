var Component = function() {
	
	var _handleExportFarm = function() {
		$('#exportFarm').on('click', function(e) {
            
            e.preventDefault();
            var apiExport = '/farm/export';
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