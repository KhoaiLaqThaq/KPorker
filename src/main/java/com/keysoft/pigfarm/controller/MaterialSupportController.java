package com.keysoft.pigfarm.controller;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.ModelAndView;

import com.keysoft.pigfarm.manager.MaterialSupportManager;
import com.keysoft.pigfarm.production.dto.MaterialSupportDto;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class MaterialSupportController extends BaseController{
	
	@Autowired
	private MaterialSupportManager materialSupportManager;

	@GetMapping("/materialSupport/form")
	public ModelAndView show() throws Exception {
		log.debug("entering 'show' method...");
		ModelAndView modelAndView = new ModelAndView("material-support-form");
		MaterialSupportDto materialSupportDto = new MaterialSupportDto();
		
		modelAndView.addObject("materialSupport", materialSupportDto);
		modelAndView.addObject("materials", materialSupportManager.gets());
		return modelAndView;
	}
	
	@PostMapping("/materialSupport/form")
	public ModelAndView searchMaterialSupport(@Valid MaterialSupportDto criteria) {
		log.info("************CONTROLLER::searchMaterialSupport, materialSupport={}", criteria);
		ModelAndView modelAndView = new ModelAndView("material-support-form");
		
		modelAndView.addObject("materialSupport", criteria);
		modelAndView.addObject("materials", materialSupportManager.searchMaterialsForTool(criteria));
		return modelAndView;
	}
	
	@PostMapping("/materialSupport/save")
    public String save(MaterialSupportDto materialSupportDto, BindingResult bindingResult, HttpServletRequest request, HttpServletResponse response) throws Exception {
        log.debug("entering 'save' method...");

        Locale locale = request.getLocale();
        String view = "material-support-form";
        if (bindingResult.hasErrors()) {
        	addError(request, bindingResult.getAllErrors().toString());
            return view;
        }
        view = "redirect:/materialSupport/form";	
            
        materialSupportManager.save(materialSupportDto);
        addMessage(request, getText("material.support.success", locale));

       return view;
    }
}
