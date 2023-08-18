const TASK_CONFIRM_ENUM = {
	CONFIRMED: 'confirmed',
	REJECTED: 'rejected',
	REQUEST: 'request-to-reject-frequency',
	ACCEPT: 'accept-to-reject-frequency',
	COMMENT: 'comment',
};

const TaskFormComponent = function() {

	let isClicked = false;

  const _componentFileUpload = function() {
    if (!$().fileinput) {
      console.warn('Warning - fileinput.min.js is not loaded.');
      return;
    }

    // Modal template
    let modalTemplate = '<div class="modal-dialog modal-lg" role="document">\n' +
      '  <div class="modal-content">\n' +
      '    <div class="modal-header align-items-center">\n' +
      '      <h6 class="modal-title">{heading} <small><span class="kv-zoom-title"></span></small></h6>\n' +
      '      <div class="kv-zoom-actions btn-group">{toggleheader}{fullscreen}{borderless}{close}</div>\n' +
      '    </div>\n' +
      '    <div class="modal-body">\n' +
      '      <div class="floating-buttons btn-group"></div>\n' +
      '      <div class="kv-zoom-body file-zoom-content"></div>\n' + '{prev} {next}\n' +
      '    </div>\n' +
      '  </div>\n' +
      '</div>\n';

      // Buttons inside zoom modal
      let previewZoomButtonClasses = {
        toggleheader: 'btn btn-light btn-icon btn-header-toggle btn-sm',
        fullscreen: 'btn btn-light btn-icon btn-sm',
        borderless: 'btn btn-light btn-icon btn-sm',
        close: 'btn btn-light btn-icon btn-sm'
      };

      // Icons inside zoom modal classes
      let previewZoomButtonIcons = {
        prev: '<i class="icon-arrow-left32"></i>',
        next: '<i class="icon-arrow-right32"></i>',
        toggleheader: '<i class="icon-menu-open"></i>',
        fullscreen: '<i class="icon-screen-full"></i>',
        borderless: '<i class="icon-alignment-unalign"></i>',
        close: '<i class="icon-cross2 font-size-base"></i>'
      };

      // File actions
      let fileActionSettings = {
        zoomClass: '',
        zoomIcon: '<i class="icon-zoomin3"></i>',
        dragClass: 'p-2',
        dragIcon: '<i class="icon-three-bars"></i>',
        removeClass: '',
        removeErrorClass: 'text-danger',
        removeIcon: '<i class="icon-bin"></i>',
        indicatorNew: '<i class="icon-file-plus text-success"></i>',
        indicatorSuccess: '<i class="icon-checkmark3 file-icon-large text-success"></i>',
        indicatorError: '<i class="icon-cross2 text-danger"></i>',
        indicatorLoading: '<i class="icon-spinner2 spinner text-muted"></i>'
      };
    
      $('.file-input').fileinput({
        browseLabel: 'Browse',
        browseIcon: '<i class="icon-file-plus mr-2"></i>',
        uploadIcon: '<i class="icon-file-upload2 mr-2"></i>',
        removeIcon: '<i class="icon-cross2 font-size-base mr-2"></i>',
        layoutTemplates: {
            icon: '<i class="icon-file-check"></i>',
            modal: modalTemplate
        },
        initialCaption: "No file selected",
        previewZoomButtonClasses: previewZoomButtonClasses,
        previewZoomButtonIcons: previewZoomButtonIcons,
        fileActionSettings: fileActionSettings
      });

      let formData = new FormData();

      $(".file-input-preview").fileinput({
        theme: 'fa',
        uploadUrl: "#",
        uploadAsync: false,
        required: true,
        overwriteInitial: false,
        initialPreviewAsData: true, // identify if you are sending preview data only and not the raw markup
        initialPreviewFileType: 'image', // image is the default and can be overridden in config below
        showUpload: false,
        showRemove: false,
        fileActionSettings: fileActionSettings
      }).on('filebatchselected', function(e, files) {
				formData = new FormData();
        $.each(files, function (key, value) {
          if(value != null){
            formData.append("photos", value, value.name); 
						// photos.push(value);
          }
        });        
      });

	  $('#btn--submit__progress').on('click', function(e){
		e.preventDefault();
		const values = [...formData.entries()];
		if (isClicked) {
			if (values.length < 1) {
				bootbox.alert({
					title: "Thông báo",
					message: "Yêu cầu tối thiểu một hình ảnh chứng minh đã hoàn thành."
				});
				return false;
			}
		}

		$('#modal--task__progress').hide();
		showLoading();
		var model_data = $("#updateProgress").serializeArray();
		$.each(model_data,function(key, input){
			formData.append(input.name,input.value);
		});

		if (isClicked) formData.append("action", "additional")

		$.ajax({
			method: 'POST',
			url: getContext() + "/task/progress",
			cache: false,
			processData: false, // Important!
			contentType: false, // Important! I set dataType above as Json
			data: formData,
			success: function(data) {
				if (data == true) {
					bootbox.alert({
						title: "Thông báo:",
						message: "Tải tệp tin thành công.",
					});
					location.reload();
				} else {
					bootbox.alert({
						title: "Thông báo:",
						message: "Tải tệp tin không thành công.",
					});
					location.reload();
				}
			}, error: function(error) {
				console.log('ERROR:', error);
				bootbox.alert({
					title: "Thông báo:",
					message: "Upload không thành công.",
				});
				location.reload();
			}
		}).always(() => hideLoading());
	  });
  }

  const getPhotoExisted = function() {
	  let dataFinal = [];
	  let images = $("input[name='imageAttachments']");
	  if (images) {
		  let imageUrls = images.val();
		  if (imageUrls && imageUrls.length > 0) {
			  let photoUrls = imageUrls.split(',');
			  for (let i = 0; i < photoUrls.length; i++) {
				  let element = photoUrls[i];
				  dataFinal.push(element);
			  }
		  }
	  }
	  return dataFinal;
  }

  const getVideoExisted = function() {
	  let dataFinal = [];
	  let videos = $("input[name='videoAttachments']");
	  if (videos) {
		  let videoUrls = videos.val();
		  if (videoUrls && videoUrls.length > 0) {
			  let listVideoUrl = videoUrls.split(',');
			  for (let i = 0; i < listVideoUrl.length; i++) {
				  let element = listVideoUrl[i];
				  dataFinal.push(element);
			  }
		  }
	  }
	  return dataFinal;
  }

  const _initPreviewEvidence = function() {
	  let status = $("#taskStatus");
	  if (status.val() === 'done') {
		  // Buttons inside zoom modal
		  let previewZoomButtonClasses = {
			  toggleheader: 'btn btn-light btn-icon btn-header-toggle btn-sm',
			  fullscreen: 'btn btn-light btn-icon btn-sm',
			  borderless: 'btn btn-light btn-icon btn-sm',
			  close: 'btn btn-light btn-icon btn-sm'
		  };

		  // Icons inside zoom modal classes
		  let previewZoomButtonIcons = {
			  prev: '<i class="icon-arrow-left32"></i>',
			  next: '<i class="icon-arrow-right32"></i>',
			  toggleheader: '<i class="icon-menu-open"></i>',
			  fullscreen: '<i class="icon-screen-full"></i>',
			  borderless: '<i class="icon-alignment-unalign"></i>',
			  close: '<i class="icon-cross2 font-size-base"></i>'
		  };

		  // File actions
		  let fileActionSettings = {
			  zoomClass: '',
			  zoomIcon: '<i class="icon-zoomin3"></i>',
			  dragClass: 'p-2',
			  dragIcon: '',
			  removeClass: '',
			  removeErrorClass: 'text-danger',
			  removeIcon: '',
			  indicatorNew: '<i class="icon-file-plus text-success"></i>',
			  indicatorSuccess: '<i class="icon-checkmark3 file-icon-large text-success"></i>',
			  indicatorError: '<i class="icon-cross2 text-danger"></i>',
			  indicatorLoading: '<i class="icon-spinner2 spinner text-muted"></i>'
		  };

		  // Modal template
		  let modalTemplate = '<div class="modal-dialog modal-lg" role="document">\n' +
			  '  <div class="modal-content">\n' +
			  '    <div class="modal-header align-items-center">\n' +
			  '      <h6 class="modal-title">{heading} <small><span class="kv-zoom-title"></span></small></h6>\n' +
			  '      <div class="kv-zoom-actions btn-group">{toggleheader}{fullscreen}{borderless}{close}</div>\n' +
			  '    </div>\n' +
			  '    <div class="modal-body">\n' +
			  '      <div class="floating-buttons btn-group"></div>\n' +
			  '      <div class="kv-zoom-body file-zoom-content"></div>\n' + '{prev} {next}\n' +
			  '    </div>\n' +
			  '  </div>\n' +
			  '</div>\n';

		  let data = getPhotoExisted();
		  $('.file-input-overwrite').fileinput({
			  showClose: false,
			  showCaption: false,
			  showUpload: false,
			  layoutTemplates: {
				  icon: '<i class="icon-file-check"></i>',
				  modal: modalTemplate
			  },
			  initialPreview: data,
			  initialPreviewConfig: [
				  {showDrag: false, showRemove: false}
			  ],
			  //defaultPreviewContent: imgTag,
			  initialPreviewAsData: true,
			  overwriteInitial: true,
			  previewZoomButtonClasses: previewZoomButtonClasses,
			  previewZoomButtonIcons: previewZoomButtonIcons,
			  fileActionSettings: fileActionSettings
		  });

		  let dataVideo = getVideoExisted();
		  let videoPreviewConfigs = []

		  for (i in dataVideo) {
			  const config = {
				  showDrag: false,
				  showRemove: false,
				  type: "video",
				  filetype: "video/mp4",
			  }

			  videoPreviewConfigs.push(config)
		  }
		  $('.file-input-overwrite-video').fileinput({
			  showClose: false,
			  showCaption: false,
			  showUpload: false,
			  browseIcon: '<i class="icon-file-plus mr-2"></i>',
			  uploadIcon: '<i class="icon-file-upload2 mr-2"></i>',
			  removeIcon: '<i class="icon-cross2 font-size-base mr-2 delVideoIntroMenu"></i>',
			  layoutTemplates: {
				  icon: '<i class="icon-file-check"></i>',
				  modal: modalTemplate
			  },
			  initialPreview: dataVideo,
			  initialPreviewConfig: videoPreviewConfigs,
			  initialPreviewAsData: true,
			  overwriteInitial: true,
			  previewZoomButtonClasses: previewZoomButtonClasses,
			  previewZoomButtonIcons: previewZoomButtonIcons,
			  fileActionSettings: fileActionSettings
		  });

		  $(".fileinput-remove").hide();
		  $(".fileinput-cancel").hide();

		  $(".file-input-new .btn-file").hide();
		  $(".video-loading .btn-file").hide();
	  }
  }

  const _loadPhotoExited = function() {
	  $("#tabTitleEvidence").on('click', function() {
		  _initPreviewEvidence();
	  });
  }

	/**
	 * Initial function to show task modal confirm
	 */
	const _eventListenerShowTaskConfirm = function() {
		$('#btn--update__confirm').on('click', function() {
			let countdown = 5;
			let btnUpdateRejected = $('#btn--update__rejected');
			btnUpdateRejected.find('.icon').html(countdown);
			btnUpdateRejected.prop('disabled', true);
			const countdownToAcceptRejected =  setInterval(() => {
				countdown--;
				$('#btn--update__rejected').find('.icon').html(countdown);
				if (countdown === 1)
					clearInterval(countdownToAcceptRejected);
			}, 1000);
			
			setTimeout(() => {
				btnUpdateRejected.find('.icon').html(`<i class="icon-stack-cancel mr-1"></i>`);
				btnUpdateRejected.prop('disabled', false);
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
						if (response.code === '200') {
							showNotification("Tiếp nhận công việc thành công!");
							location.reload();
						} else {
							showNotification(`Xảy ra lỗi ${response.code}: ${response.message}`);
						}
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
							if (response.code === '200') {
								location.reload();
							} else {
								alert(response.message);
							}
						}
					},
					error: function(error) {
						$('#message__response').html('Từ chối công việc thất bại.');
						setTimeout(() => {
							$('#message__response').html('');
						}, 3000);
					}
				}).done(() => {
					hideLoading();
				})
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

	const _eventListenerRequestRejectFrequency = function() {
		$('#btn__request--frequency').on('click', function() {
			let task = {
				code: $('#taskCode').val(),
				action: TASK_CONFIRM_ENUM.REQUEST
			};
			showLoading();
			$.ajax({
				url: `${getContext()}/api/task/request-reject-frequency`,
				method: 'POST',
				contentType: 'application/json',
				data: JSON.stringify(task),
				success: function(response) {
					if (response?.code === '200') location.reload();
					else if (response?.code === '404') showNotification("Không tìm thấy công việc");
					else if (response?.code === '500') showNotification("Có lỗi không xác định");
					else showNotification("Lỗi gì đó!");
				}, error: function(error) { console.log("ERROR: Something wrong! ", error.toString()) }
			}).always(() => hideLoading());
		});
	}

	const showNotification = (message) => {
		bootbox.alert({
			title: 'Thông báo',
			message: message
		});
	}

	// event listener to focus input comment, then to show the button save comment
	const _eventFocusCommentInput = function() {
		$('#cmt').on('focus', function() {
			$('#btnSaveComment').show();
		})
	}

	// event to save comment
	const _eventListenerToClickSaveComment = function() {
		$("#btnSaveComment").on('click', function() {
			let commentSelector = $('#cmt');
			if (commentSelector && commentSelector.val().trim().length > 0) {
				let task = {
					code: $('#taskCode').val(),
					action: TASK_CONFIRM_ENUM.COMMENT,
					commentContent: $('#cmt').val()
				};

				showLoading();
				$.ajax({
					url: `${getContext()}/api/task/addComment`,
					method: 'POST',
					contentType: 'application/json',
					data: JSON.stringify(task),
					success: function(response) {
						if (response) {
							if (response.code === '200') {
								showNotification('Thêm bình luận thành công!');
								location.reload();
							} else if (response.code === '500') {
								showNotification('Thêm bình luận không thành công!');
							} else {
								showNotification('Xảy ra lỗi gì đó, bình luận không thành công');
							}
						}
					}, error: function(error) {
						console.log(error);
					}
				}).always(() => hideLoading());
			} else showNotification('Bình luận không hợp lệ!')
		});
	}

	/**
	 * Event accept to reject frequency
	 * @private
	 */
	const _eventListenerToClickAcceptRejectFrequency = function() {
		$('#btnAccept').on('click', function() {
			showLoading();
			let task = {
				id: $('#taskId').val(),
				action: TASK_CONFIRM_ENUM.ACCEPT
			};
			$.ajax({
				url: `${getContext()}/api/task/request-reject-frequency/accept`,
				method: 'POST',
				contentType: 'application/json',
				data: JSON.stringify(task),
				success: function(response) {
					if (response) {
						if (response.code === '200') {
							showNotification("Đã huỷ tần suất công việc.");
							location.reload();
						}
					}
				}, error: function(err) {
					console.log("ERROR: ", err);
				}
			}).always(() => hideLoading());
		})
	}

	const _eventListenerClickEvidenceAdditional = function() {
		$('#btnAdditionEvidence').on('click', function() {
			isClicked = true;
		})
	}

	const showLoading = () => $('#modalLoading').addClass('d-block').removeClass('d-none');
	const hideLoading = () => $('#modalLoading').addClass('d-none').removeClass('d-block');

  return {
    init: function() {
      _componentFileUpload();
		_eventListenerShowTaskConfirm();
		_eventRequestEnterCauseToReject();
		_eventListenerTaskHistoryAppended();
		_eventListenerRequestRejectFrequency();
		_eventFocusCommentInput();
		// event confirm
		_eventSendCauseToReject();
		_eventListenerToClickAcceptRejectFrequency();
		_eventConfirmTask();
		_eventListenerToClickSaveComment();
		// _initPreviewEvidence();
		_loadPhotoExited();
		_eventListenerClickEvidenceAdditional();
    }
  }
}();

document.addEventListener("DOMContentLoaded", function() {
  TaskFormComponent.init();
});