package com.keysoft.pigfarm.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.keysoft.pigfarm.common.PageDto;
import com.keysoft.pigfarm.config.ServiceProperties;
import com.keysoft.pigfarm.constant.ApiEnum;
import com.keysoft.pigfarm.production.dto.InstockBaselineDto;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class InstockBaselineManager {
	@Autowired
	private RestHelper restHelper;
	
	@Autowired
	private ServiceProperties serviceProperties;

	public PageDto gets(InstockBaselineDto criteria) {
		log.info("PROCESS: SEARCH INSTOCK_BASELINE, criteria: {}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_INSTOCK_BASELINE_GETS.val), HttpMethod.POST, criteria, PageDto.class);
		return (PageDto) response.getBody();
	}
	
	public InstockBaselineDto get(Long id) {
		log.info("PROCESS: GET INSTOCK_BASELINE, INSTOCK_BASELINE_ID: {}", id);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_INSTOCK_BASELINE_GET.val), HttpMethod.GET, InstockBaselineDto.class,id);
		return (InstockBaselineDto) response.getBody();
	}
}
