package com.keysoft.pigfarm.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.keysoft.pigfarm.common.PageDto;
import com.keysoft.pigfarm.config.ServiceProperties;
import com.keysoft.pigfarm.constant.ApiEnum;
import com.keysoft.pigfarm.production.dto.StockCountDto;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;
@Slf4j
@Service
public class StockCountManager {
	@Autowired
	private RestHelper restHelper;
	
	@Autowired
	private ServiceProperties serviceProperties;
	
	public PageDto gets(StockCountDto criteria) {
		log.info("PROCESS: SEARCH STOCK_COUNT, criteria: {}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_STOCK_COUNT_SEARCH.val), HttpMethod.POST, criteria, PageDto.class);
		return (PageDto) response.getBody();
	}
	
	public StockCountDto get(Long id) {
		log.info("PROCESS: GET STOCK_COUNT, STOCK_COUNT_ID: {}", id);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_STOCK_COUNT_GET.val), HttpMethod.GET, StockCountDto.class,id);
		return (StockCountDto) response.getBody();
	}
}
