'use strict';

var ReportDayDetailComponent = function() {

    var _checkStockCodeValue = function() {
        var stockCode = $('#stockSelect').val();
        if (stockCode || stockCode != '') 
            return stockCode;
        bootbox.alert({
            title: 'Thông báo',
            message: 'Vui lòng chọn trại.'
        });
        return '';
    }

    /*
    *  Export report dead rate
    */
    var _handleExportReportDeadRate = function() {
        $('#exportReportDeadRate').on('click', function(e) {
            e.preventDefault();
            var stockCode = _checkStockCodeValue();
            if (stockCode == '') return false;
            var stage = $('#stage').val()
            var apiExport = '/report/deadRate-export-excel?stockCode=' + stockCode + '&stage=' + stage;
            location.href = apiExport;
        });
    }

    var _handleSubmit = function() {
        $('#btnSubmit').on('click', function(e) {
            e.preventDefault();
            var stockCode = _checkStockCodeValue();
            if (stockCode == '') return false;e;
            $('#reportDeadRateForm').submit();
        })
    }

    return {
        init: function() {
            _handleExportReportDeadRate();
            _handleSubmit();
        }
    }
}();

document.addEventListener('DOMContentLoaded', function() {
    ReportDayDetailComponent.init();
});
