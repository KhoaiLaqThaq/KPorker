package com.keysoft.pigfarm.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

import com.keysoft.pigfarm.constant.ModelViewEnum;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class PasswordController extends BaseController  {

	
	@GetMapping("/passwordChange")
	public ModelAndView changePassForm(HttpServletRequest request, HttpServletResponse response) {
		return new ModelAndView(ModelViewEnum.VIEW_CHANGE_PASS.mav);
	}


}
