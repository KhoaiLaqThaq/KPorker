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
import com.keysoft.pigfarm.report.dto.ReportProdEstimateDto;
import com.keysoft.pigfarm.report.dto.ReportSaleEstimateDto;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/report")
@RequiredArgsConstructor
public class ReportSaleEstimateController {
	@Autowired
	private ReportManager reportManager;
	@Autowired
	private FarmManager farmManager;

	@GetMapping("/sale-estimate")
	public ModelAndView getReportSaleEstimate() {
		log.info("****************CONTROLLER::process=report-sale-estimate");
		ModelAndView modelAndView = new ModelAndView("reports/report-sale-estimate");
		List<FarmDto> farms = farmManager.getAllFarmByUser();
		
		modelAndView.addObject("farms", farms);
		return modelAndView;
	}
	
	@PostMapping("/sale-estimate")
	public ModelAndView postReportSaleEstimate(@Valid ReportSaleEstimateDto criteria) {
		log.info("**********CONTROLLER::post-report-sale-estimate, reportSaleEstimate={}", criteria);
		if(CollectionUtils.isEmpty(criteria.getFarmCodes())) {
			return getReportSaleEstimate();
		}
		ModelAndView modelAndView = new ModelAndView("reports/report-sale-estimate");
		List<FarmDto> farms = farmManager.getAllFarmByUser();
		List<ReportSaleEstimateDto> reports = reportManager.handleReportSaleEstimate(criteria);
				
		modelAndView.addObject("farms", farms);
		modelAndView.addObject("reports", reports);
		modelAndView.addObject("criteria", criteria);
		
		return modelAndView;
	}

}
