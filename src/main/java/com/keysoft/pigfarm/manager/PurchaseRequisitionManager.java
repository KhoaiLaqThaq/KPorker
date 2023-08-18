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
import com.keysoft.pigfarm.production.dto.PurchaseRequisitionDto;
import com.keysoft.pigfarm.report.dto.ReportPurchaseRequisitionDto;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class PurchaseRequisitionManager {
	@Autowired
	private RestHelper restHelper;
	@Autowired
	private ServiceProperties serviceProperties;
	
	public PageDto gets(PurchaseRequisitionDto criteria) {
		log.info("PROCESS: SEARCH PURCHASE_REQUISITION, criteria: {}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PURCHASE_REQUISITION_SEARCH.val), HttpMethod.POST, criteria, PageDto.class);
		return (PageDto) response.getBody();
	}
	
	public PurchaseRequisitionDto get(Long id) {
		log.info("PROCESS: GET PURCHASE_REQUISITION, PURCHASE_REQUISITION_ID: {}", id);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PURCHASE_REQUISITION_GET.val), HttpMethod.GET, PurchaseRequisitionDto.class,id);
		return (PurchaseRequisitionDto) response.getBody();
	}
	
	public EntityResponse save(PurchaseRequisitionDto purchaseRequisition) {
		log.info("PROCESS: SAVE PURCHASE_REQUISITION, PURCHASE_REQUISITION: {}", purchaseRequisition);
		ResponseEntity<?> response = null;
		if (purchaseRequisition.getId() != null) {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PURCHASE_REQUISITION_UPDATE.val), HttpMethod.PUT, purchaseRequisition, EntityResponse.class, purchaseRequisition.getId());
		} else {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PURCHASE_REQUISITION_CREATE.val), HttpMethod.POST, purchaseRequisition, EntityResponse.class);
		}
		return (EntityResponse)response.getBody();	
	}
	
	public void delete(Long id) {
		log.info("PROCESS: DELETE PURCHASE_REQUISITION, PURCHASE_REQUISITION_ID: {}", id);
		restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PURCHASE_REQUISITION_DELETE.val), HttpMethod.DELETE, Boolean.class,id);
	}
	
	@SuppressWarnings("unchecked")
	public List<ReportPurchaseRequisitionDto> getTemplates() {
		log.info("PROCESS: GET PURCHASE_REQUISITION_TYPE_TEMPLATE");
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PURCHASE_REQUISITION_GET_TEMPLATE.val), HttpMethod.GET, new ParameterizedTypeReference<List<PurchaseRequisitionDto>>() {});
		return (List<ReportPurchaseRequisitionDto>)response.getBody();
	}
	
}
