'use strict';

const THEAD_REPORT_PR_OTHER_ENUM = {
    NO: "STT",
    CODE: "Mã vật tư",
    NAME: "Tên vật tư/ thông số kĩ thuật",
    UNIT: "ĐVT",
    AMOUNT_GOODS_RECEIPT_IN_THREE_MONTH: "Số lượng lĩnh dùng 3 tháng",
    FINAL_INSTOCK_LAST_MONTH: "Tồn cuối kỳ tháng ",
    AMOUNT_PR: "Số lượng mua tháng ",
    NOTE: "Mục đích sử dụng"
};

const MESSAGE_VALIDATE_ENUM = {
    FARM_REQUIRED: 'Vui lòng chọn trại.',
    MONTH_REQUIRED: 'Vui lòng chọn tháng.',
    YEAR_REQUIRED: 'Vui lòng nhập năm.'
};

var ReportPurchaseRequisitionOtherComponent = function() {
    var contextPath = getContext();

    var _showModalProcessing = () => $('#modalLoading').addClass('d-block').removeClass('d-none');
    var _hideModalProcessing = () => $('#modalLoading').addClass('d-none').removeClass('d-block');

    let _initDidMount = function() {
        let currentYear = new Date().getFullYear();
        $("#year").val(currentYear);
    }
    
    var _resetDataTable = function() {
        $('#thTable').html('');
        $('#tbodyTable').html('');
    }

    var _generateTHeadRowOneTemplate = function() {
        var getMonthValueLastMonth = $('#month').val();
        var currentMonthValue = parseInt(getMonthValueLastMonth) + 1;
        var template = '';
        template += '<th class="bgc-primary border-primary text-white " rowspan="2">'+ THEAD_REPORT_PR_OTHER_ENUM.NO +'</th>';
        template += '<th class="bgc-primary border-primary text-white " rowspan="2">'+ THEAD_REPORT_PR_OTHER_ENUM.CODE +'</th>';
        template += '<th class="bgc-primary border-primary text-white " rowspan="2">'+ THEAD_REPORT_PR_OTHER_ENUM.NAME +'</th>';
        template += '<th class="bgc-primary border-primary text-white " rowspan="2">'+ THEAD_REPORT_PR_OTHER_ENUM.UNIT +'</th>';
        template += '<th colspan="3" class="bgc-primary border-primary text-white text-center">'+ THEAD_REPORT_PR_OTHER_ENUM.AMOUNT_GOODS_RECEIPT_IN_THREE_MONTH +'</th>';
        template += '<th class="bgc-primary border-primary text-white " rowspan="2">'+ THEAD_REPORT_PR_OTHER_ENUM.FINAL_INSTOCK_LAST_MONTH + getMonthValueLastMonth +'</th>';
        template += '<th class="bgc-primary border-primary text-white " rowspan="2">'+ THEAD_REPORT_PR_OTHER_ENUM.AMOUNT_PR + currentMonthValue +'</th>';
        template += '<th class="bgc-primary border-primary text-white " rowspan="2">'+ THEAD_REPORT_PR_OTHER_ENUM.NOTE +'</th>';
        $('#thTable').html(template);
    }
    
    var _generateTHeadRowTwoTemplate = function(subDataMonth) {
        var templateDetail = '';
        console.log("subDataMonth", subDataMonth);
        templateDetail += `<th>${subDataMonth.threeMonthAgo}</th><th>${subDataMonth.twoMonthAgo}</th><th>${subDataMonth.oneMonthAgo}</th>`;
        $('#thTableDetailInMonth').html(templateDetail);
    }

    var _generateTBodyTemplate = function(data) {
        console.log('generating tbody template');
        var template = '';
        for (let i = 0; i < data.length; i++) {
            const element = data[i];
            var count = i + 1;
            template += '<tr>';
                template += '<td>'+ count + '</td>';
                template += '<td>'+ element.materialCode + '</td>';
                template += '<td>'+ element.materialName +'</td>';
                template += '<td class="text-center">'+ element.unit +'</td>';
                // three months ago
                template += '<td class="text-center">'+ element.subReportVTDC.sumThreeMonthAgo +'</td>';
                // two months ago
                template += '<td class="text-center">'+ element.subReportVTDC.sumTwoMonthAgo +'</td>';
                // on month ago
                template += '<td class="text-center">'+ element.subReportVTDC.sumOneMonthAgo +'</td>';
                template += '<td class="text-center">'+ element.amountFinalBeforeStage +'</td>';
                template += '<td class="text-center">'+ element.quantity +'</td>';
                template += '<td>'+ element.note +'</td>';
            template += '</tr>'
        }
        $('#tbodyTable').html(template);
    }

    var _checkStockCodeValue = function() {
        var stockCode = $('#stockCode').val();
        if (stockCode || stockCode != '')
            return stockCode;
        bootbox.alert({
            title: 'Thông báo',
            message: MESSAGE_VALIDATE_ENUM.FARM_REQUIRED
        });
        return '';
    }

    var _checkMonthValue = function() {
        var monthValue = $('#month').val();
        if (monthValue || monthValue != '')
            return monthValue;
        bootbox.alert({
            title: 'Thông báo',
            message: MESSAGE_VALIDATE_ENUM.MONTH_REQUIRED
        });
        return '';
    }

    var _checkYearValue = function() {
        var yearValue = $('#year').val();
        if (yearValue || yearValue != '')
            return yearValue;
        bootbox.alert({
            title: 'Thông báo',
            message: MESSAGE_VALIDATE_ENUM.YEAR_REQUIRED
        });
        return '';
    }

    var searchDataReport = function() {
        $('#btnSearch').on('click', function(e) {
            e.preventDefault();
            var stockCode = _checkStockCodeValue();
            if (stockCode == '') return false;
            var monthValue = _checkMonthValue();
            if (monthValue == '') return false;
            var yearValue = _checkYearValue();
            if (yearValue == '') return false;
            var stage = monthValue + "-" + yearValue;
            var criteria = {
                stockCode: stockCode,
                stage: stage
            };
            _showModalProcessing();
            $.ajax({
                url: contextPath + '/report/purchase-requisition-other',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(criteria),
                success: function(data) {
                    _hideModalProcessing();
                    if (data && data[0] != null && data[0].subReportVTDC != null) {
                        _generateTHeadRowOneTemplate();
                        _generateTHeadRowTwoTemplate(data[0].subReportVTDC);
                        _generateTBodyTemplate(data);
                    }
                },
                error: function(err) {
                    _hideModalProcessing();
                    console.log("ERROR: ", err);
                    bootbox.alert({
                        title: "Error",
                        message: 'Something wrong!'
                    });
                }
            });
        });
    }

    return {
        init: function() {
            _initDidMount();
            searchDataReport();
        }
    }
}();

document.addEventListener('DOMContentLoaded', function() {
    ReportPurchaseRequisitionOtherComponent.init();
});