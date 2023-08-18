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
import com.keysoft.pigfarm.production.dto.PigEntryDto;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class PigEntryManager {
	@Autowired
	private RestHelper restHelper;
	@Autowired 
	private ServiceProperties serviceProperties;
	
	public EntityResponse save(PigEntryDto pigEntryDto) {
		log.info("PROCESS: SAVE PIG_ENTRY, PIG_ENTRY: {}", pigEntryDto);
		ResponseEntity<?> response = null;
		if(pigEntryDto.getId()!= null) {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PIG_ENTRY_UPDATE.val), HttpMethod.PUT, pigEntryDto, EntityResponse.class, pigEntryDto.getId());
		}else {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PIG_ENTRY_CREATE.val), HttpMethod.POST, pigEntryDto, EntityResponse.class);
		}
		return (EntityResponse)response.getBody();
	}
	
	public EntityResponse cancel(PigEntryDto pigEntryDto) {
		log.info("PROCESS: CANCEL PIG_ENTRY, PIG_ENTRY: {}", pigEntryDto);
		ResponseEntity<?> response = null;
		if(pigEntryDto.getId()!= null) {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PIG_ENTRY_CANCEL.val), HttpMethod.PUT, pigEntryDto, EntityResponse.class, pigEntryDto.getId());
		}
		return (EntityResponse)response.getBody();
	}
	
	public PageDto search(PigEntryDto criteria) {
		log.info("PROCESS: SEARCH PIG_ENTRY, PIG_ENTRY: {}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PIG_ENTRY_SEARCH.val),HttpMethod.POST, criteria, PageDto.class);
		return (PageDto) response.getBody();
	}
	
	public PigEntryDto get(Long id) {
		log.info("PROCESS: GET PIG_ENTRY, PIG_ENTRY_ID: {}", id);
		ResponseEntity<?> response = null;
		response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PIG_ENTRY_GET.val), HttpMethod.GET, PigEntryDto.class, id);
		return (PigEntryDto)response.getBody();
	}
	
	@SuppressWarnings("unchecked")
	public List<PigEntryDto> getByPoCode(String poCode) {
		log.info("PROCESS: GET PIG_ENTRY BY POCODE");
		ResponseEntity<?> response = null;
		response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PIG_ENTRY_GET_BY_POCODE.val), HttpMethod.GET, new ParameterizedTypeReference<List<PigEntryDto>>() {}, poCode);
		return (List<PigEntryDto>)response.getBody();
	}
}
