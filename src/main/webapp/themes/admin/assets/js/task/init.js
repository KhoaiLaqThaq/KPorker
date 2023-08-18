const VIEW_MODE = {
  TABLE: 'table',
  LIST: 'list',
  CALENDAR: 'calendar'
}

var TaskInit = function() {
  var _loaded = function() {
    let pathName = window.location.pathname;

    if (pathName.includes(VIEW_MODE.TABLE)) {
      $('#viewMode').html("Bảng");
      $('.view__mode--table').addClass('active');
    } else if (pathName.includes(VIEW_MODE.LIST)) {
      $('#viewMode').html("Danh sách");
      $('.view__mode--list').addClass('active');
    } else {
      $('#viewMode').html("Lịch");
      $('.view__mode--calendar').addClass('active');
    }
  }

  var _setHeightContent = function() {
    let height = window.innerHeight - 185;
    $('#task--table__container').css("maxHeight", height);
  }

  var _changeViewMode = function() {
    $('#view--model__table').on('click', function() {
			showModal();
            location.href = "/task/table";
		});

     $('#view--model__list').on('click', function() {
			showModal();
            location.href = "/task/list";
		});

     $('#view--model__calendar').on('click', function() {
			showModal();
            location.href = "/task/calendar";
		});
  }

  const _eventToTaskClone = function() {
      $('#btnTaskClone').on('click', function() {
          showModal();
         $.ajax({
             url: `${getContext()}/api/task/clone`,
             method: 'GET',
             contentType: 'application/json',
             success: function(res) {
                 if (res) {
                     bootbox.alert({
                         title: "Thông báo",
                         message: "Clone công việc thành công"
                     });
                 }
                 else {
                     bootbox.alert({
                         title: "Thông báo",
                         message: "Lỗi!!! Clone công việc không thành công!"
                     });
                 }
             },
             error: function(err) {
                 console.log('ERROR: ', err);
             }
         }).always(() => hideModal());
      });
    }

  var showModal = () => $('#modalLoading').addClass('d-block').removeClass('d-none');
	var hideModal = () => $('#modalLoading').addClass('d-none').removeClass('d-block');

  return {
    init: function() {
      _loaded();
        _eventToTaskClone();
      _setHeightContent();
      _changeViewMode();
    },
    useResize: function() {
      _setHeightContent();
    }
  }
}();

document.addEventListener("DOMContentLoaded", function() {
  TaskInit.init();
});

window.addEventListener('resize', function() {
  console.log('resize')
  TaskInit.useResize();
})
