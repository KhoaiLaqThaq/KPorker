let FormComponent = function() { 
	let documentFiles = []
	let filesToDelete = []
	   
	const showLoading = () => $('#modalLoading').addClass('d-block').removeClass('d-none');
    const hideLoading = () => $('#modalLoading').addClass('d-none').removeClass('d-block');
	
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
		let documentType = $(this).closest('.document-type').attr('id');
		
		// Remove files with matching documentType from documentFiles array
 		documentFiles = documentFiles.filter(function(file) {
    		return file.functionType !== documentType;
  		});

        $.each(files, function (key, value) {
          if(value != null){
			documentFiles.push({
				'file' 		   : value,
				'functionType' : documentType
			})
		  }
         });  
      }).on('fileremoved', function(event, id, index) {
		// Get the files from $(".file-input-preview")
  		let files = $(this).fileinput('getFileStack');

  		let documentType = $(this).closest('.document-type').attr('id');
		
		// Remove files with matching documentType from documentFiles array
 		documentFiles = documentFiles.filter(function(file) {
    		return file.functionType !== documentType;
  		});

        $.each(files, function (key, value) {
          if(value != null){
			documentFiles.push({
				'file' 		   : value,
				'functionType' : documentType
			})
		  }
         });  
	  });

	$("#documentForm").on('submit', function(e){
		e.preventDefault()
		
		let id = $("#id").val();
		if(id.length <= 0) {
			bootbox.alert({
				title: "Thông báo",
				message: "Mã tài liệu không hợp lệ."
			});
			return;
		}
		
		var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
		var email = "";
		var errorEmails = [];
		var elements = $('#emailId .token-label');
		if(elements) {
			for(let i = 0; i < elements.length; i++) {
				let subEmail = elements[i].outerText;
				var isValidEmail = emailRegex.test(subEmail);
				if (isValidEmail) {
					email = email + "," + subEmail;
				} else {
					errorEmails.push(subEmail);
				}
			}
		}

		var ccEmail = "";
		var elementCcEmails = $('#ccEmailId .token-label');
		if(elementCcEmails) {
			for(let i = 0; i < elementCcEmails.length; i++) {
				let subEmail = elementCcEmails[i].outerText;
				var isValidEmail = emailRegex.test(subEmail);
				if (isValidEmail) {
					ccEmail = ccEmail + "," + subEmail;
				} else {
					errorEmails.push(subEmail);
				}
			}
		}

		if(errorEmails.length > 0) {
			bootbox.alert({
				title: "Thông báo",
				message: "Một số email định dạng không đúng: " + JSON.stringify(errorEmails),
			});
			return;
		} else {
			if(email.length > 0) {
				email = email.substring(1);
			}
		}

		var content = $('#content').val();
		const document = {
			'id' 			: id,
			'email'			: email,
			'ccEmail'			: ccEmail.substring(1),
			'content'			: content,
			'description'	: $("#description").val().trim(),

		}
		
		let formData = new FormData();
		
		for (const [key, value] of Object.entries(document)) {
  			formData.append(key, value);
		} 
		
		documentFiles.forEach(function (item, index) {
			formData.append("files["+ index +"].file", item.file)
			formData.append("files["+ index +"].functionType", item.functionType)
		});
		
		if(filesToDelete.length > 0) {
			filesToDelete.forEach(function (file, index) {
				formData.append("filesToDelete["+ index +"]", file);
			})
		}

		let checkSubmitForm = true;
		if(filesToDelete.length > 0) {
			checkSubmitForm = false;
			bootbox.confirm({
				title: "Xác nhận:",
			 	   message: "Có file sẽ bị xóa ! Bạn có muốn tiếp tục ?",
			 	   buttons: {
			 	       confirm: {
			 	           label: 'Xác nhận',
			 	           className: 'btn-success'
			 	       },
			 	       cancel: {
			 	           label: 'Từ chối',
			 	           className: 'btn-danger'
			 	       }
			 	   },
				    callback: function (result) {
				    	if(result){
							showLoading();
							$.ajax({
								method: 'POST',
								url: getContext() + "/document/save",
								cache: false,
								processData: false, // Important!
								contentType: false, // Important! I set dataType above as Json
								data: formData,
								success: function(data) {
									if (data) {
										bootbox.alert({
											title: "Thông báo:",
											message: "Đã cập nhật tài liệu",
											callback: function() { window.location.replace(getContext() + "/document/list"); }
										});
									} else {
										bootbox.alert({
											title: "Thông báo:",
											message: "Cập nhật tài liệu không thành công.",
										});
									}
								}, error: function(error) {
									console.log('ERROR:', error);
									bootbox.alert({
										title: "Thông báo:",
										message: "Cập nhật tài liệu không thành công.",
									});
								}
							}).always(() => hideLoading());
				    	} else {
							return;
						}
				    }
			});
		}

		if(checkSubmitForm) {
			showLoading();
			$.ajax({
				method: 'POST',
				url: getContext() + "/document/save",
				cache: false,
				processData: false, // Important!
				contentType: false, // Important! I set dataType above as Json
				data: formData,
				success: function(data) {
					if (data) {
						bootbox.alert({
							title: "Thông báo:",
							message: "Đã cập nhật tài liệu",
							callback: function() { window.location.replace(getContext() + "/document/list"); }
						});
					} else {
						bootbox.alert({
							title: "Thông báo:",
							message: "Cập nhật tài liệu không thành công.",
						});
					}
				}, error: function(error) {
					console.log('ERROR:', error);
					bootbox.alert({
						title: "Thông báo:",
						message: "Cập nhật tài liệu không thành công.",
					});
				}
			}).always(() => hideLoading());
		}
	  });
	}
	
	
	const getPhotoExisted = function(id) {
	  let dataFinal = [];
	  let images = $(".image-files-" + id);
	  if (images) {
		  let imageUrls = images.val();
		  if (imageUrls && imageUrls.length > 0) {
			  for (let image of imageUrls.split(',')) {
				  dataFinal.push(image);
			  }
			  
		  }
	  }
	  return dataFinal;
  }

  const getVideoExisted = function(id) {
	  let dataFinal = [];
	  let videos = $(".video-files-" + id);
	  if (videos) {
		  let videoUrls = videos.val();
		  if (videoUrls && videoUrls.length > 0) {
			  for (let video of videoUrls.split(',')) {
				  dataFinal.push(video);
			  }
		  }
	  }
	  return dataFinal;
  }

  const _initPreview = function() {
		const canDelete = $('#canDelete').length > 0;
	
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
			removeIcon: canDelete ? '<i class="icon-bin"></i>' : '',
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

		$('.document-type').each(function() {
  			let documentTypeId = $(this).attr('id');
	
			if($('.document-list-file-'+ documentTypeId).find('.has-content').length <= 0) {
				$('.document-list-preview-' + documentTypeId).removeClass('col-md-8');
				$('.document-list-file-' + documentTypeId).remove();
			}
			
			let data = getPhotoExisted(documentTypeId);
			$('.file-input-overwrite-' + documentTypeId).fileinput({
				showClose: true,
				showCaption: false,
				showUpload: false,
				layoutTemplates: {
					icon: '<i class="icon-file-check"></i>',
					modal: modalTemplate
				},
				initialPreview: data,
				initialPreviewConfig: [
					{showDrag: false, showRemove: canDelete ? true : false}
				],
				//defaultPreviewContent: imgTag,
				initialPreviewAsData: true,
				overwriteInitial: true,
				previewZoomButtonClasses: previewZoomButtonClasses,
				previewZoomButtonIcons: previewZoomButtonIcons,
				fileActionSettings: fileActionSettings
			});
			
			let dataVideo = getVideoExisted(documentTypeId);
			let videoPreviewConfigs = []
			
			for (i in dataVideo) {
				const config = {
					 showDrag: false,
					 showRemove: canDelete ? true : false,
					 type: "video",
					 filetype: "video/mp4",
				}
				
				videoPreviewConfigs.push(config)
			}
			
			$('.file-input-overwrite-video-'+ documentTypeId).fileinput({
				showClose: true,
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
		});
		
		$(".tab-pane .fileinput-remove").hide();
		$(".tab-pane .fileinput-cancel").hide();
		$(".old-files .btn-file").hide();
	}
	
	var _removePreviewFile = function() {
		$(".old-files .kv-file-remove").on('click', function() {
			let previewFrame = $(this).closest('.file-preview-frame').attr('id');
			let imageToDelete = $('#' + previewFrame + ' .kv-preview-data').attr('src');
			let videoToDelete = $('#' + previewFrame + ' .kv-preview-data source').attr('src');
						
			if(typeof imageToDelete !== "undefined" && imageToDelete.length > 0){
				$("#" + previewFrame).next('.kv-zoom-cache').remove();
				$("#" + previewFrame).remove();
				filesToDelete.push(imageToDelete);
				return;
			} 
			
			if(typeof videoToDelete !== "undefined" && videoToDelete.length > 0){
				$("#" + previewFrame).next('.kv-zoom-cache').remove();
				$("#" + previewFrame).remove();
				filesToDelete.push(videoToDelete);
				return;
			}
		})
		
		$(".old-files .delete-file").on('click', function() {
			let fileToDelete = $(this).find('input').val();
			let previewFrame = $(this).parents('.has-content');
			
			if(fileToDelete.length > 0){
				previewFrame.remove();
				filesToDelete.push(fileToDelete);
			}
		})
	}
	
	// Tokenfield
    var _componentTokenfield = function() {
        if (!$().tokenfield) {
            console.warn('Warning - tokenfield.min.js is not loaded.');
            return;
        }

        // Basic initialization
        $('.tokenfield').tokenfield();

    };

    // Tags input
    var _componentTagsinput = function() {
        if (!$().tagsinput) {
            console.warn('Warning - tagsinput.min.js is not loaded.');
            return;
        }
        $('.tags-input').tagsinput();
    };
	
    // Check non image/video file previews
	var checkFilePreview = function() {
		if ($('.old-files').length > 0) {
  			$('.old-files').each(function() {
    			var documentsPreview = $(this).find('.document-preview');

				if($(this).find('.document-list').length <= 0 && documentsPreview.length > 0)
					documentsPreview.removeClass('col-lg-8');
  			});
		}
	}

	var changeRowTextArea = function() {
		var valueTextArar = $("#content").val();
		if(valueTextArar) {
			var element = document.getElementById('content');
			element.style.overflowY = "hidden";
			element.style.height = "auto";
			element.style.height = `${element.scrollHeight}px`;
		}
	}
	
    return {
        init: function() {
        	_componentTokenfield();
        	_componentTagsinput();
			_componentFileUpload();
			_initPreview();
			_removePreviewFile();
			checkFilePreview();
			changeRowTextArea();
        }
    }
}();

var DocumentForm = {
	changeRowTextArea: function(){
		// Sử dụng JavaScript để tự động co giãn textarea
		document.getElementById('content').addEventListener('input', function () {
		 this.style.height = 'auto';
		  this.style.height = (this.scrollHeight) + 'px';
		  });
	},
	
};

// Initialize module
// ------------------------------

document.addEventListener('DOMContentLoaded', function() {
	FormComponent.init();
});
