package com.keysoft.pigfarm.controller.report;

import java.util.List;

import com.keysoft.pigfarm.report.dto.ReportTaskDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.keysoft.pigfarm.common.SymbolEnum;
import com.keysoft.pigfarm.controller.BaseController;
import com.keysoft.pigfarm.manager.ProcessOrderManager;
import com.keysoft.pigfarm.manager.ReportManager;
import com.keysoft.pigfarm.production.dto.ProcessOrderDto;
import com.keysoft.pigfarm.report.dto.ReportVTDCDto;

import lombok.extern.slf4j.Slf4j;

import javax.servlet.http.HttpServletRequest;

@Slf4j
@RestController
@RequestMapping("/report")
public class ReportAPIController extends BaseController {
	
	@Autowired
	private ReportManager reportManager;
	@Autowired
	private ProcessOrderManager processOrderManager;
	private final String roleTaskAdminView = "ROLE_TASK_ADMIN_VIEW";

	/*
	 * Tính toán báo cáo dự trù vật tư dụng cụ
	 */
	@PostMapping(value ="/purchase-requisition-other")
	public ResponseEntity<?> handleReportPrVDC(@RequestBody ReportVTDCDto criteria) throws Exception {
		log.info("**********CONTROLLER::process='handle-report-pr-VDC, criteria={}'", criteria);
		List<ReportVTDCDto> reportVDC = reportManager.handleReportPurchaseRequisitionVDC(criteria);
		return ResponseEntity.ok(reportVDC);
	}
	
	/*
	 * this api will get the list processOrder's status 'closed' & 'synchronized'
	 * @param farmCode required
	 */
	@GetMapping("/processOrderForReport/farm")
	public ResponseEntity<?> getAllProcessOrderByFarmCode(@RequestParam(value = "farmCode", required = true) String farmCode) {
		log.info("**********RESTAPI:process='get-all-process-order-by-farmCode, farmCode={}'", farmCode);
		List<ProcessOrderDto> processOrders = processOrderManager.getAllForReportByFarmCode(farmCode);
		if (processOrders != null) {
			return ResponseEntity.status(HttpStatus.OK).body(processOrders);
		}
		return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
	}

	/*
	 * this api will get the list processOrder's status 'closed' & 'synchronized' & 'confirmed'
	 * @param farmCode required
	 */
	@GetMapping("/processOrderAllForReport")
	public ResponseEntity<?> getProcessOrderByFarmCode(@RequestParam(value = "farmCode", required = true) String farmCode,
			@RequestParam(value = "startDate", required = true) String startDate,
			@RequestParam(value = "endDate", required = true) String endDate) {
		log.info("**********RESTAPI:process='get-all-process-order-by-farmCode, farmCode={}, stage={}'", farmCode, startDate, endDate);
		
		ProcessOrderDto criteria = new ProcessOrderDto();
		criteria.setFarmCode(farmCode);
		criteria.setStage(startDate.concat(SymbolEnum.HYPHEN.val).concat(endDate));
		
		List<ProcessOrderDto> processOrders = processOrderManager.getAllProcessOrderForReport(criteria);
		if (processOrders != null) {
			return ResponseEntity.status(HttpStatus.OK).body(processOrders);
		}
		return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
	}

	@PostMapping("/task")
	public ResponseEntity<?> getTaskDataReport(@RequestBody ReportTaskDto criteria, HttpServletRequest request) {
		log.info("entering: 'get-task-data-report' method...");
		criteria.setAdminView(request.isUserInRole(roleTaskAdminView));
		return ResponseEntity.ok(reportManager.handleReportTask(criteria));
	}
}
