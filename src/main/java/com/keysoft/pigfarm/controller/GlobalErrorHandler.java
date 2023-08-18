package com.keysoft.pigfarm.controller;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.method.annotation.ExceptionHandlerExceptionResolver;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@ControllerAdvice
public class GlobalErrorHandler extends ExceptionHandlerExceptionResolver {
	 
	/**
	 * Method called when IOException is thrown from the application
	 * 
	 * @param e
	 * @return
    */
	@ExceptionHandler(IOException.class)
	public ModelAndView inputOutputError(IOException e) {
		ModelAndView error = new ModelAndView("error");
		error.addObject("errorStatus", e.getMessage());
		error.addObject("errorMsg", e);
		return error;
	}

	/**
	  * Method called when RuntimeException is thrown from the application
	  * 
	  * @param e
	  * @return
	  */
	@ExceptionHandler(RuntimeException.class)
	public ModelAndView applicationError(RuntimeException e) {
		ModelAndView error = new ModelAndView("error");
		error.addObject("errorStatus", e.getMessage());
		error.addObject("errorMsg", e);
		return error;
	}

	/**
	  * Method called when RuntimeException is thrown from the application
	  * 
	  * @param e
	  * @return
	  */
	@ExceptionHandler(HttpClientErrorException.class)
	public ModelAndView applicationError(HttpServletRequest request, HttpServletResponse response, HttpClientErrorException e) {
		log.info("Catch HttpClientErrorException");
		
		ModelAndView error = new ModelAndView("error");		
		int status = response.getStatus();
		if (HttpStatus.UNAUTHORIZED.value() == status) {
			error.setViewName("redirect:/login");
		} else {
			error.addObject("errorStatus", e.getMessage());
			error.addObject("errorMsg", e);
		}
		
		return error;
	}
	
	/**
	  * Method called when RuntimeException is thrown from the application
	  * 
	  * @param e
	  * @return
	  */
	@ExceptionHandler(Exception.class)
	public ModelAndView globalError(Exception e) {
		ModelAndView error = new ModelAndView("error");
		error.addObject("errorStatus", e.getMessage());
		error.addObject("errorMsg", e);
		return error;
	}
	
}
