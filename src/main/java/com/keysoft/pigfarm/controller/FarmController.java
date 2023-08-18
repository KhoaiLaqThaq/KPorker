package com.keysoft.pigfarm.controller;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.keysoft.pigfarm.constant.ModelViewEnum;
import com.keysoft.pigfarm.manager.FarmManager;
import com.keysoft.pigfarm.production.dto.FarmDto;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class FarmController extends BaseController {
	@Autowired
	private FarmManager farmManager;		
	
	@GetMapping("/farm/list")
	public ModelAndView list(HttpServletRequest request) throws IOException {
		log.debug("entering 'list' method...");
		ModelAndView modelAndView = new ModelAndView(ModelViewEnum.VIEW_FARM_LIST.mav);
		FarmDto criteria = FarmDto.builder()
									.porkerFarm(true)
									.page(appProperties.getDefaultPage())
									.size(appProperties.getDefaultPageSize())
									.build();
		modelAndView.addObject(ModelViewEnum.MODEL_PAGE.mav, farmManager.search(criteria));
		return modelAndView;
	}
	
	@PostMapping("/farm/list")
	public ModelAndView search(@Valid FarmDto criteria, BindingResult bindingResult ) {
		log.debug("entering 'search list' method...");
		ModelAndView modelAndView = new ModelAndView(ModelViewEnum.VIEW_FARM_LIST.mav);
		modelAndView.addObject("searchName", criteria.getName());
		modelAndView.addObject("searchCode", criteria.getCode());
		modelAndView.addObject(ModelViewEnum.MODEL_PAGE.mav, farmManager.search(criteria));	
		return modelAndView;
	}
	@GetMapping("/checkFarmCode")
	public @ResponseBody Boolean checkFarmCode(@RequestParam(value="id", required= false) Long id, @RequestParam String code) {
		log.debug("entering check farm code");
		return farmManager.checkFarmCode(code, id);
	}
	
}
