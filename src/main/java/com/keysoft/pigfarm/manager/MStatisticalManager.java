package com.keysoft.pigfarm.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.keysoft.pigfarm.config.ServiceProperties;
import com.keysoft.pigfarm.constant.ApiEnum;
import com.keysoft.pigfarm.report.dto.MStatisticalRequest;
import com.keysoft.pigfarm.report.dto.MStatisticalResponse;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class MStatisticalManager {
	
	@Autowired
	private RestHelper restHelper;
	@Autowired
	private ServiceProperties serviceProperties;
	
	public MStatisticalResponse handleMStatisticalMaterial(MStatisticalRequest criteria) {
		log.info("*******MANAGER:process='handle-mStatistical-material'");
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_STATISTICAL_MATERIAL.val), HttpMethod.POST, criteria, MStatisticalResponse.class);
		return (MStatisticalResponse) response.getBody();
	}

}
