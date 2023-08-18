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
import com.keysoft.pigfarm.production.dto.GoodsReceiptDto;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;
@Slf4j
@Service
public class GoodsReceiptManager {
	@Autowired
	private RestHelper restHelper;
	@Autowired
	private ServiceProperties serviceProperties;
	
	public PageDto search(GoodsReceiptDto criteria) {
		log.info("PROCESS: SEARCH GOODS_RECEIPTS, criteria: {}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GOODS_RECEIPT_SEARCH.val), HttpMethod.POST, criteria, PageDto.class);
		return (PageDto) response.getBody();
	}
	
	public GoodsReceiptDto get(Long id) {
		log.info("PROCESS: GET GOODS_RECEIPT, GOODS_RECEIPT_ID: {}", id);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GOODS_RECEIPT_GET.val), HttpMethod.GET, GoodsReceiptDto.class,id);
		return (GoodsReceiptDto) response.getBody();
	}
	
	public EntityResponse save(GoodsReceiptDto goodsReceipt) {
		log.info("PRCESS: SAVE GOODS_RECEIPT, GOODS_RECEIPT: {}", goodsReceipt);
		ResponseEntity<?> response = null;
		if (goodsReceipt.getId() != null) {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GOODS_RECEIPT_UPDATE.val), HttpMethod.PUT, goodsReceipt, EntityResponse.class, goodsReceipt.getId());
		} else {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GOODS_RECEIPT_CREATE.val), HttpMethod.POST, goodsReceipt, EntityResponse.class);
		}
		return (EntityResponse)response.getBody();	
	}
	
	public EntityResponse cancel(GoodsReceiptDto goodsReceipt) {
		log.info("PROCESS: CANCEL GOODS_RECEIPT, GOODS_RECEIPT_ID: {}", goodsReceipt);
		ResponseEntity<?> response = null;
		if (goodsReceipt.getId() != null) {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GOODS_RECEIPT_CANCEL.val), HttpMethod.PUT, goodsReceipt, EntityResponse.class, goodsReceipt.getId());
		} else {
			return null;
		}
		return (EntityResponse)response.getBody();	
	}
	
	public EntityResponse delete(Long id) {
		log.info("PROCESS: DELETE GOODS_RECEIPT, GOODS_RECEIPT_ID: {}", id);
		
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GOODS_RECEIPT_DELETE.val), HttpMethod.DELETE, EntityResponse.class,id);
		return (EntityResponse) response.getBody();
	}
	
	@SuppressWarnings("unchecked")
	public List<GoodsReceiptDto> getTemplates() {
		log.info("PROCESS: GET GOODS_RECEIPT TYPE TEMPLATE");
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GOODS_RECEIPT_GET_TEMPLATE.val), HttpMethod.GET, new ParameterizedTypeReference<List<GoodsReceiptDto>>() {});
		return (List<GoodsReceiptDto>)response.getBody();
	}
}
