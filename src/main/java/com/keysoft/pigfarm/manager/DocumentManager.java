package com.keysoft.pigfarm.manager;



import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.keysoft.pigfarm.common.PageDto;
import com.keysoft.pigfarm.config.ServiceProperties;
import com.keysoft.pigfarm.constant.ApiEnum;
import com.keysoft.pigfarm.integration.EntityResponse;
import com.keysoft.pigfarm.production.dto.AttachmentDto;
import com.keysoft.pigfarm.production.dto.DocumentDto;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class DocumentManager {
	@Autowired
	private RestHelper restHelper;
	@Autowired
	private ServiceProperties serviceProperties;
	
	public PageDto gets(DocumentDto criteria) {
		log.info("process=get-documents, criteria={}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_DOCUMENT_SEARCH.val), HttpMethod.POST , criteria, PageDto.class );
		return (PageDto) response.getBody();
	}
	
	public DocumentDto get(Long id) {
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_DOCUMENT_GET.val), HttpMethod.GET, DocumentDto.class, id);
		return (DocumentDto) response.getBody();
	}
	
	public EntityResponse save(DocumentDto document) {
		log.info("PROCESS: SAVE DOCUMENT");
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_DOCUMENT_UPDATE.val), HttpMethod.POST, document, EntityResponse.class);
		return (EntityResponse) response.getBody();	
	}
	
	public Map<String, List<AttachmentDto>> mapFilesByTypes(List<AttachmentDto> files) {
		Map<String, List<AttachmentDto>> fileMap = new HashMap<>();
		Set<String> typeSet = new HashSet<>();
		
		for(AttachmentDto file : files) {
			typeSet.add(file.getFunctionType());
		}
		
		for(String type : typeSet) {
			fileMap.put(type, new ArrayList<>());
		}
		
		for(AttachmentDto file : files) {
			fileMap.get(file.getFunctionType()).add(file);
		}
				
		return fileMap;
	}

}
