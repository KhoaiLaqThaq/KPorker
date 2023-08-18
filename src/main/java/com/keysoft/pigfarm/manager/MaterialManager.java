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
import com.keysoft.pigfarm.production.dto.MaterialDto;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;
@Slf4j
@Service
public class MaterialManager {
	@Autowired
	private RestHelper restHelper;
	@Autowired
	private ServiceProperties serviceProperties;
	
	@SuppressWarnings("unchecked")
	public List<MaterialDto> gets() {
		log.info("PROCESS: GET MATERIALS");
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_MATERIAL_GETS.val), HttpMethod.GET, new ParameterizedTypeReference<List<MaterialDto>>() {});
		return (List<MaterialDto>) response.getBody();
	}
	
	public PageDto search(MaterialDto criteria) {
		log.info("PROCESS: SEARCH MATERIALS, MATERIAL: {}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_MATERIAL_SEARCH.val), HttpMethod.POST, criteria, PageDto.class);
		return (PageDto) response.getBody();
	}
	
	public MaterialDto get(Long id) {
		log.info("PROCESS: GET MATERIAL, MATERIAL_ID: {}", id);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_MATERIAL_GET.val), HttpMethod.GET, MaterialDto.class,id);
		return (MaterialDto) response.getBody();
	}
	
	// not complete yet	
	public Boolean checkMaterialNameOrCode(String name , String code) {
		log.info("PROCESS: CHECK MATERIAL, MATERIAL_NAME: {} , MATERIAL_CODE: {}",name,code);	
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_MATERIAL_GETS.val), HttpMethod.GET, Boolean.class,name,code);
		return (Boolean) response.getBody();
	}
	
	@SuppressWarnings("unchecked")
	public List<MaterialDto> gets(String code) {
		log.info("PROCESS: GET MATERIAL BY CODE, MATERIAL_CODE: {}", code);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_MATERIAL_BY_CODE.val), HttpMethod.GET, new ParameterizedTypeReference<List<MaterialDto>>() {}, code);
		return (List<MaterialDto>) response.getBody();
	}
	
	@SuppressWarnings("unchecked")
	public List<MaterialDto> searchByName(MaterialDto criteria) {
		log.info("PROCESS: SEARCH MATERIAL BY NAME, MATERIAL: {}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_MATERIAL_SEARCH_BY_NAME.val), HttpMethod.POST, criteria, new ParameterizedTypeReference<List<MaterialDto>>() {});
		return (List<MaterialDto>) response.getBody();
	}
	
	
	public MaterialDto save(MaterialDto material) {
		log.info("PROCESS: SAVE MATERIAL, MATERIAL: {}", material);
		ResponseEntity<?> response = null;
		if (material.getId() != null) {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_MATERIAL_UPDATE.val), HttpMethod.PUT, material, MaterialDto.class, material.getId());
		} else {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_MATERIAL_CREATE.val), HttpMethod.POST, material, MaterialDto.class);
		}
		return (MaterialDto)response.getBody();	
	}
	
	@SuppressWarnings("unchecked")
	public List<MaterialDto> getByPurchasingGroup(MaterialDto criteria){
		log.info("PROCESS: GET MATERIAL BY PURCHASING GROUP, MATERIAL: {}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_MATERIAL_GETS_BY_PURCHASING_GROUP.val), HttpMethod.POST, criteria, new ParameterizedTypeReference<List<MaterialDto>>() {});
		return (List<MaterialDto>) response.getBody();
	}
}
