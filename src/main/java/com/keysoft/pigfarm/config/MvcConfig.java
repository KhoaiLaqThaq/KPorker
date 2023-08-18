package com.keysoft.pigfarm.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.keysoft.pigfarm.interceptor.ProfileSettingInterceptor;
import com.keysoft.pigfarm.interceptor.TokenSettingInterceptor;

@Configuration
public class MvcConfig implements WebMvcConfigurer {
    @Autowired
    Environment env;
    @Autowired
    protected AppProperties appProperties;
    
    @Autowired
    TokenSettingInterceptor tokenSettingInterceptor;
    @Autowired
    ProfileSettingInterceptor profileSettingInterceptor;
    public MvcConfig() {
        super();
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler(appProperties.getAttachmentContextPath() + "**").addResourceLocations("file:" + appProperties.getAttachmentPath());
    }
    
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
    	registry.addInterceptor(profileSettingInterceptor).addPathPatterns("/user/*");
    	
    }
}