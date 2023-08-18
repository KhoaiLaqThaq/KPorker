package com.keysoft.pigfarm.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.extern.slf4j.Slf4j;

/**
 * 
 * The Class LoginController.
 * 
 * @author <a href="mailto:ngtrungkien@gmail.com">Kien Nguyen</a>
 */
@Slf4j
@Controller
public class LoginController extends BaseController  {
	
	@GetMapping("/login*")
    public String handleRequest(HttpServletRequest request) {
		log.info("process=login");
        return "login";
    }
}
