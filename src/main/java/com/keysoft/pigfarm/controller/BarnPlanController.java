 package com.keysoft.pigfarm.controller;


import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.keysoft.pigfarm.common.BarnPlanStatusEnum;
import com.keysoft.pigfarm.constant.ModelViewEnum;
import com.keysoft.pigfarm.integration.EntityResponse;
import com.keysoft.pigfarm.manager.BarnPlanManager;
import com.keysoft.pigfarm.production.dto.BarnPlanDto;

import lombok.extern.slf4j.Slf4j;

/**
 * Generated by Speed Generator
 * 
 * @author <a href="mailto:ngtrungkien@gmail.com">Kien Nguyen</a>
 */
@Slf4j
@Controller
public class BarnPlanController extends BaseController {

	@Autowired
    private BarnPlanManager barnPlanManager;

    @GetMapping("/barnPlan/list")
    public ModelAndView list(HttpServletRequest request) {
    	log.debug("ENTERING 'LIST BARN_PLAN' METHOD..."); 
    	BarnPlanDto criteria = BarnPlanDto.builder().size(appProperties.getDefaultPageSize()).page(appProperties.getDefaultPage()).build();
    	List<String> barnPlanStatus = new ArrayList<>();
    	Arrays.asList(BarnPlanStatusEnum.values()).forEach(item -> barnPlanStatus.add(item.value));
    	ModelAndView modelAndView = new ModelAndView("barn-plan-list");
    	modelAndView.addObject("page", barnPlanManager.search(criteria));
    	modelAndView.addObject("barnPlanStatus", barnPlanStatus);
    	modelAndView.addObject("criteria",criteria);
        return modelAndView;
    }
    
    @PostMapping("/barnPlan/list")
    public ModelAndView search(@Valid BarnPlanDto criteria, BindingResult bindingResult){
    	log.debug("ENTERING 'SEARCH BARN_PLAN' METHOD..."); 
    	ModelAndView modelAndView = new ModelAndView("barn-plan-list");
		if(criteria != null && criteria.getSize() == null){
			criteria.setSize(appProperties.getDefaultPageSize());
	    	criteria.setPage(appProperties.getDefaultPage());
	    }
    	List<String> barnPlanStatus = new ArrayList<>();
    	Arrays.asList(BarnPlanStatusEnum.values()).forEach(item -> barnPlanStatus.add(item.value));
    	modelAndView.addObject("page", barnPlanManager.search(criteria));
    	modelAndView.addObject("criteria",criteria);
    	modelAndView.addObject("barnPlanStatus", barnPlanStatus);
    	return modelAndView;
    }
    
    @ModelAttribute
    @GetMapping("/barnPlan/form")
    public ModelAndView show(@RequestParam(value="id", required=true) Long id, HttpServletRequest request) throws Exception {
    	log.debug("ENTERING 'SHOW BARN_PLAN' METHOD...");
    	Locale locale = request.getLocale();
    	
    	ModelAndView modelAndView = new ModelAndView("barn-plan-form");
    	BarnPlanDto barnPlanDto = new BarnPlanDto();
    	if(id != null) {
    		 barnPlanDto = barnPlanManager.get(id);
    		 if(barnPlanDto == null) {
    	    		addError(request, getText("data.notfound", locale));
    	    		return new ModelAndView("redirect:/barnPlan/list");
    	    	}
    	}
    	modelAndView.addObject("barnPlan", barnPlanDto);
    	
        return modelAndView;
    }

    @PostMapping("/barnPlan/confirm")
    public String save(@Valid BarnPlanDto barnPlanDto, BindingResult bindingResult, HttpServletRequest request, HttpServletResponse response) {
        log.debug("ENTERING 'SAVE BARN_PLAN' METHOD..."); 
        Locale locale = request.getLocale();
        String view = ModelViewEnum.VIEW_BARN_PLAN_LIST.mav;
        if (bindingResult.hasErrors()) {
        	addError(request, bindingResult.getAllErrors().toString());
            return view;
        }
        try {
        	EntityResponse result  = barnPlanManager.confirm(barnPlanDto);
            if(String.valueOf(HttpStatus.OK.value()).equals(result.getCode())) {
            	 addMessage(request, getText("plan.updated.success", locale));
            } else {
            	addError(request, result.getMessage());
            }
        } catch (Exception e) {
        	log.error("SAVE BARN_PLAN ERROR EXCEPTION: {}", e);
			addError(request, e.getMessage());
		}
        view = "redirect:/barnPlan/list";
        return view;
    }
 
    
}
