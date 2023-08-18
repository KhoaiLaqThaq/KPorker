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
import com.keysoft.pigfarm.production.dto.SystemParameterDto;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class SystemParameterManager {
	@Autowired
	private RestHelper restHelper;
	@Autowired
	private ServiceProperties serviceProperties;
	
	public PageDto search(SystemParameterDto criteria) {
		log.info("process=search SystemParameterDto, criteria{}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_SYSTEM_PARAMETER_SEARCH.val), HttpMethod.POST, criteria, PageDto.class);
		return (PageDto) response.getBody();
	}
	
	public SystemParameterDto get(Long id) {
		log.info("process=get SystemParameterDto, SystemParameter_id{}", id);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_SYSTEM_PARAMETER_GET.val), HttpMethod.GET, SystemParameterDto.class,id);
		return (SystemParameterDto) response.getBody();
	}
	
	public SystemParameterDto save(SystemParameterDto systemParameter) {
		log.info("process=save-SystemParameter, SystemParameterDto={}", systemParameter);
		ResponseEntity<?> response = null;
		if (systemParameter.getId() != null) {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_SYSTEM_PARAMETER_UPDATE.val), HttpMethod.PUT, systemParameter, SystemParameterDto.class, systemParameter.getId());
		} else {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_SYSTEM_PARAMETER_CREATE.val), HttpMethod.POST, systemParameter, SystemParameterDto.class);
		}
		return (SystemParameterDto)response.getBody();	
	}
	
	@SuppressWarnings("unchecked")
	public List<MaterialDto> getMaterials(SystemParameterDto criteria) {
		log.info("process=getMaterials, criteria{}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_SYSTEM_PARAMETER_GET_MATERIAL.val), HttpMethod.POST, criteria, new ParameterizedTypeReference<List<MaterialDto>>() {});
		return (List<MaterialDto>) response.getBody();
	}
	
	@SuppressWarnings("unchecked")
	public List<MaterialDto> getByPrefixs(String prefix) {
		log.info("process=getByPrefixs, prefix{}", prefix);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_SYSTEM_PARAMETER_GET_BY_PREFIX.val), HttpMethod.GET, new ParameterizedTypeReference<List<MaterialDto>>() {}, prefix);
		return (List<MaterialDto>) response.getBody();
	}

	public SystemParameterDto getByParamName(String paramName) {
		log.info("process=get SystemParameterDto By ParamName, ParamName{}", paramName);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_SYSTEM_PARAMETER_GET_BY_PARAM_NAME.val), HttpMethod.GET, SystemParameterDto.class, paramName);
		return (SystemParameterDto) response.getBody();
	}
}
