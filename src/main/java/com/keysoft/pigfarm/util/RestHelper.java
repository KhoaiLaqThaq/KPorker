package com.keysoft.pigfarm.util;

import java.nio.charset.StandardCharsets;
import java.util.Collections;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import com.keysoft.pigfarm.config.ServiceProperties;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class RestHelper {
	@Autowired
	private ServiceProperties serviceProperties;
	@Autowired
	private RestTemplate restTemplate;

	public ResponseEntity<?> send(String token, String path, HttpMethod method, Class<?> responseType, Object... uriVariables) {
		String url = serviceProperties.getApiUrl() + path;
		if (uriVariables != null && uriVariables.length > 0) {
			return restTemplate.exchange(url, method, buildHttpEntityWithToken(token), responseType, uriVariables);
		} else {
			return restTemplate.exchange(url, method, buildHttpEntityWithToken(token), responseType);
		}
	}
	
	public ResponseEntity<?> send(String path, HttpMethod method, Class<?> responseType, Object... uriVariables) {
		String url = serviceProperties.getApiUrl() + path;
		if (uriVariables != null && uriVariables.length > 0) {
			return restTemplate.exchange(url, method, buildHttpEntity(), responseType, uriVariables);
		} else {
			return restTemplate.exchange(url, method, buildHttpEntity(), responseType);
		}
	}

	public ResponseEntity<?> send(String path, HttpMethod method, Class<?> responseType, Map<String, ?> uriVariables) {
		String url = serviceProperties.getApiUrl() + path;
		if (uriVariables != null) {
			return restTemplate.exchange(url, method, buildHttpEntity(), responseType, uriVariables);
		} else {
			return restTemplate.exchange(url, method, buildHttpEntity(), responseType);
		}
	}

	public ResponseEntity<?> send(String path, HttpMethod method, Object body, Class<?> responseType, Object... uriVariables) {
		String url = serviceProperties.getApiUrl() + path;
		if (uriVariables != null && uriVariables.length > 0) {
			return restTemplate.exchange(url, method, buildHttpEntity(body), responseType, uriVariables);
		} else {
			return restTemplate.exchange(url, method, buildHttpEntity(body), responseType);
		}
	}
	
	public ResponseEntity<?> send(String path, HttpMethod method, ParameterizedTypeReference<?> responseType, Object... uriVariables) {
		String url = serviceProperties.getApiUrl() + path;
		if (uriVariables != null && uriVariables.length > 0) {
			return restTemplate.exchange(url, method, buildHttpEntity(), responseType, uriVariables);
		} else {
			return restTemplate.exchange(url, method, buildHttpEntity(), responseType);
		}
	}

	public ResponseEntity<?> send(String path, HttpMethod method, Object body, ParameterizedTypeReference<?> responseType, Object... uriVariables) {
		String url = serviceProperties.getApiUrl() + path;
		if (uriVariables != null && uriVariables.length > 0) {
			return restTemplate.exchange(url, method, buildHttpEntity(body), responseType, uriVariables);
		} else {
			return restTemplate.exchange(url, method, buildHttpEntity(body), responseType);
		}
	}

	
	private HttpEntity<?> buildHttpEntityWithToken(String token) {
		HttpHeaders headers = initHeaders();
		//System.out.println("TOKEN: " + token);
		if (StringUtils.isNotBlank(token)) {
			headers.add("Authorization", "Bearer " + token);
		}
		return new HttpEntity<>(headers);
	}
	
	
	private HttpEntity<?> buildHttpEntity() {
		return buildHttpEntity(null);
	}
	
	private HttpEntity<?> buildHttpEntity(Object body) {
		HttpHeaders headers = initHeaders();

		String token = UserContext.getAccessToken();
		log.debug("TOKEN: {}", token);
		if (StringUtils.isNotBlank(token)) {
			headers.add("Authorization", "Bearer " + token);
		}
		
		String realm = UserContext.getRealm();
		log.debug("REALM: {}", realm);
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
