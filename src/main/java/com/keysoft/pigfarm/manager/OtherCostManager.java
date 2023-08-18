package com.keysoft.pigfarm.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.keysoft.pigfarm.common.PageDto;
import com.keysoft.pigfarm.config.ServiceProperties;
import com.keysoft.pigfarm.constant.ApiEnum;
import com.keysoft.pigfarm.production.dto.OtherCostDto;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class OtherCostManager {
	@Autowired
	private RestHelper restHelp;
	@Autowired
	private ServiceProperties serviceProperties;
	
	public PageDto search(OtherCostDto criteria) {
		log.info("process=search-other-cost, criteria={}", criteria);
		ResponseEntity<?> response = restHelp.send(serviceProperties.getPaths().get(ApiEnum.PATH_OTHER_COST_SEARCH.val), HttpMethod.POST, criteria, PageDto.class);
		PageDto page = (PageDto) response.getBody();
		log.info("page, {}", page.getContent());
		return page;
	}
	
	public OtherCostDto get(Long id) {
		log.info("process=get-other-cost");
		ResponseEntity<?> response = restHelp.send(serviceProperties.getPaths().get(ApiEnum.PATH_OTHER_COST_GET.val), HttpMethod.GET, OtherCostDto.class, id);
		return (OtherCostDto) response.getBody();
	}
	
	public OtherCostDto save(OtherCostDto criteria) {
		log.info("process=save-other-cost, OtherCost={}", criteria);
		ResponseEntity<?> response = null;
		if (criteria.getId() != null) {
			response = restHelp.send(serviceProperties.getPaths().get(ApiEnum.PATH_OTHER_COST_UPDATE.val), HttpMethod.PUT, criteria, OtherCostDto.class, criteria.getId());
		} else {
			response = restHelp.send(serviceProperties.getPaths().get(ApiEnum.PATH_OTHER_COST_CREATE.val), HttpMethod.POST, criteria, OtherCostDto.class);
		}
		return (OtherCostDto) response.getBody();
	}
}
