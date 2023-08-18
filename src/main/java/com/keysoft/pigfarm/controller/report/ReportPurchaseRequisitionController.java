package com.keysoft.pigfarm.controller.report;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.keysoft.pigfarm.common.MonthEnum;
import com.keysoft.pigfarm.common.PrTypeEnum;
import com.keysoft.pigfarm.common.ReportPrTypeEnum;
import com.keysoft.pigfarm.controller.BaseController;
import com.keysoft.pigfarm.manager.FarmManager;
import com.keysoft.pigfarm.manager.ReportManager;
import com.keysoft.pigfarm.production.dto.FarmDto;
import com.keysoft.pigfarm.report.dto.ReportPurchaseRequisitionDto;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/report")
@RequiredArgsConstructor
public class ReportPurchaseRequisitionController extends BaseController {
	
	@Autowired
	private ReportManager reportManager;
	@Autowired
	private FarmManager farmManager;

	private final String PAGE_NAME = "report-purchase-requisition";
	private final String PAGE_NAME_OTHER = "report-purchase-requisition-other";

	/*
	 * Báo cáo dự trù
	 */
	@GetMapping("/purchase-requisition")
	public ModelAndView handleReportPR() {
		log.info("process='handle-report-purchase-requisition'");
		ModelAndView modelAndView = new ModelAndView();
		
		// get list farm
		List<FarmDto> farms = farmManager.getFarmByUserName();
		List<String> prTypes = new ArrayList<String>();
		List<String> purchasingGroups = new ArrayList<String>();
		
		Arrays.asList(PrTypeEnum.values()).forEach(item -> prTypes.add(item.val));
		Arrays.asList(ReportPrTypeEnum.values()).forEach(item -> purchasingGroups.add(item.val));
		// add to model
		modelAndView.addObject("farms", farms);
		modelAndView.addObject("prTypes", prTypes);
		modelAndView.addObject("purchasingGroups", purchasingGroups);
		modelAndView.addObject("criteria", new ReportPurchaseRequisitionDto());
		modelAndView.setViewName(PAGES_REPORT_PATH.concat(PAGE_NAME));
		
		return modelAndView;
	}
	
	@PostMapping("/purchase-requisition")
	public ResponseEntity<?> handleReportPrSearch(@RequestBody ReportPurchaseRequisitionDto criteria) {
		log.info("***********CONTROLLER::process='handle-report-pr-search'");
		return ResponseEntity.ok(reportManager.reportPr(criteria));
	}
	
	/*
	 * Hiển thị form báo cáo dự trù vật tư dụng cụ
	 */
	@GetMapping("/purchase-requisition-other")
	public ModelAndView showReportPrVDC() {
		log.info("********CONTROLLER::process=show-report-PR-VDC");
		ModelAndView modelAndView = new ModelAndView();
		List<FarmDto> farms = farmManager.getFarmByUserName();
		List<String> months = new ArrayList<String>();
		Arrays.asList(MonthEnum.values()).forEach(item -> months.add(item.val));
		
		modelAndView.addObject("farms", farms);
		modelAndView.addObject("months", months);
		modelAndView.setViewName(PAGES_REPORT_PATH.concat(PAGE_NAME_OTHER));
		return modelAndView;
	}
}
