/**
 * Format number
 */

var formatNumberComponent = {
	initDatepicker: function() {
		$(".datepicker:not([readonly])").datepicker({
            format: "dd/mm/yyyy",
            todayBtn: "linked",
            language: "vi",
            autoclose: true,
            todayHighlight: true
        }).on('change', function(e) {
        	//$('form').bootstrapValidator('revalidateField', $(this).attr('name'));
        });
	},

	removeDatepicker: function() {
        $(".datepicker").each(function () {
            $(this).datepicker('remove');
        });
	},
	
	initAutoNumeric: function() {

		$('.currency').autoNumeric('init', {
			aPad  : false,
			aSep  : ',',
			aDec  : '.',
			mDec  : '2',
			vMax  : '9999999999999.99',
			pSign : 's',
			lZero : 'deny'
		});
		
		$('.number').autoNumeric('init', {
			mDec  : '0',
			aSep  : ',',
			aDec  : '.',
			vMax  : '9999999999999',
			lZero : 'deny'
		});
		
		$('.float').autoNumeric('init', {
			aPad  : false,
			aSep  : ',',
			aDec  : '.',
			mDec : '2',
			vMax  : '9999999999999.99',
			lZero : 'deny'
		});
		
		$('.bank-account-no').autoNumeric('init', {
			aSep: '',
			mDec: '0',
			lZero: 'keep',
			vMax : '99999999999999999999' // 20 chars
		});
		
		$('.year-string').autoNumeric('init', {
            aSep: '',
            mDec: '0',
            lZero: 'keep',
            vMax : '9999' // 4 chars
        });
	},

	disableAutoNumeric: function() {

		$('.number').each(function(i) {
			var self = $(this);
			formatNumberComponent.destroyAutoNumeric(self);
		});
		
		$('.float').each(function(i) {
			var self = $(this);
			formatNumberComponent.destroyAutoNumeric(self);
		});
		
		$('.currency').each(function(i) {
			var self = $(this);
			formatNumberComponent.destroyAutoNumeric(self);
		});
	},

	destroyAutoNumeric: function(self) {
		try {
			var v = self.autoNumeric('get');
			self.autoNumeric('destroy');
			self.val(v);
		} catch (err) {
			console.log("Not an autonumeric field: " + self.attr("name"));
		}
	},

	isValidTaxCode: function(input) {
		var isValid = false;
		
		if (10 == input.length) {
			isValid = isValidFirstTenNumberOfTaxCode(input);
		} else if (14 == input.length) {
			var firstTenNumbers = input.substring(0, 10);
			var minusSign = input.substring(10, 11);
			var lastThreeNumbers = input.substring(11, 14);

			if (!isNaN(firstTenNumbers) 
					&& !isNaN(lastThreeNumbers) 
					&& ("-" == minusSign)) {
				isValid = isValidFirstTenNumberOfTaxCode(firstTenNumbers);
			}
		}
		return isValid;
	},

	isValidFirstTenNumberOfTaxCode: function(taxCode) {
		var n1 = taxCode.substring(0, 1);
		var n2 = taxCode.substring(1, 2);
		var n3 = taxCode.substring(2, 3);
		var n4 = taxCode.substring(3, 4);
		var n5 = taxCode.substring(4, 5);
		var n6 = taxCode.substring(5, 6);
		var n7 = taxCode.substring(6, 7);
		var n8 = taxCode.substring(7, 8);
		var n9 = taxCode.substring(8, 9);
		var n10 = taxCode.substring(9, 10);
		
		if (n10 != (10 - ((n1*31 + n2*29 + n3*23 + n4*19 +n5*17 + n6*13 + n7*7 + n8*5 + n9*3) % 11))) {
			return false;
		} else {
			return true;
		}
	}
}