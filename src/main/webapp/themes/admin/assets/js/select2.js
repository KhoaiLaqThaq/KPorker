var Select2Component = function() {
    var _componentSelect2 = function() {
        if(!$().select2) {
            console.warn('Warning - select2.js is not loaded');
            return;
        }
        $('.select2').select2();
        
        // Default initialization
        $('.select').select2({
            minimumResultsForSearch: Infinity
        });
    }

    return {
        init: function() {
            _componentSelect2();
        }
    }
}();

document.addEventListener('DOMContentLoaded', function(){
    Select2Component.init();
});