package com.keysoft.pigfarm.config;

import java.util.Map;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import lombok.Data;

@Data
@Component
@ConfigurationProperties("service")
public class ServiceProperties {
	private String apiUrl;
	private int apiTimeout;
	private Map<String, String> paths;
}
