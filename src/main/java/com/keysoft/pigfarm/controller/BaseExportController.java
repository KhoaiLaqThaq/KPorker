package com.keysoft.pigfarm.controller;

import java.io.IOException;

import javax.servlet.http.HttpServletResponse;

import org.docx4j.Docx4J;
import org.docx4j.openpackaging.exceptions.Docx4JException;
import org.docx4j.openpackaging.packages.WordprocessingMLPackage;

import lombok.extern.slf4j.Slf4j;
@Slf4j
public class BaseExportController extends BaseController{
	protected final String TEMPLATE_PATH 	= "templates/";
	protected final String DOCX_EXT			= ".docx";
	protected final String UNDERSCORE			= "_";
	
	protected String getTemplatePath(String nameTemplate) {
		log.info("Entering getTemplatePath("+ nameTemplate +")...");
		
		StringBuilder builder = new StringBuilder();
		builder.append(TEMPLATE_PATH).append(nameTemplate).append(DOCX_EXT);
		return builder.toString();
	}
	
	protected String getExportName(String nameTemplate, String transCode) {
		log.info("Entering getExportName("+ transCode +")...");
		
		StringBuilder builder = new StringBuilder();
		builder.append(nameTemplate).append(UNDERSCORE).append(transCode).append(DOCX_EXT);
		return builder.toString();
	}
	
	protected void save(HttpServletResponse response, WordprocessingMLPackage wmlPackage, String fileName) throws Docx4JException, IOException {
		log.info("Entering save()...");
		
		response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
		response.setContentType("application/vnd.openxmlformats-officedocument.wordprocessingml.document");
		
		Docx4J.save(wmlPackage, response.getOutputStream(), Docx4J.FLAG_NONE);
		
	}
}
