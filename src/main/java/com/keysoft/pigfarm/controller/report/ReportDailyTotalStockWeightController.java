package com.keysoft.pigfarm.controller.report;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.keysoft.pigfarm.common.MonthEnum;
import com.keysoft.pigfarm.controller.BaseController;
import com.keysoft.pigfarm.manager.FarmManager;
import com.keysoft.pigfarm.manager.ReportManager;
import com.keysoft.pigfarm.production.dto.FarmDto;
import com.keysoft.pigfarm.production.dto.GoodsIssueDto;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/report")
@RequiredArgsConstructor
public class ReportDailyTotalStockWeightController extends BaseController {
	
	@Autowired
	private ReportManager reportManager;
	@Autowired
	private FarmManager farmManager;
	
	private final String PAGE_NAME = "report-daily-total-stock-weight";
	
	/*
	 * Báo cáo tổng hợp nhập xuất tiêu hao cám thuốc theo ngày
	 */
	@GetMapping("/dailyTotalStockWeight")
	public ModelAndView getDailyTotalStockWeight() {
		log.info("****************process='handle-report-dailyTotalStockWeight'******************");
		ModelAndView modelAndView = new ModelAndView();
		List<FarmDto> farms = farmManager.getFarmByUserName();
		List<String> months = new ArrayList<String>();
		Arrays.asList(MonthEnum.values()).forEach(item -> months.add(item.val));
		
		modelAndView.addObject("farms", farms);
		modelAndView.addObject("months", months);
		modelAndView.setViewName(PAGES_REPORT_PATH.concat(PAGE_NAME));
		return modelAndView;
	}
	
	@PostMapping("/dailyTotalStockWeight")
	public ResponseEntity<?> postDailyTotalStockView(@Valid GoodsIssueDto criteria, HttpServletRequest request) {
		log.info("**********CONTROLLER::'report-dailyTotalStockWeight', {}", criteria);
		return ResponseEntity.ok(reportManager.handleDailyTotalStockWeight(criteria));
	}
}
