package com.keysoft.pigfarm.controller.report;

import java.util.List;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.keysoft.pigfarm.controller.BaseController;
import com.keysoft.pigfarm.manager.FarmManager;
import com.keysoft.pigfarm.manager.ReportManager;
import com.keysoft.pigfarm.production.dto.FarmDto;
import com.keysoft.pigfarm.report.dto.ReportFCRDto;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/report")
@RequiredArgsConstructor
public class ReportFcrController extends BaseController {
	
	@Autowired
	private ReportManager reportManager;
	@Autowired
	private FarmManager farmManager;
	
	private final String PAGE_NAME = "report-fcr";
	
	/*
	 * Báo cáo FCR 
	 */
	@GetMapping("/fcr")
	public ModelAndView getReportFCR() {
		log.info("************CONTROLLER:process=get-report-fcr");
		ModelAndView modelAndView = new ModelAndView();
		List<FarmDto> farms = farmManager.getAllFarmByUser();
		modelAndView.addObject("farms", farms);
		modelAndView.setViewName(PAGES_REPORT_PATH.concat(PAGE_NAME));
		return modelAndView;
	}
	
	@PostMapping("/fcr")
	public ModelAndView handleReportFCR(@Valid ReportFCRDto criteria) {
		log.info("**********CONTROLLER:process=handle-report-fcr, criteria={}", criteria);
		ModelAndView modelAndView = new ModelAndView();
		List<ReportFCRDto> fcrLst = reportManager.handleReportFcr(criteria);
		
		List<FarmDto> farms = farmManager.getAllFarmByUser();
		modelAndView.addObject("farms", farms).addObject("fcrLst", fcrLst).addObject("criteria", criteria);
		modelAndView.setViewName(PAGES_REPORT_PATH.concat(PAGE_NAME));
		return modelAndView;
	}
}
