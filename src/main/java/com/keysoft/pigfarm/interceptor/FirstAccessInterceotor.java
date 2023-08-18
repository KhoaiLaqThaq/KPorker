package com.keysoft.pigfarm.interceptor;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.keysoft.pigfarm.manager.UserManager;
import com.keysoft.pigfarm.master.dto.UserDto;
import com.keysoft.pigfarm.util.UserContext;

import lombok.extern.slf4j.Slf4j;

@SuppressWarnings("deprecation")
@Slf4j
@Component
public class FirstAccessInterceotor extends HandlerInterceptorAdapter {
	
	private UserManager appUserManager;
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		log.info("Request URL:" + request.getRequestURI().toString());
		String username = UserContext.getUserDetails().getUsername();
		UserDto appUser = appUserManager.getByUsername(username);
		if ( appUser != null ) {
			if (appUser.getPasswordChangedDate() == null) {
				if (!request.getPathInfo().equals("/user/resetpw")) {
					redirect(request, response, "/user/resetpw");
					return false;
				}
			}


		}
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
