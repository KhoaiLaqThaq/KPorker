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
import com.keysoft.pigfarm.manager.InstockManager;
import com.keysoft.pigfarm.production.dto.InstockDto;
import com.keysoft.pigfarm.production.dto.MaterialDetailDto;
import com.keysoft.pigfarm.production.dto.SearchDto;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class InstockController extends BaseController{
	@Autowired
	private InstockManager instockManager;
	@Autowired
	private FarmManager farmManager;
	
	Map<String, SearchDto> userSearchs = new HashMap<>();
	
	@GetMapping("/instock/list")
    public ModelAndView instocks(HttpServletRequest request) throws Exception {
    	log.debug("ENTERING 'LIST INSTOCK' METHOD...");
    	String userName = request.getUserPrincipal().getName();
		String url = request.getRequestURI();
		if(userSearchs.containsKey(userName)) {
			SearchDto searchDto = userSearchs.get(userName);
			String lastUrl = searchDto.getLatestUrl();
			
			if(lastUrl.equals(url) && searchDto.getSearchInstock() != null) {
				return searchInstocks(searchDto.getSearchInstock(), request);
			}
		}
		
		ModelAndView modelAndView = new ModelAndView("instock-list");
		InstockDto criteria = new InstockDto();
    	criteria.setLatestOfDay(true);
    	criteria.setSize(appProperties.getDefaultPageSize());
    	criteria.setPage(appProperties.getDefaultPage());
    	modelAndView.addObject("farms", farmManager.getFarmByUserName());
		modelAndView.addObject("page", instockManager.gets(criteria));
		modelAndView.addObject("criteria", criteria);
        return modelAndView;
    }
	    
    @PostMapping("/instock/list")
    public ModelAndView searchInstocks(@Valid InstockDto criteria, HttpServletRequest request){
    	log.debug("ENTERING 'SEARCH INSTOCK' METHOD...");
		ModelAndView modelAndView = new ModelAndView("instock-list");
		if(criteria != null && criteria.getSize() == null){
			criteria.setSize(appProperties.getDefaultPageSize());
	    	criteria.setPage(appProperties.getDefaultPage());
	    }
		if(StringUtils.isNotBlank(criteria.getSyncDateSearch())) {
			LocalDate syncDate = DateTimeHelper.toLocalDate(criteria.getSyncDateSearch(), DatePatternEnum.DD_MM_YYYY_2.pattern);
			criteria.setSyncDate(syncDate);
		}
		
		modelAndView.addObject("farms", farmManager.getFarmByUserName());
		modelAndView.addObject("page", instockManager.gets(criteria));
		modelAndView.addObject("criteria", criteria);
		
		String userName = request.getUserPrincipal().getName();
		String url = request.getRequestURI();
		if(userSearchs.containsKey(userName)) {
			SearchDto searchDto = userSearchs.get(userName);
			searchDto.setSearchInstock(criteria);
			searchDto.setLatestUrl(url);
			userSearchs.put(userName, searchDto);
		} else {
			SearchDto searchDto = new SearchDto();
			searchDto.setSearchInstock(criteria);
			searchDto.setLatestUrl(url);
			userSearchs.put(userName, searchDto);
		}
		
        return modelAndView;
    }
		
	@ModelAttribute
    @GetMapping("/instock/form")
    public ModelAndView showForm(@RequestParam (value="id", required=false) Long id, HttpServletRequest request) throws Exception {
		log.debug("ENTERING 'SHOW INSTOCK' METHOD...");
		Locale locale = request.getLocale();
		
    	ModelAndView modelAndView = new ModelAndView("instock-form");
    	InstockDto instock = new InstockDto();
    	List<MaterialDetailDto> materialDetails = new ArrayList<>();
    	if(id != null) {
    		instock = instockManager.get(id);
    		if(instock == null) {
        		addError(request, getText("data.notfound", locale));
				return new ModelAndView("redirect:/instock/list");
        	}
    		materialDetails = instock.getMaterialDetails();
    	} else {
    		modelAndView.setViewName("redirect:/instock/list");
    		addError(request, getText("instock.notfound", locale));
    	}
		modelAndView.addObject("materialExistings", materialDetails);
        modelAndView.addObject("instock", instock);

        return modelAndView;
    }
}
