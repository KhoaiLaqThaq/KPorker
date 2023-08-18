var barnData = null;

var MaterialSelector = {
	initdatetimepicker: () =>{
		$('.datetimepicker').daterangepicker({ 
				singleDatePicker: true,
				locale: {
					format: 'YYYY-MM-DD'
				}
			});
	},
	initBootBox: () =>{
		if (typeof bootbox == 'undefined') {
			console.warn('Warning - bootbox.min.js is not loaded.');
			return;
		}
	},
	templateLoaiHang: (data) => {
		var template = '<option value=""></option>';
		for (var i = 0; i < data.length; i++)
			template += '<option value="'+ data[i].code +'_'+ data[i].name +'">'+ data[i].name +'</option>';
		return template;
	},
	saveTemplatePhieuCan: (data) => {
		// trong hàm này, lấy template của chuồng đã tồn tại (do đã call ajax) để clone bản ghi mới khi chưa thay đổi trại
		if (!data) {
			console.log('warning - barn data is empty!');
			return;
		}
		var template = '<option value=""></option>';
		for (let i = 0; i < data.length; i++) {
			template += '<option value="'+ data[i].code +'">'+ data[i].name +'</option>';
		}
		return template;
	},
	generateDateTime: () => {
		var date = new Date();
		var dateFormat = (date.getDate() < 10 ? ('0' + date.getDate()) : date.getDate());
		dateFormat += '/' + ((date.getMonth() + 1) < 10 ? ('0' + (date.getMonth() + 1)) : (date.getMonth() + 1));
		dateFormat += '/' + (date.getFullYear());
		dateFormat += ' ' + (date.getHours() < 10 ? ('0' + date.getHours()) : date.getHours());
		dateFormat += ':' + (date.getMinutes() < 10 ? ('0' + date.getMinutes()) : date.getMinutes());
		dateFormat += ':' + (date.getSeconds() < 10 ? ('0' + date.getSeconds()) : date.getSeconds());
		// dd/MM/yyyy hh:mm:ss
		return dateFormat;
	},
	cloneRow: (index, data) => {
		var counter = index + 1;
		var newRow = $('<tr id="rec-material'+counter+'">');
		var cols = "";
		
		cols += '<td><span class="no">'+counter+'</span></td>';
		cols += '<td class="text-center">';
		cols += '<div class="list-icons">';
		// cols += '<button type="button" class="btn-primary btn-xs" onclick="javascript:MaterialSelector.addRow()" style="display: inline-block; float: none; border: none"><i class="icon-pencil7"></i></button>';
		cols += '<button type="button" class="btn-danger btn-xs" onclick="javascript:MaterialSelector.removeRow('+counter+')" title="Remove Row" style="display: inline-block; float: none; border: none"><i class="fa fa-times"></i></button>';
		cols += '</td>';
		
		cols += '<td><input type="text" class="form-control" id="chuong-'+ counter +'" value="' + data.chuong + '" disabled="disabled" /></td>';
		cols += '<td><input type="text" class="form-control" id="loaiHang-'+ counter +'" value="' + data.loaiHang + '" disabled="disabled" /></td>';
		cols += '<td><input type="text" class="form-control" id="selected-item-dvt'+counter+'" value="'+ data.dvt +'" disabled="disabled" /></td>';
		cols += '<td><input type="text" class="form-control" id="selected-item-soLuong'+counter+'" value="' + data.soLuong + '"></td>';
		cols += '<td><input type="text" class="form-control" id="selected-item-tlCan'+counter+'" value="'+ data.tlCan + '"></td>';
		cols += '<td><input type="text" class="form-control" id="selected-item-slHeoCai'+counter+'" value="'+ data.slHeoCai + '"></td>';
		cols += '<td><input type="text" class="form-control" id="selected-item-tlGiamTru'+counter+'" value="'+ data.tlGiamTru + '"></td>';
		cols += '<td><input type="text" class="form-control" id="selected-item-trangThai'+counter+'" value="'+ data.trangThai+ '"></td>';
		newRow.append(cols);
		return newRow;
	},
	
	addRow: function(data){
		var index = parseInt($("#tblSelectedphieuCanChiTiets").find(".index-table").last().val());
		var newRow = MaterialSelector.cloneRow(index);
		newRow.appendTo('#tblSelectedphieuCanChiTiets tbody');
		$('#tblSelectedphieuCanChiTiets tbody tr').each(function(index) {
				$(this).find('span.no').html(index+1);
		});
	},
	
	removeRow: function(index){
		bootbox.prompt({
			title: 'Nhập "OK" để xác nhận xóa lần cân!',
			centerVertical: true,
			callback: function(result){ 
				if (result === 'OK' || result === 'ok') {
					var itemId = $('#input-item-id_' + index).val();
					if (itemId) {
						$.ajax({
							url: getContext() + '/api/deletePhieuCanChiTiet/' + itemId,
							method: 'post',
							contextType: 'application/json',
							success: function(data) {
								if (data) {
									$('#rec-material'+index).remove();
									$('#tblSelectedphieuCanChiTiets tbody tr').each(function(index) {
											$(this).find('span.no').html(index+1);
									});
								}
							},
							error: function(err) {
								console.log('Error - ' + err);
							}
						})
					}
				}
				else return;
			}
		})
	},
};

var GrossWeightFormComponent = function() {
	var contextPath = getContext();
	var initForm = function() {
        if (!$().select2) {
            return;
        }
    	// select2
   	 	$('.select2').select2();
	}

	var _loadingDataMaterialWeigh = function (dataEdit) {
		var codeExist = dataEdit ? dataEdit.loaiHang : '';
		$.ajax({
			url: contextPath + "/api/get-material-weigh",
			method: 'GET',
			contextType: 'application/json',
			success: function (data) {
				if (data) {
					var template = '<option value=""></option>';
					for (var i = 0; i < data.length; i++) {
						var material = data[i];
						var materialValue = material.code +'_'+ material.name;
						template += '<option value="'+ materialValue +'" ' + (codeExist === materialValue ? 'selected' : '') + '>'+ material.name +'</option>';
					}
					$('#select-item-loaihang').html(template);
				}
			}, 
			error: function (err) {
				console.log('Error: ' + err);
			}
		})
	}

	var _loadBarnsByFarmCode = function(barns, barnCodeEdit) {
		var template = '';
		template += '<option value=""></option>';
		for (let index = 0; index < barns.length; index++) {
			const element = barns[index];
			var elementValue = barns[index].code;
			template += '<option value="' + elementValue + '" ' + (elementValue === barnCodeEdit ? 'selected':'') + '>'+ barns[index].name + '</option>';
		}
		$('#select-item-chuong').html(template);
	}

	/**
	 * In this function, we need to load the barn of farm, when we changed the stockCode
	 */
	var _handleChangeStockCode = function(dataEdit) {
		// $('#stockCode').on('change', function(e) {
			var barnValue = dataEdit ? dataEdit.chuong : '';
			var stockCode = $('#stockCode').val();
			if (stockCode && stockCode.trim() != '') {
				$.ajax({
					url: contextPath + '/api/barnsByFarm/' + stockCode,
					contextType: 'application/json',
					method: 'GET',
					success: function(data) {
						$('#add-plus').click();
						if (data) {
							_loadBarnsByFarmCode(data, barnValue);
							barnData = data;
						} else {
							console.log("Warning - the barn's data is empty");
						}
					},
					error: function(err) {
						console.log('error: ', err);
					}
				})
			} else {
				bootbox.alert({
					title: 'Thông báo',
					message: 'Vui lòng chọn trại xuất.'
				});
			}
		// })
	}

	var _resetFormDetail = function() {
		$("#selector-item-id").val('');
		$("#selector-item-lanCan").val('');
		$("#selector-item-traiXuat").val('');
		$("#selector-item-soPhieu").val('');
		$("#selector-item-soPhieuXk").val('');
		$("#select-item-chuong").html('');
		$("#select-item-loaihang").html('');
		$("#input-item-dvt").val('');
		$("#input-item-amount").val('');
		$("#input-item-tlCan").val('');
		$("#input-item-slHeoCai").val('');
		$("#input-item-tlGiamTru").val('');
		$("#input-item-status").val('');
	}

	var _initShowModalFormDetail = function() {
		$('#addRowFormDetail').on('click', function(e) {
			// loading data initForm
			_resetFormDetail();
			_handleChangeStockCode();
			_loadingDataMaterialWeigh();
		});

		$('.cancel_form_detail').on('click', function(e) {
			// reset form for new item detail
			_resetFormDetail();
		});
	}

	var _submitFormDetail = function() {
		$('#submit_form_detail').on('click', function(e) {
			$('#btnSubmit').click();
		})
	}

	var _notificationMessage = function(message) {
		bootbox.alert(message);
	}

	var _setValueFormDetail = function(value) {
		$('#selector-item-id').val(value.id);
		$('#selector-item-lanCan').val(value.lanCan);
		$('#selector-item-traiXuat').val(value.traiXuat);
		$('#selector-item-soPhieu').val(value.soPhieu);
		$('#selector-item-soPhieuXk').val(value.soPhieuXk);
		$('#input-item-dvt').val(value.dvt);
		$('#input-item-amount').val(value.soLuong);
		$('#input-item-tlCan').val(value.tlCan);
		$('#input-item-slHeoCai').val(value.slHeoCai);
		$('#input-item-tlGiamTru').val(value.tlGiamTru);
		$('#input-item-status').val(value.trangThai);
		_loadingDataMaterialWeigh(value);
	}

	var _handleEditGrossWeight = function() {
		$('.btn-edit').on('click', function(e) {
			var id = this.id;
			if (id) {
				var idArray = id.split('-');
				var grossWeightDetailId = idArray[1];
				if (grossWeightDetailId) {
					$.ajax({
						url: contextPath + "/phieuCanChiTiet/" + grossWeightDetailId,
						method: 'GET',
						contextType: 'application/json',
						success: function (data) {
							if (data.id) {
								// $('#add-plus').click();
								_handleChangeStockCode(data);
								_setValueFormDetail(data);
							} else {
								_notificationMessage("Lỗi kỹ thuật!");
							}
						},
						error: function (err) {
							_notificationMessage("Lỗi kỹ thuật!");
							console.log("error: " + err);
						}
					})
				} else {
					_notificationMessage("Không tìm được id lần cân!");
				}
			}
		})
	}

	return {
		init: function() {
			initForm();
			_initShowModalFormDetail();
			_submitFormDetail();
			_handleEditGrossWeight();
		}
	}
}();

document.addEventListener('DOMContentLoaded', function() {
	GrossWeightFormComponent.init();
})