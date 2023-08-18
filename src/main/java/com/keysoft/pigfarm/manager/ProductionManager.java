package com.keysoft.pigfarm.manager;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.keysoft.pigfarm.config.ServiceProperties;
import com.keysoft.pigfarm.constant.ApiEnum;
import com.keysoft.pigfarm.production.dto.ProductionDto;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ProductionManager {
	@Autowired
	private RestHelper restHelper;
	@Autowired
	private ServiceProperties serviceProperties;
	
	@SuppressWarnings("unchecked")
	public List<ProductionDto> getsByProcessOrderCode(String code) {
		log.info("PROCESS: GET PRODUCTIONS BY PROCESS_ORDER, PROCESS_ORDER_CODE: {}", code);
		ResponseEntity<?> response = restHelper.send(
				serviceProperties.getPaths().get(ApiEnum.PATH_PRODUCTION_BY_PROCESS_ORDER_CODE.val)
				, HttpMethod.GET
				, new ParameterizedTypeReference<List<ProductionDto>>() {}
				, code);
		return (List<ProductionDto>) response.getBody();
	}
	
	
	public Integer getTotalPigRetainedByPoCode(String processOrderCode) {
		log.info("PROCESS: GET TOTAL PIG_RETAINED BY PROCESS_ORDER, PROCESS_ORDER_CODE: {}", processOrderCode);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PRODUCTION_GET_PIG_RETAINED.val), HttpMethod.GET, new ParameterizedTypeReference<Integer>() {}, processOrderCode);
		return  (Integer) response.getBody();
	}
	
	public Integer getTotalPigRetainedByPoCodeAndDate(ProductionDto criteria) {
		log.info("PROCESS: GET TOTAL PIG_RETAINED BY PROCESS_ORDER, criteria: {}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PRODUCTION_GET_PIG_RETAINED_BY_DATE.val), HttpMethod.POST, criteria, new ParameterizedTypeReference<Integer>() {});
		return  (Integer) response.getBody();
	}
}
