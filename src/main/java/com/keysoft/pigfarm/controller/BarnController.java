package com.keysoft.pigfarm.controller;


import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.keysoft.pigfarm.common.PageDto;
import com.keysoft.pigfarm.constant.ModelViewEnum;
import com.keysoft.pigfarm.manager.BarnManager;
import com.keysoft.pigfarm.production.dto.BarnDto;

import lombok.extern.slf4j.Slf4j;

/**
 * Generated by Speed Generator
 * 
 * @author <a href="mailto:ngtrungkien@gmail.com">Kien Nguyen</a>
 */
 @Slf4j
@Controller
public class BarnController extends BaseController {

	@Autowired
    private BarnManager barnManager;
    @GetMapping("/barn/list")
    public ModelAndView list(@RequestParam(value = "farmCode",required = true) String farmCode,HttpServletRequest request) throws Exception {
    	log.debug("entering 'list' method...");
    	Locale locale = request.getLocale();
    	
    	BarnDto criteria = BarnDto.builder()
    								.farmCode(farmCode)
    								.page(appProperties.getDefaultPage())
    								.size(appProperties.getDefaultPageSize())
    								.build();	
		ModelAndView modelAndView = new ModelAndView(ModelViewEnum.VIEW_BARN_LIST.mav);
		System.err.println(barnManager.gets(criteria));
		PageDto page = barnManager.gets(criteria);
		if(page == null) {
			addError(request, getText("data.notfound", locale));
			return new ModelAndView("redirect:/farm/list");
		}
		modelAndView.addObject(ModelViewEnum.MODEL_PAGE.mav, barnManager.gets(criteria));
        return modelAndView;
    }
    
}