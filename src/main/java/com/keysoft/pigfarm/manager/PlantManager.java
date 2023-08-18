package com.keysoft.pigfarm.manager;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.keysoft.pigfarm.config.ServiceProperties;
import com.keysoft.pigfarm.constant.ApiEnum;
import com.keysoft.pigfarm.production.dto.PlantDto;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class PlantManager {
	@Autowired
	private RestHelper restHelp;
	@Autowired
	private ServiceProperties serviceProperties;
	
	@SuppressWarnings("unchecked")
	public List<PlantDto> gets() {
		log.info("process=gets-plant");
		ResponseEntity<?> response = restHelp.send(
				serviceProperties.getPaths().get(ApiEnum.PATH_PLANT_GETS.val)
				, HttpMethod.GET
				, new ParameterizedTypeReference<List<PlantDto>>() {});
		return (List<PlantDto>) response.getBody();
	}
	
	@SuppressWarnings("unchecked")
	public List<PlantDto> getAll() {
		log.info("process=gets-plant");
		ResponseEntity<?> response = restHelp.send(
				serviceProperties.getPaths().get(ApiEnum.PATH_PLANT_GET_ALL.val)
				, HttpMethod.GET
				, new ParameterizedTypeReference<List<PlantDto>>() {});
		return (List<PlantDto>) response.getBody();
	}
	
}
