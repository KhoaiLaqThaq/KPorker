'use strict';

var MedicineForm = function() {
	
}();

// Initialize Module

document.addEventListener('DOMContentLoaded', function() {
	
});

$(function() {
	$('#medicineCode').on('change', function(e) {
		var medicineCode = this.value;
		var messageMedicineCode = document.getElementById('messageCheckCode');
		var buttonMedicineSubmit = document.getElementById('medicineSubmit');
		
		$.ajax({
			url: getContext() + '/medicine/checkMedicineCode?medicineCode=' + medicineCode,
			method: 'GET',
			data: {},
			success: function(data) {
				if (data && data === true) {
					$('#messageCheckCode').html('Mã thuốc đã tồn tại.');
					$('#messageCheckCode').addClass('text-danger');
					messageMedicineCode.style.display = "block";
					buttonMedicineSubmit.disabled = true;
				} else {
					$('#messageCheckCode').html('Mã thuốc chưa tồn tại.')
					$('#messageCheckCode').removeClass('text-danger');
					messageMedicineCode.style.display = "block";
					buttonMedicineSubmit.disabled = false;
				}
			},
			error: function(err) {
				console.log('err', err);
			}
		});
	});
	$('#medicineName').on('change', function(e) {
		var medicineName = this.value;
		var messageMedicineName = document.getElementById('messageCheckName');
		var buttonMedicineSubmit = document.getElementById('medicineSubmit');
		$.ajax({
			url: getContext() + '/medicine/checkMedicineName?medicineName=' + medicineName,
			method: 'GET',
			data: {},
			success: function(data) {
				if (data && data === true) {
					$('#messageCheckName').html('Tên thuốc đã tồn tại.');
					$('#messageCheckName').addClass('text-danger');
					messageMedicineName.style.display = "block";
					buttonMedicineSubmit.disabled = true;
				} else {
					$('#messageCheckName').html('Tên thuốc chưa tồn tại.')
					$('#messageCheckName').removeClass('text-danger');
					messageMedicineName.style.display = "block";
					buttonMedicineSubmit.disabled = false;
				}
			},
			error: function(err) {
				console.log('err', err);
			}
		});
	});
});