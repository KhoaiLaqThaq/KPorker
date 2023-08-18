package com.keysoft.pigfarm.controller.report;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.keysoft.pigfarm.common.EntityResponseCodeEnum;
import com.keysoft.pigfarm.common.PurchasingGroupCodeEnum;
import com.keysoft.pigfarm.common.SymbolEnum;
import com.keysoft.pigfarm.controller.BaseController;
import com.keysoft.pigfarm.integration.EntityResponse;
import com.keysoft.pigfarm.manager.FarmManager;
import com.keysoft.pigfarm.manager.ReportManager;
import com.keysoft.pigfarm.production.dto.FarmDto;
import com.keysoft.pigfarm.report.dto.ReportInstockDto;
import com.keysoft.pigfarm.report.dto.ReportInstockPigDto;
import com.keysoft.pigfarm.report.dto.ReportInstockPigSummaryDto;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/report")
@RequiredArgsConstructor
public class ReportInstockController extends BaseController {
	
	@Autowired
	private ReportManager reportManager;
	@Autowired
	private FarmManager farmManager;
	
	private final String PAGE_NAME = "report-instock";
	
	/*
	 * Báo cáo NXT
	 */
	@GetMapping("/instock")
	public ModelAndView getReportInstock() {
		log.info("****************CONTROLLER::process=report-Instock");
		ModelAndView modelAndView = new ModelAndView();
		List<FarmDto> farms = farmManager.getAllFarmByUser();
		List<String> purchasingGroupCodes = new ArrayList<String>();
		Arrays.asList(PurchasingGroupCodeEnum.values()).forEach(item -> {
			if(!item.equals(PurchasingGroupCodeEnum.PIG)) {
				purchasingGroupCodes.add(item.val);
			}
		});
		
		modelAndView.addObject("farms", farms);
		modelAndView.addObject("purchasingGroupCodes", purchasingGroupCodes);
		modelAndView.addObject("criteria", new ReportInstockDto());
		modelAndView.setViewName(PAGES_REPORT_PATH.concat(PAGE_NAME));
		return modelAndView;
	}
	
	@PostMapping("/instock")
	public ModelAndView postReportInstock(@Valid ReportInstockDto criteria) {
		log.info("**********CONTROLLER::post-report-instock, reportInstock={}", criteria);
		ModelAndView modelAndView = new ModelAndView();
		List<FarmDto> farms = farmManager.getAllFarmByUser();
		List<String> purchasingGroupCodes = new ArrayList<String>();
		Arrays.asList(PurchasingGroupCodeEnum.values()).forEach(item -> {
			if(!item.equals(PurchasingGroupCodeEnum.PIG)) {
				purchasingGroupCodes.add(item.val);
			}
		});
		List<ReportInstockDto> reportInstocks = reportManager.handleReportInstock(criteria);
		
		modelAndView.addObject("farms", farms);
		modelAndView.addObject("purchasingGroupCodes", purchasingGroupCodes);
		modelAndView.addObject("reportInstocks", reportInstocks);
		modelAndView.addObject("criteria", criteria);
		modelAndView.setViewName(PAGES_REPORT_PATH.concat(PAGE_NAME));
		
		return modelAndView;
	}
	
	/*
	 * Báo cáo tồn đầu heo
	 */
	@GetMapping("/instock-pig")
	public ModelAndView getReportInstockPig() {
		log.info("****************CONTROLLER::process=report-Instock-Pig");
		ModelAndView modelAndView = new ModelAndView("reports/report-instock-pig");
		List<FarmDto> farms = farmManager.getAllFarmByUser();
		
		modelAndView.addObject("farms", farms)
					.addObject("criteria", new ReportInstockPigDto());
		return modelAndView;
	}
	
	@SuppressWarnings("unchecked")
	@PostMapping("/instock-pig")
	public ModelAndView postReportInstockPig(@Valid ReportInstockPigDto criteria, HttpServletRequest request) {
		log.info("**********CONTROLLER::post-report-instock-pig, reportInstock={}", criteria);
		
		if(CollectionUtils.isEmpty(criteria.getFarmCodes())) {
			return getReportInstockPig();
		}
		ModelAndView modelAndView = new ModelAndView("reports/report-instock-pig");
		List<FarmDto> farms = farmManager.getAllFarmByUser();
		ReportInstockPigSummaryDto reportInstocks = new ReportInstockPigSummaryDto();
		ObjectMapper mapper = new ObjectMapper();
		
		EntityResponse response = reportManager.handleReportInstockPig(criteria);
		if (response.getCode().equals(EntityResponseCodeEnum.SUCCESS_200.val)) {
//			reportInstocks = (ReportInstockPigSummaryDto) response.getData();
			reportInstocks = mapper.convertValue(response.getData(), ReportInstockPigSummaryDto.class);
		}
		
		if(!CollectionUtils.isEmpty(criteria.getBarnCodes())) {
			StringBuilder barnCodeStr = new StringBuilder();
			criteria.getBarnCodes().forEach(b -> barnCodeStr.append(b).append(SymbolEnum.COMMA.val));
			criteria.setBarnCodeStr(barnCodeStr.toString());
		}
		
		modelAndView.addObject("farms", farms);
		modelAndView.addObject("reportInstocks", reportInstocks);
		modelAndView.addObject("criteria", criteria);
		
		return modelAndView;
	}
	
}
