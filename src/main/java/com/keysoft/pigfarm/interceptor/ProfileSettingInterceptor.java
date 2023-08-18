package com.keysoft.pigfarm.interceptor;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.keysoft.pigfarm.config.ServiceProperties;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;

@SuppressWarnings("deprecation")
@Component
@Slf4j
public class ProfileSettingInterceptor extends HandlerInterceptorAdapter{
	@Autowired
	private ServiceProperties serviceProperties;
	
	@Autowired
	private RestHelper restHelper;
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		log.info("process = set user profile");
		return true;
	}
	public void redirect (HttpServletRequest request, HttpServletResponse response, String path) throws ServletException {
		try {
			response.sendRedirect(request.getContextPath() + path);
		} catch (java.io.IOException e) {
			throw new ServletException(e);
		}
	}
	
}	
