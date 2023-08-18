package com.keysoft.pigfarm.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.keysoft.pigfarm.config.ServiceProperties;
import com.keysoft.pigfarm.constant.ApiEnum;
import com.keysoft.pigfarm.integration.EntityResponse;
import com.keysoft.pigfarm.production.dto.TaskDto;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class TaskManager {
	@Autowired
	private RestHelper restHelper;
	@Autowired
	private ServiceProperties serviceProperties;
	
	public EntityResponse getOrSearch(TaskDto criteria) {
		log.info("ENTERING: get-or-search, criteria={}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_TASK_SEARCH.val), HttpMethod.POST, criteria, EntityResponse.class);
		return (EntityResponse) response.getBody();
	}
	
	public EntityResponse save(TaskDto taskDto) {
		log.info("ENTERING: get-or-search, criteria={}", taskDto);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_TASK_SAVE.val), HttpMethod.POST, taskDto, EntityResponse.class);
		return (EntityResponse) response.getBody();
	}
	
	public TaskDto getByCode(String code) {
		log.info("ENTERING: get-by-code, {}", code);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_TASK_GET.val), HttpMethod.GET, TaskDto.class, code);
		return (TaskDto) response.getBody();
	}
	
	public EntityResponse confirmTask(TaskDto task) {
		log.info("ENTERING: confirm-task");
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_TASK_CONFIRM.val), HttpMethod.POST, task, EntityResponse.class);
		return (EntityResponse) response.getBody();
	}
	
	public EntityResponse updateProgress(TaskDto task) {
		log.info("ENTERING: update-progress: task={}", task);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_TASK_UPDATE_PROGRESS.val), HttpMethod.POST, task, EntityResponse.class);
		return (EntityResponse) response.getBody();
	}
	
	public EntityResponse sendNotification(TaskDto task) {
		log.info("ENTERING: send-notification: task={}", task);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_TASK_NOTIFICATION.val), HttpMethod.POST, task, EntityResponse.class);
		return (EntityResponse) response.getBody();
	}

	public EntityResponse getDataViewMode(TaskDto criteria) {
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_TASK_VIEW_MODE.val), HttpMethod.POST, criteria, EntityResponse.class);
		return (EntityResponse) response.getBody();
	}
	
	public EntityResponse searchDataViewMode(TaskDto criteria) {
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_TASK_VIEW_MODE_SEARCH.val), HttpMethod.POST, criteria, EntityResponse.class);
		return (EntityResponse) response.getBody();
	}

	public EntityResponse getDataCalendar(TaskDto criteria) {
		log.info("process=get-data-calendar()");
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_TASK_CALENDAR.val), HttpMethod.POST, criteria, EntityResponse.class);
		return (EntityResponse) response.getBody();
	}

	public EntityResponse requestRejectFrequency(TaskDto task) {
		log.info("process=request-reject-frequency()...");
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_TASK_REQUEST_TO_REJECT_FREQUENCY.val), HttpMethod.POST, task, EntityResponse.class);
		return (EntityResponse) response.getBody();
	}

    public EntityResponse addComment(TaskDto task) {
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_TASK_ADD_COMMENT.val), HttpMethod.POST, task, EntityResponse.class);
		return (EntityResponse) response.getBody();
    }

    public Boolean cloneTask() {
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_TASK_CLONE.val), HttpMethod.POST, Boolean.class);
		return (Boolean) response.getBody();
    }

    public EntityResponse acceptRejectFrequency(TaskDto task) {
		log.info("process=accept-reject-frequency()...");
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_TASK_ACCEPT_TO_REJECT_FREQUENCY.val), HttpMethod.POST, task, EntityResponse.class);
		return (EntityResponse) response.getBody();
    }
}
