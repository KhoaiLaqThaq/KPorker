package com.keysoft.pigfarm.manager;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.keysoft.pigfarm.config.ServiceProperties;
import com.keysoft.pigfarm.constant.ApiEnum;
import com.keysoft.pigfarm.integration.EntityResponse;
import com.keysoft.pigfarm.production.dto.PeriodCloseExceptionDto;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class PeriodCloseManager {
	@Autowired
	private RestHelper restHelper;
	@Autowired
	private ServiceProperties serviceProperties;
	
	@SuppressWarnings("unchecked")
	public List<PeriodCloseExceptionDto> gets(PeriodCloseExceptionDto criteria) {
		log.info("PROCESS: GET LIST PERIOD CLOSE EXCEPTION");
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PERIOD_CLOSE_EXCEPTION_GETS.val), HttpMethod.POST, criteria, new ParameterizedTypeReference<List<PeriodCloseExceptionDto>>() {});
		return (List<PeriodCloseExceptionDto>) response.getBody();
	}
	
	public EntityResponse closePeriodAllInstock() {
		log.info("PROCESS: CLOSE PERIOD METHOD");
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PERIOD_CLOSE_EXCEPTION.val), HttpMethod.GET, EntityResponse.class);
		return (EntityResponse) response.getBody();
	}
	
	public EntityResponse save(PeriodCloseExceptionDto criteria) {
		log.info("PROCESS: CREATE CLOSE PERIOD EXCEPTION METHOD");
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PERIOD_CLOSE_EXCEPTION_CREATE.val), HttpMethod.POST, criteria, EntityResponse.class);
		return (EntityResponse) response.getBody();
	}
	
	public EntityResponse delete(Long id) {
		log.info("PROCESS: DELETE PERIOD CLOSE EXCEPTION, ID: {}", id);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PERIOD_CLOSE_EXCEPTION_DELETE.val), HttpMethod.DELETE, EntityResponse.class,id);
		return (EntityResponse) response.getBody();
	}
}
