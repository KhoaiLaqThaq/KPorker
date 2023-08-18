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
import com.keysoft.pigfarm.production.dto.GoodsIssueDto;
import com.keysoft.pigfarm.production.dto.MaterialDetailDto;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class GoodsIssueManager {

	@Autowired
	private RestHelper restHelper;
	@Autowired
	private ServiceProperties serviceProperties;
	
	public PageDto search(GoodsIssueDto criteria) {
		log.info("PROCESS: SEARCH GOODS_ISSUES, criteria: {}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GOODS_ISSUE_SEARCH.val), HttpMethod.POST, criteria, PageDto.class);
		return (PageDto) response.getBody();
	}
	
	public GoodsIssueDto get(Long id) {
		log.info("PROCESS: GET GOODS_ISSUE, GOODS_ISSUE_ID: {}", id);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GOODS_ISSUE_GET.val), HttpMethod.GET, GoodsIssueDto.class,id);
		return (GoodsIssueDto) response.getBody();
	}
	
	public EntityResponse save(GoodsIssueDto goodsIssue) {
		log.info("PROCESS: SAVE GOODS_ISSUE, GOODS_ISSUE: {}", goodsIssue);
		ResponseEntity<?> response = null;
		if (goodsIssue.getId() != null) {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GOODS_ISSUE_UPDATE.val), HttpMethod.PUT, goodsIssue, EntityResponse.class, goodsIssue.getId());
		} else {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GOODS_ISSUE_CREATE.val), HttpMethod.POST, goodsIssue, EntityResponse.class);
		}
		return (EntityResponse)response.getBody();	
	}
	
	public EntityResponse cancel(GoodsIssueDto goodsIssue) {
		log.info("PROCESS: CANCEL GOODS_ISSUE, GOODS_ISSUE: {}", goodsIssue);
		ResponseEntity<?> response = null;
		if (goodsIssue.getId() != null) {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GOODS_ISSUE_CANCEL.val), HttpMethod.PUT, goodsIssue, EntityResponse.class, goodsIssue.getId());
		} else {
			return null;
		}
		return (EntityResponse)response.getBody();	
	}
	
	public void delete(Long id) {
		log.info("PROCESS: DELETE GOODS_ISSUE, GOODS_ISSUE_ID: {}", id);
		restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GOODS_ISSUE_DELETE.val), HttpMethod.DELETE, Boolean.class,id);
	}
	
	@SuppressWarnings("unchecked")
	public List<GoodsIssueDto> getTemplates() {
		log.info("PROCESS: GET GOODS_ISSUES TYPE TEMPLATE");
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GOODS_ISSUE_GET_TEMPLATE.val), HttpMethod.GET, new ParameterizedTypeReference<List<GoodsIssueDto>>() {});
		return (List<GoodsIssueDto>)response.getBody();
	}
	
	@SuppressWarnings("unchecked")
	public List<GoodsIssueDto> getByPoCode(String poCode) {
		log.info("PROCESS: GET GOODS_ISSUES BY PROCESS_ORDER_CODE, PROCESS_ORDER_CODE: {}", poCode);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GOODS_ISSUE_BY_PO_CODE.val), HttpMethod.GET, new ParameterizedTypeReference<List<GoodsIssueDto>>() {}, poCode);
		return (List<GoodsIssueDto>)response.getBody();
	}
	
	@SuppressWarnings("unchecked")
	public List<GoodsIssueDto> getByStockCode(String stockCode) {
		log.info("PROCESS: GET GOODS_ISSUES BY STOCK_CODE, STOCK_CODE: {}", stockCode);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GOODS_ISSUE_BY_STOCK_CODE.val), HttpMethod.GET, new ParameterizedTypeReference<List<GoodsIssueDto>>() {}, stockCode);
		return (List<GoodsIssueDto>)response.getBody();
	}
	
	public EntityResponse saveGoodsAttritionSupport(GoodsIssueDto goodsIssue) {
		log.info("PROCESS: SAVE GOODS_ATTRITION_SUPPORT, GOODS_ISSUE: {}", goodsIssue);
		ResponseEntity<?> response = null;
		if (goodsIssue.getId() != null) {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GOODS_ATTRITION_SUPPORT_UPDATE.val), HttpMethod.PUT, goodsIssue, EntityResponse.class, goodsIssue.getId());
		} else {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GOODS_ATTRITION_SUPPORT_CREATE.val), HttpMethod.POST, goodsIssue, EntityResponse.class);
		}
		return (EntityResponse)response.getBody();	
	}
	
	@SuppressWarnings("unchecked")
	public List<GoodsIssueDto> getGoodsIssues(GoodsIssueDto goodsIssue) {
		log.info("PROCESS: GET GOODS_ISSUES, GOODS_ISSUE: {}", goodsIssue);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GOODS_ISSUE_GETS.val), HttpMethod.POST,goodsIssue, new ParameterizedTypeReference<List<GoodsIssueDto>>() {});
		return (List<GoodsIssueDto>)response.getBody();
	}
	
	@SuppressWarnings("unchecked")
	public List<MaterialDetailDto> getMaterialInGoodsIssues(GoodsIssueDto goodsIssue) {
		log.info("PROCESS: GET MATERIAL_DETAIL IN GOODS_ISSUE, GOODS_ISSUE: {}", goodsIssue);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GOODS_ISSUE_GET_MATERIALS.val), HttpMethod.POST,goodsIssue, new ParameterizedTypeReference<List<MaterialDetailDto>>() {});
		return (List<MaterialDetailDto>)response.getBody();
	}
	
	public EntityResponse copyGoodsAttritionSupport(GoodsIssueDto goodsIssue) {
		log.info("PROCESS: COPY GOODS_ATTRITION_SUPPORT, GOODS_ISSUE: {}", goodsIssue);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GOODS_ISSUE_COPY.val), HttpMethod.POST,goodsIssue, EntityResponse.class);
		return (EntityResponse)response.getBody();
	}
	
	public GoodsIssueDto getGoodsIssuesReport(GoodsIssueDto goodsIssue) {
		log.info("PROCESS: GET GOODS_ISSUES REPORT, GOODS_ISSUE: {}", goodsIssue);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GOODS_ISSUE_REPORT.val), HttpMethod.POST,goodsIssue, GoodsIssueDto.class);
		return (GoodsIssueDto)response.getBody();
	}
}
