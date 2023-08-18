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
import com.keysoft.pigfarm.production.dto.SDPItemDto;
import com.keysoft.pigfarm.production.dto.SupportRequireDto;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class SupportRequireManager {
	@Autowired
	private RestHelper restHelper;
	@Autowired
	private ServiceProperties serviceProperties;
	
	public String save(SupportRequireDto criteria) {
		log.info("process=send require, event={}", criteria);
		ResponseEntity<?> response = null;
		response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_SUPPORT_REQUIRE_CREATE.val), HttpMethod.POST, criteria, String.class);
		return (String)response.getBody();	
	}

	@SuppressWarnings("unchecked")
	public List<String> getsSDPItem(SDPItemDto criteria) {
		log.info("process=get list sdp items");
		ResponseEntity<?> response = null;
		response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_SDP_ITEM_GETS.val), HttpMethod.POST, criteria, new ParameterizedTypeReference<List<String>>() {});
		return (List<String>)response.getBody();	
	}
	
	public PageDto search(SupportRequireDto criteria) {
		log.info("process=search SupportRequireDto, criteria{}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_SUPPORT_REQUIRE_GETS.val), HttpMethod.POST, criteria, PageDto.class);
		return (PageDto) response.getBody();
	}
	
	public SupportRequireDto get(Long id) {
		log.info("process=get SupportRequireDto, id{}", id);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_SUPPORT_REQUIRE_GET.val), HttpMethod.GET, SupportRequireDto.class,id);
		return (SupportRequireDto) response.getBody();
	}
}
