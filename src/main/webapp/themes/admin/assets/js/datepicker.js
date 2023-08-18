var DatePickerComponent = function() {
    var _componentLoaded = function() {
        if (!$().daterangepicker) {
            console.log('warning - bootbox.min.js is not loaded');
            return;
        }
        $('.daterange-single').daterangepicker({
            singleDatePicker: true,
            locale: {
                format: 'DD-MM-YYYY'
            }
        });
    };

    return {
        init: function() {
            _componentLoaded();
        }
    }
}();

document.addEventListener('DOMContentLoaded', function() {
    DatePickerComponent.init();
});