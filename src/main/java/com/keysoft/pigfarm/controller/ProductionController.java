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

import com.keysoft.pigfarm.helper.TransCodeHelper;
import com.keysoft.pigfarm.manager.EventManager;
import com.keysoft.pigfarm.manager.ProcessOrderManager;
import com.keysoft.pigfarm.manager.ProductionManager;
import com.keysoft.pigfarm.production.dto.ProductionDto;

import lombok.extern.slf4j.Slf4j;

/**
 * Generated by Speed Generator
 * 
 * @author <a href="mailto:ngtrungkien@gmail.com">Kien Nguyen</a>
 */
 @Slf4j
@Controller
public class ProductionController extends BaseController {

    @Autowired
	private EventManager eventManager;
	@Autowired
	private TransCodeHelper transCodeHelper;
	@Autowired
	private ProductionManager productionManager;
	@Autowired
	private ProcessOrderManager processOrderManager ;
	
    @GetMapping("/production/list")
    public ModelAndView list(HttpServletRequest request) throws Exception {
    	log.debug("entering 'list' method...");

        //modelAndView.addObject("productions", productionManager.gets());

        return new ModelAndView("production-list");
    }
    
    @PostMapping("/production/list")
    public ModelAndView search(@Valid ProductionDto criteria, BindingResult bindingResult){
    	log.debug("entering 'search' method...");
		ModelAndView modelAndView = new ModelAndView("production-list");
		//modelAndView.addObject("page", productionManager.gets(criteria));
		modelAndView.addObject("criteria", criteria);
        return modelAndView;
    }
    
    @ModelAttribute
    @GetMapping("/production/form")
    public ModelAndView show(@RequestParam (value="id", required=false) Long id) throws Exception {
    	log.debug("entering 'show' method...");
    
    	ModelAndView modelAndView = new ModelAndView("production-form");
        //modelAndView.addObject(productionManager.get(id));

		modelAndView.addObject("production", new ProductionDto());

        return modelAndView;
    }

    @PostMapping("/production/save")
    public String save(ProductionDto productionDto, BindingResult bindingResult, HttpServletRequest request, HttpServletResponse response) throws Exception {
        log.debug("entering 'save' method...");

        Locale locale = request.getLocale();
        String view = "production-form";
        
        if (bindingResult.hasErrors()) {
        	addError(request, bindingResult.getAllErrors().toString());
            return view;
        }

        //productionManager.save(productionDto);
        addMessage(request, getText("production.updated", locale));
        view = "redirect:/production/list";

        return view;
    }
    
}