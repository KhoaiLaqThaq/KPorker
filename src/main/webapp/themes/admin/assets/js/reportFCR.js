'use strict';

var ReportDayDetailComponent = function() {
    var contextPath = getContext();

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

    var _checkPOCodeValue = function() {
        var poCode = $('#poSelect').val();
        if (poCode || poCode != '') 
            return poCode;
        bootbox.alert({
            title: 'Thông báo',
            message: 'Vui lòng chọn lệnh.'
        });
        return '';
    }

    var _resetSelectBeforeChangeFarm = () => $('#poSelect').html('');

    var _generateProcessOrderCodeTempl = function(data, poCode) {
        var template = '';
        for (let i = 0; i < data.length; i++) {
            const element = data[i];
            template += '<option value='+ element.code +' '+ (poCode === element.code ? 'selected' : ' ') +'>' + element.code + '</option>';
        }
        $('#poSelect').html(template);
    }

    var _callApiToGetProcessOrders = function(farmCode, poCode) {
        _resetSelectBeforeChangeFarm();
        let apiURL = contextPath + '/report/processOrderForReport/farm?farmCode=' + farmCode;
        $.ajax({
            url: apiURL,
            method: 'GET',
            contentType: 'application/json',
            success: function(data) {
                if (data) {
                    _generateProcessOrderCodeTempl(data, poCode);
                }
            }, error: function(err) {
                console.error(err.toString());
            }
        })
    }

    var _loadedComponent = function() {
        var farmCode = $('#stockSelect').val();
        if (farmCode && farmCode != '') {
            var poCode = $('#poCodeHidden').val();
            if (poCode && poCode != '') {
                _callApiToGetProcessOrders(farmCode, poCode);
            }
        }
    }

    var _findAllProcessOrderWithStockCode = function() {
        $('#stockSelect').on('change', function(e) {
            var stockCode = _checkStockCodeValue();
            _callApiToGetProcessOrders(stockCode)

        });
    }

    var _handleSubmit = function() {
        $('#btnSubmit').on('click', function(e) {
            e.preventDefault();
            var stockCode = _checkStockCodeValue();
            if (stockCode == '') return false;
            $('#reportFCRForm').submit();
        })
    }

    /*
    *  Export report FCR
    */
    var _handleExportReportFCR = function() {
        $('#exportReportFCR').on('click', function(e) {
            e.preventDefault();
            var stockCode = _checkStockCodeValue();
            if (stockCode == '') return false;
            var stage = $('#stage').val()
            var poCode = _checkPOCodeValue();
            if (poCode == '') return false;
            var apiExport = '/report/fcr-export-excel?stockCode=' + stockCode + '&poCode=' + poCode + '&stage=' + stage;
            location.href = apiExport;
        });
    }

    return {
        init: function() {
            _handleSubmit();
            _handleExportReportFCR();
            _findAllProcessOrderWithStockCode();
            _loadedComponent();
        }
    }
}();

document.addEventListener('DOMContentLoaded', function() {
    ReportDayDetailComponent.init();
});
