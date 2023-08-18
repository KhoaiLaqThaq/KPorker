package com.keysoft.pigfarm.manager;

import com.keysoft.pigfarm.common.PageDto;
import com.keysoft.pigfarm.config.ServiceProperties;
import com.keysoft.pigfarm.constant.ApiEnum;
import com.keysoft.pigfarm.integration.EntityResponse;
import com.keysoft.pigfarm.production.dto.GeneralLedgerDto;
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
public class GeneralLedgerManager {
    @Autowired
    private RestHelper restHelper;
    @Autowired
    private ServiceProperties serviceProperties;

    public PageDto search(GeneralLedgerDto criteria) {
        log.info("process=search(), {}", criteria);
        ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GENERAL_LEDGER_SEARCH.val), HttpMethod.POST, criteria, PageDto.class);
        return (PageDto) response.getBody();
    }

    public GeneralLedgerDto get(Long id) {
        log.info("process=get-by-id(), id={}", id);
        ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GENERAL_LEDGER_GET.val), HttpMethod.GET, GeneralLedgerDto.class, id);
        return  (GeneralLedgerDto) response.getBody();
    }

    public EntityResponse saveOrUpdate(GeneralLedgerDto generalLedger) {
        log.info("process: saveOrUpdate()");
        ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GENERAL_LEDGER_SAVE_OR_UPDATE.val), HttpMethod.POST, generalLedger, EntityResponse.class);
        return (EntityResponse) response.getBody();
    }

    public EntityResponse saveAndSync(GeneralLedgerDto generalLedger) {
        log.info("process: saveAndSync()...");
        ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GENERAL_LEDGER_SAVE_AND_SYNC.val), HttpMethod.POST, generalLedger, EntityResponse.class);
        return (EntityResponse) response.getBody();
    }

    @SuppressWarnings("unchecked")
    public List<GeneralLedgerDto> searchAll(GeneralLedgerDto criteria) {
        log.info("process: searchAll()");
        ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GENERAL_LEDGER_EXPORT.val), HttpMethod.POST, criteria, new ParameterizedTypeReference<List<GeneralLedgerDto>>() {});
        return (List<GeneralLedgerDto>) response.getBody();
    }

    public EntityResponse cancel(Long id) {
        log.info("process: cancel(), id={}", id);
        ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_GENERAL_LEDGER_CANCEL.val), HttpMethod.POST, EntityResponse.class, id);
        return (EntityResponse) response.getBody();
    }
}
