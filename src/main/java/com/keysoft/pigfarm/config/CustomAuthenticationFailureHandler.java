package com.keysoft.pigfarm.config;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.DefaultRedirectStrategy;
import org.springframework.security.web.RedirectStrategy;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class CustomAuthenticationFailureHandler implements AuthenticationFailureHandler {
    @Override
    public void onAuthenticationFailure(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, AuthenticationException e) throws IOException, ServletException {
    	log.info("Entering onAuthenticationFailure() ....");
	
    	log.error("ERROR: " + e.getMessage());
    	
        RedirectStrategy redirectStrategy = new DefaultRedirectStrategy();
        if(e instanceof DisabledException){
            redirectStrategy.sendRedirect(httpServletRequest, httpServletResponse, "/login?error=disabled");
        } else if(e instanceof BadCredentialsException){
            redirectStrategy.sendRedirect(httpServletRequest, httpServletResponse, "/login?error=true");
        } else {
        	redirectStrategy.sendRedirect(httpServletRequest, httpServletResponse, "/login?error=true");
        }
    }
}
