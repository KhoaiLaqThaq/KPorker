package com.keysoft.pigfarm.controller.report;

import java.util.List;

import javax.validation.Valid;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
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
import com.keysoft.pigfarm.report.dto.ReportProdResultDto;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/report")
@RequiredArgsConstructor
public class ReportProductivityController {

	@Autowired
	private ReportManager reportManager;
	@Autowired
	private FarmManager farmManager;
	
	/*
	 * Báo cáo dự kiến năng suất theo lệnh
	 */
	@GetMapping("/prod-estimate")
	public ModelAndView getReportProdEstimate() {
		log.info("****************CONTROLLER::process=report-Productivity-estimate");
		ModelAndView modelAndView = new ModelAndView("reports/report-prod-estimate");
		List<FarmDto> farms = farmManager.getAllFarmByUser();
		
		modelAndView.addObject("farms", farms);
		return modelAndView;
	}
	
	@PostMapping("/prod-estimate")
	public ModelAndView postReportProdEstimate(@Valid ReportProdEstimateDto criteria) {
		log.info("**********CONTROLLER::post-report-prod-estimate, reportProductivityEstimate={}", criteria);
		if(CollectionUtils.isEmpty(criteria.getFarmCodes())  && StringUtils.isBlank(criteria.getProcessOrderCode())) {
			return getReportProdEstimate();
		}
		ModelAndView modelAndView = new ModelAndView("reports/report-prod-estimate");
		List<FarmDto> farms = farmManager.getAllFarmByUser();
		List<ReportProdEstimateDto> reports = reportManager.handleReportProdEstimate(criteria);
		
		if(!CollectionUtils.isEmpty(criteria.getBarnCodes())) {
			StringBuilder barnCodeStr = new StringBuilder();
			criteria.getBarnCodes().forEach(b -> barnCodeStr.append(b).append(SymbolEnum.COMMA.val));
			criteria.setBarnCodeStr(barnCodeStr.toString());
		}
		
		modelAndView.addObject("farms", farms);
		modelAndView.addObject("reports", reports);
		modelAndView.addObject("criteria", criteria);
		
		return modelAndView;
	}
	
	/*
	 * Báo cáo dự kiến năng suất theo lứa heo
	 */
	@GetMapping("/prod-estimate-by-level")
	public ModelAndView getReportProdEstimateByLevel() {
		log.info("****************CONTROLLER::process=report-Productivity-estimate-by-level");
		ModelAndView modelAndView = new ModelAndView("reports/report-prod-estimate-byLevel");
		List<FarmDto> farms = farmManager.getAllFarmByUser();
		
		modelAndView.addObject("farms", farms);
		return modelAndView;
	}
	
	@PostMapping("/prod-estimate-by-level")
	public ModelAndView postReportProdEstimateByLevel(@Valid ReportProdEstimateDto criteria) {
		log.info("**********CONTROLLER::post-report-prod-estimate-by-level, reportProductivityEstimate={}", criteria);
		if(CollectionUtils.isEmpty(criteria.getFarmCodes())) {
			return getReportProdEstimateByLevel();
		}
		ModelAndView modelAndView = new ModelAndView("reports/report-prod-estimate-byLevel");
		List<FarmDto> farms = farmManager.getAllFarmByUser();
		List<ReportProdEstimateDto> reports = reportManager.handleReportProdEstimateByLevel(criteria);
		
		if(!CollectionUtils.isEmpty(criteria.getBarnCodes())) {
			StringBuilder barnCodeStr = new StringBuilder();
			criteria.getBarnCodes().forEach(b -> barnCodeStr.append(b).append(SymbolEnum.COMMA.val));
			criteria.setBarnCodeStr(barnCodeStr.toString());
		}
		
		modelAndView.addObject("farms", farms);
		modelAndView.addObject("reports", reports);
		modelAndView.addObject("criteria", criteria);
		
		return modelAndView;
	}
	

	/*
	 * Báo cáo kết quả năng suất
	 */
	@GetMapping("/prod-result")
	public ModelAndView getReportProdResult() {
		log.info("****************CONTROLLER::process=report-Productivity-Result");
		ModelAndView modelAndView = new ModelAndView("reports/report-prod-result");
		List<FarmDto> farms = farmManager.getAllFarmByUser();
		
		modelAndView.addObject("farms", farms);
		return modelAndView;
	}
	
	@PostMapping("/prod-result")
	public ModelAndView postReportProdResult(@Valid ReportProdResultDto criteria) {
		log.info("**********CONTROLLER::post-report-prod-result, reportProductivityResult={}", criteria);
		if(CollectionUtils.isEmpty(criteria.getFarmCodes())) {
			return getReportProdResult();
		}
		ModelAndView modelAndView = new ModelAndView("reports/report-prod-result");
		List<FarmDto> farms = farmManager.getAllFarmByUser();
		List<ReportProdResultDto> reports = reportManager.handleReportProdResult(criteria);
		
		if(!CollectionUtils.isEmpty(criteria.getBarnCodes())) {
			StringBuilder barnCodeStr = new StringBuilder();
			criteria.getBarnCodes().forEach(b -> barnCodeStr.append(b).append(SymbolEnum.COMMA.val));
			criteria.setBarnCodeStr(barnCodeStr.toString());
		}
		
		modelAndView.addObject("farms", farms);
		modelAndView.addObject("reports", reports);
		modelAndView.addObject("criteria", criteria);
		
		return modelAndView;
	}
	
	/*
	 * Báo cáo kết quả năng suất
	 */
	@GetMapping("/prod-result-by-level")
	public ModelAndView getReportProdResultByPigLevel() {
		log.info("****************CONTROLLER::process=report-Productivity-Result-By-Pig-Level");
		ModelAndView modelAndView = new ModelAndView("reports/report-prod-result-by-level");
		List<FarmDto> farms = farmManager.getAllFarmByUser();
		
		modelAndView.addObject("farms", farms);
		return modelAndView;
	}
	
	@PostMapping("/prod-result-by-level")
	public ModelAndView postReportProdResultByPigLevel(@Valid ReportProdResultDto criteria) {
		log.info("**********CONTROLLER::post-report-prod-result-by-pig-level, reportProductivityResult={}", criteria);
		if(CollectionUtils.isEmpty(criteria.getFarmCodes())) {
			return getReportProdResultByPigLevel();
		}
		ModelAndView modelAndView = new ModelAndView("reports/report-prod-result-by-level");
		List<FarmDto> farms = farmManager.getAllFarmByUser();
		List<ReportProdResultDto> reports = reportManager.handleReportProdResultByLevel(criteria);
		
		if(!CollectionUtils.isEmpty(criteria.getBarnCodes())) {
			StringBuilder barnCodeStr = new StringBuilder();
			criteria.getBarnCodes().forEach(b -> barnCodeStr.append(b).append(SymbolEnum.COMMA.val));
			criteria.setBarnCodeStr(barnCodeStr.toString());
		}
		
		modelAndView.addObject("farms", farms);
		modelAndView.addObject("reports", reports);
		modelAndView.addObject("criteria", criteria);
		
		return modelAndView;
	}
}
