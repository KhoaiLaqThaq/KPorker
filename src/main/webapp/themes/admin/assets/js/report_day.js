'use strict';

const PeriodEnum = {
	MONTH: 'month',
	WEEK: 'week',
	DAY: 'day'
};

var ReportComponent = function() {

	var _hidePeriods = function() {
		var periodValue = $('#periodSelect option:select').text();
		if (!periodValue)
			return;
		$('#period__detail').hide();
	};

	var _componentLoaded = function() {
		_hidePeriods();
	};

	var _generateTable = function (periodData) {
		
	}

	// generate table th
	var _initGenerateTable = function() {
		var periodValue = $('#periodSelect option:select').text();
		if (periodValue === PeriodEnum.WEEK) {
			var monthValue = $('#input__month').val();

		} else if (periodValue === PeriodEnum.MONTH) {
			var weekValue = $('#input__week').val();

		} else if (periodValue === PeriodEnum.DAY) {
			var dayValue = $('#input__day').val();

		}
	}

	return {
		init: function() {
			_componentLoaded();
		}
	}
}();

document.addEventListener('DOMContentLoaded', function() {
    ReportComponent.init();
});