package com.keysoft.pigfarm.manager;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.keysoft.pigfarm.config.ServiceProperties;
import com.keysoft.pigfarm.constant.ApiEnum;
import com.keysoft.pigfarm.production.dto.MaterialDto;
import com.keysoft.pigfarm.production.dto.MaterialSupportDto;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class MaterialSupportManager {
	@Autowired
	private RestHelper restHelper;
	@Autowired
	private ServiceProperties serviceProperties;
	
	@SuppressWarnings("unchecked")
	public List<MaterialSupportDto> gets() {
		log.info("process=gets");
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_MATERIAL_SUPPORT_GETS.val), HttpMethod.GET, new ParameterizedTypeReference<List<MaterialSupportDto>>() {});
		return (List<MaterialSupportDto>) response.getBody();
	}
	
	@SuppressWarnings("unchecked")
	public List<MaterialSupportDto> save(MaterialSupportDto materialSupport) {
		log.info("process=save-materialSupport, materialSupport={}", materialSupport);
		ResponseEntity<?> response = null;
		if (materialSupport.getId() != null) {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_MATERIAL_SUPPORT_UPDATE.val), HttpMethod.PUT, materialSupport, new ParameterizedTypeReference<List<MaterialSupportDto>>() {}, materialSupport.getId());
		} else {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_MATERIAL_SUPPORT_CREATE.val), HttpMethod.POST, materialSupport, new ParameterizedTypeReference<List<MaterialSupportDto>>() {});
		}
		return (List<MaterialSupportDto>)response.getBody();	
	}
	
	@SuppressWarnings("unchecked")
	public List<MaterialDto> checkAllMaterialsForTool(MaterialSupportDto criteria) {
		log.info("*********MANAGER::checkAllMaterialsForTool, criteria={}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_MATERIAL_CHECKALL_FOR_TOOL_SAVE.val), HttpMethod.POST, criteria, new ParameterizedTypeReference<List<MaterialDto>>() {});
		return (List<MaterialDto>) response.getBody();
	}
	
	public Boolean saveOrDelete(String code, Integer isSelected) {
		log.info("********MANAGER::saveOrDelete, code={}, isSelected={}", code, isSelected);
		ResponseEntity<?> response = null;
		if (isSelected == 1)
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_MATERIAL_FOR_TOOL_CREATE.val), HttpMethod.POST, Boolean.class, code);
		else
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_MATERIAL_FOR_TOOL_DELETE.val), HttpMethod.DELETE, Boolean.class, code);
		return (Boolean) response.getBody();
	}
	
	@SuppressWarnings("unchecked")
	public List<MaterialDto> searchMaterialsForTool(MaterialSupportDto criteria) {
		log.info("process=search, criteria{}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_MATERIAL_TOOL_SEARCH.val), HttpMethod.POST, criteria, new ParameterizedTypeReference<List<MaterialDto>>() {});
		return (List<MaterialDto>) response.getBody();
	}
	
	@SuppressWarnings("unchecked")
	public List<MaterialSupportDto> searchMaterialSupport(MaterialSupportDto criteria) {
		log.info("process=search, criteria{}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_MATERIAL_SUPPORT_SEARCH.val), HttpMethod.POST, criteria, new ParameterizedTypeReference<List<MaterialSupportDto>>() {});
		return (List<MaterialSupportDto>) response.getBody();
	}
	
	@SuppressWarnings("unchecked")
	public List<MaterialSupportDto> saves(List<MaterialSupportDto> materialSupports) {
		log.info("process=save-materialSupports");
		ResponseEntity<?> response = null;
		response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_MATERIAL_SUPPORT_CREATES.val), HttpMethod.POST, materialSupports, new ParameterizedTypeReference<List<MaterialSupportDto>>() {});
		return (List<MaterialSupportDto>)response.getBody();	
	}
}
