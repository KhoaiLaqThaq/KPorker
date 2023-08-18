package com.keysoft.pigfarm.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.keysoft.pigfarm.common.PageDto;
import com.keysoft.pigfarm.config.ServiceProperties;
import com.keysoft.pigfarm.constant.ApiEnum;
import com.keysoft.pigfarm.integration.EntityResponse;
import com.keysoft.pigfarm.production.dto.ProposalDto;
import com.keysoft.pigfarm.production.dto.ProposalEntryDto;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;
@Slf4j
@Service
public class ProposalManager {
	@Autowired
	private RestHelper restHelper;
	@Autowired
	private ServiceProperties serviceProperties;
	
	
	public PageDto search(ProposalDto criteria) {
		log.info("PROCESS: SEARCH PROPOSAL, PROPOSAL: {}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PROPOSAL_SEARCH.val), HttpMethod.POST, criteria, PageDto.class);
		return (PageDto) response.getBody();
	}
	
	public ProposalDto get(Long id) {
		log.info("PROCESS: GET PROPOSAL, PROPOSAL_ID: {}", id);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PROPOSAL_GET.val), HttpMethod.GET, ProposalDto.class,id);
		return (ProposalDto) response.getBody();
	}
	
	public EntityResponse save(ProposalDto proposal) {
		log.info("PROCESS: SAVE PROPOSAL, PROPOSAL: {}", proposal);
		ResponseEntity<?> response = null;
		if (proposal.getId() != null) {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PROPOSAL_UPDATE.val), HttpMethod.PUT, proposal, EntityResponse.class, proposal.getId());
		} else {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PROPOSAL_CREATE.val), HttpMethod.POST, proposal, EntityResponse.class);
		}
		return (EntityResponse)response.getBody();	
	}
	
	public ProposalEntryDto calculateEntryProposal(String processOrderCoce) {
		log.info("PROCESS: calculateEntryProposal, poCode={}", processOrderCoce);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_CALCULATE_PROPOSAL_ENTRY.val), HttpMethod.POST, ProposalEntryDto.class, processOrderCoce);
		return (ProposalEntryDto) response.getBody();
	}
	
}
