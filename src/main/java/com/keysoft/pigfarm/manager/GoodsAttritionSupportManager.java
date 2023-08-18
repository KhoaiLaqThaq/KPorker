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
import com.keysoft.pigfarm.production.dto.GoodsAttritionSupportDto;
import com.keysoft.pigfarm.production.dto.GoodsIssueDto;
import com.keysoft.pigfarm.production.dto.ProcessOrderDto;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class GoodsAttritionSupportManager {
	@Autowired
	private RestHelper restHelper;
	@Autowired
	private ServiceProperties serviceProperties;
	
	public PageDto search(GoodsAttritionSupportDto criteria) {
		log.info("PROCESS: SEARCH GOODS_ATTRITION_SUPPORTS, GOODS_ATTRITION_SUPPORT: {}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GOODS_ATTRITION_SUPPORT_SEARCH.val), HttpMethod.POST, criteria, PageDto.class);
		return (PageDto) response.getBody();
	}
	
	public GoodsAttritionSupportDto get(Long id) {
		log.info("PROCESS: GET GOODS_ATTRITION_SUPPORT, GOODS_ATTRITION_SUPPORT_ID: {}", id);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GOODS_ATTRITION_SUPPORT_GET.val), HttpMethod.GET, GoodsAttritionSupportDto.class,id);
		return (GoodsAttritionSupportDto) response.getBody();
	}
	
	public GoodsAttritionSupportDto save(GoodsAttritionSupportDto goodsAttritionSupport) {
		log.info("PROCESS: SAVE GOODS_ATTRITION_SUPPORT, GOODS_ATTRITION_SUPPORT: {}", goodsAttritionSupport);
		ResponseEntity<?> response = null;
		if (goodsAttritionSupport.getId() != null) {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GOODS_ATTRITION_SUPPORT_UPDATE.val), HttpMethod.PUT, goodsAttritionSupport, GoodsAttritionSupportDto.class, goodsAttritionSupport.getId());
		} else {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GOODS_ATTRITION_SUPPORT_CREATE.val), HttpMethod.POST, goodsAttritionSupport, GoodsAttritionSupportDto.class);
		}
		return (GoodsAttritionSupportDto)response.getBody();	
	}
	
	@SuppressWarnings("unchecked")
	public List<ProcessOrderDto> getProcessOrderInGoodsAttritionSupportByPostingDate(GoodsIssueDto criteria) {
		log.info("PROCESS: GET PROCESS_ORDER IN GOODS_ATTRITION_SUPPORT BY POSTING_DATE, GOODS_ATTRITION_SUPPORT: {}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GOODS_ATTRITION_SUPPORT_GET_PROCESS_ORDERS.val), HttpMethod.POST, criteria, new ParameterizedTypeReference<List<ProcessOrderDto>>() {});
		return (List<ProcessOrderDto>) response.getBody();
	}
	
	@SuppressWarnings("unchecked")
	public List<String> getProcessOrderCodes(String postingDate) {
		log.info("PROCESS: GET PROCESS_ORDER_CODES BY POSTING_DATE, POSTING_DATE: {}", postingDate);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GOODS_ATTRITION_SUPPORT_GET_PROCESS_ORDER_CODES.val), HttpMethod.GET, new ParameterizedTypeReference<List<String>>() {}, postingDate);
		return (List<String>) response.getBody();
	}
	
	@SuppressWarnings("unchecked")
	public List<ProcessOrderDto> getProcessOrderByPostingDate(String postingDate) {
		log.info("PROCESS: GET PROCESS_ORDERS BY POSTING_DATE, POSTING_DATE: {}", postingDate);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GOODS_ATTRITION_SUPPORT_GET_PROCESS_ORDER_BY_POSTINGDATE.val), HttpMethod.GET, new ParameterizedTypeReference<List<ProcessOrderDto>>() {}, postingDate);
		return (List<ProcessOrderDto>) response.getBody();
	}
	
	public EntityResponse checkGoodsAttrition(GoodsIssueDto criteria) {
		log.info("PROCESS: CHECK GOODS ATTRITION SUPPORT, GOODS_ATTRITION_SUPPORT: {}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GOODS_ATTRITION_SUPPORT_CHECK.val), HttpMethod.POST, criteria, EntityResponse.class);
		return (EntityResponse) response.getBody();
	}
}
