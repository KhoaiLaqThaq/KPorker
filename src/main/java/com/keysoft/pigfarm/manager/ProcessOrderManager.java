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
import com.keysoft.pigfarm.production.dto.ProcessOrderDto;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ProcessOrderManager {
	@Autowired
	private RestHelper restHelper;
	@Autowired
	private ServiceProperties serviceProperties;
	
	@SuppressWarnings("unchecked")
	public List<ProcessOrderDto> gets() {
		log.info("PROCESS: GET PROCESS_ORDERS");
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PROCESS_ORDER_GETS.val), HttpMethod.GET, new ParameterizedTypeReference<List<ProcessOrderDto>>() {});
		
		return (List<ProcessOrderDto>)response.getBody();
	}
	public ProcessOrderDto get(Long id) {
		log.info("PROCESS: GET PROCESS_ORDER, PROCESS_ORDER_ID: {}", id);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PROCESS_ORDER_GET.val), HttpMethod.GET, ProcessOrderDto.class, id);
		return (ProcessOrderDto)response.getBody();
	}
	
	public PageDto search(ProcessOrderDto criteria) {
		log.info("PROCESS: GET PROCESS_ORDERS PROCESS_ORDER: {}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PROCESS_ORDER_SEARCH.val), HttpMethod.POST, criteria, PageDto.class);
		return (PageDto) response.getBody();
	}
	
	public ProcessOrderDto getByCode(String code) {
		log.info("PROCESS: GET PROCESS_ORDER, PROCESS_ORDER_CODE: {}", code);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PROCESS_ORDER_BY_CODE.val), HttpMethod.GET, ProcessOrderDto.class, code);
		return (ProcessOrderDto) response.getBody();
	}
	
	public ProcessOrderDto getProcessOrderAndQuota(String code) {
		log.info("PROCESS: GET PROCESS_ORDER_AND_QUOTA, PROCESS_ORDER_CODE: {}", code);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PROCESS_ORDER_AND_QUOTA_GET.val), HttpMethod.GET, ProcessOrderDto.class, code);
		return (ProcessOrderDto)response.getBody();
	}
	
	
	public EntityResponse confirm(ProcessOrderDto processOrder) {
		log.info("PROCESS: CONFIRM PROCESS_ORDER, PROCESS_ORDER: {}", processOrder);
		ResponseEntity<?>  response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PROCESS_ORDER_CONFIRM.val), HttpMethod.PUT, processOrder, EntityResponse.class, processOrder.getId());
		return (EntityResponse) response.getBody();
	}


	@SuppressWarnings("unchecked")
	public List<ProcessOrderDto> getByFarmCode(String farmCode) {
		log.info("PROCESS: GET PROCESS_ORDERS BY FARM_CODE, FARM_CODE: {}", farmCode);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PROCESS_ORDER_BY_FARMCODE.val), HttpMethod.GET, new ParameterizedTypeReference<List<ProcessOrderDto>>() {},farmCode);
		return (List<ProcessOrderDto>)response.getBody();
	}
	
	@SuppressWarnings("unchecked")
	public List<ProcessOrderDto> getAllForReportByFarmCode(String farmCode) {
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PROCESS_ORDER_FOR_REPORT_BY_FARMCODE.val), HttpMethod.GET, new ParameterizedTypeReference<List<ProcessOrderDto>>() {}, farmCode);
		return (List<ProcessOrderDto>) response.getBody();
	}
	
	@SuppressWarnings("unchecked")
	public List<ProcessOrderDto> getAllProcessOrderForReport(ProcessOrderDto criteria) {
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PROCESS_ORDER_ALL_FOR_REPORT.val), HttpMethod.POST, criteria, new ParameterizedTypeReference<List<ProcessOrderDto>>() {});
		return (List<ProcessOrderDto>) response.getBody();
	}
	
	@SuppressWarnings("unchecked")
	public List<ProcessOrderDto> gets(ProcessOrderDto criteria) {
		log.info("PROCESS: GET PROCESS_ORDERS PROCESS_ORDER: {}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PROCESS_ORDER_BY_FARMCODE_AND_POSTING_DATE.val), HttpMethod.POST, criteria, new ParameterizedTypeReference<List<ProcessOrderDto>>() {});
		return (List<ProcessOrderDto>)response.getBody();
	}
	
	@SuppressWarnings("unchecked")
	public List<String> getAllPigLevelByBarnCode(String barnCode) {
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PROCESS_ORDER_GET_PIG_LEVEL_BY_BARNCODE.val), HttpMethod.GET, new ParameterizedTypeReference<List<String>>() {}, barnCode);
		return (List<String>) response.getBody();
	}
	
	@SuppressWarnings("unchecked")
	public List<ProcessOrderDto> checkGa(ProcessOrderDto criteria) {
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PROCESS_ORDER_GET_CHECK_GA.val), HttpMethod.POST, criteria, new ParameterizedTypeReference<List<ProcessOrderDto>>() {});
		return (List<ProcessOrderDto>) response.getBody();
	}
	
	@SuppressWarnings("unchecked")
	public List<ProcessOrderDto> getProcessOrderForExport(ProcessOrderDto criteria) {
		log.info("PROCESS: GET PROCESS_ORDERS FOR EXPORT PROCESS_ORDER: {}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PROCESS_ORDER_FOR_EXPORT.val), HttpMethod.POST, criteria, new ParameterizedTypeReference<List<ProcessOrderDto>>() {});
		return (List<ProcessOrderDto>) response.getBody();
	}
}
