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
import com.keysoft.pigfarm.production.dto.BarnPlanDto;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class BarnPlanManager {
	@Autowired
	private RestHelper restHelper;
	@Autowired
	private ServiceProperties serviceProperties;
	
	@SuppressWarnings("unchecked")
	public List<BarnPlanDto> gets() {
		log.info("PROCESS: GET BARN_PLANS");
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_BARN_PLAN_GETS.val), HttpMethod.GET, new ParameterizedTypeReference<List<BarnPlanDto>>() {});
		
		return (List<BarnPlanDto>)response.getBody();
	}
	public BarnPlanDto get(Long id) {
		log.info("PROCESS: GET_BARN_PLAN, BarnPlan_ID: {}", id);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_BARN_PLAN_GET.val), HttpMethod.GET, BarnPlanDto.class, id);
		return (BarnPlanDto)response.getBody();
	}
	
	public PageDto search(BarnPlanDto criteria) {
		log.info("PROCESS: SEARCH, criteria: {}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_BARN_PLAN_SEARCH.val), HttpMethod.POST, criteria, PageDto.class);
		return (PageDto) response.getBody();
	}
	public EntityResponse confirm(BarnPlanDto barnPlanDto) {
		log.info("PROCESS: CONFIRM BARN_PLAN, BarnPlan: {}", barnPlanDto);
		ResponseEntity<?>  response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_BARN_PLAN_CONFIRM.val), HttpMethod.PUT, barnPlanDto, EntityResponse.class);
		return (EntityResponse) response.getBody();
	}
}
