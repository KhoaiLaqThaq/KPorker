package com.keysoft.pigfarm.controller.report;

import java.util.List;

import javax.validation.Valid;

import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.keysoft.pigfarm.common.SymbolEnum;
import com.keysoft.pigfarm.manager.FarmManager;
import com.keysoft.pigfarm.manager.ReportManager;
import com.keysoft.pigfarm.production.dto.FarmDto;
import com.keysoft.pigfarm.report.dto.DataInvestDto;
import com.keysoft.pigfarm.report.dto.ReportInstockPigDto;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/report")
@RequiredArgsConstructor
public class ReportDataInvestController {
	@Autowired
	private ReportManager reportManager;
	@Autowired
	private FarmManager farmManager;
	
	/*
	 * Báo cáo soát dữ liệu
	 */
	@GetMapping("/data-invest")
	public ModelAndView getReportDataInvest() {
		log.info("****************CONTROLLER::process=report-Data-Invest");
		ModelAndView modelAndView = new ModelAndView("reports/report-data-invest");
		List<FarmDto> farms = farmManager.getAllFarmByUser();
		
		modelAndView.addObject("farms", farms);
		return modelAndView;
	}
	
	@PostMapping("/data-invest")
	public ModelAndView postReportDataInvest(@Valid DataInvestDto criteria) {
		log.info("**********CONTROLLER::post-report-data-invest, criteria={}", criteria);
		if(CollectionUtils.isEmpty(criteria.getFarmCodes())) {
			return getReportDataInvest();
		}
		ModelAndView modelAndView = new ModelAndView("reports/report-data-invest");
		List<FarmDto> farms = farmManager.getAllFarmByUser();
		List<DataInvestDto> reportInvest = reportManager.handleReportDataInvest(criteria);
		
		
		modelAndView.addObject("farms", farms);
		modelAndView.addObject("reportInvest", reportInvest);
		modelAndView.addObject("criteria", criteria);
		
		return modelAndView;
	}
}
