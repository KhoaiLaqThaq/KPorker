package com.keysoft.pigfarm.manager;

import com.keysoft.pigfarm.config.ServiceProperties;
import com.keysoft.pigfarm.constant.ApiEnum;
import com.keysoft.pigfarm.integration.EntityResponse;
import com.keysoft.pigfarm.production.template.TemplateDto;
import com.keysoft.pigfarm.util.RestHelper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class TemplateManager {

    @Autowired
    private RestHelper restHelper;
    @Autowired
    private ServiceProperties serviceProperties;

//    public EntityResponse importTemplate(TemplateDto template) {
//        log.info("process: importTemplate()...");
//        ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_TEMPLATE_IMPORT_FILE.val), HttpMethod.POST, template, EntityResponse.class);
//        return (EntityResponse) response.getBody();
//    }

}
