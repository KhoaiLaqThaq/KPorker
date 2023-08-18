package com.keysoft.pigfarm.manager;

import com.keysoft.pigfarm.common.PageDto;
import com.keysoft.pigfarm.config.ServiceProperties;
import com.keysoft.pigfarm.constant.ApiEnum;
import com.keysoft.pigfarm.production.dto.VendorDto;
import com.keysoft.pigfarm.util.RestHelper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.List;

@Slf4j
@Service
public class VendorManager {

    @Autowired
    private RestHelper restHelper;
    @Autowired
    private ServiceProperties serviceProperties;

    public PageDto search(VendorDto criteria) {
        log.info("process: 'search()'...");
        ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_VENDOR_SEARCH.val), HttpMethod.POST, criteria, PageDto.class);
        return (PageDto) response.getBody();
    }

    @SuppressWarnings("unchecked")
    public List<VendorDto> gets() {
        log.info("process: 'gets()'...");
        ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_VENDOR_GETS.val), HttpMethod.GET, new ParameterizedTypeReference<>() {});

        return (List<VendorDto>) response.getBody();
    }

    public VendorDto getByCode(String vendorCode) {
        log.info("process: getByCode()");
        ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_VENDOR_GET_BY_CODE.val), HttpMethod.GET, VendorDto.class, vendorCode);
        return (VendorDto) response.getBody();
    }

    public String syncFromSAP() {
        log.info("process: 'syncFromSAP()'");
        ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_VENDOR_SYNC_FROM_SAP.val), HttpMethod.GET, String.class);
        return (String) response.getBody();
    }
}
