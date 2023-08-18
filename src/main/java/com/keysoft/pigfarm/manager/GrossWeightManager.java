package com.keysoft.pigfarm.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.keysoft.pigfarm.common.PageDto;
import com.keysoft.pigfarm.config.ServiceProperties;
import com.keysoft.pigfarm.constant.ApiEnum;
import com.keysoft.pigfarm.production.dto.BarnDto;
import com.keysoft.pigfarm.util.RestHelper;
import com.keysoft.pigfarm.weighing.dto.PhieuCanChiTietDto;
import com.keysoft.pigfarm.weighing.dto.PhieuCanDto;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class GrossWeightManager {
	@Autowired
	private RestHelper restHelper;
	@Autowired
	private ServiceProperties serviceProperties;
	@Autowired
	private BarnManager barnManager;
	
	public PageDto search(PhieuCanDto criteria) {
		log.info("************MANAGER::search-phieucan, criteria={}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PHIEUCAN_SEARCH.val), HttpMethod.POST, criteria, PageDto.class);
		return (PageDto) response.getBody();
	}
	
	public PhieuCanDto get(Long id) {
		log.info("************MANAGER::get-phieucan, id={}", id);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PHIEUCAN_GET.val), HttpMethod.GET, PhieuCanDto.class, id);
		PhieuCanDto phieuCan = (PhieuCanDto) response.getBody();
		phieuCan.getPhieuCanChiTiets().stream().forEach(item -> {
			BarnDto barn = barnManager.get(item.getChuong());
			item.setTenChuong(barn.getName());
		});
		
		return phieuCan;
	}
	
	public PhieuCanDto save(PhieuCanDto phieuCanDto) {
		log.info("***************MANAGER:save-phieuCan=phieucan: {}************************", phieuCanDto);
		ResponseEntity<?> response = null;
		if (phieuCanDto.getId() != null) {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PHIEUCAN_UPDATE.val), HttpMethod.PUT, phieuCanDto, PhieuCanDto.class, phieuCanDto.getId());
		} else {
			response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PHIEUCAN_CREATE.val), HttpMethod.POST, phieuCanDto, PhieuCanDto.class);
		}
			
		return (PhieuCanDto) response.getBody();
	}
	
	public PhieuCanChiTietDto getPhieuCanChiTietByID(Long id) {
		log.info("******************MANAGER::get-phieuCanChiTiet**********");
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PHIEUCANCHITIET_GET.val), HttpMethod.GET, PhieuCanChiTietDto.class, id);
		return (PhieuCanChiTietDto) response.getBody();
	}
	
	public Boolean deletePhieuCanChiTiet(Long id) {
		log.info("***********MANAGER::delete-PhieuCanChiTiet");
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_PHIEUCANCHITIET_DELETE.val), HttpMethod.DELETE, Boolean.class, id);
		return (Boolean) response.getBody();
	}
}
