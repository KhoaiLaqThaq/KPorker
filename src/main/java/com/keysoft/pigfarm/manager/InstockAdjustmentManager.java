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
import com.keysoft.pigfarm.production.dto.InstockAdjustmentDto;
import com.keysoft.pigfarm.production.dto.MaterialDetailDto;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class InstockAdjustmentManager {
	@Autowired
	private RestHelper restHelper;
	
	@Autowired
	private ServiceProperties serviceProperties;
	
	public PageDto gets(InstockAdjustmentDto criteria) {
		log.info("PROCESS: SEARCH INSTOCK_ADJUSTMENT, criteria: {}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_INSTOCK_ADJUSTMENT_SEARCH.val), HttpMethod.POST, criteria, PageDto.class);
		return (PageDto) response.getBody();
	}
	
	public InstockAdjustmentDto get(Long id) {
		log.info("PROCESS: GET INSTOCK_ADJUSTMENT, INSTOCK_ADJUSTMENT_ID: {}", id);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_INSTOCK_ADJUSTMENT_GET.val), HttpMethod.GET, InstockAdjustmentDto.class,id);
		return (InstockAdjustmentDto) response.getBody();
	}
	
	public EntityResponse save(InstockAdjustmentDto instockAdjustment) {
		log.info("PROCESS: SAVE INSTOCK_ADJUSTMENT, INSTOCK_ADJUSTMENT: {}", instockAdjustment);
		ResponseEntity<?> response = null;
		if (instockAdjustment.getId() != null) {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_INSTOCK_ADJUSTMENT_UPDATE.val), HttpMethod.PUT, instockAdjustment, EntityResponse.class, instockAdjustment.getId());
		} else {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_INSTOCK_ADJUSTMENT_CREATE.val), HttpMethod.POST, instockAdjustment, EntityResponse.class);
		}
		return (EntityResponse)response.getBody();	
	}
	
	public EntityResponse cancel(InstockAdjustmentDto instockAdjustment) {
		log.info("PROCESS: CANCEL INSTOCK_ADJUSTMENT, INSTOCK_ADJUSTMENT: {}", instockAdjustment);
		ResponseEntity<?> response = null;
		if (instockAdjustment.getId() != null) {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_INSTOCK_ADJUSTMENT_CANCEL.val), HttpMethod.PUT, instockAdjustment, EntityResponse.class, instockAdjustment.getId());
		} else {
			return null;
		}
		return (EntityResponse)response.getBody();	
	}
	
	@SuppressWarnings("unchecked")
	public List<MaterialDetailDto> searchMaterialDetailInstockAdjustment(MaterialDetailDto criteria) {
		log.info("PROCESS: SEARCH MATERIAL_DETAIL BY NAME, MATERIAL_DETAIL: {}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_INSTOCK_ADJUSTMENT_SEARCH_MATERIAL.val), HttpMethod.POST, criteria, new ParameterizedTypeReference<List<MaterialDetailDto>>() {});
		return (List<MaterialDetailDto>) response.getBody();
	}
}
