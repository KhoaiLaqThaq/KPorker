package com.keysoft.pigfarm.manager;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.keysoft.pigfarm.config.ServiceProperties;
import com.keysoft.pigfarm.constant.ApiEnum;
import com.keysoft.pigfarm.production.dto.QuotaDto;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class QuotaManager {
	@Autowired
	private RestHelper restHelper;
	@Autowired
	private ServiceProperties serviceProperties;
	
	@SuppressWarnings("unchecked")
	public List<QuotaDto> gets() {
		log.info("process=getAll Quota");
		ResponseEntity<?> response = restHelper.send(
				ApiEnum.PATH_QUOTA_GETS.val
				, HttpMethod.GET
				, new ParameterizedTypeReference<List<QuotaDto>>() {});
		return (List<QuotaDto>) response.getBody();
	}
	
	public QuotaDto get(Long id) {
		log.info("process=get-quota, id={}", id);
		ResponseEntity<?> response = restHelper.send(
				ApiEnum.PATH_QUOTA_GET.val
				, HttpMethod.GET
				, QuotaDto.class
				, id);
		
		return (QuotaDto) response.getBody();
	}
	
	@SuppressWarnings("unchecked")
	public List<QuotaDto> getByProcessOrderCode(String processOrderCode) {
		log.info("process=get-by-process-order-code method");
		ResponseEntity<?> response = restHelper.send(
				ApiEnum.PATH_QUOTA_BY_PROCESS_ORDER_CODE.val
				, HttpMethod.GET
				, new ParameterizedTypeReference<List<QuotaDto>>() {});
		return (List<QuotaDto>) response.getBody();
	}
	
	@SuppressWarnings("unchecked")
	public List<QuotaDto> getByProcessOrderCodeAndLatest(String processOrderCode) {
		ResponseEntity<?> response = restHelper.send(
				serviceProperties.getPaths().get(ApiEnum.PATH_QUOTA_BY_PROCESS_ORDER_CODE_AND_LATEST.val)
				, HttpMethod.GET
				, new ParameterizedTypeReference<List<QuotaDto>>() {}
				, processOrderCode);
		return (List<QuotaDto>) response.getBody();
	}
}
