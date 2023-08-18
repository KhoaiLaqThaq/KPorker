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

    var _checkPigLevelValue = function() {
        var pigLevel = $('#pigLevelSelect').val();
        if (pigLevel || pigLevel != '') 
            return pigLevel;
        bootbox.alert({
            title: 'Thông báo',
            message: 'Vui lòng chọn lứa heo.'
        });
        return '';
    }

    var _resetSelectBeforeChangeFarm = () => $('#pigLevel').html('');

    var _generatePigLevelTempl = function(data, pigLevel) {
        var template = '';
        for (let i = 0; i < data.length; i++) {
            const element = data[i];
            template += '<option value='+ element +' '+ (pigLevel === element ? 'selected' : ' ') +'>' + element + '</option>';
        }
        $('#pigLevelSelect').html(template);
    }

    var _callApiToGetPigLevel = function(barnCode, pigLevel) {
        _resetSelectBeforeChangeFarm();
        let apiURL = contextPath + '/api/processOrder/get-pig-level-by-barn?barnCode=' + barnCode;
        $.ajax({
            url: apiURL,
            method: 'GET',
            contentType: 'application/json',
            success: function(data) {
                if (data) {
					console.log(data);
                    _generatePigLevelTempl(data, pigLevel);
                }
            }, error: function(err) {
                console.error(err.toString());
            }
        })
    }

    var _loadedComponent = function() {
        var barnCodeStr = $('#barnCodeSelected').val();
        var list = barnCodeStr.split(",");
        
        var barnCode;
        list.forEach(b => {
			if(b && b != ""){
				barnCode = b;
			}
		});
        console.log(barnCode);
        
        if (barnCode && barnCode != '') {
            var pigLevel = $('#pigLevelHidden').val();
            if (pigLevel && pigLevel != '') {
                _callApiToGetPigLevel(barnCode, pigLevel);
            }
        }
    }

    var _findAllPigLevelWithBarnCode = function() {
        $('#barnSelect').on('change', function(e) {
            var barnCode = $("#barnSelect").val();
            if(barnCode && barnCode != ''){
                $("#pigLevelSelect").removeAttr("disabled");
                var barnCode = $("#barnSelect").val();
                _callApiToGetPigLevel(barnCode);
            } else {
                $("#pigLevelSelect").prop("disabled", true);
            }
        });
    }

    var _findAllBarnWithStockCode = function() {
        $('#stockSelect').on('change', function(e) {
            $("#barnSelect").removeAttr("disabled");
            getBarnCodeByFarm();
            $("#pigLevelSelect").html('');
            $("#pigLevelSelect").prop("disabled", true);
        });
    }

    var initData = function(){
        var stock =  $('#stockSelect').val();
        if(stock && stock != ''){
            getBarnCodeByFarm();
            $("#barnSelect").removeAttr("disabled");
            $("#pigLevelSelect").removeAttr("disabled");
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
            var pigLevel = _checkPigLevelValue();
            if (pigLevel == '') return false;
            var apiExport = '/report/farm-analyst-by-pigLevel-export-excel?stockCode=' + stockCode + '&pigLevel=' + pigLevel + '&stage=' + stage;
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
            _findAllPigLevelWithBarnCode();
            _loadedComponent();
            _findAllBarnWithStockCode();
            initData();
        }
    }
}();

document.addEventListener('DOMContentLoaded', function() {
    ReportFarmAnalystComponent.init();
});
