const TASK_FREQUENCY_ENUM = {
	ARISE: 'arise',
	DAY: 'day',
	WEEK: 'week',
	MONTH: 'month'
};

const TASK_STATUS_ENUM = {
	ASSIGNED: 'assigned',
	CONFIRMED: 'confirmed',
	EDITED: 'edited',
	NEW: 'new',
	REJECTED: 'rejected',
	REASSIGNED: 'reassigned',
	DONE: 'done'
};

const TASK_GROUP_ENUM = {
	TODO: 'todo',
	OVERDUE: 'overdue',
	DONE: 'done'
};

const TaskListComponent = function() {
  const _initDatePicker = function() {
    /*
     * Initialize the date picker
     */
	  let searchFromDateStr = $('input[name="searchFromDateStr"]');
	  searchFromDateStr.daterangepicker({
			singleDatePicker: true,
		    autoUpdateInput: false,
				locale: {
					cancelLabel: 'Clear',
					format: 'DD-MM-YYYY'
				}
		});

	  searchFromDateStr.on('apply.daterangepicker', function(ev, picker) {
				$(this).val(picker.startDate.format('DD-MM-YYYY'));
		});

	  searchFromDateStr.on('cancel.daterangepicker', function(ev, picker) {
				$(this).val('');
		});

	  let searchToDateStr = $('input[name="searchToDateStr"]');
	  searchToDateStr.daterangepicker({
		singleDatePicker: true,
			autoUpdateInput: false,
				locale: {
						cancelLabel: 'Clear',
						format: 'DD-MM-YYYY'
				}
		});

	  searchToDateStr.on('apply.daterangepicker', function(ev, picker) {
				$(this).val(picker.startDate.format('DD-MM-YYYY'));
		});

	  searchToDateStr.on('cancel.daterangepicker', function(ev, picker) {
				$(this).val('');
		});
	};

	const _onReset = function() {
		$('#btn__reset').on('click', function(e) {
			showModal();
			e.preventDefault();

			$('#task__keyword').val('');
			$('.select2').val('').trigger('change');
			let assigneeUsername = $('#assigneeUsername');
			if (assigneeUsername) assigneeUsername.val('');
			$('#from__date').val('');
			$('#to__date').val('');
			$('form').submit();
		});
	}

	const showModal = () => $('#modalLoading').addClass('d-block').removeClass('d-none');

  return {
    init: function() {
      _initDatePicker();
			_onReset();
    }
  }
}();

document.addEventListener("DOMContentLoaded", function() {
  TaskListComponent.init();
});