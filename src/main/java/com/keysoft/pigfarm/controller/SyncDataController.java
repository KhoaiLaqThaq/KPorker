package com.keysoft.pigfarm.controller;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import com.keysoft.pigfarm.config.ServiceProperties;
import com.keysoft.pigfarm.manager.SyncDataManager;
import com.keysoft.pigfarm.production.json.SyncResponse;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class SyncDataController extends BaseController{
	@Autowired
	RestHelper restHelper ;
	@Autowired
	ServiceProperties serviceProperties ;
	@Autowired
	private SyncDataManager syncDataManager;
	
	@GetMapping("/all/sync-from-sap")
    public String synncFromSAP(HttpServletRequest request) throws Exception {
    	log.debug("ENTERING 'SYNC_MASTER_DATA_FROM_SAP' METHOD...");
    	Locale locale = request.getLocale();
    	try {
    		SyncResponse syncResponse = syncDataManager.syncMasterDataFromSAP();
    		if (String.valueOf(HttpStatus.OK.value()).equals(syncResponse.getCode())) {
    			addMessage(request, getText("sync.master.data.success", locale));
			} else {
				addError(request, syncResponse.getMessage());
			}
    		
		} catch (Exception e) {
			log.error("ERROR SYNC_MASTER_DATA_FROM_SAP: EXCEPTION: {}", e);
			addError(request, e.getMessage());
		}
    	return "redirect:/";
    }	
	
	@GetMapping("/all/sync-to-sap")
    public String synncDataToSAP(HttpServletRequest request) throws Exception {
    	log.debug("entering 'synncDataToSAP' method...");
    	Locale locale = request.getLocale();
    	try {
    		SyncResponse syncResponse = syncDataManager.syncDataToSAP();
    		if (String.valueOf(HttpStatus.OK.value()).equals(syncResponse.getCode())) {
    			addMessage(request, getText("sync.data.success", locale));
			} else {
				addError(request, syncResponse.getMessage());
			}
		} catch (Exception e) {
			log.error("ERROR SYNC_DATA_TO_SAP: EXCEPTION: {}", e);
			addError(request, e.getMessage());
		}
    	return "redirect:/";
    }	
}
