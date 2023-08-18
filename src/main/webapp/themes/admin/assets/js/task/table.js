const TASK_FREQUENCY_ENUM = {
	ARISE: 'arise',
	DAY: 'day',
	WEEK: 'week',
	MONTH: 'month'
};

const TASK_GROUP_ENUM = {
  PLAN: 'plan',
	TODO: 'todo',
	OVERDUE: 'overdue',
	DONE: 'done',
  REJECTED: 'rejected'
};

const APP_DEFAULT = {
  SIZE: 5
};

var TaskTableComponent = function() {

  var _showMoreData = function() {
    let defaultPlanPage = 1;
    let defaultTodoPage = 1;
    let defaultOverduePage = 1;
    let defaultDonePage = 1;
    let defaultRejectedPage = 1;

    $("#task--plan__showMore").on('click', function() {
      _restAPI(defaultPlanPage, TASK_GROUP_ENUM.PLAN);
      defaultPlanPage++;
    });

    $("#task--todo__showMore").on('click', function() {
      _restAPI(defaultTodoPage, TASK_GROUP_ENUM.TODO );
      defaultTodoPage++;
    });

    $("#task--overdue__showMore").on('click', function() {
      _restAPI(defaultOverduePage, TASK_GROUP_ENUM.OVERDUE );
      defaultOverduePage++;
    });

    $("#task--done__showMore").on('click', function() {
      _restAPI(defaultDonePage, TASK_GROUP_ENUM.DONE );
      defaultDonePage++;
    });

    $("#task--rejected__showMore").on('click', function() {
      _restAPI(defaultRejectedPage, TASK_GROUP_ENUM.REJECTED );
      defaultRejectedPage++;
    });
  }

  /**
	 * Convert task frequency to text
	 * @param {*} frequency 
	 * @returns 
	 */
	var convertFrequenctToText = function(frequency) {
		switch (frequency) {
			case TASK_FREQUENCY_ENUM.ARISE:
				return "Phát sinh";
			case TASK_FREQUENCY_ENUM.DAY:
				return "Ngày";
			case TASK_FREQUENCY_ENUM.WEEK:
				return "Tuần";
			case TASK_FREQUENCY_ENUM.MONTH:
				return "Tháng";
			default:
				return "Chưa có";
		}
	}

  var _generateTemplate = function(tasks) {
    let checkTaskActionDetail = $('.task--column').find('.task--item__action_detail');
    let checkTaskActionPreview = $('.task--column').find('.task--item__action_preview');
    let template = "";

    for (const task of tasks) {
      template += `<div class="task--column__item mb-2"><div class="task--item__title mb-2"><span>${task.title}</span><div class="task--item__actions">`;
      if (checkTaskActionDetail) template += `<a href="/task/form?code=${task.code}" class="task--item__action_detail"><i class="icon-pencil"></i></a>`;
      if (checkTaskActionPreview) template += `<a href="/task/confirm?code=${task.code}" class="task--item__action_preview"><i class="icon-eye"></i></a>`;
      template += `</div></div>
          <div class="task--item__content">
            <div class="row"><div class="col-12"><p class="mb-0">Mô tả: </p></div><div class="col-12 desc mb-2">${task.description}</div></div>
            <div class="row">
              <div class="col-12 col-md-6"><div class="d-flex"><span><i class="icon-pulse2 mr-2"></i>${convertFrequenctToText(task.frequency)}</span></div></div>
              <div class="col-12 col-md-6 text-right">${task.assigneeFullname}</div>
            </div>
          </div>
        </div>
      `;
    }

    return template;
  }

  var _restAPI = function(page, taskGroup) {
    showModal();
    let criteria = {
      page: page,
      size: APP_DEFAULT.SIZE,
      taskGroup: taskGroup
    };
    $.ajax({
      url: getContext() + `/api/task/viewMode/search`,
      method: 'POST',
      contentType: 'application/json',
      data: JSON.stringify(criteria),
      success: function(response) {
        if (response?.content) {
          let tasks = response.content;
          let templateHTML = _generateTemplate(tasks, taskGroup);
          let taskColumnItem = $(`.task--column.${taskGroup} .task--column__item`);
          $(templateHTML).insertAfter(taskColumnItem.last());
          let countDataRow = taskColumnItem.length;
          if (countDataRow <= response.totalElements) $(`#task--${taskGroup}__showMore`).remove();
        }
      }, error: function(error) {
        console.log("Error: " + error);
      }
    }).always(function() {
      hideModal();
    });
  }

	var showModal = () => $('#modalLoading').addClass('d-block').removeClass('d-none');
	var hideModal = () => $('#modalLoading').addClass('d-none').removeClass('d-block');

  return {
    init: function() {
      _showMoreData();
    }
  }
}();

document.addEventListener("DOMContentLoaded", function() {
  TaskTableComponent.init();
});