
var EchartPieDashboard = function () {
    var contextPath = getContext();

    let _showModalProcessing = () => $('#modalLoading').addClass('d-block').removeClass('d-none');
    let _hideModalProcessing = () => $('#modalLoading').addClass('d-none').removeClass('d-block');

    var _piesFarmInit = function () {
        if (typeof echarts == "undefined") {
            console.warn('Warning - echarts.js is not available');
            return;
        }
        var pie_farm_type_element = document.getElementById('pie_farm_type');
        var pie_farm_element = document.getElementById('pie_farm');
        var totalPigRetainedValue = parseInt($('#totalPigRetained').text());
        var totalPigCullingValue  = parseInt($('#totalPigCulling').text());
        var totalFarmsRentValue = parseInt($('#totalFarmsRent').text());
        var totalFarmsManufacturedValue = parseInt($('#totalFarmsManufactured').text());
        var totalPigRetained = totalPigRetainedValue > 0 ? totalPigRetainedValue : 0;
        var totalPigCulling = totalPigCullingValue > 0 ? totalPigCullingValue : 0;
        var totalFarmsRent = totalFarmsRentValue > 0 ? totalFarmsRentValue : 0;
        var totalFarmsManufactured = totalFarmsManufacturedValue > 0 ? totalFarmsManufacturedValue : 0;

        if (pie_farm_element && pie_farm_type_element) {
            // Initialize chart
            var pie_basic_element = echarts.init(pie_farm_element);
            var pie_basic_type_element = echarts.init(pie_farm_type_element);
            //
            // Chart config
            //

            // Options
            pie_basic_type_element.setOption({
                // Colors
                color: [
                    '#2ec7c9','#d87a80'
                ],
                // Global text styles
                textStyle: {
                    fontFamily: 'Roboto, Arial, Verdana, sans-serif',
                    fontSize: 13
                },
                // Add title
                title: {
                    text: 'Thống kê số lượng trại',
                    subtext: 'Tỉ lệ số lượng trại thuê và gia công',
                    left: 'center',
                    textStyle: {
                        fontSize: 17,
                        fontWeight: 500
                    },
                    subtextStyle: {
                        fontSize: 12
                    }
                },
                // Add tooltip
                tooltip: {
                    trigger: 'item',
                    backgroundColor: 'rgba(0,0,0,0.75)',
                    padding: [10, 15],
                    textStyle: {
                        fontSize: 13,
                        fontFamily: 'Roboto, sans-serif'
                    },
                    formatter: "{a} <br/>{b}: {c} ({d}%)"
                },
                // Add legend
                legend: {
                    orient: 'vertical',
                    top: 'center',
                    left: 0,
                    data: ['TỔNG SỐ TRẠI THUÊ', 'TỔNG SỐ TRẠI GIA CÔNG'],
                    itemHeight: 8,
                    itemWidth: 8
                },
                // Add series
                series: [{
                    name: 'Tỉ lệ trại',
                    type: 'pie',
                    radius: '70%',
                    center: ['50%', '57.5%'],
                    itemStyle: {
                        normal: {
                            borderWidth: 1,
                            borderColor: '#fff'
                        }
                    },
                    data: [
                        {value: totalFarmsRent, name: 'TỔNG SỐ TRẠI THUÊ'},
                        {value: totalFarmsManufactured, name: 'TỔNG SỐ TRẠI GIA CÔNG'},
                    ]
                }]
            })

            pie_basic_element.setOption({

                // Colors
                color: [
                    '#2ec7c9','#d87a80'
                ],

                // Global text styles
                textStyle: {
                    fontFamily: 'Roboto, Arial, Verdana, sans-serif',
                    fontSize: 13
                },

                // Add title
                title: {
                    text: 'Thống kê số lượng heo các trại quản lý',
                    subtext: 'Tỉ lệ tổng số heo, heo chết và heo thải loại',
                    left: 'center',
                    textStyle: {
                        fontSize: 17,
                        fontWeight: 500
                    },
                    subtextStyle: {
                        fontSize: 12
                    }
                },

                // Add tooltip
                tooltip: {
                    trigger: 'item',
                    backgroundColor: 'rgba(0,0,0,0.75)',
                    padding: [10, 15],
                    textStyle: {
                        fontSize: 13,
                        fontFamily: 'Roboto, sans-serif'
                    },
                    formatter: "{a} <br/>{b}: {c} ({d}%)"
                },

                // Add legend
                legend: {
                    orient: 'vertical',
                    top: 'center',
                    left: 0,
                    data: ['TỔNG SỐ HEO', 'HEO CHẾT, THẢI LOẠI'],
                    itemHeight: 8,
                    itemWidth: 8
                },

                // Add series
                series: [{
                    name: 'Tỉ lệ heo',
                    type: 'pie',
                    radius: '70%',
                    center: ['50%', '57.5%'],
                    itemStyle: {
                        normal: {
                            borderWidth: 1,
                            borderColor: '#fff'
                        }
                    },
                    data: [
                        {value: totalPigRetained, name: 'TỔNG SỐ HEO'},
                        {value: totalPigCulling, name: 'HEO CHẾT, THẢI LOẠI'},
                    ]
                }]
            });
        }
         // Resize function
        var triggerChartResize = function() {
            pie_farm_element && pie_basic_element.resize();
            pie_farm_type_element && pie_basic_type_element.resize();
        };

        // On sidebar width change
        $(document).on('click', '.sidebar-control', function() {
            setTimeout(function () {
                triggerChartResize();
            }, 0);
        });

        // On window resize
        var resizeCharts;
        window.onresize = function () {
            clearTimeout(resizeCharts);
            resizeCharts = setTimeout(function () {
                triggerChartResize();
            }, 200);
        };

    }

    var _pieStatistical = function(data) {
        let pieMStatisticalElement = document.getElementById("pie-material__sum");
        let totalFeed = data.sumFeed;
        let totalMedicine = data.sumMedicine;

        if (pieMStatisticalElement) {
            var pie_basic_element = echarts.init(pieMStatisticalElement);

            pie_basic_element.setOption({
                // colors
                color: [
                    '#2ec7c9','#d87a80'
                ],
                // Global text styles
                textStyle: {
                    fontFamily: 'Roboto, Arial, Verdana, sans-serif',
                    fontSize: 13
                },
                // Add title
                title: {
                    text: 'Thống kê vật tư đã dùng',
                    subtext: 'Tỉ lệ tổng số vật cám và thuốc đã dùng trong khoảng thời gian',
                    left: 'center',
                    textStyle: {
                        fontSize: 17,
                        fontWeight: 500
                    },
                    subtextStyle: {
                        fontSize: 12
                    }
                },
                // Add tooltip
                tooltip: {
                    trigger: 'item',
                    backgroundColor: 'rgba(0,0,0,0.75)',
                    padding: [10, 15],
                    textStyle: {
                        fontSize: 13,
                        fontFamily: 'Roboto, sans-serif'
                    },
                    formatter: "{a} <br/>{b}: {c} ({d}%)"
                },
                // Add legend
                legend: {
                    orient: 'vertical',
                    top: 'center',
                    left: 0,
                    data: ['TỔNG SỐ CÁM ĐÃ SỬ DỤNG', 'TỔNG SỐ THUỐC, VACXIN ĐÃ DÙNG'],
                    itemHeight: 8,
                    itemWidth: 8
                },
                // Add series
                series: [{
                    name: 'Tỉ lệ vật tư',
                    type: 'pie',
                    radius: '70%',
                    center: ['50%', '57.5%'],
                    itemStyle: {
                        normal: {
                            borderWidth: 1,
                            borderColor: '#fff'
                        }
                    },
                    data: [
                        {value: totalFeed, name: 'TỔNG SỐ CÁM (KG)'},
                        {value: totalMedicine, name: 'TỔNG SỐ THUỐC, VACXIN'},
                    ]
                }]
            })
        }
         // Resize function
         var triggerChartResize = function() {
            pieMStatisticalElement && pieMStatisticalElement.resize();
        };

        // On sidebar width change
        $(document).on('click', '.sidebar-control', function() {
            setTimeout(function () {
                triggerChartResize();
            }, 0);
        });

        // On window resize
        var resizeCharts;
        window.onresize = function () {
            clearTimeout(resizeCharts);
            resizeCharts = setTimeout(function () {
                triggerChartResize();
            }, 200);
        };
    }

    let _getDataForm = () => {
        let stageValue = $('#stage').val();
        let stockCode = $("#stockSelect").val();

        if (stockCode == '') {
            return null;
        }
        return {
            stage: stageValue,
            stockCode: stockCode
        };
    }

    let handleEventClickSubmitStatistical = function () {
        $('#btnSubmit__statistical').on('click', function (e) {
            let apiURL = contextPath + "/api/statistical/material-other";
            let criteria = _getDataForm();
            if (criteria && criteria.stockCode !== '') {
                _showModalProcessing();
                $.ajax({
                    url: apiURL,
                    method: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify(criteria),
                    success: function (response) {
                        if (response) {
                            _hideModalProcessing();
                            if (response.hasOwnProperty("errCode") && response.errCode == null) {
                                _pieStatistical(response.result);
                            } else {
                                alert("Request timeout!");
                            }
                        }
                    },
                    error: function (err) {
                        _hideModalProcessing()
                        console.log(err);
                    }
                });
            }
        });
    };

    return {
        init: function() {
            _piesFarmInit();
            handleEventClickSubmitStatistical();
        }
    }
}();

document.addEventListener('DOMContentLoaded', function() {
    EchartPieDashboard.init();
});