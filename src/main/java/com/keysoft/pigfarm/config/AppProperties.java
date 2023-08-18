package com.keysoft.pigfarm.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import lombok.Data;

@Data
@Component
@ConfigurationProperties("app")
public class AppProperties {
	private String systemName;
	private int defaultPage;
	private int defaultPageSize;
	private String attachmentPath;
	private String attachmentContextPath;
	private boolean sendEmailEnabled;
}
