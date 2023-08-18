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
import com.keysoft.pigfarm.manager.FarmManager;
import com.keysoft.pigfarm.manager.SiloManager;
import com.keysoft.pigfarm.production.dto.SiloDto;
import com.keysoft.pigfarm.util.UserContext;

import lombok.extern.slf4j.Slf4j;


@Slf4j
@Controller
public class SiloController  extends BaseController {
	
	@Autowired
	private SiloManager siloManager ;
	@Autowired 
	private FarmManager farmManager ;
	
	 @GetMapping("/silo/list")
	    public ModelAndView list(@RequestParam(value = "farmCode",required = true) String farmCode,HttpServletRequest request) throws Exception {
	    	log.debug("entering 'list' method...");
	    	SiloDto criteria = SiloDto.builder().page(appProperties.getDefaultPage()).size(appProperties.getDefaultPageSize()).build();	
	    	criteria.setFarmCode(farmCode);
	    	
			ModelAndView modelAndView = new ModelAndView(ModelViewEnum.VIEW_SILO_LIST.mav);
			modelAndView.addObject("farmCode", farmCode);
			modelAndView.addObject(ModelViewEnum.MODEL_PAGE.mav, siloManager.gets(criteria));
			modelAndView.addObject("criteria", criteria);
	        return modelAndView;
	    }
	 @PostMapping("/silo/list")
	    public ModelAndView search(@Valid SiloDto criteria, BindingResult bindingResult){
	    	log.debug("entering 'search' method...");    	
			ModelAndView modelAndView = new ModelAndView(ModelViewEnum.VIEW_SILO_LIST.mav);
			modelAndView.addObject(ModelViewEnum.MODEL_PAGE.mav, siloManager.gets(criteria));
			modelAndView.addObject("criteria", criteria);
	        return modelAndView;
	    }
	 
	 
		@GetMapping("/silo/form")
		public ModelAndView show(@RequestParam(name="farmCode", required = true) String farmCode, @RequestParam(value="id", required=false) Long id) throws Exception {
			log.debug("entering 'show' method...");
			ModelAndView modelAndView = new ModelAndView("silo-form");
			SiloDto silo = new SiloDto() ;
			if(id != null ){
				silo = siloManager.get(id);
			}
			modelAndView.addObject("silo", silo);
			modelAndView.addObject("farm", farmManager.getByFarmCode(farmCode.trim()));
			return modelAndView;
		}
		
		@PostMapping("/silo/save")
		public String save(@ModelAttribute("silo") SiloDto silo, BindingResult bindingResult, HttpServletRequest req, HttpServletResponse res) throws Exception 
		{
			log.info("process='save' method, {}", silo);	
			Locale locale = req.getLocale();
			String view = "redirect:/silo/list?farmCode="+ silo.getFarmCode();
			if (bindingResult.hasErrors()) {
				addError(req, bindingResult.getAllErrors().toString());
				return view;
			}
			silo.setCreatedBy(UserContext.getUsername());
			SiloDto siloSaved = siloManager.save(silo);
			if(siloSaved != null) {
				addMessage(req, getText("silo.save.updated", locale));
			} else {
				addError(req, getText("silo.save.failed", locale));
			}
			return view;
		}
}
