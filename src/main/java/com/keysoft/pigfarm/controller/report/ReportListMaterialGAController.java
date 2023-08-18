package com.keysoft.pigfarm.controller.report;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.keysoft.pigfarm.common.EntityResponseCodeEnum;
import com.keysoft.pigfarm.common.PurchasingGroupCodeEnum;
import com.keysoft.pigfarm.common.SymbolEnum;
import com.keysoft.pigfarm.controller.BaseController;
import com.keysoft.pigfarm.integration.EntityResponse;
import com.keysoft.pigfarm.manager.FarmManager;
import com.keysoft.pigfarm.manager.ReportManager;
import com.keysoft.pigfarm.production.dto.FarmDto;
import com.keysoft.pigfarm.production.dto.MaterialDetailDto;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/report")
@RequiredArgsConstructor
public class ReportListMaterialGAController extends BaseController {

	@Autowired
	private ReportManager reportManager;
	@Autowired
	private FarmManager farmManager;
	
	private final String PAGE_NAME = "report-list-material-GA";
	
	/*
	 * Báo cáo kê xuất vật tư
	 */
	@GetMapping("/listMaterialGA")
	public ModelAndView getListMaterialGA() {
		log.info("*****************CONTROLLER::process=get-report-list-material-GA");
		ModelAndView modelAndView = new ModelAndView();
		List<FarmDto> farms = farmManager.getAllFarmByUser();
		List<String> purchasingGroupCodes = new ArrayList<>();
		Arrays.asList(PurchasingGroupCodeEnum.values()).forEach(item -> purchasingGroupCodes.add(item.val));
		
		modelAndView.addObject("farms", farms);
		modelAndView.addObject("purchasingGroupCodes", purchasingGroupCodes);
		modelAndView.addObject("criteria", new MaterialDetailDto());
		modelAndView.setViewName(PAGES_REPORT_PATH.concat(PAGE_NAME));
		return modelAndView;
	}
	
	@SuppressWarnings("unchecked")
	@PostMapping("/listMaterialGA")
	public ModelAndView handleListMaterialGA(@Valid MaterialDetailDto criteria, HttpServletRequest request) {
		log.info("************CONTROLLER::process=handle-report-list-material-GA");
		
		ModelAndView modelAndView = new ModelAndView();
		List<FarmDto> farms = farmManager.getAllFarmByUser();
		List<MaterialDetailDto> materialDetails = new ArrayList<>();
		
		EntityResponse response = reportManager.handleReportListMaterialGA(criteria);
		if (response.getCode().equals(EntityResponseCodeEnum.SUCCESS_200.val)) {
			materialDetails = (List<MaterialDetailDto>) response.getData();
		} else {
			addError(request, response.getMessage());
		}
		List<String> purchasingGroupCodes = new ArrayList<>();
		Arrays.asList(PurchasingGroupCodeEnum.values()).forEach(item -> purchasingGroupCodes.add(item.val));
		
		if(!CollectionUtils.isEmpty(criteria.getBarnCodes())) {
			StringBuilder barnCodeStr = new StringBuilder();
			criteria.getBarnCodes().forEach(b -> barnCodeStr.append(b).append(SymbolEnum.COMMA.val));
			criteria.setBarnCodeStr(barnCodeStr.toString());
		}
		
		modelAndView.addObject("farms", farms).addObject("materialDetails", materialDetails).addObject("criteria", criteria).addObject("purchasingGroupCodes", purchasingGroupCodes);
		modelAndView.setViewName(PAGES_REPORT_PATH.concat(PAGE_NAME));
		return modelAndView;
	}
}
