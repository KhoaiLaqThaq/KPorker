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
import com.keysoft.pigfarm.report.dto.ReportFarmAnalystDto;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/report")
@RequiredArgsConstructor
public class ReportFarmAnalystController extends BaseController {
	
	@Autowired
	private ReportManager reportManager;
	@Autowired
	private FarmManager farmManager;
	
	private final String PAGE_NAME = "report-farm-analyst";
	private final String PAGE_NAME_PIG_LEVEL = "report-farm-analyst-pig-level";
	
	@GetMapping("/farm-analyst")
	public ModelAndView getPage() throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		List<FarmDto> farms = farmManager.getFarmByUserName();
		modelAndView.addObject("farms", farms).addObject("criteria", new ReportFarmAnalystDto());
		modelAndView.setViewName(PAGES_REPORT_PATH.concat(PAGE_NAME));
		
		return modelAndView;
	}
	
	@PostMapping("/farm-analyst")
	public ModelAndView handleReportFarmAnalyst(@Valid ReportFarmAnalystDto criteria) throws Exception {
		log.info("----------CONTROLLER::process=handle-report-farm-analyst, criteria={}", criteria);
		ModelAndView modelAndView = new ModelAndView();
		List<FarmDto> farms = farmManager.getAllFarmByUser();
		ReportFarmAnalystDto farmAnalyst = reportManager.handleReportFarmAnalyst(criteria);
		
		modelAndView.addObject("farmAnalyst", farmAnalyst);
		modelAndView.addObject("farms", farms);
		modelAndView.addObject("criteria", criteria);
		modelAndView.setViewName(PAGES_REPORT_PATH.concat(PAGE_NAME));
		return modelAndView;
	}
	
	@GetMapping("/farm-analyst-pig-level")
	public ModelAndView getPageByPigLevel() throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		List<FarmDto> farms = farmManager.getFarmByUserName();
		modelAndView.addObject("farms", farms).addObject("criteria", new ReportFarmAnalystDto());
		modelAndView.setViewName(PAGES_REPORT_PATH.concat(PAGE_NAME_PIG_LEVEL));
		
		return modelAndView;
	}
	
	@PostMapping("/farm-analyst-pig-level")
	public ModelAndView handleReportFarmAnalystByPigLevel(@Valid ReportFarmAnalystDto criteria) throws Exception {
		log.info("----------CONTROLLER::process=handle-report-farm-analyst-bt-pig-level, criteria={}", criteria);
		ModelAndView modelAndView = new ModelAndView();
		List<FarmDto> farms = farmManager.getAllFarmByUser();
		ReportFarmAnalystDto farmAnalyst = reportManager.handleReportFarmAnalystByPigLevel(criteria);
		
		modelAndView.addObject("farmAnalyst", farmAnalyst);
		modelAndView.addObject("farms", farms);
		modelAndView.addObject("criteria", criteria);
		modelAndView.setViewName(PAGES_REPORT_PATH.concat(PAGE_NAME_PIG_LEVEL));
		return modelAndView;
	}
}
