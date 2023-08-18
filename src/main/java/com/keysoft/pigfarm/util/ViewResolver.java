package com.keysoft.pigfarm.util;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.keysoft.pigfarm.helper.FreeMarkerHelper;

import freemarker.template.TemplateException;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class ViewResolver {
	
	@Autowired
	private JsonHelper jsonHelper;
	
	@Autowired
	private FreeMarkerHelper freeMarkerHelper;
	
	@SuppressWarnings("unchecked")
	public String resolveContent(String viewName, String templateFolder, String templateName, Map<String, Object> variables) {
		log.info("entering resolveContent()...");
		
		String content = "";
		
		try {
			String json = jsonHelper.readFromJsonFile(templateFolder + "/" + viewName + ".json");
			
			ObjectMapper mapper = new ObjectMapper();
			Map<String, Object> viewSetting = mapper.readValue(json, Map.class);
			System.out.println("viewSetting: " + viewSetting);
			
			Map<String, Object> variable = new HashMap<>();
			variable.put("viewSetting", viewSetting);
			variables.entrySet().stream().forEach(v -> variable.put(v.getKey(), v.getValue()));
			
			content = freeMarkerHelper.renderToString(templateFolder + "/" + templateName + ".ftl", variable);
			
		} catch (IOException | TemplateException e) {
			e.printStackTrace();
		}
		
		return content;
		
	}
}
