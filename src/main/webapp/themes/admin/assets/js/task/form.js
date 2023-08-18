const TASK_CONFIRM_ENUM = {
	CONFIRMED: 'confirmed',
	REJECTED: 'rejected'
};

const TaskFormComponent = function() {
  const _initDatePicker = function() {
    /*
     * Initialize the date picker
     */
	let startDateStr = $('input[name="startDateStr"]');
	startDateStr.daterangepicker({
		singleDatePicker: true,
		autoUpdateInput: false,
		locale: {
			cancelLabel: 'Clear',
			format: 'DD-MM-YYYY'
		}
	});
	  	
	startDateStr.on('apply.daterangepicker', function(ev, picker) {
		$(this).val(picker.startDate.format('DD-MM-YYYY'));
	});

	startDateStr.on('cancel.daterangepicker', function(ev, picker) {
		$(this).val('');
	});

	let deadlineStr = $('input[name="deadlineStr"]');
	deadlineStr.daterangepicker({
		singleDatePicker: true,
		autoUpdateInput: false,
		locale: {
			cancelLabel: 'Clear',
			format: 'DD-MM-YYYY'
		}
	});
	  	
	deadlineStr.on('apply.daterangepicker', function(ev, picker) {
		$(this).val(picker.startDate.format('DD-MM-YYYY'));
	});

	deadlineStr.on('cancel.daterangepicker', function(ev, picker) {
		$(this).val('');
	});

	$('#task__assignee').multiselect({
	  includeSelectAllOption: true,
	  enableFiltering: true,
	  enableCaseInsensitiveFiltering: true
	});

	formatNumberComponent.initAutoNumeric();

	  insertSelectOption();
  }

	const  insertSelectOption = function(){
		$(document).on('keyup', '.multiselect-search', function(e){
			if(e.key === 'Enter' || e.keyCode === 13){
				let searchStr = $(this).val();
				let array = searchStr.split(",").map(function(item){
					return item.trim();
				})

				let list = $('#task__assignee option');

				list.each(function(index, item){
					if(array.includes(item.text)){
						item.selected = true;
					} else {
						item.selected = false;
					}
				})

				$('.multiselect-search').val(null);
				$("#task__assignee").multiselect('rebuild');

			}
		})
	}

	const _initComponentAnyTime = function() {
		if (!$().AnyTime_picker) {
			console.warn('Warning - anytime.min.js is not loaded.');
			return;
		}

		// Time picker
		$('#startDate__time').AnyTime_picker({
			format: '%H:%i'
		});
		$('#deadline__time').AnyTime_picker({
			format: '%H:%i'
		});
	}

	/**
	 * Initial function to show task modal confirm
	 */
	const _eventListenerShowTaskConfirm = function() {
		$('#btn--update__confirm').on('click', function() {
			let countdown = 5;
			let btnRejected = $('#btn--update__rejected');
			btnRejected.find('.icon').html(countdown);
			btnRejected.prop('disabled', true);
			const countdownToAcceptRejected =  setInterval(() => {
				countdown--;
				$('#btn--update__rejected').find('.icon').html(countdown);
				if (countdown === 1)
					clearInterval(countdownToAcceptRejected);
			}, 1000);
			
			setTimeout(() => {
				btnRejected.find('.icon').html(`<i class="icon-stack-cancel mr-1"></i>`);
				btnRejected.prop('disabled', false);
			}, 5000);
		});
	}

	/**
	 * Khi user tu choi cong viec thi bat buoc (*) nhap nguyen nhan
	 */
	const _eventRequestEnterCauseToReject = function() {
		$('#btn--update__rejected').on('click', function() {
			$('#close__modal_confirm').click();
		});
	}

	/**
	 * Event to confirm task
	 */
	const _eventConfirmTask = function() {
		$('#btn--update__confirmed').on('click', function() {
			let task = {
				code: $('#taskCode').val(),
				action: TASK_CONFIRM_ENUM.CONFIRMED
			};
			showLoading();
			$.ajax({
				url: getContext() + '/api/task/confirm',
				method: 'POST',
				contentType: 'application/json',
				data: JSON.stringify(task), 
				success: function(response) {
					if (response) {
						if (response.code === '200') location.reload();
						else alert(response.message);
					}
				},
				error: function(error) {
					console.log("ERROR: " + error);
				}
			}).always(() => hideLoading());
		});
	}

	/**
	 * Event to send cause reject task
	 */
	const _eventSendCauseToReject = function() {
		$('#btn__send--cause').on('click', function(){
			let causeContent = $('#inputCause').val();

			if (causeContent && causeContent.trim().length > 20) {
				let task = {
					code: $('#taskCode').val(),
					cause: causeContent,
					action: TASK_CONFIRM_ENUM.REJECTED
				};
				showLoading();
				$.ajax({
					url: getContext() + '/api/task/confirm',
					method: 'POST',
					contentType: 'application/json',
					data: JSON.stringify(task),
					success: function(response) {
						if (response) {
							if (response.code === '200') location.reload();
							else alert(response.message);
						}
					},
					error: function(error) {
						$('#message__response').html('Từ chối công việc thất bại.');
						setTimeout(() => {
							$('#message__response').html('');
						}, 3000);
					}
				}).always(() => hideLoading());
			} else
				$('#request__enter--cause .message').html("Nguyên nhân từ chối tiếp nhận phải nhiều hơn 20 ký tự")
		});
	}

	const _eventListenerTaskHistoryAppended = function() {
		let isCollapsed = false;
		$('#btn--task__history').on('click', function(){
			$('.task--history__container').toggleClass('collapse');
			isCollapsed = !isCollapsed;
			$('#btn--task__history').text(isCollapsed ? 'Hiện chi tiết' : 'Ẩn chi tiết');
		});
	}

	const _validateForm = function() {
		let taskTitle = $('#task__title').val();
		if (!taskTitle.length > 0) {
			bootbox.alert({
				title: 'Thông báo',
				message: "Vui lòng nhập tiêu đề công việc."
			});
			return false;
		}
		let edit = $('#assigneeUsername').val();
		if (!edit) {
			let assignee = $("#task__assignee").val();
			if (!assignee.length > 0) {
				bootbox.alert({
					title: 'Thông báo',
					message: "Vui lòng phân phối công việc tối thiểu 1 người"
				});
				return false;
			} return true;
		}

		let time1 = $("input[name='time1']").val();
		if (time1 && !time1.length > 0) {
			let unit1 = $("#unit1").val();
			if (!unit1.length > 0) {
				bootbox.alert({
					title: 'Thông báo',
					message: 'Vui lòng chọn đơn vị thời gian cho lần thông báo 1'
				});
				return false;
			}
		}
		let time2 = $("input[name='time2']").val();
		if (time2 && time2.length > 0) {
			let unit2 = $("#unit2").val();
			if (!unit2.length > 0) {
				bootbox.alert({
					title: 'Thông báo',
					message: 'Vui lòng chọn đơn vị thời gian cho lần thông báo 2'
				});
				return false;
			}
		}
		return true;
	}

	const _onSave = function() {
		$('#btn--submit').on('click', function(e) {
			e.preventDefault();
			if (_validateForm()) {
				$('#task__form').submit();
			}
		})
	}

	const _eventKeypress = function() {
		let time1 = $('input[name="time1"]');
		time1.on('keypress', function(e) {
			let vlua = this.value;
			if (vlua.length >2) time1.val(vlua.substring(0, 2));
		});

		let time2 = $('input[name="time2"]');
		time2.on('keypress', function(e) {
			let vlua = this.value;
			if (vlua.length >2) time2.val(vlua.substring(0, 2));
		});
	}

	const showLoading = () => $('#modalLoading').addClass('d-block').removeClass('d-none');
	const hideLoading = () => $('#modalLoading').addClass('d-none').removeClass('d-block');

  return {
    init: function() {
      _initDatePicker();
			_initComponentAnyTime();
			_eventListenerShowTaskConfirm();
			_eventRequestEnterCauseToReject();
			_eventListenerTaskHistoryAppended();
			_eventKeypress();
			// event confirm
			_eventSendCauseToReject();
			_eventConfirmTask();
			// on submit
			_onSave();
    }
  }
}();

document.addEventListener("DOMContentLoaded", function() {
  TaskFormComponent.init();
});
