'use strict';

var ReportStockDayComponent = function() {
    var contextPath = getContext();

    var _showModalProcessing = () => $('#modalLoading').addClass('d-block').removeClass('d-none');
    var _hideModalProcessing = () => $('#modalLoading').addClass('d-none').removeClass('d-block');

    var _resetDataTable = function() {
        $('#thTable').html('');
        $('#thTypeTable').html('');
        $('#tbodyTable').html('');
    }

    var getDaysInMonth = function(month, year) {
        return new Date(year, month, 0).getDate();
    };

    var _generateDataTableHeader = function(daysInMonth, month, year) {
        var template = "";
        template += "<th rowspan='2'>STT</th>";
        template += "<th rowspan='2' class='mw-200'>Trại</th>";
        template += "<th rowspan='2' class='mw-200'>Chuồng</th>";
        template += "<th rowspan='2' class='mw-160'>Ngày nhập</th>";
        template += "<th rowspan='2' class='mw-200'>Nguồn gốc</th>";
        template += "<th rowspan='2'>SL nhập</th>";
        template += "<th rowspan='2'>Loại heo</th>";
        template += "<th rowspan='2'>TL Nhập</th>";

        template += "<th rowspan='2'>TB Nhập</th>";
        template += "<th rowspan='2' class='mw-100'>Tuần tuổi lúc nhập (wks)</th>";
        template += "<th rowspan='2'>Tồn đầu kỳ</th>";
        for (var i = 1; i <= daysInMonth; i++) {
            template += `<th colspan="3" class="text-center">${i}/${parseInt(month)}/${year}</th>`;
        }
        template += "<th rowspan='2'>Nhập tháng</th>";
        template += "<th rowspan='2'>Chết tháng</th>";
        template += "<th rowspan='2'>Bán tháng</th>";
        template += "<th rowspan='2' class='mw-100'>Chênh lệch đầu heo</th>";
        template += "<th rowspan='2'>% Chết</th>";
        template += "<th rowspan='2' class='mw-100'>Đầu heo tồn cuối kỳ</th>";
        $("#thTable").append(template);
    }

    var _generateContentDetailTableHeader = function(daysInMonth) {
        var template = "";
        for (let i = 0; i < daysInMonth; i++) {
            template += `<th>Nhập</th>
                        <th>Chết</th>
                        <th>Bán</th>`;
        }
        $("#thTypeTable").append(template);
    }

    var _generateDataTableBody = function(data, daysInMonth) {
        var template = "";
        for (let j = 0; j < data.barnReports.length; j++) {
            var barnReport = data.barnReports[j];
            var totalPig = barnReport.totalPig; // so luong heo nhap
            var amountEarlyStage = barnReport.amountEarlyStage;
            template += "<tr>";
            template += `<td>${j + 1}</td>`;
            template += `<td rowspan="${barnReport.length}">${data.farmName}</td>`;
            template += `<td>${barnReport.barnName}</td>`;
            template += `<td>${barnReport.startDate}</td>`;
            template += `<td>${barnReport.receiveFarm}</td>`;
            template += `<td>${totalPig}</td>`;
            template += `<td>${barnReport.pigType ? barnReport.pigType : ''}</td>`;
            template += `<td>${barnReport.totalEntryVolumn}</td>`;
            template += `<td>${barnReport.averageVolumn}</td>`;
            template += `<td>${barnReport.ageWeek}</td>`;
            template += `<td>${amountEarlyStage}</td>`; // ton dau ky
            var sumPigReleaseInMonth = 0;
            var sumPigDeadInMonth = 0;
            var sumPigSaleInMonth = 0;
            for (let k = 0; k < daysInMonth; k++) {
                sumPigReleaseInMonth += barnReport.contents[k].pigRelease;
                sumPigDeadInMonth += barnReport.contents[k].pigDead;
                template += `<td>${barnReport.contents[k].pigRelease}</td>`;
                template += `<td>${barnReport.contents[k].pigDead}</td>`;
                template += `<td>${sumPigSaleInMonth}</td>`;    // chưa biết lấy heo bán
            }
            template += `<td>${sumPigReleaseInMonth}</td>`;
            template += `<td>${sumPigDeadInMonth}</td>`;
            template += `<td>${sumPigSaleInMonth}</td>`;
            // ton cuoi ky
            var amountFinalStage = barnReport.amountEarlyStage + sumPigReleaseInMonth - sumPigDeadInMonth - sumPigSaleInMonth;
            var percentPigDead = (sumPigDeadInMonth*100/amountEarlyStage).toFixed(3);
            template += `<td>${totalPig - amountFinalStage}</td>`;
            template += `<td>${percentPigDead}</td>`;
            template += `<td>${amountFinalStage}</td>`;
        }
        $("#tbodyTable").append(template);
    }

    var _loadingDataTable = function() {
        $('#btnSearch').on('click', function(e) {
            _showModalProcessing();
            e.preventDefault();
            var stockCode = $('#stockSelect').val();
            var periodMonth = parseInt($('#prTypeSelect').val()) + 1;
            var periodYear = $('#year').val();

            if (stockCode && periodYear && periodYear) {
                _resetDataTable();
                var today = new Date().getDate();
                console.log('today', today);
                var monthStr = periodMonth;
                if (periodMonth <= 9) {
                    monthStr = '0' + monthStr;
                }
                var tempPeriod = today + '-' + monthStr + '-' + periodYear; // dd-MM-yyyy
                var pathUrl = contextPath + '/report/stockDay/' + stockCode + '/' + tempPeriod;
                // ajax
                $.ajax({
                    url: pathUrl,
                    contentType: 'application/json',
                    method: 'POST',
                    success: function (data) {
                        _hideModalProcessing();
                        if (data) {
                            var daysInMonth = getDaysInMonth(parseInt(periodMonth), periodYear);
                            _generateDataTableHeader(daysInMonth, periodMonth, periodYear);
                            _generateContentDetailTableHeader(daysInMonth);
                            // generate data
                            _generateDataTableBody(data, daysInMonth);
                        } 
                    },
                    error: function(err) {  
                        _hideModalProcessing()
                        console.log(err); 
                    }
                });
            } else {
                _resetDataTable();
                _hideModalProcessing();
            }
        })
    }

    return {
        init: function() {
            _loadingDataTable();
        }
    }
}();

document.addEventListener('DOMContentLoaded', function() {
    ReportStockDayComponent.init();
})