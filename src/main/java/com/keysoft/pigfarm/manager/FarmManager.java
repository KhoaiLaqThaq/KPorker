package com.keysoft.pigfarm.manager;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.keysoft.pigfarm.common.PageDto;
import com.keysoft.pigfarm.common.util.FancyTree;
import com.keysoft.pigfarm.config.ServiceProperties;
import com.keysoft.pigfarm.constant.ApiEnum;
import com.keysoft.pigfarm.production.dto.FarmDto;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class FarmManager {
	@Autowired
	private RestHelper restHelper;
	@Autowired
	private ServiceProperties serviceProperties;
	
	public FarmDto get(Long id) {
		log.info("PROCESS: GET FARM, FARM_ID: {}", id);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_FARM_GET.val), HttpMethod.GET, FarmDto.class, id);
		return (FarmDto)response.getBody();
	}
	
	public FarmDto getByFarmCode(String farmCode) {
		log.info("PROCESS: GET FARM, FARM_CODE: {}", farmCode);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_FARM_GET_BY_FARMCODE.val), HttpMethod.GET, FarmDto.class, farmCode);
		return (FarmDto) response.getBody();
	}
	
	@SuppressWarnings("unchecked")
	public List<FarmDto> gets(){
		log.info("process=get-farms, ");
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_FARM_GETS.val), HttpMethod.GET, new ParameterizedTypeReference<List<FarmDto>>() {});
		return (List<FarmDto>)response.getBody();		
	}
	
	@SuppressWarnings("unchecked")
	public List<FarmDto> getsPorkerFarms(){
		log.info("process=get-porker-farms, ");
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_FARM_PORKER_GETS.val), HttpMethod.GET, new ParameterizedTypeReference<List<FarmDto>>() {});
		return (List<FarmDto>)response.getBody();		
	}

	
	public PageDto search(FarmDto criteria) {
		log.info("process=search-farm, criteria{}", criteria );		
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_FARM_SEARCH.val), HttpMethod.POST, criteria , PageDto.class);
		return (PageDto) response.getBody();
		
	}
	
	public Boolean checkFarmCode(String code, Long id) {
		log.info("process= check farm code");
		ResponseEntity<?> response = null;
		if(id != null) {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_FARM_CHECKCODEANDID.val), HttpMethod.GET, Boolean.class, code, id);
		}else {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_FARM_CHECKCODE.val), HttpMethod.GET, Boolean.class, code);
		}
		return (Boolean)response.getBody();
	}
	
	@SuppressWarnings("unchecked")
	public List<FarmDto> getAllFarmByUser(){
		log.info("process= get all farm by username");
		ResponseEntity<?> response  = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_FARM_GETS_BYUSER.val), HttpMethod.GET, new ParameterizedTypeReference<List<FarmDto>>() {});
		return (List<FarmDto>)response.getBody();
	}
	
	@SuppressWarnings("unchecked")
	public List<FarmDto> getsByPlantCode(String plantCode) {
		log.info("process=gets-by-plant-code, plantCode: {}", plantCode);
		ResponseEntity<?> response = restHelper.send(
				serviceProperties.getPaths().get(ApiEnum.PATH_FARM_BY_PLANT_CODE.val)
				, HttpMethod.GET
				, new ParameterizedTypeReference<List<FarmDto>>() {}
				, plantCode);
		return (List<FarmDto>) response.getBody();
	}
	
	@SuppressWarnings("unchecked")
	public List<FarmDto> getFarmByUserName(){
		log.info("PROCESS: GET FARMS BY USERNAME");
		ResponseEntity<?> response  = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_FARM_GET_BY_USERNAME.val), HttpMethod.GET, new ParameterizedTypeReference<List<FarmDto>>() {});
		return (List<FarmDto>)response.getBody();
	}
	
	public FancyTree getTree(String username) {
		log.info("--------process=get-tree, username={}", username);
		ResponseEntity<?> response = restHelper.send(
				serviceProperties.getPaths().get(ApiEnum.PATH_FARM_GET_TREE.val)
				, HttpMethod.POST
				, FancyTree.class
				, username);
		return (FancyTree) response.getBody();
	}

}
