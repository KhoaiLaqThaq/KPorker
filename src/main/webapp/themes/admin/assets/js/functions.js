(function($) {
    "use strict";

    $.fn.pineput = function() {
        var $this = $(this);
        for (var i = 0; i < $this.length; i++) {
            var $input_fields = $($this[i]).find('.form-item__inner input:not([type="submit"])');
            $input_fields.on('focus', function(e) {
                var $field = $(this).closest('.form-item__inner');
                $field.addClass('focus');
            }).on('blur', function(e) {
                var $this = $(this);
                var $field = $this.closest('.form-item__inner');
                $field.removeClass('focus');

                var val = $this.val().trim();
                if (val !== '') {
                    $field.removeClass('error');
                } else {
                    $field.addClass('error');
                }
            }).on('change', function(e) {
                var $this = $(this);
                var $field = $this.closest('.form-item__inner');
                var val = $this.val().trim();

                if (val !== '') {
                    $field.removeClass('error');
                } else {
                    $field.addClass('error');
                }
            });
        }
    }

    $(window).on('load', function() {
        $('.content').pineput();
    })
})(jQuery);