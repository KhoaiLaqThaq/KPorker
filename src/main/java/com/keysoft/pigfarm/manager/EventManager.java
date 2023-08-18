package com.keysoft.pigfarm.manager;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.keysoft.pigfarm.common.PageDto;
import com.keysoft.pigfarm.config.ServiceProperties;
import com.keysoft.pigfarm.constant.ApiEnum;
import com.keysoft.pigfarm.integration.EntityResponse;
import com.keysoft.pigfarm.production.dto.EventDto;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class EventManager {
	@Autowired
	private RestHelper restHelper;
	@Autowired
	private ServiceProperties serviceProperties;
	
	
	public PageDto search(EventDto criteria) {
		log.info("PROCESS: SEARCH EVENTS, EVENT: {}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_EVENT_SEARCH.val), HttpMethod.POST, criteria, PageDto.class);
		return (PageDto) response.getBody();
	}
	
	public EventDto get(Long id) {
		log.info("PROCESS: GET EVENT, EVENT_ID: {}", id);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_EVENT_GET.val), HttpMethod.GET, EventDto.class,id);
		return (EventDto) response.getBody();
	}
	
	public EntityResponse save(EventDto event) {
		log.info("PROCESS: GET EVENT, EVENT: {}", event);
		ResponseEntity<?> response = null;
		if (event.getId() != null) {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_EVENT_UPDATE.val), HttpMethod.PUT, event, EntityResponse.class, event.getId());
		} else {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_EVENT_CREATE.val), HttpMethod.POST, event, EntityResponse.class);
		}
		return (EntityResponse)response.getBody();	
	}
	
	public EntityResponse saveDailyAvgWeight(EventDto event) {
		log.info("PROCESS: GET EVENT, EVENT: {}", event);
		ResponseEntity<?> response = null;
		if (event.getId() != null) {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_EVENT_DAILY_AVG_WEIGHT_UPDATE.val), HttpMethod.PUT, event, EntityResponse.class, event.getId());
		} else {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_EVENT_CREATE.val), HttpMethod.POST, event, EntityResponse.class);
		}
		return (EntityResponse)response.getBody();	
	}
	
	@SuppressWarnings("unchecked")
	public List<EventDto> getExport(EventDto criteria) {
		log.info("PROCESS: EXPORT EVENTS, EVENT: {}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_EVENT_EXPORT.val), HttpMethod.POST, criteria, new ParameterizedTypeReference<List<EventDto>>() {});
		return (List<EventDto>) response.getBody();
	}

}
