package com.keysoft.pigfarm.controller;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.keysoft.pigfarm.common.DatePatternEnum;
import com.keysoft.pigfarm.helper.DateTimeHelper;
import com.keysoft.pigfarm.manager.FarmManager;
import com.keysoft.pigfarm.manager.InstockBaselineManager;
import com.keysoft.pigfarm.production.dto.InstockBaselineDto;
import com.keysoft.pigfarm.production.dto.MaterialDetailBaselineDto;
import com.keysoft.pigfarm.production.dto.SearchDto;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class InstockBaselineController extends BaseController {
	@Autowired
	private InstockBaselineManager instockBaselineManager;
	@Autowired
	private FarmManager farmManager;
	
	Map<String, SearchDto> userSearchs = new HashMap<>();
	
	@GetMapping("/instock-baseline/list")
    public ModelAndView instocks(HttpServletRequest request) throws Exception {
    	log.debug("ENTERING 'LIST INSTOCK_BASELINE' METHOD...");
    	
    	String userName = request.getUserPrincipal().getName();
		String url = request.getRequestURI();
		if(userSearchs.containsKey(userName)) {
			SearchDto searchDto = userSearchs.get(userName);
			String lastUrl = searchDto.getLatestUrl();
			
			if(lastUrl.equals(url) && searchDto.getSearchInstockBase() != null) {
				return searchInstocks(searchDto.getSearchInstockBase(), request);
			}
		}
		
		ModelAndView modelAndView = new ModelAndView("instock-baseline-list");
		InstockBaselineDto criteria = new InstockBaselineDto();
    	criteria.setLatestOfDay(true);
    	criteria.setSize(appProperties.getDefaultPageSize());
    	criteria.setPage(appProperties.getDefaultPage());
    	modelAndView.addObject("farms", farmManager.getFarmByUserName());
		modelAndView.addObject("page", instockBaselineManager.gets(criteria));
		modelAndView.addObject("criteria", criteria);
        return modelAndView;
    }
	    
    @PostMapping("/instock-baseline/list")
    public ModelAndView searchInstocks(@Valid InstockBaselineDto criteria, HttpServletRequest request){
    	log.debug("ENTERING 'SEARCH INSTOCK_BASELINE' METHOD...");
		ModelAndView modelAndView = new ModelAndView("instock-baseline-list");
		if(criteria != null && criteria.getSize() == null){
			criteria.setSize(appProperties.getDefaultPageSize());
	    	criteria.setPage(appProperties.getDefaultPage());
	    }
		
		if(StringUtils.isNotBlank(criteria.getSyncDateSearch())) {
			LocalDate syncDate = DateTimeHelper.toLocalDate(criteria.getSyncDateSearch(), DatePatternEnum.DD_MM_YYYY_2.pattern);
			criteria.setSyncDate(syncDate);
		}
		
		modelAndView.addObject("farms", farmManager.getFarmByUserName());
		modelAndView.addObject("page", instockBaselineManager.gets(criteria));
		modelAndView.addObject("criteria", criteria);
		
		String userName = request.getUserPrincipal().getName();
		String url = request.getRequestURI();
		if(userSearchs.containsKey(userName)) {
			SearchDto searchDto = userSearchs.get(userName);
			searchDto.setSearchInstockBase(criteria);
			searchDto.setLatestUrl(url);
			userSearchs.put(userName, searchDto);
		} else {
			SearchDto searchDto = new SearchDto();
			searchDto.setSearchInstockBase(criteria);
			searchDto.setLatestUrl(url);
			userSearchs.put(userName, searchDto);
		}
		
        return modelAndView;
    }
		
	@ModelAttribute
    @GetMapping("/instock-baseline/form")
    public ModelAndView showForm(@RequestParam (value="id", required=false) Long id, HttpServletRequest request) throws Exception {
		log.debug("ENTERING 'SHOW INSTOCK_BASELINE' METHOD...");
		Locale locale = request.getLocale();
		
    	ModelAndView modelAndView = new ModelAndView("instock-baseline-form");
    	InstockBaselineDto instockBaseline = new InstockBaselineDto();
    	List<MaterialDetailBaselineDto> materialDetails = new ArrayList<>();
    	if(id != null) {
    		instockBaseline = instockBaselineManager.get(id);
    		if(instockBaseline == null) {
        		addError(request, getText("data.notfound", locale));
				return new ModelAndView("redirect:/instock-baseline/list");
        	}
    		materialDetails = instockBaseline.getMaterialDetails();
    	} else {
    		modelAndView.setViewName("redirect:/instock-baseline/list");
    		addError(request, getText("instock.notfound", locale));
    	}
		modelAndView.addObject("materialExistings", materialDetails);
        modelAndView.addObject("instockBaseline", instockBaseline);

        return modelAndView;
    }
}
