let TaskCalendarComponent = function() {
	let calendar;

	let _initCalendar = function() {
		// Basic view
		let taskCalendar = document.getElementById("calendar");
		calendar = new FullCalendar.Calendar(taskCalendar, {
			headerToolbar: {
				left: 'prev,next today',
				center: 'title',
				right: ''
			},
			initialDate: new Date(),
			editable: true,
			events: function(info, successCallback, failureCallback) {
				// console.log(info)
				let criteria = {
					searchFromDateStr: info?.startStr,
					searchToDateStr: info?.endStr
				};
				$.ajax({
					url: getContext() + `/api/task/calendar`,
					method: 'POST',
					contentType: 'application/json',
					data: JSON.stringify(criteria),
					success: function (response) {
						if (response?.code === '200') {
							successCallback(response.data)
						} else {
							failureCallback(response);
						}
					}, error: function(error) {
						console.log(error);
						failureCallback(error);
					}
				});
			},
			eventClick: function(info) {
				info.el.style.borderColor = 'red';
			}
		});

		calendar.render();
	};

  return {
    init: function() {
		_initCalendar();
	}
  }
}();

document.addEventListener("DOMContentLoaded", function() {
  TaskCalendarComponent.init();
});
