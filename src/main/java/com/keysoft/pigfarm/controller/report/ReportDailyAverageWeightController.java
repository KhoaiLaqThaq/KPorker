package com.keysoft.pigfarm.controller.report;

import java.util.ArrayList;
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
import com.keysoft.pigfarm.controller.BaseController;
import com.keysoft.pigfarm.manager.FarmManager;
import com.keysoft.pigfarm.manager.ReportManager;
import com.keysoft.pigfarm.production.dto.EventDto;
import com.keysoft.pigfarm.production.dto.FarmDto;
import com.keysoft.pigfarm.report.dto.ReportWeightCompareDto;
import com.keysoft.pigfarm.report.dto.ReportWeightNoteDto;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/report")
@RequiredArgsConstructor
public class ReportDailyAverageWeightController extends BaseController {
	
	@Autowired
	private ReportManager reportManager;
	@Autowired
	private FarmManager farmManager;
	
	private final String PAGE_NAME = "report-daily-avg-weight";
	
	/*
	 * Báo cáo biểu cân
	 */
	@GetMapping("/daily-average-weight")
	public ModelAndView getReportDailyAverageWeight() {
		log.info("**********CONTROLLER::process=get-report-average-weight");
		ModelAndView modelAndView = new ModelAndView();
		List<FarmDto> farms = farmManager.getAllFarmByUser();
		
		List<String> weightRanges = new ArrayList<>();
		for(int i = 0; i<=130; i+=5) {
			StringBuilder rangeBuild = new StringBuilder();
			rangeBuild.append(i).append("Kg").append("-").append(i+5).append("Kg");
			weightRanges.add(rangeBuild.toString());
		}
		
		modelAndView.addObject("farms", farms);
		modelAndView.addObject("criteria", new EventDto());
		modelAndView.addObject("ranges", weightRanges);
		modelAndView.setViewName(PAGES_REPORT_PATH.concat(PAGE_NAME));
		return modelAndView;
	}
	
	@PostMapping("/daily-average-weight")
	public ModelAndView postReportDailyAverageWeight(@Valid EventDto criteria) {
		log.info("**********CONTROLLER::process=post-report-average-weight, criteria={}", criteria);

		ModelAndView modelAndView = new ModelAndView();
		ReportWeightNoteDto report = reportManager.handleReportDailyAverageWeight(criteria);
		List<FarmDto> farms = farmManager.getAllFarmByUser();
		
		List<String> weightRanges = new ArrayList<>();
		for(int i = 0; i<=130; i+=5) {
			StringBuilder rangeBuild = new StringBuilder();
			rangeBuild.append(i).append("Kg").append("-").append(i+5).append("Kg");
			weightRanges.add(rangeBuild.toString());
		}
		
		modelAndView.addObject("farms", farms);
		modelAndView.addObject("criteria", criteria);
		modelAndView.addObject("report", report);
		modelAndView.addObject("ranges", weightRanges);
		modelAndView.setViewName(PAGES_REPORT_PATH.concat(PAGE_NAME));
		return modelAndView;
	}
	
	@GetMapping("/weight-compare")
	public ModelAndView getReportWeightCompare() {
		log.info("**********CONTROLLER::process=get-report-weight-compare");
		ModelAndView modelAndView = new ModelAndView("reports/report--weight-compare");
		List<FarmDto> farms = farmManager.getAllFarmByUser();
		modelAndView.addObject("farms", farms);
		return modelAndView;
	} 
	
	@PostMapping("/weight-compare")
	public ModelAndView postReportWeightCompare(@Valid ReportWeightCompareDto criteria) {
		log.info("**********CONTROLLER::process=post-report-weight-compare, criteria={}", criteria);
		if(CollectionUtils.isEmpty(criteria.getFarmCodes())) {
			return getReportWeightCompare();
		}
		ModelAndView modelAndView = new ModelAndView("reports/report--weight-compare");
		List<FarmDto> farms = farmManager.getAllFarmByUser();
		List<ReportWeightCompareDto> list = reportManager.handleReportWeightCompare(criteria);
		
		if(!CollectionUtils.isEmpty(criteria.getBarnCodes())) {
			StringBuilder barnCodeStr = new StringBuilder();
			criteria.getBarnCodes().forEach(b -> barnCodeStr.append(b).append(SymbolEnum.COMMA.val));
			criteria.setBarnCodeStr(barnCodeStr.toString());
		}
		
		modelAndView.addObject("farms", farms);
		modelAndView.addObject("report", list);
		modelAndView.addObject("criteria", criteria);
		
		return modelAndView;
	}
	
	@GetMapping("/weight-compare-by-pigLevel")
	public ModelAndView getReportWeightCompareByPigLevel() {
		log.info("**********CONTROLLER::process=get-report-weight-compare-by-piglevel");
		ModelAndView modelAndView = new ModelAndView("reports/report-weight-compare-by-pig-level");
		List<FarmDto> farms = farmManager.getAllFarmByUser();
		modelAndView.addObject("farms", farms);
		return modelAndView;
	} 
	
	@PostMapping("/weight-compare-by-pigLevel")
	public ModelAndView postReportWeightCompareByPigLevel(@Valid ReportWeightCompareDto criteria) {
		log.info("**********CONTROLLER::process=post-report-weight-compare-by-piglevel, criteria={}", criteria);
		if(CollectionUtils.isEmpty(criteria.getFarmCodes())) {
			return getReportWeightCompare();
		}
		ModelAndView modelAndView = new ModelAndView("reports/report-weight-compare-by-pig-level");
		List<FarmDto> farms = farmManager.getAllFarmByUser();
		List<ReportWeightCompareDto> list = reportManager.handleReportWeightCompareByPigLevel(criteria);
		
		if(!CollectionUtils.isEmpty(criteria.getBarnCodes())) {
			StringBuilder barnCodeStr = new StringBuilder();
			criteria.getBarnCodes().forEach(b -> barnCodeStr.append(b).append(SymbolEnum.COMMA.val));
			criteria.setBarnCodeStr(barnCodeStr.toString());
		}
		
		modelAndView.addObject("farms", farms);
		modelAndView.addObject("report", list);
		modelAndView.addObject("criteria", criteria);
		
		return modelAndView;
	}
}
