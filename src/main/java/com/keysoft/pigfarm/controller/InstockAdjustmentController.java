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

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.CollectionUtils;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.keysoft.pigfarm.common.EntityResponseCodeEnum;
import com.keysoft.pigfarm.common.InstockAdjustmentStatusEnum;
import com.keysoft.pigfarm.common.InstockAdjustmentTypeEnum;
import com.keysoft.pigfarm.common.PurchaseRequisitionStatusEnum;
import com.keysoft.pigfarm.common.TransCodeTypeEnum;
import com.keysoft.pigfarm.integration.EntityResponse;
import com.keysoft.pigfarm.manager.FarmManager;
import com.keysoft.pigfarm.manager.InstockAdjustmentManager;
import com.keysoft.pigfarm.manager.TransCodeManager;
import com.keysoft.pigfarm.production.dto.FarmDto;
import com.keysoft.pigfarm.production.dto.InstockAdjustmentDto;
import com.keysoft.pigfarm.production.dto.MaterialDetailDto;
import com.keysoft.pigfarm.production.dto.SearchDto;
import com.keysoft.pigfarm.util.UserContext;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class InstockAdjustmentController extends BaseController{

	@Autowired
	private InstockAdjustmentManager instockAdjustmentManager;
	@Autowired
	private TransCodeManager transCodeManager;
	@Autowired
	private FarmManager farmManager;
	
	Map<String, SearchDto> userSearchs = new HashMap<>();
	
	@GetMapping("/instockAdjustment/list")
    public ModelAndView list(HttpServletRequest request) throws Exception {
    	log.debug("ENTERING 'LIST INSTOCK_ADJUSTMENT' METHOD...");
    	
    	String userName = request.getUserPrincipal().getName();
		String url = request.getRequestURI();
		if(userSearchs.containsKey(userName)) {
			SearchDto searchDto = userSearchs.get(userName);
			String lastUrl = searchDto.getLatestUrl();
			
			if(lastUrl.equals(url) && searchDto.getSearchInstockAdj() != null) {
				return search(searchDto.getSearchInstockAdj(), request);
			}
		}
		
		ModelAndView modelAndView = new ModelAndView("instock-adjustment-list");
		InstockAdjustmentDto criteria = new InstockAdjustmentDto();
    	criteria.setSize(appProperties.getDefaultPageSize());
    	criteria.setPage(appProperties.getDefaultPage());
		modelAndView.addObject("page", instockAdjustmentManager.gets(criteria));
		modelAndView.addObject("criteria", criteria);
        return modelAndView;
    }

    @PostMapping("/instockAdjustment/list")
    public ModelAndView search(@Valid InstockAdjustmentDto criteria, HttpServletRequest request){
    	log.debug("ENTERING 'SEARCH INSTOCK_ADJUSTMENT' METHOD...");
		ModelAndView modelAndView = new ModelAndView("instock-adjustment-list");
		if(criteria != null && criteria.getSize() == null){
			criteria.setSize(appProperties.getDefaultPageSize());
	    	criteria.setPage(appProperties.getDefaultPage());
	    }
		modelAndView.addObject("page", instockAdjustmentManager.gets(criteria));
		modelAndView.addObject("criteria", criteria);
		
		String userName = request.getUserPrincipal().getName();
		String url = request.getRequestURI();
		if(userSearchs.containsKey(userName)) {
			SearchDto searchDto = userSearchs.get(userName);
			searchDto.setSearchInstockAdj(criteria);
			searchDto.setLatestUrl(url);
			userSearchs.put(userName, searchDto);
		} else {
			SearchDto searchDto = new SearchDto();
			searchDto.setSearchInstockAdj(criteria);
			searchDto.setLatestUrl(url);
			userSearchs.put(userName, searchDto);
		}
		
        return modelAndView;
    }

    @ModelAttribute
    @GetMapping("/instockAdjustment/form")
    public ModelAndView show(@RequestParam(value="id", required=false) Long id, HttpServletRequest request) throws Exception {
    	log.debug("ENTERING 'SHOW INSTOCK_ADJUSTMENT' METHOD...");
    	Locale locale = request.getLocale();
    
    	ModelAndView modelAndView = new ModelAndView("instock-adjustment-form");
    	InstockAdjustmentDto instockAdjustment = new InstockAdjustmentDto();
		List<MaterialDetailDto> materialExistings = new ArrayList<>();
		String username = UserContext.getUsername();
    	List<String> types = new ArrayList<>();
    	Arrays.asList(InstockAdjustmentTypeEnum.values()).forEach(item -> types.add(item.val));
    	if(id != null) {
    		instockAdjustment = instockAdjustmentManager.get(id);
    		if(instockAdjustment == null) {
        		addError(request, getText("data.notfound", locale));
				return new ModelAndView("redirect:/instockAdjustment/list");
        	}
    		
    		if(!CollectionUtils.isEmpty(instockAdjustment.getMaterialDetails())) {
    			materialExistings = instockAdjustment.getMaterialDetails();
    		} else {
    			materialExistings.add(new MaterialDetailDto());
    		}
    	} else {
    		materialExistings.add(new MaterialDetailDto());
    		instockAdjustment.setTransCode(transCodeManager.getTransCode(TransCodeTypeEnum.INSTOCK_ADJUSTMENT.val));
    		instockAdjustment.setUsername(username);
    		instockAdjustment.setStatus(PurchaseRequisitionStatusEnum.CONFIRMED.val);
    		types.remove(InstockAdjustmentTypeEnum.IMPORT.val);
    	}
    	List<FarmDto> farms = farmManager.getFarmByUserName();
		modelAndView.addObject("farms", farms);
        modelAndView.addObject("instockAdjustment", instockAdjustment);
		modelAndView.addObject("materialExistings", materialExistings);
		modelAndView.addObject("types", types);
        return modelAndView;
    }
    
    @PostMapping("/instockAdjustment/save")
    public String save(InstockAdjustmentDto instockAdjustment, BindingResult bindingResult, HttpServletRequest request, HttpServletResponse response) throws Exception {
    	log.debug("ENTERING 'SAVE INSTOCK_ADJUSTMENT' METHOD...");
        Locale locale = request.getLocale();
        String view = "instock-adjustment-form";
        if(instockAdjustment.getId() != null) {
        	 view = "/instockAdjustment/form?id=" + instockAdjustment.getId();
        }
        if (bindingResult.hasErrors()) {
        	addError(request, bindingResult.getAllErrors().toString());
            return view;
        }
        view = "redirect:/instockAdjustment/list";	
        try {
             if(instockAdjustment.getStatus().equals(InstockAdjustmentStatusEnum.CANCEL.val)) {
                 EntityResponse result = instockAdjustmentManager.cancel(instockAdjustment);
                 if(result.getCode().equals(EntityResponseCodeEnum.SUCCESS_200.val)) {
                 	addMessage(request, getText("instock.adjustment.cancel.success", locale));
                 } else if(result.getCode().equals(EntityResponseCodeEnum.ERROR_400.val)){
 	        	     addError(request, getText("data.lock.15.minutes", locale));
	  	         } else {
	  	        	  addError(request, result.getMessage());
	  	         }
             } else {
             	 EntityResponse result = instockAdjustmentManager.save(instockAdjustment);
             	 if(result.getCode().equals(EntityResponseCodeEnum.SUCCESS_200.val)) {
                 	addMessage(request, getText("instock.adjustment.updated.success", locale));
                 } else if(result.getCode().equals(EntityResponseCodeEnum.ERROR_400.val)){
 	        	     addError(request, getText("data.lock.15.minutes", locale));
	  	         } else {
	  	        	  addError(request, result.getMessage());
	  	         }
             }
		} catch (Exception e) {
			log.error("ERROR SAVE INSTOCK_ADJUSTMENT: EXCEPTION: {}", e);
			addError(request, e.getMessage());
		}

       return view;
    }
	
	
}
