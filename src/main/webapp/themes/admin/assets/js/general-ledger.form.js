const SymbolEnum = {
    SPACE: " "
};

const BOOTBOX_TITLE = {
    TITLE: "Thông báo"
};

const MESSAGE = {
    FARM_REQUIRED: "Bắt buộc chọn mã trại.",
    DOC_NUM_REQUIRED: "Bắt buộc phải nhập số hoá đơn.",
    DOC_CODE_REQUIRED: "Bắt buộc phải nhập loại hoá đơn.",
    POSTING_DATE_REQUIRED: "Bắt buộc phải chọn ngày hoá đơn.",
    OBJECT_REQUIRED: "Bắt buộc phải chọn đối tượng CN.",
    DOC_DATE_REQUIRED: "Bắt buộc phải chọn ngày hạch toán.",
    AMOUNT_REQUIRED: "Bắt buộc phải nhập số tiền.",
    DESC_REQUIRED: "Bắt buộc phải nhập diễn giải."
};

const GeneralLedgerComponent = function(){

    const initComponent = function() {
        formatNumberComponent.initAutoNumeric();

        // postingDate
        let postingDate = $("input[name='postingDateStr']");
        postingDate.on('apply.daterangepicker', function(ev, picker) {
            $(this).val(picker.startDate.format('DD-MM-YYYY'));
        });
        postingDate.on('cancel.daterangepicker', function(ev, picker) {
            $(this).val('');
        });
        postingDate.daterangepicker({
            singleDatePicker: true,
            autoUpdateInput: false,
            locale: {
                cancelLabel: 'Clear',
                format: 'DD-MM-YYYY'
            }
        });

        // docDate
        let docDate = $("input[name='docDateStr']");
        docDate.on('apply.daterangepicker', function(ev, picker) {
            $(this).val(picker.startDate.format('DD-MM-YYYY'));
        });
        docDate.on('cancel.daterangepicker', function(ev, picker) {
            $(this).val('');
        });
        docDate.daterangepicker({
            singleDatePicker: true,
            autoUpdateInput: false,
            locale: {
                cancelLabel: 'Clear',
                format: 'DD-MM-YYYY'
            }
        });

        _eventSetWidthDescElement();
        _setFocusInput();
    }

    const _eventSetWidthDescElement = function() {
        let labelAddress = $('#label__address');
        if (labelAddress) {
            let widthLabelAddress = labelAddress.width();
            console.log('widthLabelAddress', widthLabelAddress);
            if (widthLabelAddress > 0) {
                $('#label__desc__input').width(widthLabelAddress + 20).addClass('px-10p');
                let descInput = $('#desc__input');
                let parentInput = descInput.parent();
                descInput.width(parentInput.width() - widthLabelAddress - 20).addClass('px-10p');
            }
        }
    }

    const _setFocusInput = function() {
        var $input_fields = $("form").find('.form-item__inner input:not([type="submit"]), .form-item__inner  textarea, .form-item__inner select');
        $input_fields.on('focus', function(e){
            var $field = $(this).closest('.form-item__inner');
            $field.addClass('focus');
        }).on('blur', function(e){
            var $this = $(this);
            var $field = $this.closest('.form-item__inner');
            $field.removeClass('focus');

            var val = $this.val().trim();

            if (val === '') {
                $field.removeClass('active');
            } else {
                $field.addClass('active');
            }
        }).on('change', function(e){
            var $this = $(this);
            var $field = $this.closest('.form-item__inner');
            var val = $this.val().trim();

            if (val === '') {
                $field.removeClass('active');
            } else {
                $field.addClass('active');
            }
        });

        for (var j = 0; j < $input_fields.length; j++) {
            var $input_field = $($input_fields[j]);

            var $field = $input_field.closest('.form-item__inner');
            var val = $input_field.val().trim();

            if (val === '') {
                $field.removeClass('active');
            } else {
                $field.addClass('active');
            }
        }

        $('form').find('label').on('click', function(){
            $(this).closest('.form-item__inner').find('input, select').trigger('focus');
        });
    }

    const setFormValue = function(vendorSelected) {
        if (vendorSelected?.taxNumber?.length > 0 ) {
            $('#vendorName').val(vendorSelected.name);
            $('#taxNumber').val(vendorSelected.taxNumber);
            let street = vendorSelected.street;
            let district = vendorSelected.district;
            let city = vendorSelected.city;
            $('#address').val(street + SymbolEnum.SPACE + district + SymbolEnum.SPACE + city);
        } else {
            $('#vendorName').val('');
            $('#taxNumber').val('');
            $('#address').val('');
        }
    }

    const eventChooseNCC = function() {
        $('#vendorCode').on("change", function(e) {
            let vendorSelected = this.value;
            showLoading();
            $.ajax({
                url: `${getContext()}/api/getVendorByCode/${vendorSelected}`,
                method: 'GET',
                contentType: 'application/json',
                success: function(response) {
                    if (response) {
                        setFormValue(response);
                    }
                }, error: function(error) {
                    console.log(error);
                }
            }).always(() => hideLoading());
        });
    }

    const _validateRequired = function(field, message) {
        if (field && field.val().length > 0)
            return field.val();

        field.focus();
        bootbox.alert({
            title: BOOTBOX_TITLE.TITLE,
            message: message
        });
        return "";
    }

    const _validateForm = function() {
        let farmCode = _validateRequired($('#farmCode'), MESSAGE.FARM_REQUIRED);
        if (farmCode === '') return false;
        let objectName = _validateRequired($('#vendorCode'), MESSAGE.OBJECT_REQUIRED);
        if (objectName === '') return false;
        let docNum = _validateRequired($('#docNum'), MESSAGE.DOC_NUM_REQUIRED);
        if (docNum=== '') return false;
        let docCode = _validateRequired($('#docCode'), MESSAGE.DOC_CODE_REQUIRED);
        if (docCode === '') return false;
        let postingDate = _validateRequired($('#postingDate'), MESSAGE.POSTING_DATE_REQUIRED);
        if (postingDate === '') return false;
        let docDate = _validateRequired($('#docDate'), MESSAGE.DOC_DATE_REQUIRED);
        if (docDate === '') return false;
        let amount = _validateRequired($('#amount'), MESSAGE.AMOUNT_REQUIRED);
        if (amount === '') return false;
        let desc = _validateRequired($('#desc'), MESSAGE.DESC_REQUIRED);
        if (desc === '') return false;

        return true;
    }

    const _onSubmit = function() {
        let formSelector = $('#generalLedgerForm');
        // lưu tạm
        $('#btn-submit__temporary').on('click', function(e) {
            let isValid = _validateForm();
            if (isValid) {
                e.preventDefault();
                formatNumberComponent.disableAutoNumeric();
                formSelector.submit();
            }
        });

        // lưu và đồng bộ ERP
        $('#btn-submit__sync').on('click', function(e) {
            let isValid = _validateForm();
            if (isValid) {
                e.preventDefault();
                formatNumberComponent.disableAutoNumeric();
                formSelector.attr('action', '/general-ledger/saveAndSync');
                formSelector.submit();
            }
        });
    }

    const _eventCancelGL = function() {
        $("#btn-submit__cancel").on('click', function() {
           let glID = $('#generalLedgerId').val();
           if (glID && glID.trim().length > 0) {
               showLoading();
               $.ajax({
                   url: `${getContext()}/api/general-ledger/cancel/${glID}`,
                   method: 'POST',
                   contentType: 'application/json',
                   success: function(response) {
                       if (response) {
                           if (response.code === '200') {
                                bootbox.alert({
                                    title: "Thông báo",
                                    message: "Huỷ hoá đơn thành công!"
                                });
                                location.href = "/general-ledger/list";
                           } else {
                                bootbox.alert({
                                    title: "Error!",
                                    message: response.message
                                });
                           }
                       }
                   }, error: function(error) {
                       console.log('error', error);
                   }
               }).always(() => hideLoading());
           }
        });
    }

    const showLoading = () => $('#modalLoading').addClass('d-block').removeClass('d-none');
    const hideLoading = () => $('#modalLoading').addClass('d-none').removeClass('d-block');

    return {
        init: function() {
            initComponent();
            eventChooseNCC();
            _eventCancelGL();
            _onSubmit();
        },
        resize: function() {
            _eventSetWidthDescElement();
        },
    }
}();

document.addEventListener("DOMContentLoaded", function() {
    GeneralLedgerComponent.init();
});

document.addEventListener('resize', function() {
    GeneralLedgerComponent.resize();
});

