// Initial constant
const DAYS_OF_WEEK = 7;

var EchartsLines = function() {

    //
    // Setup module components
    //

    // Line charts
    var _lineChartOne = function() {
        if (typeof echarts == 'undefined') {
            console.warn('Warning - echarts.min.js is not loaded.');
            return;
        }
        // Define elements
        var line_values_element = document.getElementById('line_values');
        //
        // Charts configuration
        //

        // Display point values
        if (line_values_element) {

            // Initialize chart
            var line_values = echarts.init(line_values_element);


            //
            // Chart config
            //

            // Options
            line_values.setOption({

                // Define colors
                color: ['#49C1B6', '#EA007B', '#035494', '#060101'],

                // Global text styles
                textStyle: {
                    fontFamily: 'Roboto, Arial, Verdana, sans-serif',
                    fontSize: 13
                },

                // Chart animation duration
                animationDuration: 750,

                // Setup grid
                grid: {
                    left: 0,
                    right: 40,
                    top: 35,
                    bottom: 0,
                    containLabel: true
                },

                // Add legend
                legend: {
                    data: ['Tổng lượng thuốc', 'Tổng lượng thức ăn', 'FCR', 'Tổng lượng cá hao hụt'],
                    itemHeight: 8,
                    itemGap: 20
                },

                // Add tooltip
                tooltip: {
                    trigger: 'axis',
                    backgroundColor: 'rgba(0,0,0,0.75)',
                    padding: [10, 15],
                    textStyle: {
                        fontSize: 13,
                        fontFamily: 'Roboto, sans-serif'
                    }
                },

                // Horizontal axis
                xAxis: [{
                    type: 'category',
                    boundaryGap: false,
                    data: dailyBreedingDays,
                    axisLabel: {
                        color: '#333'
                    },
                    axisLine: {
                        lineStyle: {
                            color: '#999'
                        }
                    },
                    splitLine: {
                        lineStyle: {
                            color: ['#eee']
                        }
                    }
                }],

                // Vertical axis
                yAxis: [{
                    type: 'value',
                    axisLabel: {
//                        formatter: '{value} °C',
                        color: '#333'
                    },
                    axisLine: {
                        lineStyle: {
                            color: '#999'
                        }
                    },
                    splitLine: {
                        lineStyle: {
                            color: ['#eee']
                        }
                    },
                    splitArea: {
                        show: true,
                        areaStyle: {
                            color: ['rgba(250,250,250,0.1)', 'rgba(0,0,0,0.01)']
                        }
                    }
                }],

                // Add series
                series: [
                    {
                        name: 'Tổng lượng thuốc',
                        type: 'line',
                        data: dailyMedications,
                        smooth: true,
                        symbolSize: 7,
                        label: {
                            normal: {
                                show: true
                            } 
                        },
                        itemStyle: {
                            normal: {
                                borderWidth: 2
                            }
                        }
                    },
                    {
                        name: 'Tổng lượng thức ăn',
                        type: 'line',
                        data: dailyFeeds,
                        smooth: true,
                        symbolSize: 7,
                        label: {
                            normal: {
                                show: true
                            } 
                        },
                        itemStyle: {
                            normal: {
                                borderWidth: 2
                            }
                        }
                    },
                    /* {
                        name: 'FCR',
                        type: 'line',
                        data: [23, 12, 9, 39, 05, 20, 41],
                        smooth: true,
                        symbolSize: 7,
                        label: {
                            normal: {
                                show: true
                            } 
                        },
                        itemStyle: {
                            normal: {
                                borderWidth: 2
                            }
                        }
                    },
                    {
                        name: 'Tổng lượng cá hao hụt',
                        type: 'line',
                        data: [100, 121, 56, 88, 20, 10, 50],
                        smooth: true,
                        symbolSize: 7,
                        label: {
                            normal: {
                                show: true
                            }
                        },
                        itemStyle: {
                            normal: {
                                borderWidth: 2
                            }
                        }
                    }*/
                    
                ]
            });
        }
        //
        // Resize charts
        //

        // Resize function
        var triggerChartResize = function() {
            line_values_element && line_values.resize();
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

        
    };
    
    var _lineChartTwo = function() {
    	 if (typeof echarts == 'undefined') {
             console.warn('Warning - echarts.min.js is not loaded.');
             return;
         }
    	 
    	 var line_weight_values_element = document.getElementById('line_weight_values');
    	 
    	 if (line_weight_values_element) {
	        // Initialize chart
	        var line_weight_values = echarts.init(line_weight_values_element);
            // Options
	        line_weight_values.setOption({
                // Define colors
                color: ['#060101'],

                // Global text styles
                textStyle: {
                    fontFamily: 'Roboto, Arial, Verdana, sans-serif',
                    fontSize: 13
                },

                // Chart animation duration
                animationDuration: 750,

                // Setup grid
                grid: {
                    left: 0,
                    right: 40,
                    top: 35,
                    bottom: 0,
                    containLabel: true
                },

                // Add legend
                legend: {
                    data: ['Tổng trọng lượng đàn', 'FCR'],
                    itemHeight: 8,
                    itemGap: 20
                },

                // Add tooltip
                tooltip: {
                    trigger: 'axis',
                    backgroundColor: 'rgba(0,0,0,0.75)',
                    padding: [10, 15],
                    textStyle: {
                        fontSize: 13,
                        fontFamily: 'Roboto, sans-serif'
                    }
                },

                // Horizontal axis
                xAxis: [{
                    type: 'category',
                    boundaryGap: false,
                    data: dailyWeightPeriod,
                    axisLabel: {
                        color: '#333'
                    },
                    axisLine: {
                        lineStyle: {
                            color: '#999'
                        }
                    },
                    splitLine: {
                        lineStyle: {
                            color: ['#eee']
                        }
                    }
                }],

                // Vertical axis
                yAxis: [{
                    type: 'value',
                    axisLabel: { color: '#333' },
                    axisLine: {
                        lineStyle: { color: '#999' }
                    },
                    splitLine: {
                        lineStyle: { color: ['#eee'] }
                    },
                    splitArea: {
                        show: true,
                        areaStyle: { color: ['rgba(250,250,250,0.1)', 'rgba(0,0,0,0.01)'] }
                    }
                }],

                // Add series
                series: [
                    {
                        name: 'Tổng trọng lượng đàn',
                        type: 'line',
                        data: dailyWeightCage,
                        smooth: true,
                        symbolSize: 7,
                        label: {
                            normal: {
                                show: true
                            } 
                        },
                        itemStyle: {
                            normal: {
                                borderWidth: 2
                            }
                        }
                    },{
                        name: 'FCR',
                        type: 'line',
                        data: fcr,
                        smooth: true,
                        symbolSize: 7,
                        label: {
                            normal: {
                                show: true
                            } 
                        },
                        itemStyle: {
                            normal: {
                                borderWidth: 2
                            }
                        }
                    }
                ]
            });
        }
        //
        // Resize charts
        //

        // Resize function
        var triggerChartResize = function() {
        	line_weight_values_element && line_weight_values.resize();
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
    };
    

    var _componentSelect2 = function() {
        if (!$().select2) {
            console.warn('Warning - select2.js is not loaded.');
            return;
        }
        $('.multiselect-select-all-filtering').multiselect({
            includeSelectAllOption: true,
            enableFiltering: true,
            enableCaseInsensitiveFiltering: true
        });

        // select2
        $('.select2').select2();
        
        // Reacting to external value changes
        $('.select-access-multiple-value').select2();
        $('.change-to-ca').on('click', function() { $('.select-access-multiple-value').val('CA').trigger('change'); });
        $('.change-to-ak-co').on('click', function() { $('.select-access-multiple-value').val(['AK','CO']).trigger('change'); });

    };
    
    var _componentMultiselect = function() {
        if (!$().multiselect) {
            console.warn('Warning - bootstrap-multiselect.js is not loaded.');
            return;
        }
        // Select All and Filtering features
        $('.multiselect-select-all-filtering').multiselect({
            includeSelectAllOption: true,
            enableFiltering: true,
            enableCaseInsensitiveFiltering: true
        });
        
    };

    //
    // Return objects assigned to module
    //

    return {
        init: function() {
            _lineChartOne();
            _lineChartTwo();
            _componentSelect2();
            _componentMultiselect();
        }
    }
}();


// Initialize module
// ------------------------------

document.addEventListener('DOMContentLoaded', function() {
    EchartsLines.init();
});


function getWeekFromFeedingDay(feedingDay) {
	return Math.ceil(feedingDay/DAYS_OF_WEEK);
}

function getDayOfWeekFromFeedingDay(feedingDay) {
	if (feedingDay != null && feedingDay != '') {
		const dayOfWeek = feedingDay % DAYS_OF_WEEK;
		if (dayOfWeek === 0) {
			return DAYS_OF_WEEK;
		} else {
			return feedingDay % DAYS_OF_WEEK;
		}
	}
	return '';
}

function dataRowSumReport(data) {
	return `<tr style="background-color: #8bc34a" class="font-weight-bold">
		<td colspan="2">Tổng lượng đã dùng</td>
		<td class="text-center">` + data.totalFeedWeight +`</td>
		<td class="text-center">` + data.totalMedicineWeight +`</td>
		<td class="text-center">` + data.totalLost +`</td>
		<td class="text-center">` + data.totalAmount +`</td>
	</tr>`;
}

function dataRowReportDetail(data, index) {
	return `<tr>
		<td>` + getWeekFromFeedingDay(data.latestDay - index) +`</td>
		<td class="text-center">` + getDayOfWeekFromFeedingDay(data.latestDay - index) +`</td>
		<td class="text-center">` + data.totalFeeds[index] +`</td>
		<td class="text-center">` + data.totalMedicines[index] +`</td>
		<td class="text-center">` + data.losses[index] + `</td>
		<td></td>
	</tr>`;
}

function dataRowWeightHistory(data, index) {
	return `<tr>
		<td>` + (index + 1) + `</td>
		<td>` + (data.dates[index] ? data.dates[index] : '') + `</td>
		<td>` + data.totalWeight[index] + `</td>
		<td>` + data.fcr[index] + `</td>
	</tr>`;
}

// defined flag variable to check spam server
var isFlag = true;

$(function(){
	$('#line_values').click(function(){
		if (isFlag === true) {
			var cageIdentityCode = document.getElementById('reportCageId').value;
	        if (cageIdentityCode != null && cageIdentityCode != '') {
	        	$('#report-history').html('');
        		isFlag = false;
        		$.ajax({
            		url: getContext() + '/report/totalData?identityCode=' + cageIdentityCode,
            		method: 'GET',
            		data: {},
            		success: function(data) {
            			isFlag = true;
            			if (data) {
            				// dataRow Sum report
            				$('#report-history').append(dataRowSumReport(data));
        					
        					for (let i = 0; i < data.latestDay; i++) {
        						$('#report-history').append(dataRowReportDetail(data, i));
            				}
//        					$('#report-history').html(componentData);
            				if(document.getElementById("table_values").style.display == "none"){
            					$('#titleCageCode').html(cageIdentityCode);
            	                $('#table_values').show('slow');
            	            }
            			}
            		},
            		error: function(err) {
            			isFlag = true;
            			console.log('error', err);
            		}
        		});
	        } else {
	            $('#table_values').hide('slow');
	        }
		}
	});
});

$(function() {
	$('#line_weight_values').click(function(){
		var cageIdentityCode = document.getElementById('reportCageId').value;
		if (cageIdentityCode != null && cageIdentityCode != '') {
            if(document.getElementById("table_weight_values").style.display == "none"){
                $('#table_weight_values').show('slow');
            }
        } else {
            $('#table_weight_values').hide('slow');
        }
	})
})

$(function() {
    $('#reportFarmId').on('change', function(e) {
        var farmCode = this.value;
        $.ajax({
            url: getContext() + '/cage/farm?farmIdentityCode=' + farmCode,
            method: 'GET',
            data: {},
            success: function(data) {
                if (data != null && data != '') {
                    var optionElement = '<option></option>';
                    data.forEach(element => {
                        optionElement += '<option value="' + element.identityCode + '">' + element.code + '</option>';
                    });
                    $('#reportCageId').html(optionElement);
                    $('#report-history').html('');
                    $('#report-weight-history').html('');
                }
            },
            error: function(error) {
                //nofi for user
                console.log('error', error);
            }
        });
    });
});

$(function() {
    $('#reportCageId').on('change', function(e) {
        var cageIdentityCode = this.value;
        // reset
        $('#report-history').html('');
        $('#report-weight-history').html('');
        
        $.ajax({
            url: getContext() + '/report/cage?identityCode=' + cageIdentityCode,
            method: 'GET',
            data: {},
            success: function(data) {
                // danh sach long trong trai
                if (data != null && data != '') {
                    dailyFeeds = data.totalFeeds.reverse();
                    dailyMedications = data.totalMedicines.reverse();
                    dailyBreedingDays = data.breedingDays.reverse();
                    dailyWeightCage = data.totalWeight.reverse();
                    dailyWeightPeriod = data.dates.reverse();
                    fcr = data.fcr.reverse();
                    EchartsLines.init();
                    document.getElementById('chart-fixed-bottom').style.display = 'block';
                }
                $('#titleCageCode').html(cageIdentityCode);
                $('#titleWeightCageCode').html(cageIdentityCode);

                for (let i = 0; i < data.totalWeight.length; i++) {
                	$('#report-weight-history').append(dataRowWeightHistory(data, i));
                }
            },
            error: function(error) {
                //nofi for user
                console.log('error', error);
            }
        });
    });
});




















