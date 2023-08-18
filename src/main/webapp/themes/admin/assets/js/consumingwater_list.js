var ConsumingWaterComponent = function() {
    var _componentLoaded = function() {
        var costOthers = document.getElementsByClassName('cost-other');
        for (let index = 0; index < costOthers.length; index++) {
            const iValue = costOthers[index].innerHTML;
            if (iValue.includes("E")) {
                var costOtherArr = iValue.split("E");
                console.log(parseFloat(costOtherArr[0])*parseInt(costOtherArr[1]));
                costOthers[index].innerHTML = parseFloat(costOtherArr[0])*Math.pow(10, parseInt(costOtherArr[1]));
            }
        }
        formatNumberComponent.initAutoNumeric();
    }
    
    var resetFromSearch = function() {
		$('#btnReset').on('click',function(e){
			$('#farmName').val("");
			$('#otherCostType').val(null).trigger('change');
		});
	}

    return {
        init: function() {
            _componentLoaded();
            resetFromSearch();
        }
    }
}();

document.addEventListener('DOMContentLoaded', function() {
    ConsumingWaterComponent.init();
})