package com.keysoft.pigfarm.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.keysoft.pigfarm.common.PageDto;
import com.keysoft.pigfarm.config.ServiceProperties;
import com.keysoft.pigfarm.constant.ApiEnum;
import com.keysoft.pigfarm.production.dto.SiloDto;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class SiloManager {
	@Autowired
	private RestHelper restHelper;
	@Autowired
	private ServiceProperties serviceProperties;
	public SiloDto get(Long id) {
		log.info("process=get-silo, silo_id={}", id);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_SILO_GET.val), HttpMethod.GET, SiloDto.class, id);
		return (SiloDto)response.getBody();
	}
	public PageDto gets(SiloDto criteria) {
		log.info("process=get-silos, criteria={}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_SILO_SEARCH.val), HttpMethod.POST ,criteria,PageDto.class );
		return (PageDto) response.getBody();
	}
	public SiloDto save(SiloDto silo) {
		log.info("process=save-silo, silo={}", silo);
		ResponseEntity<?> response = null;
		if (silo.getId() != null) {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_SILO_UPDATE.val), HttpMethod.PUT, silo, SiloDto.class, silo.getId());
		} else {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_SILO_CREATE.val), HttpMethod.POST, silo, SiloDto.class);
		}
		return (SiloDto)response.getBody();	
	}
	
}
