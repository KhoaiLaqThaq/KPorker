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
import com.keysoft.pigfarm.master.dto.TenantDto;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class TenantManager {

	@Autowired
	private RestHelper restHelper;

	@Autowired
	private ServiceProperties serviceProperties;

	public TenantDto get(Long id) {
		log.info("process=get-tenant, tenant_id={}", id);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_TENANT_GET.val), HttpMethod.GET, TenantDto.class, id);
		return (TenantDto) response.getBody();
	}


	@SuppressWarnings("unchecked")
	public List<TenantDto> gets() {
		log.info("process=tenant-gets");
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_TENANT_GETS.val), HttpMethod.GET, new ParameterizedTypeReference<List<TenantDto>>() {});
		return (List<TenantDto>) response.getBody();
	}

	public TenantDto save(TenantDto tenantDto) {
		log.info("process=save-tenant, Tenant", tenantDto);

		ResponseEntity<?> response = null;
		if (tenantDto.getId() != null) {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_TENANT_UPDATE.val), HttpMethod.PUT, tenantDto, TenantDto.class, tenantDto.getId());
		}else {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_TENANT_CREATE.val), HttpMethod.POST, tenantDto, TenantDto.class);
		}
		return (TenantDto) response.getBody();
	}
	
	public PageDto search(TenantDto criteria) {
		log.info("process=search, criteria={}", criteria);

		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_TENANT_SEARCH.val), HttpMethod.POST, criteria, PageDto.class);
		PageDto page = (PageDto) response.getBody();
		log.debug("page: {}", page);
		return page;
	}
	
	/*
	public Boolean checkTenantCode(String code, Long id){
		log.info("process=get-tenant, tenant_id", id);
		ResponseEntity<?> response = null;
		if(id != null) {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_TENANT_CHECKCODEANDID.val), HttpMethod.GET, Boolean.class, code , id );
		}else {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_TENANT_CHECKCODE.val), HttpMethod.GET, Boolean.class, code );
		}		
		return (Boolean)response.getBody();
	}
	*/
}
