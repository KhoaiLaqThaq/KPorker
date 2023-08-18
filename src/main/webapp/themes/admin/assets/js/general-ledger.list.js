const SymbolEnum = {
    SPACE: " ",
    COMMA: ",",
    NONE: ""
};

const GeneralLedgerComponent = function(){

    const initComponent = function() {
        formatNumberComponent.initAutoNumeric();

        // searchFromDateStr
        let searchFromDate = $("input[name='searchFromDateStr']");
        searchFromDate.on('apply.daterangepicker', function(ev, picker) {
            $(this).val(picker.startDate.format('DD-MM-YYYY'));
        });
        searchFromDate.on('cancel.daterangepicker', function(ev, picker) {
            $(this).val('');
        });
        searchFromDate.daterangepicker({
            singleDatePicker: true,
            autoUpdateInput: false,
            locale: {
                cancelLabel: 'Clear',
                format: 'DD-MM-YYYY'
            }
        });

        // searchToDateStr
        let searchToDate = $("input[name='searchToDateStr']");
        searchToDate.on('apply.daterangepicker', function(ev, picker) {
            $(this).val(picker.startDate.format('DD-MM-YYYY'));
        });
        searchToDate.on('cancel.daterangepicker', function(ev, picker) {
            $(this).val('');
        });
        searchToDate.daterangepicker({
            singleDatePicker: true,
            autoUpdateInput: false,
            locale: {
                cancelLabel: 'Clear',
                format: 'DD-MM-YYYY'
            }
        });
    }

    let checkAllToSync = false;
    let transCodeLst = "";

    const _setChecked = function(selectors, checked) {
        for (let i = 0; i < selectors.length; i++) {
            let selector = selectors[i];
            selector.checked = checked;
        }
    }
    const _eventCheckAllGLtoSync = function() {
        $('#checkAll').on('change', function(e) {
            let checkAll = this.checked;
            checkAllToSync = checkAll;
            let dataToSync = $('.non--checked');
            transCodeLst = "";
            if (checkAll) {
                _setChecked(dataToSync, true);
                for (let i = 0; i < dataToSync.length; i++) {
                    let selector = dataToSync[i];
                    if (i === (dataToSync.length - 1)) transCodeLst += selector.id;
                    else transCodeLst += selector.id + SymbolEnum.COMMA;
                }
                console.log('transCodeLst: ', transCodeLst);
            } else {
                _setChecked(dataToSync, false);
            }
        });
    }

    const _eventChangeSubCheckBox = function() {
        $('.non--checked').on('change', function(e) {
            let selectorCheck = this.checked;
            let selectorId = this.id;
            if (selectorCheck) {
                transCodeLst += `${transCodeLst.length === 0 ? '': SymbolEnum.COMMA}${selectorId}`;
            } else {
                let stringToReplace = '';
                if (transCodeLst.endsWith(selectorId)) {
                    if (transCodeLst.includes(SymbolEnum.COMMA)) stringToReplace = SymbolEnum.COMMA + selectorId;
                    else stringToReplace = selectorId;
                }
                else stringToReplace = selectorId + SymbolEnum.COMMA
                transCodeLst =  transCodeLst.replace(stringToReplace, SymbolEnum.NONE)
            }
        });
    }

    const _eventClickToSync = function() {
        $('#btn__sync').on('click', function() {
            if (transCodeLst.length > 0) {
                showLoading();
                let data = {
                    checkAll: checkAllToSync,
                    transCodeToSync: transCodeLst
                };
                $.ajax({
                    url: `${getContext()}/api/sync-general-ledger`,
                    method: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify(data),
                    success: function(response) {
                        if (response) {
                            if (response.code === '200') {
                                bootbox.alert({
                                    title: "Thông báo",
                                    message: "Đồng bộ thành công!"
                                });
                                location.reload();
                            } else {
                                bootbox.alert({
                                    title: "Thông báo lỗi!",
                                    message: `Xảy ra lỗi khi đồng bộ. Chi tiết ${response.code} - ${response.message}`
                                });
                            }
                        }
                    }, error: function(err) {
                        console.log(err)
                    }
                }).always(() => hideLoading())
            } else {
                bootbox.alert({
                    title: "Thông báo",
                    message: "Tối thiểu cần chọn 1 hóa đơn để đồng bộ"
                });
            }
        });
    }

    const _eventToExportExcel = function() {
        $('#btn__export').on('click', function(e) {
            console.log("entering: 'event-to-export-excel' method...");
            e.preventDefault();
            let farmCode =  $('#farmCode').val();
            let docNum = $('input[name="docNum"]').val();
            let status = $('#status').val();
            let fromDate = $('input[name="searchFromDateStr"]').val();
            let toDate = $('input[name="searchToDateStr"]').val();

            showLoading();
            location.href = `/general-ledger/export?farmCode=${farmCode}&docNum=${docNum}&status=${status}&fromDate=${fromDate}&toDate=${toDate}`;
            hideLoading();
        });
    }

    const _resetForm = function() {
        $('#btn__reset').click(function() {
            location.href = "/general-ledger/list"
        })
    }

    const showLoading = () => $('#modalLoading').addClass('d-block').removeClass('d-none');
    const hideLoading = () => $('#modalLoading').addClass('d-none').removeClass('d-block');

    return {
        init: function() {
            initComponent();
            _eventClickToSync();
            _eventToExportExcel();
            _resetForm();
            // events to sync
            _eventCheckAllGLtoSync();
            _eventChangeSubCheckBox();
        }
    }
}();

document.addEventListener("DOMContentLoaded", function() {
    GeneralLedgerComponent.init();
})