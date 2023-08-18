package com.keysoft.pigfarm.manager;

import java.util.List;

import com.keysoft.pigfarm.integration.EntityResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.keysoft.pigfarm.common.PageDto;
import com.keysoft.pigfarm.config.ServiceProperties;
import com.keysoft.pigfarm.constant.ApiEnum;
import com.keysoft.pigfarm.production.dto.NotificationDto;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class NotificationManager {
	@Autowired
	private RestHelper restHelper;
	@Autowired
	private ServiceProperties serviceProperties;
	
	public NotificationDto get(Long id) {
		log.info("process=get-notificationDto, notification_id{}", id);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_NOTIFICATION_GET.val), HttpMethod.PUT, NotificationDto.class,id);
		return (NotificationDto) response.getBody();
	}

	@SuppressWarnings("unchecked")
	public List<NotificationDto> gets() {
		log.info("process=gets-all");
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_NOTIFICATION_GETS.val), HttpMethod.GET, new ParameterizedTypeReference<List<NotificationDto>>() {});
		return (List<NotificationDto>) response.getBody();
	}
	
	public PageDto search(NotificationDto criteria) {
		log.info("process=search: {}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_NOTIFICATION_SEARCH.val), HttpMethod.POST, criteria, PageDto.class);
		return (PageDto) response.getBody();
	}

	public EntityResponse updateByTaskCode(String taskCode) {
		log.info("process=update-by-task-code, {}", taskCode);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_NOTIFICATION_UPDATE_BY_TASK_CODE.val), HttpMethod.POST, EntityResponse.class, taskCode);
		return  (EntityResponse) response.getBody();
	}
}
