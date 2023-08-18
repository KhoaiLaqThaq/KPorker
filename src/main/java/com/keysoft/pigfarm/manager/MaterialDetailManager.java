package com.keysoft.pigfarm.manager;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.keysoft.pigfarm.config.ServiceProperties;
import com.keysoft.pigfarm.constant.ApiEnum;
import com.keysoft.pigfarm.production.dto.MaterialDetailDto;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class MaterialDetailManager {
	@Autowired
	private RestHelper restHelper;
	
	@Autowired
	private ServiceProperties serviceProperties;
	
	@SuppressWarnings("unchecked")
	public List<MaterialDetailDto> searchMaterialInstockByName(MaterialDetailDto criteria) {
		log.info("PROCESS: SEARCH MATERIAL_DETAIL IN INSTOCK BY NAME, MATERIAL_DETAIL: {}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_MATERIAL_SEARCH_MATERIAL_INSTOCK_BY_NAME.val), HttpMethod.POST, criteria, new ParameterizedTypeReference<List<MaterialDetailDto>>() {});
		return (List<MaterialDetailDto>) response.getBody();
	}
	
	@SuppressWarnings("unchecked")
	public List<MaterialDetailDto> searchMaterialInstockStage(MaterialDetailDto criteria) {
		log.info("PROCESS: SEARCH MATERIAL_DETAIL STAGE, MATERIAL_DETAIL: {}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_MATERIAL_SEARCH_MATERIAL_STAGE.val), HttpMethod.POST, criteria, new ParameterizedTypeReference<List<MaterialDetailDto>>() {});
		return (List<MaterialDetailDto>) response.getBody();
	}
	
	@SuppressWarnings("unchecked")
	public List<MaterialDetailDto> getMaterialsInstockLatest(String stockCode) {
		log.info("PROCESS: SEARCH MATERIAL_DETAIL IN INSTOCK LATEST, STOCK: {}", stockCode);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_MATERIAL_GET_INSTOCK_LATEST.val), HttpMethod.GET, new ParameterizedTypeReference<List<MaterialDetailDto>>() {}, stockCode);
		return (List<MaterialDetailDto>) response.getBody();
	}
}
