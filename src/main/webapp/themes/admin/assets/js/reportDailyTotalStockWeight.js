'use strict';
var ReportDailyTotalStockWeight = function() {
    var contextPath = getContext();
    
    var _resetDataTable = function() {
        $('#thTable').html('');
        $('#tbodyTable').html('');
        // $('#table__responsive').addClass('d-none').remove('d-block');
    }

    var getDaysInMonth = function(month, year) {
       return new Date(year, month, 0).getDate();
    };

    var _genereteDataTableHeader = function(daysInMonth) {
        var template = "";
        template += `<th>TT</th>
                     <th>Mã vật tư</th>
                     <th style="min-width: 200px;">Mô tả</th>
                     <th>ĐVT</th>`;
        for (var i = 1; i <= daysInMonth; i++) {
            template += `<th>${i}</th>`;
        }
        template += `<th class="text-danger">Tổng tháng</th>`;
        $("#thTable").append(template);
    }

    var _generateDataTableBody = function(materials, daysInMonth) {
        var template = "";
        for (var i = 0; i < materials.length; i++) {
            if (materials[i]) {
                template += '<tr>';
                template += '<td>'+ (i + 1) +'</td>';
                template += '<td>'+ materials[i].code +'</td>';
                template += '<td>'+ materials[i].name +'</td>';
                template += '<td>'+ materials[i].unit + '</td>';
                
                var actuallyExporteds = Object.keys(materials[i].actuallyExporteds) 
                                    ? Object.keys(materials[i].actuallyExporteds) : null;
                var summaryMonth = 0;
                for (var j = 1; j <= daysInMonth; j++) {
                    if (actuallyExporteds.includes(j.toString())) {
                        template += '<td class="number">'+ materials[i].actuallyExporteds[j] +'</td>';
                        summaryMonth += parseFloat(materials[i].actuallyExporteds[j]);
                    } else {
                        template += "<td>-</td>";
                    }
                }
                var summaryFinal = summaryMonth > 0 ? summaryMonth : '-';
                template += '<td class="number font-weight-bold">' + summaryFinal + '</td></tr>';
            }
        }
        $("#tbodyTable").append(template);
    }

    var _loadingDataTable = function() {
        $('#btnSearch').on('click', function(e) {
            e.preventDefault();
            var stockCode = $('#stockSelect').val();
            var periodMonth = $('#prTypeSelect').val();
            var periodYear = $('#year').val();
            if (stockCode && periodMonth && periodYear) {
                _resetDataTable();
                var dataObj = {"stockCode": stockCode, "period": periodMonth + '-' + periodYear};
                $.ajax({
                    url: contextPath + '/report/dailyTotalStockWeight',
                    contextType: 'application/json',
                    method: 'POST',
                    data: dataObj,
                    success: function(data) {
                        if (data) {
                            
                            var daysInMonth = getDaysInMonth(parseInt(periodMonth) - 1, periodYear)
                            _genereteDataTableHeader(daysInMonth);
                            _generateDataTableBody(data, daysInMonth);
                            formatNumberComponent.initAutoNumeric();
                            // console.log('data: ', data);
                        } else _resetDataTable();
                    },
                    error: function(err) { console.log('loi: ', err); }
                });
            } else {
                // reset datatable
                _resetDataTable();
            }   
        });
    }

    return {
        init: function() {
            _loadingDataTable();
        }
    }
}();

document.addEventListener('DOMContentLoaded', function() {
    ReportDailyTotalStockWeight.init();
});