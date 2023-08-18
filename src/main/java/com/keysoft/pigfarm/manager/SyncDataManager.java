package com.keysoft.pigfarm.manager;

import com.keysoft.pigfarm.production.dto.GeneralLedgerDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.keysoft.pigfarm.config.ServiceProperties;
import com.keysoft.pigfarm.constant.ApiEnum;
import com.keysoft.pigfarm.production.json.SyncResponse;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class SyncDataManager {
	@Autowired
	private RestHelper restHelper;
	@Autowired
	private ServiceProperties serviceProperties;
	
	public SyncResponse syncMasterDataFromSAP() {
		log.info("PROCESS: SYNC_MASTER_DATA_FROM_SAP");
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_SYNC_ALL_MASTER_DATA_FROM_SAP.val), HttpMethod.GET, SyncResponse.class);
		return (SyncResponse) response.getBody();
	}
	
	//sync all data to SAP
	public SyncResponse syncDataToSAP() {
		log.info("PROCESS: SYNC_DATA_TO_SAP");
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_SYNC_ALL_DATA_TO_SAP.val), HttpMethod.GET,SyncResponse.class);
		return (SyncResponse) response.getBody();
	}

	public SyncResponse syncGL(GeneralLedgerDto data) {
		log.info("PROCESS: SYNC_GENERAL_LEDGER()");
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_SYNC_GL_DATA_TO_SAP.val), HttpMethod.POST, data, SyncResponse.class);
		return (SyncResponse) response.getBody();
	}
	
	// realtime - doi voi dong lenh san xuat thi can gui luon thong tin len SAP
	public SyncResponse closedPO(String transCode) {
		log.info("PROCESS: CLOSE PROCESS_ORDER, PROCESS_ORDER_TRANS_CODE: {}", transCode);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PROCESS_ORDER_CLOSED.val), HttpMethod.GET,SyncResponse.class,transCode);
		return (SyncResponse) response.getBody();
	}
	
	// realtime - doi voi dong lenh san xuat thi can gui luon thong tin len SAP
	// nhap kho thanh pham va heo thai loai
	public SyncResponse sendDataToSAP() {
		log.info("PROCESS: SYNC_DATA_TO_SAP");
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_SYNC_FINISH_PRODUCTION_DATA_TO_SAP.val), HttpMethod.GET,SyncResponse.class);
		return (SyncResponse) response.getBody();
	}
	
	//sync all data to SAP
	public SyncResponse syncGoodsAtritionDataToSAP() {
		log.info("PROCESS: SYNC_GOODS_ATTRITION_DATA_TO_SAP");
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_SYNC_GOODS_ATTRITION_DATA_TO_SAP.val), HttpMethod.GET,SyncResponse.class);
		return (SyncResponse) response.getBody();
	}
}
