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
import com.keysoft.pigfarm.report.dto.ReportDeadRateDto;
import com.keysoft.pigfarm.report.dto.ResponseResultDto;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/report")
@RequiredArgsConstructor
public class ReportDeadRateController extends BaseController {

	@Autowired
	private ReportManager reportManager;
	@Autowired
	private FarmManager farmManager;
	
	private final String PAGE_NAME = "report-dead-rate";
	
	/*
	 * Báo cáo tỉ lệ chết
	 */
	@GetMapping("/deadRate")
	public ModelAndView getReportDeadRate() {
		log.info("************CONTROLLER:process=get-report-percent-dead");
		ModelAndView modelAndView = new ModelAndView();
		List<FarmDto> farms = farmManager.getAllFarmByUser();
		modelAndView.addObject("farms", farms);
		modelAndView.setViewName(PAGES_REPORT_PATH.concat(PAGE_NAME));
		return modelAndView;
	}
	
	@PostMapping("/deadRate")
	public ModelAndView handleReportDeadRate(@Valid ReportDeadRateDto criteria) {
		log.info("**********CONTROLLER::process=handle-report-dead-rate");
		ModelAndView modelAndView = new ModelAndView();
		
		ResponseResultDto result = reportManager.handleReportDeadRate(criteria);
		List<FarmDto> farms = farmManager.getAllFarmByUser();
		modelAndView.addObject("farms", farms);
		modelAndView.addObject("criteria", criteria);
		modelAndView.addObject("result", result);
		modelAndView.setViewName(PAGES_REPORT_PATH.concat(PAGE_NAME));
		return modelAndView;
	}
}
