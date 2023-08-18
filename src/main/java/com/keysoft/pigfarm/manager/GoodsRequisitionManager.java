package com.keysoft.pigfarm.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.keysoft.pigfarm.common.PageDto;
import com.keysoft.pigfarm.config.ServiceProperties;
import com.keysoft.pigfarm.constant.ApiEnum;
import com.keysoft.pigfarm.integration.EntityResponse;
import com.keysoft.pigfarm.production.dto.GoodsRequisitionDto;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class GoodsRequisitionManager {
	@Autowired
	private RestHelper restHelper;
	@Autowired
	private ServiceProperties serviceProperties;
	
	public PageDto gets(GoodsRequisitionDto criteria) {
		log.info("PROCESS: SEARCH GOODS_REQUISITONS, criteria: {}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GOODS_REQUISITION_SEARCH.val), HttpMethod.POST, criteria, PageDto.class);
		return (PageDto) response.getBody();
	}
	
	public GoodsRequisitionDto get(Long id) {
		log.info("PROCESS: GET GOODS_REQUISITON, GOODS_REQUISITON_ID: {}", id);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GOODS_REQUISITIONN_GET.val), HttpMethod.GET, GoodsRequisitionDto.class,id);
		return (GoodsRequisitionDto) response.getBody();
	}
	
	public EntityResponse delete(Long id) {
		log.info("PROCESS: DELETE GOODS_REQUISITON, GOODS_REQUISITON_ID: {}", id);
		
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GOODS_REQUISITIONN_DELETE.val), HttpMethod.DELETE, Boolean.class,id);
		return (EntityResponse) response.getBody();
	}
}
