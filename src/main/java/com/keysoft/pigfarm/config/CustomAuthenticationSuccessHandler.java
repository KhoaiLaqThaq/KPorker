package com.keysoft.pigfarm.config;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.DefaultRedirectStrategy;
import org.springframework.security.web.RedirectStrategy;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;
import org.springframework.stereotype.Component;

import com.keysoft.pigfarm.constant.ApiEnum;
import com.keysoft.pigfarm.util.RestHelper;
import com.keysoft.pigfarm.util.UserContext;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class CustomAuthenticationSuccessHandler implements AuthenticationSuccessHandler {
	@Autowired
	private ServiceProperties serviceProperties;
	
	@Autowired
	private RestHelper restHelper;
	
    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
    	log.info("process=on-authentication-success");
    	
        response.setStatus(HttpServletResponse.SC_OK);
        
        // get jwt token for using after
        ResponseEntity<?> res = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GET_TOKEN.val), HttpMethod.GET, String.class, UserContext.getUsername());
     
        
        String token = (String)res.getBody();
        log.debug("Token: {}", token);
        request.getSession().setAttribute("ACCESS_TOKEN", token);
     
        RedirectStrategy redirectStrategy = new DefaultRedirectStrategy();
        
        //since we have created our custom success handler, its up to us, to where
        //we will redirect the user after successfully login
        String savedRequestUrl = "/";
        SavedRequest savedRequest = new HttpSessionRequestCache().getRequest(request, response);
        if (savedRequest != null) {
    		savedRequestUrl = savedRequest.getRedirectUrl();
        }
        redirectStrategy.sendRedirect(request, response, savedRequestUrl);
   
    }

}
