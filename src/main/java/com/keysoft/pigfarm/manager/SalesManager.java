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
import com.keysoft.pigfarm.production.dto.SalesDto;
import com.keysoft.pigfarm.production.json.SyncResponse;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class SalesManager {
	@Autowired
	private RestHelper restHelper;
	
	@Autowired
	private ServiceProperties serviceProperties;
	
	public PageDto gets(SalesDto criteria) {
		log.info("PROCESS: SEARCH SALES, criteria: {}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_SALES_GETS.val), HttpMethod.POST, criteria, PageDto.class);
		return (PageDto) response.getBody();
	}
	
	@SuppressWarnings("unchecked")
	public List<SalesDto> getsToExport(SalesDto criteria) {
		log.info("process=gets SalesDto to export, criteria{}", criteria);
		
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_SALES_EXPORT.val), HttpMethod.POST, criteria, new ParameterizedTypeReference<List<SalesDto>>() {});
		return (List<SalesDto>) response.getBody();
	}
	
	public SalesDto get(Long id) {
		log.info("PROCESS: GET SALES, SALES_ID: {}", id);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_SALES_GET.val), HttpMethod.GET, SalesDto.class,id);
		return (SalesDto) response.getBody();
	}
	
	public SyncResponse syncFromSAP() {
		log.info("PROCESS: SYNC_SALES_DATA_FROM_SAP");
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_SYNC_SALES_DATA_FROM_SAP.val), HttpMethod.GET, SyncResponse.class);
		return (SyncResponse) response.getBody();
	}
}
