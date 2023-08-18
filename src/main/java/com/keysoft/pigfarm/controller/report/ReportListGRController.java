package com.keysoft.pigfarm.controller.report;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.validation.Valid;

import com.keysoft.pigfarm.constant.ModelViewEnum;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.keysoft.pigfarm.common.EntityResponseCodeEnum;
import com.keysoft.pigfarm.common.PurchasingGroupCodeEnum;
import com.keysoft.pigfarm.controller.BaseController;
import com.keysoft.pigfarm.integration.EntityResponse;
import com.keysoft.pigfarm.manager.FarmManager;
import com.keysoft.pigfarm.manager.ReportManager;
import com.keysoft.pigfarm.production.dto.FarmDto;
import com.keysoft.pigfarm.report.dto.ReportGoodsReceiptDto;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/report")
public class ReportListGRController extends BaseController {
	
	@Autowired
	private FarmManager farmManager;
	@Autowired
	private ReportManager reportManager;
	
	private final String PAGE_NAME = "report-list-goodsReceipts";
	
	/*
	 * Báo cáo kê nhập vật tư
	 */
	@GetMapping("/listGoodsReceipt")
	public ModelAndView getListGoodsReceipt() {
		log.info("**************CONTROLLER::process=get-report-list-goodsReceipt");
		ModelAndView modelAndView = new ModelAndView();
		List<FarmDto> farms = farmManager.getAllFarmByUser();
		List<String> purchasingGroupCodes = new ArrayList<String>();
		Arrays.asList(PurchasingGroupCodeEnum.values()).forEach(item -> purchasingGroupCodes.add(item.val));

		modelAndView.addObject(ModelViewEnum.MODEL_CRITERIA.mav, new ReportGoodsReceiptDto());
		modelAndView.addObject("purchasingGroupCodes", purchasingGroupCodes);
		modelAndView.addObject("farms", farms);
		modelAndView.setViewName(PAGES_REPORT_PATH.concat(PAGE_NAME));
		return modelAndView;
	}
	  
	@SuppressWarnings("unchecked")
	@PostMapping("/listGoodsReceipt")
	public ModelAndView handleListGoodsReceipt(@Valid ReportGoodsReceiptDto criteria) {
		log.info("****************CONTROLLER::process=handle-list-GoodsReceipt...");
		
		ModelAndView modelAndView = new ModelAndView();
		List<ReportGoodsReceiptDto> reportGoodsReceipts = new ArrayList<>();
		EntityResponse response = reportManager.handleReportListGoodsReceipt(criteria);
		if (response.getCode().equals(EntityResponseCodeEnum.SUCCESS_200.val)) {
			reportGoodsReceipts = (List<ReportGoodsReceiptDto>) response.getData();
		}
		List<FarmDto> farms = farmManager.getAllFarmByUser();
		List<String> purchasingGroupCodes = new ArrayList<String>();
		Arrays.asList(PurchasingGroupCodeEnum.values()).forEach(item -> purchasingGroupCodes.add(item.val));
		
		modelAndView.addObject("farms", farms)
			.addObject("materialCode", criteria.getMaterialCode())
			.addObject("materialName", criteria.getMaterialName())
			.addObject("purchasingGroupCodes", purchasingGroupCodes)
			.addObject("reportGoodsReceipts", reportGoodsReceipts)
			.addObject("criteria", criteria);
		modelAndView.setViewName(PAGES_REPORT_PATH.concat(PAGE_NAME));
		return modelAndView;
	}
}
