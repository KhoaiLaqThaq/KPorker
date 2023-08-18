package com.keysoft.pigfarm.controller.report;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.keysoft.pigfarm.common.DatePatternEnum;
import com.keysoft.pigfarm.common.EntityResponseCodeEnum;
import com.keysoft.pigfarm.common.PurchasingGroupCodeEnum;
import com.keysoft.pigfarm.controller.BaseController;
import com.keysoft.pigfarm.helper.DateTimeHelper;
import com.keysoft.pigfarm.integration.EntityResponse;
import com.keysoft.pigfarm.manager.FarmManager;
import com.keysoft.pigfarm.manager.ReportManager;
import com.keysoft.pigfarm.production.dto.DayDetailDto;
import com.keysoft.pigfarm.production.dto.FarmDto;
import com.keysoft.pigfarm.report.dto.ReportDayDetailDto;
import com.keysoft.pigfarm.report.dto.ReportDayGRGADto;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/report")
@RequiredArgsConstructor
public class ReportDayDetailController extends BaseController {

	@Autowired
	private ReportManager reportManager;
	@Autowired
	private FarmManager farmManager;
	
	private final String PAGE_NAME = "report-day-detail";
	private final String PAGE_DAY_GRGA_NAME = "report-day-grga";
	
	/*
	 * Báo cáo chi tiết ngày
	 */
	@GetMapping("/day-detail")
	public ModelAndView getReportDayDetail() {
		log.info("**********CONTROLLER::process=get-report-day-detail");
		ModelAndView modelAndView = new ModelAndView();
		List<FarmDto> farms = farmManager.getAllFarmByUser();
		modelAndView.addObject("farms", farms);
		modelAndView.addObject("criteria", new ReportDayDetailDto());
		modelAndView.setViewName(PAGES_REPORT_PATH.concat(PAGE_NAME));
		return modelAndView;
	}
	
	@SuppressWarnings("unchecked")
	@PostMapping("/day-detail")
	public ModelAndView handleReportDayDetail(@Valid ReportDayDetailDto criteria, HttpServletRequest request) {
		log.info("**********CONTROLLER::process=handle-report-day-detail, criteria={}", criteria);
		
		ModelAndView modelAndView = new ModelAndView();
		List<ReportDayDetailDto> reportDayDetails = new ArrayList<>();
		List<FarmDto> farms = farmManager.getAllFarmByUser();
		modelAndView.addObject("farms", farms);
		
		EntityResponse response = reportManager.handleReportDayDetail(criteria);
		
		if (response.getCode().equals(EntityResponseCodeEnum.SUCCESS_200.val)) {
			reportDayDetails = (List<ReportDayDetailDto>) response.getData();
		} else {
			addError(request, response.getMessage());
		}
		modelAndView.addObject("reportDayDetails", reportDayDetails);
		modelAndView.addObject("criteria", criteria);
		modelAndView.setViewName(PAGES_REPORT_PATH.concat(PAGE_NAME));
		return modelAndView;
	}
	
	
	/*
	 * Báo cáo nhập xuất tồn chi tiết ngày
	 */
	@GetMapping("/day-grga")
	public ModelAndView getReportDayGRGA() {
		log.info("**********CONTROLLER::process=get-report-day-grga");
		ModelAndView modelAndView = new ModelAndView();
		List<FarmDto> farms = farmManager.getAllFarmByUser();
		
		List<String> purchasingGroupCodes = new ArrayList<String>();
		Arrays.asList(PurchasingGroupCodeEnum.values()).forEach(item -> purchasingGroupCodes.add(item.val));
		
		modelAndView.addObject("farms", farms);
		modelAndView.addObject("purchasingGroupCodes", purchasingGroupCodes);
		modelAndView.setViewName(PAGES_REPORT_PATH.concat(PAGE_DAY_GRGA_NAME));
		return modelAndView;
	}
	
	@PostMapping("/day-grga")
	public ModelAndView handleReportDayGRGA(@Valid ReportDayGRGADto criteria) {
		log.info("**********CONTROLLER::process=handle-report-day-grga, criteria={}", criteria);
		ModelAndView modelAndView = new ModelAndView();
		List<ReportDayGRGADto> reportDayDetails = reportManager.handleReportDayGRGA(criteria);
		List<FarmDto> farms = farmManager.getAllFarmByUser();
		modelAndView.addObject("farms", farms);
		
		List<String> purchasingGroupCodes = new ArrayList<String>();
		Arrays.asList(PurchasingGroupCodeEnum.values()).forEach(item -> purchasingGroupCodes.add(item.val));
		modelAndView.addObject("purchasingGroupCodes", purchasingGroupCodes);
		
		modelAndView.addObject("criteria", criteria);
		modelAndView.addObject("reportDayDetails", reportDayDetails);
		ReportDayGRGADto exist = reportDayDetails.get(0);
		List<DayDetailDto> list = exist.getListDdays();
		
		List<String> daysStr = new ArrayList<>();
		list.stream().forEach(d -> {
			String dateDisplay = DateTimeHelper.toDateString(d.getRecordDate(), DatePatternEnum.DD_MM_YYYY_1.pattern);
			daysStr.add(dateDisplay);
		});
		modelAndView.addObject("daysDisplay", daysStr);
		
		modelAndView.setViewName(PAGES_REPORT_PATH.concat(PAGE_DAY_GRGA_NAME));
		return modelAndView;
	}
}
