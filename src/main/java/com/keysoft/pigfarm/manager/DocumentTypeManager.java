package com.keysoft.pigfarm.manager;



import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.keysoft.pigfarm.common.PageDto;
import com.keysoft.pigfarm.config.ServiceProperties;
import com.keysoft.pigfarm.constant.ApiEnum;
import com.keysoft.pigfarm.production.dto.DocumentTypeDto;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class DocumentTypeManager {
	@Autowired
	private RestHelper restHelper;
	@Autowired
	private ServiceProperties serviceProperties;
	
	public PageDto gets(DocumentTypeDto criteria) {
		log.info("process=get-document-types, criteria={}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_DOCUMENT_TYPE_SEARCH.val), HttpMethod.POST , criteria, PageDto.class );
		return (PageDto) response.getBody();
	}
	
	public DocumentTypeDto get(Long id) {
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_DOCUMENT_TYPE_GET.val), HttpMethod.GET, DocumentTypeDto.class, id);
		return (DocumentTypeDto) response.getBody();
	}
	
	@SuppressWarnings("unchecked")
	public List<DocumentTypeDto> getActiveTypes(DocumentTypeDto type) {
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_DOCUMENT_TYPE_GET_ACTIVE.val), HttpMethod.POST, type, new ParameterizedTypeReference<List<DocumentTypeDto>>() {});
		return (List<DocumentTypeDto>) response.getBody();
	}
	
	@SuppressWarnings("unchecked")
	public List<DocumentTypeDto> getExistedTypes(DocumentTypeDto type) {
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_DOCUMENT_TYPE_GET_EXISTED.val), HttpMethod.POST, type, new ParameterizedTypeReference<List<DocumentTypeDto>>() {});
		return (List<DocumentTypeDto>) response.getBody();
	}
	
	public DocumentTypeDto save(DocumentTypeDto documentType) {
		log.info("PROCESS: SAVE DOCUMENT_TYPE, DOCUMENT_TYPE: {}", documentType);
		ResponseEntity<?> response = null;
		if (documentType.getId() != null) {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_DOCUMENT_TYPE_UPDATE.val), HttpMethod.PUT, documentType, DocumentTypeDto.class, documentType.getId());
		} else {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_DOCUMENT_TYPE_CREATE.val), HttpMethod.POST, documentType, DocumentTypeDto.class);
		}
		return (DocumentTypeDto) response.getBody();	
	}

}
