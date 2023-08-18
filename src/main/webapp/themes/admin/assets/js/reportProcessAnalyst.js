'use strict';

var ReportFarmAnalystComponent = function() {
    var contextPath = getContext();
    var _showModalProcessing = () => $('#modalLoading').addClass('d-block').removeClass('d-none');

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

    var _callApiToGetProcessOrders = function(barnCode, poCode) {
        _resetSelectBeforeChangeFarm();
        let apiURL = contextPath + '/report/processOrderForReport/farm?farmCode=' + barnCode;
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
        $('#barnSelect').on('change', function(e) {
            var barnCode = $("#barnSelect").val();
            if(barnCode && barnCode != ''){
                $("#poSelect").removeAttr("disabled");
                var barnCode = $("#barnSelect").val();
                _callApiToGetProcessOrders(barnCode);
            } else {
                $("#poSelect").prop("disabled", true);
            }
        });
    }

    var _findAllBarnWithStockCode = function() {
        $('#stockSelect').on('change', function(e) {
            $("#barnSelect").removeAttr("disabled");
            getBarnCodeByFarm();
            $("#poSelect").html('');
            $("#poSelect").prop("disabled", true);
        });
    }

    var initData = function(){
        var stock =  $('#stockSelect').val();
        if(stock && stock != ''){
            getBarnCodeByFarm();
            $("#barnSelect").removeAttr("disabled");
            $("#poSelect").removeAttr("disabled");
        }
    }

    var _handleSubmit = function() {
        $('#btnSubmit').on('click', function(e) {
            e.preventDefault();
            var stockCode = _checkStockCodeValue();
            if (stockCode == '') return false;
            _showModalProcessing();
            $('#reportFarmAnalystForm').submit();
        })
    }

    /*
    *  Export report
    */
    var _handleExportReport = function() {
        $('#exportReportFarmAnalyst').on('click', function(e) {
            e.preventDefault();
            var stockCode = _checkStockCodeValue();
            if (stockCode == '') return false;
            var stage = $('#stage').val()
            var poCode = _checkPOCodeValue();
            if (poCode == '') return false;
            var apiExport = '/report/farm-analyst-export-excel?stockCode=' + stockCode + '&poCode=' + poCode + '&stage=' + stage;
            location.href = apiExport;
        });
    }
    
    var getBarnCodeByFarm = function(){
		var farmCode = $("#stockSelect").val();
        if(farmCode){
            let apiURL = contextPath + '/api/barnsByFarm/'+farmCode;
            $.ajax({
                url: apiURL,
                method: 'GET',
                contentType: 'application/json',
                success: function(data) {
                    if (data) {
                        $("#barnSelect").html('');
                        addBarnToOption(data);
                    }
                }, error: function(err) {
                    console.error(err.toString());
                }
            })
        }
	}

    var addBarnToOption = function(list){
        var barnSelected = $("#barnCodeSelected").val();
        $("#barnSelect").append("<option value=''></option>'")
		list.forEach((b) => {
			if(barnSelected.indexOf(b.code) >= 0){
				$("#barnSelect").append("<option selected value='"+b.code+"'>"+b.name+"</option>'")
			} else {
				$("#barnSelect").append("<option value='"+b.code+"'>"+b.name+"</option>'")
			}
		})
	}

    return {
        init: function() {
            _handleSubmit();
            _handleExportReport();
            _findAllProcessOrderWithStockCode();
            _loadedComponent();
            _findAllBarnWithStockCode();
            initData();
        }
    }
}();

document.addEventListener('DOMContentLoaded', function() {
    ReportFarmAnalystComponent.init();
});
