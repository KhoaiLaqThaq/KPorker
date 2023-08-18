package com.keysoft.pigfarm.controller;

import com.keysoft.pigfarm.constant.ModelViewEnum;
import com.keysoft.pigfarm.manager.VendorManager;
import com.keysoft.pigfarm.production.dto.VendorDto;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.validation.Valid;

@Slf4j
@Controller
@RequestMapping("/vendor")
public class VendorController extends BaseController {

    @Autowired
    private VendorManager vendorManager;

    @GetMapping("/list")
    public ModelAndView showList() {
        log.info("entering: 'show-list()'...");
        ModelAndView mav = new ModelAndView(ModelViewEnum.VIEW_VENDOR_LIST.mav);
        VendorDto criteria = new VendorDto();
        criteria.setSize(appProperties.getDefaultPageSize());
        criteria.setPage(appProperties.getDefaultPage());

        mav.addObject(ModelViewEnum.MODEL_PAGE.mav, vendorManager.search(criteria))
                .addObject(ModelViewEnum.MODEL_CRITERIA.mav, criteria);
        return mav;
    }

    @PostMapping("/list")
    public ModelAndView search(@Valid VendorDto criteria) {
        log.info("entering: 'search' method()..., criteria={}", criteria);
        ModelAndView mav = new ModelAndView(ModelViewEnum.VIEW_VENDOR_LIST.mav);
        mav.addObject(ModelViewEnum.MODEL_PAGE.mav, vendorManager.search(criteria))
                .addObject(ModelViewEnum.MODEL_CRITERIA.mav, criteria);
        return mav;
    }

    @GetMapping("/preview/{code}")
    public ModelAndView previewDetail(@PathVariable String code) {
        log.info("entering: 'preview-detail' method, code={}", code);
        ModelAndView mav = new ModelAndView(ModelViewEnum.VIEW_VENDOR_PREVIEW_DETAIL.mav);
        VendorDto vendor = new VendorDto();
        if (StringUtils.isNotBlank(code))
            vendor = vendorManager.getByCode(code);

        return mav
                .addObject(ModelViewEnum.MODEL_VENDOR.mav, vendor);
    }

}
