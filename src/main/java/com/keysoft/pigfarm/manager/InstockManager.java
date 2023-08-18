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
import com.keysoft.pigfarm.production.dto.InstockDto;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class InstockManager {
	@Autowired
	private RestHelper restHelper;
	
	@Autowired
	private ServiceProperties serviceProperties;
	
	public PageDto gets(InstockDto criteria) {
		log.info("PROCESS: SEARCH INSTOCK, criteria: {}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_INSTOCK_GETS.val), HttpMethod.POST, criteria, PageDto.class);
		return (PageDto) response.getBody();
	}
	
	public InstockDto getLatestInstock(InstockDto criteria) {
		log.info("PROCESS: SEARCH LATEST INSTOCK, criteria: {}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_INSTOCK_GET_LATEST.val), HttpMethod.POST, criteria, InstockDto.class);
		return (InstockDto) response.getBody();
	}
	
	public InstockDto get(Long id) {
		log.info("PROCESS: GET INSTOCK, INSTOCK_ID: {}", id);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_INSTOCK_GET.val), HttpMethod.GET, InstockDto.class,id);
		return (InstockDto) response.getBody();
	}
	
	@SuppressWarnings("unchecked")
	public List<InstockDto> gets(){
		log.info("PROCESS: GET INSTOCK LATEST");
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_INSTOCK_GETS_BY_LATEST.val), HttpMethod.GET, new ParameterizedTypeReference<List<InstockDto>>() {});
		return (List<InstockDto>) response.getBody();
	}
	
	public EntityResponse importInstock(InstockDto instockDto) {
		log.info("PROCESS: IMPORT INSTOCK, INSTOCK: {}", instockDto);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_INSTOCK_IMPORT.val), HttpMethod.POST, instockDto, EntityResponse.class);
		return (EntityResponse)response.getBody();	
	}

	
}
