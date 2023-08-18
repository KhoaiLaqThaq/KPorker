var ReportDailyAverageWeightComponent = function() {
	var listFarm;
	
	var init = function(){
		$(document).ready(function(){
			$.ajax({
				url: getContext() + '/api/farmByUsernameLogin',
				contextType: 'application/json',
				method: 'GET',
				dataType: 'json',
				
				success: function(data) {
					listFarm = data;
					initBarnSelect();
					
				},
				error: function(err) {
					console.log(err);
				}
			});
		});
		
		$('input[name="stage"]').daterangepicker({
			singleDatePicker: true,
		    autoUpdateInput: false,
	      	locale: {
	          	cancelLabel: 'Clear',
	          	format: 'DD/MM/YYYY'
	      	}
	  	});
	  	
	  	$('input[name="stage"]').on('apply.daterangepicker', function(ev, picker) {
	      	$(this).val(picker.startDate.format('DD/MM/YYYY'));
	  	});
		
	  	$('input[name="stage"]').on('cancel.daterangepicker', function(ev, picker) {
	      	$(this).val('');
	  	});
	  	
	  	$('.header').click(function(){
			if($(this).hasClass("expand")){
				$(this).find(".spanButton").last().removeAttr("rowspan");
				$(this).find(".counter").last().removeAttr("rowspan");
				$(this).find(".poCode").last().removeAttr("rowspan");
				$(this).find(".pigType").last().removeAttr("rowspan");
				$(this).find(".barnName").last().removeAttr("rowspan");
				$(this).nextUntil('tr.header').each(function(){
					$(this).css("display","none");
				})
				$(this).removeClass("expand");
				$(this).find(".spanButton").last().find("i").last().removeClass("icon-arrow-down5");
				$(this).find(".spanButton").last().find("i").last().addClass("icon-arrow-right5");
			} else {
				if($(this).nextUntil('tr.header').length > 0){
					var size = $(this).nextUntil('tr.header').length;
					
					$(this).find(".spanButton").last().attr("rowspan", size+1);
					$(this).find(".counter").last().attr("rowspan", size+1);
					$(this).find(".poCode").last().attr("rowspan", size+1);
					$(this).find(".pigType").last().attr("rowspan", size+1);
					$(this).find(".barnName").last().attr("rowspan", size+1);
					$(this).nextUntil('tr.header').each(function(){
						$(this).removeAttr("style");
					})
				}
				$(this).addClass("expand");
				$(this).find(".spanButton").last().find("i").last().removeClass("icon-arrow-right5");
				$(this).find(".spanButton").last().find("i").last().addClass("icon-arrow-down5");
			}
			checkAllExpand();
		});
		
		$('#stockSelect').multiselect({
            includeSelectAllOption: true,
            enableFiltering: true,
            enableCaseInsensitiveFiltering: true
        });
        
		insertSelectOption();
	}
	
	var insertSelectOption = function(){
		$(document).on('keyup', '.multiselect-search', function(e){
			if(e.key === 'Enter' || e.keyCode === 13){
				let searchStr = $(this).val();
				let array = searchStr.split(",").map(function(item){
					return item.trim();
				})
				
				console.log(array);
				
				let list = $('#stockSelect option');
				
				list.each(function(index, item){
					if(array.includes(item.text)){
						item.selected = true;
					} else {
						item.selected = false;
					}
				})
				
				$('.multiselect-search').val(null); 
				$("#stockSelect").multiselect('rebuild');
				
			}
		})
	}
	
	var expandAll = function(){
		$("#expandAll").on("click", function(){
			var status;
			if($(this).hasClass("expandAll")){
				$(this).find("i").last().removeClass("icon-arrow-down5");
				$(this).find("i").last().addClass("icon-arrow-right5");
				$(this).removeClass("expandAll");
				status = 'close';
			} else {
				$(this).find("i").last().removeClass("icon-arrow-right5");
				$(this).find("i").last().addClass("icon-arrow-down5");
				$(this).addClass("expandAll");
				status = 'open';
			}
			
			$(".header").each(function(){
				if($(this).hasClass("expand")){
					if(status == 'open') return;
					
					$(this).find(".spanButton").last().removeAttr("rowspan");
					$(this).find(".counter").last().removeAttr("rowspan");
					$(this).find(".poCode").last().removeAttr("rowspan");
					$(this).find(".pigType").last().removeAttr("rowspan");
					$(this).find(".barnName").last().removeAttr("rowspan");
					$(this).nextUntil('tr.header').each(function(){
						$(this).css("display","none");
					})
					$(this).removeClass("expand");
					$(this).find(".spanButton").last().find("i").last().removeClass("icon-arrow-down5");
					$(this).find(".spanButton").last().find("i").last().addClass("icon-arrow-right5");
					
				} else {
					if(status == 'close') return;
					
					if($(this).nextUntil('tr.header').length > 0){
						var size = $(this).nextUntil('tr.header').length;
						
						$(this).find(".spanButton").last().attr("rowspan", size+1);
						$(this).find(".counter").last().attr("rowspan", size+1);
						$(this).find(".poCode").last().attr("rowspan", size+1);
						$(this).find(".pigType").last().attr("rowspan", size+1);
						$(this).find(".barnName").last().attr("rowspan", size+1);
						$(this).nextUntil('tr.header').each(function(){
							$(this).removeAttr("style");
						})
					}
					$(this).addClass("expand");
					$(this).find(".spanButton").last().find("i").last().removeClass("icon-arrow-right5");
					$(this).find(".spanButton").last().find("i").last().addClass("icon-arrow-down5");
					
				}
			});
		});
	}
	
	var checkAllExpand = function(){
		if($("#tbodyReportInstock .expand").length > 0){
			$("#expandAll").addClass("expandAll");
			$("#expandAll").find("i").last().removeClass("icon-arrow-right5");
			$("#expandAll").find("i").last().addClass("icon-arrow-down5");
		} else {
			$("#expandAll").removeClass("expandAll");
			$("#expandAll").find("i").last().removeClass("icon-arrow-down5");
			$("#expandAll").find("i").last().addClass("icon-arrow-right5");
		}
	}
	
	var _handleFarmSelected = function() {
		$("#stockSelect").on('change', function(e){
			$("#barnSelect").html('');
			var farmSelected = $("#stockSelect").val();
			if(farmSelected && farmSelected.length > 0){
				listFarm.forEach((f) => {
					if(farmSelected.indexOf(f.code) >= 0){
						addBarnToOption(f);
					}
				});
				$("#barnSelect").multiselect('rebuild');
				$("#barnSelect").prop("disabled", false);
			} else {
				$("#barnSelect").multiselect('disable');
			}
			
		})
	}
	
	var initBarnSelect = function(){
		var farmSelected = $("#stockSelect").val();
		$("#barnSelect").html('');
		if(farmSelected && farmSelected.length > 0){
			listFarm.forEach((f) => {
				if(farmSelected.indexOf(f.code) >= 0){
					addBarnToOption(f);
				}
				$("#barnSelect").multiselect('rebuild');
					$("#barnSelect").prop("disabled", false);
			});
		}
		
	}
	
	var addBarnToOption = function(item){
		var barnSelected = $("#barnCodeStrSelected").val();
		item.barns.forEach((b) => {
			if(barnSelected.indexOf(b.code) >= 0){
				$("#barnSelect").append("<option selected value='"+b.code+"'>"+b.name+"</option>'")
			} else {
				$("#barnSelect").append("<option value='"+b.code+"'>"+b.name+"</option>'")
			}
		})
	}

    /**
     * Hàm này để export 
     */
     var _handleExportReportDailyAverageWeight = function() {
        $('#exportReportDailyAverageWeight').on('click', function(e) {
            e.preventDefault();
            
            var stockCode = _checkStockCodeValue();
            if (stockCode == '') return false;
            var stockCodeStr = '';
            stockCode.forEach(s => {
				stockCodeStr = stockCodeStr + s + ',';
			});
			
			var barnCodesStr = '';
			$('#barnSelect').val().forEach(b => {
				barnCodesStr = barnCodesStr + b + ',';
			})
			
			var weightRangesStr = '';
			$('#weightRange').val().forEach(r => {
				weightRangesStr = weightRangesStr + r + ',';
			})
			
            var stage = $('#stage').val();
            var apiExport = '/report/daily-average-weight-export-excel?farmCodesStr=' + stockCodeStr + '&stage=' + stage
            + '&barnCodesStr=' + barnCodesStr+ '&weightRangesStr=' + weightRangesStr;
            location.href = apiExport;
        });
    }
    
    var _checkStockCodeValue = function() {
        var stockCode = $('#stockSelect').val();
        if (stockCode.length != 0) {
            return stockCode;
        }
        bootbox.alert({
            title: 'Thông báo',
            message: 'Vui lòng chọn trại.'
        });
        return '';
    }
    
    var resetSearchForm = function() {
		$('#btnReset').on('click',function(e){
			window.location.href = "/report/daily-average-weight";
		});
	}

    return {
        init: function() {
            init();
            _handleExportReportDailyAverageWeight();
            _handleFarmSelected();
            resetSearchForm();
            expandAll();
        }
    }
}();


document.addEventListener('DOMContentLoaded', function() {
    ReportDailyAverageWeightComponent.init();
});
