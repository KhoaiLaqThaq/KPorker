package com.keysoft.pigfarm;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.util.Collections;

import org.apache.commons.lang3.StringUtils;
import org.junit.jupiter.api.Test;
import org.keycloak.representations.AccessTokenResponse;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.BadCredentialsException;

import com.keysoft.pigfarm.util.RestHelper;
import com.speedfrwk.security.jwt.model.AuthenticationRequest;

@SpringBootTest
class AuthenticationTest {
	
	@Test
	void test_login() {
		String url 		= "http://localhost:8081/auth/login";
        String name 	= "admin@mavin.com";
        String password = "admin";
        
        AuthenticationRequest authenticationRequest = new AuthenticationRequest();
        authenticationRequest.setUsername(name);
        authenticationRequest.setPassword(password);
        
        RestHelper restHelper = new RestHelper();
        ResponseEntity<?> res = restHelper.send(url, HttpMethod.POST, authenticationRequest, AccessTokenResponse.class);
        
        AccessTokenResponse accessResponse = (AccessTokenResponse)res.getBody();
        if (StringUtils.isNotBlank(accessResponse.getError())) {
        	throw new BadCredentialsException("Username or Password not correct.");
        }
		
        System.out.println("TOKEN: " + accessResponse.getToken());
        
        assertTrue(StringUtils.isNotBlank(accessResponse.getToken()));
	}
	
	@Test
	void test_authentication_success() {
		
		System.out.println("----- Begin Login -----");
		String url 		= "http://localhost:8081/auth/login";
        
		String name 	= "kiennt@keysoft.vn";
        String password = "admin";

        //String name 	= "longnd@mavin.com";
        //String password = "12345678a@";

        AuthenticationRequest authenticationRequest = new AuthenticationRequest();
        authenticationRequest.setUsername(name);
        authenticationRequest.setPassword(password);
        
        RestHelper restHelper = new RestHelper();
        ResponseEntity<?> res = restHelper.send(url, HttpMethod.POST, authenticationRequest, AccessTokenResponse.class);
        
        AccessTokenResponse accessResponse = (AccessTokenResponse)res.getBody();
        if (StringUtils.isNotBlank(accessResponse.getError())) {
        	throw new BadCredentialsException("Username or Password not correct.");
        }
		
        System.out.println("REALM: " + accessResponse.getOtherClaims().get("realm"));
        System.out.println("TOKEN: " + accessResponse.getToken());
        assertTrue(StringUtils.isNotBlank(accessResponse.getToken()));
		
        System.out.println("----- END Login -----");
        
        
        System.out.println("----- Begin Access Resource -----");
        
        //String urlTest	= "http://localhost:8081/api/farms";        
        //ResponseEntity<?> response = restTemplate.exchange(urlTest, HttpMethod.GET, TestUtil.buildHttpEntity((String)accessResponse.getOtherClaims().get("realm"), accessResponse.getToken(), null), Map.class);

        String urlTest	= "http://localhost:8081/api/tenants";        
        ResponseEntity<?> response = restHelper.send(urlTest, HttpMethod.GET, buildHttpEntity((String)accessResponse.getOtherClaims().get("realm"), accessResponse.getToken(), null), String.class);

        
        System.out.println("RESULT: " + response.getBody());
        assertEquals(res.getStatusCodeValue(), 200);
        
        System.out.println("----- END Access Resource -----");
	}
	
	
	private HttpEntity<?> buildHttpEntity(String realm, String token, Object body) {
		HttpHeaders headers = initHeaders();
		//headers.forEach((key, value) -> {
		//	System.out.println("key: " + key);
		//	System.out.println("value: " + value);
		//});

		if (StringUtils.isNotBlank(token)) {
			headers.add("Authorization", "Bearer " + token);
		}
		
		if (StringUtils.isNotBlank(realm)) {
			headers.add("realm", realm);
		}
		
		if (body != null) {
			return new HttpEntity<>(body, headers);	
		} else {
			return new HttpEntity<>(headers);
		}
	}
	
	private HttpHeaders initHeaders() {
		HttpHeaders initHeaders = new HttpHeaders();
	    initHeaders.setContentType(new MediaType(MediaType.APPLICATION_JSON, StandardCharsets.UTF_8));
	    initHeaders.setAccept(Collections.singletonList(new MediaType(MediaType.APPLICATION_JSON, StandardCharsets.UTF_8)));

	    return initHeaders;
	}

	
}
