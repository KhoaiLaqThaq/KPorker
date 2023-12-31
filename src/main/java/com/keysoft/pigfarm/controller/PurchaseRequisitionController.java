package com.keysoft.pigfarm.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.util.CollectionUtils;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.keysoft.pigfarm.common.PrTypeEnum;
import com.keysoft.pigfarm.common.PurchaseRequisitionStatusEnum;
import com.keysoft.pigfarm.common.PurchaseRequisitionTypeEnum;
import com.keysoft.pigfarm.common.TransCodeTypeEnum;
import com.keysoft.pigfarm.integration.EntityResponse;
import com.keysoft.pigfarm.manager.FarmManager;
import com.keysoft.pigfarm.manager.PurchaseRequisitionManager;
import com.keysoft.pigfarm.manager.TransCodeManager;
import com.keysoft.pigfarm.production.dto.FarmDto;
import com.keysoft.pigfarm.production.dto.MaterialDetailDto;
import com.keysoft.pigfarm.production.dto.PurchaseRequisitionDto;
import com.keysoft.pigfarm.production.dto.SearchDto;
import com.keysoft.pigfarm.util.UserContext;

import lombok.extern.slf4j.Slf4j;

/**
 * Generated by Speed Generator
 * 
 * @author <a href="mailto:ngtrungkien@gmail.com">Kien Nguyen</a>
 */
 @Slf4j
@Controller
public class PurchaseRequisitionController extends BaseController {

	@Autowired
    private PurchaseRequisitionManager purchaseRequisitionManager;
	@Autowired
	private FarmManager farmManager;
	@Autowired
	private TransCodeManager transCodeManager;
	
	Map<String, SearchDto> userSearchs = new HashMap<>();

    @GetMapping("/purchaseRequisition/list")
    public ModelAndView list(HttpServletRequest request) throws Exception {
    	log.debug("ENTERING 'LIST PURCHASE_REQUISITION' METHOD...");
    	
    	String userName = request.getUserPrincipal().getName();
		String url = request.getRequestURI();
		if(userSearchs.containsKey(userName)) {
			SearchDto searchDto = userSearchs.get(userName);
			String lastUrl = searchDto.getLatestUrl();
			
			if(lastUrl.equals(url) && searchDto.getSearchPR() != null) {
				return search(searchDto.getSearchPR(), request);
			}
		}
		
    	PurchaseRequisitionDto criteria = new PurchaseRequisitionDto();
    	criteria.setSize(appProperties.getDefaultPageSize());
    	criteria.setPage(appProperties.getDefaultPage());
		ModelAndView modelAndView = new ModelAndView("purchaserequisition-list");
		List<String> types = new ArrayList<String>();
    	Arrays.asList(PurchaseRequisitionTypeEnum.values()).forEach(item -> types.add(item.val));
    	types.remove(PurchaseRequisitionTypeEnum.TEMPLATE.val);
		List<String> prStatus = new ArrayList<String>();
    	Arrays.asList(PurchaseRequisitionStatusEnum.values()).forEach(item -> prStatus.add(item.val));
    	prStatus.remove(PurchaseRequisitionStatusEnum.DELETE.val);
    	List<String> prTypes = new ArrayList<String>();
    	Arrays.asList(PrTypeEnum.values()).forEach(item -> prTypes.add(item.val));
    	
		modelAndView.addObject("prStatus", prStatus);
		modelAndView.addObject("prTypes", prTypes);
		modelAndView.addObject("types", types);
		modelAndView.addObject("page", purchaseRequisitionManager.gets(criteria));
		modelAndView.addObject("criteria", criteria);
		modelAndView.addObject("prTemplates", purchaseRequisitionManager.getTemplates());

        return modelAndView;
    }
    
    @PostMapping("/purchaseRequisition/list")
    public ModelAndView search(@Valid PurchaseRequisitionDto criteria, HttpServletRequest request){
    	log.debug("ENTERING 'SEARCH PURCHASE_REQUISITION' METHOD...");
		ModelAndView modelAndView = new ModelAndView("purchaserequisition-list");
		if(criteria != null && criteria.getSize() == null){
			criteria.setSize(appProperties.getDefaultPageSize());
	    	criteria.setPage(appProperties.getDefaultPage());
	    }
		List<String> types = new ArrayList<String>();
    	Arrays.asList(PurchaseRequisitionTypeEnum.values()).forEach(item -> types.add(item.val));
    	types.remove(PurchaseRequisitionTypeEnum.TEMPLATE.val);
		List<String> prStatus = new ArrayList<String>();
    	Arrays.asList(PurchaseRequisitionStatusEnum.values()).forEach(item -> prStatus.add(item.val));
    	prStatus.remove(PurchaseRequisitionStatusEnum.DELETE.val);
    	List<String> prTypes = new ArrayList<String>();
    	Arrays.asList(PrTypeEnum.values()).forEach(item -> prTypes.add(item.val));
    	modelAndView.addObject("prTypes", prTypes);
		modelAndView.addObject("prStatus", prStatus);
		modelAndView.addObject("types", types);
		modelAndView.addObject("page", purchaseRequisitionManager.gets(criteria));
		modelAndView.addObject("prTemplates", purchaseRequisitionManager.getTemplates());
		modelAndView.addObject("criteria", criteria);
		
		String userName = request.getUserPrincipal().getName();
		String url = request.getRequestURI();
		if(userSearchs.containsKey(userName)) {
			SearchDto searchDto = userSearchs.get(userName);
			searchDto.setSearchPR(criteria);
			searchDto.setLatestUrl(url);
			userSearchs.put(userName, searchDto);
		} else {
			SearchDto searchDto = new SearchDto();
			searchDto.setSearchPR(criteria);
			searchDto.setLatestUrl(url);
			userSearchs.put(userName, searchDto);
		}
		
        return modelAndView;
    }
    
	@ModelAttribute
    @GetMapping("/purchaseRequisition/form")
    public ModelAndView show(@RequestParam(value="id", required=false) Long id, @RequestParam(value="clone", required=false) Boolean cloneData, HttpServletRequest request) throws Exception {
    	log.debug("ENTERING 'SHOW PURCHASE_REQUISITION' METHOD...");
    	Locale locale = request.getLocale();
    	ModelAndView modelAndView = new ModelAndView("purchaserequisition-form");
    	PurchaseRequisitionDto purchaseRequisition = new PurchaseRequisitionDto();
    	String username = UserContext.getUsername();
    	List<MaterialDetailDto> materialExistings = new ArrayList<>();
    	if(id != null) {
    		purchaseRequisition = purchaseRequisitionManager.get(id);
    		if(purchaseRequisition == null) {
        		addError(request, getText("data.notfound", locale));
				return new ModelAndView("redirect:/purchaseRequisition/list");
        	}
    		
    		// set lai mac dinh la user neu la phieu yeu cau nhan tu sap
    		if(StringUtils.isBlank(purchaseRequisition.getRequisitioner())) {
    			purchaseRequisition.setRequisitioner(username);
    		}
    		if(StringUtils.isNotBlank(purchaseRequisition.getCreatedBy())) {
    			if(purchaseRequisition.getCreatedBy().equals("system")) {
    				purchaseRequisition.setRequisitioner(username);
    			}
    		} else {
    			purchaseRequisition.setRequisitioner(username);
    		}
    		
    		if(purchaseRequisition.getType().equals(PurchaseRequisitionTypeEnum.TEMPLATE.val)) {
    			purchaseRequisition.setTransCode(transCodeManager.getTransCode(TransCodeTypeEnum.PURCHASE_REQUISITION.val));
    		}
    		if(!CollectionUtils.isEmpty(purchaseRequisition.getMaterialDetails())) {
    			materialExistings = purchaseRequisition.getMaterialDetails();
    		} else {
    			materialExistings.add(new MaterialDetailDto());
    		}
    		// clone ban ghi moi dua tren ban ghi cu neu trang thai phieu cu bi reject
    		if(cloneData != null) {
    			purchaseRequisition.setId(null);
    			purchaseRequisition.setPrGroupCode(null); // tao tu pigfarm thi k co prGroupCode
    			purchaseRequisition.setStatus(PurchaseRequisitionStatusEnum.UNCONFIRMED.val);
    			purchaseRequisition.setType(PurchaseRequisitionTypeEnum.PR_FROM_PIGFARM.val);
    			purchaseRequisition.setRequisitioner(username);
    			purchaseRequisition.setCreatedBy(username);
    			purchaseRequisition.setTransCode(transCodeManager.getTransCode(TransCodeTypeEnum.PURCHASE_REQUISITION.val));
    		}
    	} else {
    		purchaseRequisition.setType(PurchaseRequisitionTypeEnum.PR_FROM_PIGFARM.val);
    		purchaseRequisition.setPrType(PrTypeEnum.Z1.val);
    		purchaseRequisition.setStatus(PurchaseRequisitionStatusEnum.UNCONFIRMED.val);
    		purchaseRequisition.setTransCode(transCodeManager.getTransCode(TransCodeTypeEnum.PURCHASE_REQUISITION.val));
    		purchaseRequisition.setCreatedBy(username);
    		purchaseRequisition.setRequisitioner(username);
    		materialExistings.add(new MaterialDetailDto());
    	}
    	
    	List<String> prTypes = new ArrayList<String>();
    	Arrays.asList(PrTypeEnum.values()).forEach(item -> prTypes.add(item.val));
    	List<FarmDto> farms = farmManager.getFarmByUserName();
        
		modelAndView.addObject("materialExistings", materialExistings);
		modelAndView.addObject("purchaseRequisition", purchaseRequisition);
		modelAndView.addObject("prTypes", prTypes);
		modelAndView.addObject("farms", farms);

        return modelAndView;
    }
    
    @PostMapping("/purchaseRequisition/save")
    public String save(@Valid PurchaseRequisitionDto purchaseRequisitionDto, BindingResult bindingResult, HttpServletRequest request, HttpServletResponse response) throws Exception {
        log.debug("ENTERING 'SAVE PURCHASE_REQUISITION' METHOD...");
        Locale locale = request.getLocale();
        String view = "purchaseRequisition-form";
        if(purchaseRequisitionDto.getId() != null) {
        	 view = "/purchaseRequisition/form?id=" + purchaseRequisitionDto.getId();
        }
        if (bindingResult.hasErrors()) {
        	addError(request, bindingResult.getAllErrors().toString());
            return view;
        }
        view = "redirect:/purchaseRequisition/list";
        try {
            if(StringUtils.isBlank(purchaseRequisitionDto.getTransCode())) {
            	purchaseRequisitionDto.setTransCode(transCodeManager.getTransCode(TransCodeTypeEnum.PURCHASE_REQUISITION.val));
            }
            EntityResponse result = purchaseRequisitionManager.save(purchaseRequisitionDto);
            if(String.valueOf(HttpStatus.OK.value()).equals(result.getCode())) {
            	 addMessage(request, getText("purchaseRequisition.updated.success", locale));
            } else {
            	addError(request, result.getMessage());
            }
		} catch (Exception e) {
			log.error("ERROR SAVE PURCHASE_REQUISITION: EXCEPTION: {}", e);
			addError(request, e.getMessage());
		}
        return view;
    }
    
    @GetMapping("/purchaseRequisition/delete/{id}")
    public String deletePRTemplate(@PathVariable(value="id") Long id, HttpServletRequest request) {
    	log.debug("ENTERING 'DELETE PURCHASE_REQUISITION' METHOD...");
    	Locale locale = request.getLocale();
    	String view = "redirect:/purchaseRequisition/list";
    	try {
    		purchaseRequisitionManager.delete(id);
    		addMessage(request, getText("purchaseRequisition.delete.success", locale));
		} catch (Exception e) {
			log.error("ERROR DELETE PURCHASE_REQUISITION: EXCEPTION: {}", e);
			addError(request, e.getMessage());
		}
    	return view;
    }
}