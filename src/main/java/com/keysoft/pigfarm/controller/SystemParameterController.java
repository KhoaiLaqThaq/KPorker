package com.keysoft.pigfarm.controller;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.keysoft.pigfarm.constant.ModelViewEnum;
import com.keysoft.pigfarm.manager.SystemParameterManager;
import com.keysoft.pigfarm.production.dto.SystemParameterDto;
import com.keysoft.pigfarm.util.UserContext;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class SystemParameterController extends BaseController{

	@Autowired
	private SystemParameterManager systemParameterManager;
	
	@GetMapping("/systemParameter/list")
    public ModelAndView list(HttpServletRequest request) throws Exception {
    	log.debug("entering 'list' method...");
    	SystemParameterDto criteria = new SystemParameterDto();
    	criteria.setSize(appProperties.getDefaultPageSize());
    	criteria.setPage(appProperties.getDefaultPage());
    	ModelAndView modelAndView = new ModelAndView(ModelViewEnum.VIEW_SYSTEM_PARAM_LIST.mav);
		modelAndView.addObject(ModelViewEnum.MODEL_PAGE.mav, systemParameterManager.search(criteria));
        return modelAndView;
    }
	    
    @PostMapping("/systemParameter/list")
    public ModelAndView search(@Valid SystemParameterDto criteria, BindingResult bindingResult){
    	log.debug("entering 'search' method...");
    	ModelAndView modelAndView = new ModelAndView(ModelViewEnum.VIEW_SYSTEM_PARAM_LIST.mav);
		if(criteria != null && criteria.getSize() == null){
			criteria.setSize(appProperties.getDefaultPageSize());
	    	criteria.setPage(appProperties.getDefaultPage());
	    }
		modelAndView.addObject(ModelViewEnum.MODEL_PAGE.mav, systemParameterManager.search(criteria));
        return modelAndView;
    }
    
    @ModelAttribute
    @GetMapping("/systemParameter/form")
    public ModelAndView show(@RequestParam(value="id", required=false) Long id) throws Exception {
    	log.debug("entering 'show' method...");
    	ModelAndView modelAndView = new ModelAndView(ModelViewEnum.VIEW_SYSTEM_PARAM_FORM.mav);
    	SystemParameterDto systemParameter = new SystemParameterDto();
    	if(id != null) {
    		systemParameter = systemParameterManager.get(id);
    	} else {
    		systemParameter.setVersion(1);
    	}
		modelAndView.addObject("systemParameter", systemParameter);
        return modelAndView;
    }
    
    @PostMapping("/systemParameter/save")
    public String save(@Valid SystemParameterDto systemParameterDto, BindingResult bindingResult, HttpServletRequest request, HttpServletResponse response) throws Exception {
        log.debug("ENTERING 'SAVE SYSTEM_PARAMETER' METHOD...");
        log.debug("=====> LOG CHECK DEBUG: SAVE SYSTEM_PARAMETER - USER_NAME: {} - PARAM_NAME: {} - PARAM_VALUE: {}", UserContext.getUsername(), systemParameterDto.getParamName(), systemParameterDto.getParamValue());
        Locale locale = request.getLocale();
        String view = ModelViewEnum.VIEW_SYSTEM_PARAM_FORM.mav;
        if (bindingResult.hasErrors()) {
        	addError(request, bindingResult.getAllErrors().toString());
            return view;
        }
        view = "redirect:/systemParameter/list";
        try {
        	SystemParameterDto savedSystemParam = systemParameterManager.save(systemParameterDto);
            if(savedSystemParam != null) {
            	 addMessage(request, getText("systemParameter.updated.success", locale));
            } else {
            	addError(request, getText("systemParameter.updated.fail", locale));
            }
		} catch (Exception e) {
			log.error("Save System Parameter error : " + e);
			addError(request, getText("systemParameter.updated.fail", locale));
		}
        return view;
    }
}
