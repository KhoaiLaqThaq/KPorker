package com.keysoft.pigfarm.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class HomeController extends BaseController  {
	
	@GetMapping(value = {"", "/"})
	public ModelAndView home(Model model ,HttpServletRequest request ) throws Exception {
		log.info("Entering home()...");

		return new ModelAndView("home/index");
	}
}
