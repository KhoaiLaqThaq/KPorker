package com.keysoft.pigfarm.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpMethod;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.keysoft.pigfarm.config.ServiceProperties;
import com.keysoft.pigfarm.constant.ApiEnum;
import com.keysoft.pigfarm.util.RestHelper;
import com.keysoft.pigfarm.util.UserContext;

import lombok.extern.slf4j.Slf4j;

@SuppressWarnings("deprecation")
@Slf4j
@Component
public class TokenSettingInterceptor extends HandlerInterceptorAdapter{
	@Autowired
	private ServiceProperties serviceProperties;
	
	@Autowired
	private RestHelper restHelper;
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		log.info("URL: {}", request.getRequestURL());
		
    	String accessToken = (String)request.getSession().getAttribute("ACCESS_TOKEN");
    	UserContext.setToken(accessToken);
    	   // set profile in session
		return true;
	}
	
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
		super.postHandle(request, response, handler, modelAndView);
	}
	
	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)	throws Exception {
		super.afterCompletion(request, response, handler, ex);
	}
}
