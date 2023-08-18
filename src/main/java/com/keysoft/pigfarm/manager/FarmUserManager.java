package com.keysoft.pigfarm.manager;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.keysoft.pigfarm.config.ServiceProperties;
import com.keysoft.pigfarm.constant.ApiEnum;
import com.keysoft.pigfarm.master.dto.UserDto;
import com.keysoft.pigfarm.production.dto.FarmUserDto;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class FarmUserManager {
	@Autowired
	private RestHelper restHelp;
	@Autowired
	private ServiceProperties serviceProperties;
	
	public Boolean save(UserDto user) {
		log.info("process=save-farm-user");
		ResponseEntity<?> response = restHelp.send(serviceProperties.getPaths().get(ApiEnum.PATH_FARM_USER_CREATE.val), HttpMethod.POST, user, Boolean.class);
		return (Boolean) response.getBody();
	}
	
	public Boolean save(Map<String, String> farmUserMap) {
		log.info("process=save-farm-user");
		ResponseEntity<?> response = restHelp.send(serviceProperties.getPaths().get(ApiEnum.PATH_FARM_USER_CREATE.val), HttpMethod.POST, farmUserMap, Boolean.class);
		return (Boolean) response.getBody();
	}
	
	@SuppressWarnings("unchecked")
	public List<FarmUserDto> getByUsername(String username) {
		log.info("--------process=get-farmUser-by-username", username);
		ResponseEntity<?> response = restHelp.send(serviceProperties.getPaths().get(ApiEnum.PATH_FARM_USER_SEARCH_BY_NAME.val), HttpMethod.POST, new ParameterizedTypeReference<List<FarmUserDto>>() {}, username);
		return (List<FarmUserDto>) response.getBody();
	}
}
