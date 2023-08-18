package com.keysoft.pigfarm.manager;

import java.util.List;

import com.keysoft.pigfarm.report.dto.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.keysoft.pigfarm.config.ServiceProperties;
import com.keysoft.pigfarm.constant.ApiEnum;
import com.keysoft.pigfarm.integration.EntityResponse;
import com.keysoft.pigfarm.production.dto.EventDto;
import com.keysoft.pigfarm.production.dto.GoodsIssueDto;
import com.keysoft.pigfarm.production.dto.MaterialDetailDto;
import com.keysoft.pigfarm.production.dto.MaterialDto;
import com.keysoft.pigfarm.production.dto.WeightNoteDto;
import com.keysoft.pigfarm.util.RestHelper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ReportManager {
	@Autowired
	private RestHelper restHelper;
	@Autowired
	private ServiceProperties serviceProperties;
	
	@SuppressWarnings("unchecked")
	public List<MaterialDto> handleDailyTotalStockWeight(GoodsIssueDto criteria) {
		log.info("*********MANAGER::handleDailyTotalStockWeight***********");
		ResponseEntity<?> response = restHelper.send(
				serviceProperties.getPaths().get(ApiEnum.PATH_REPORT_DAILY_TOTAL_STOCK_WEIGHT.val)
				, HttpMethod.POST
				, criteria
				, new ParameterizedTypeReference<List<MaterialDto>>() {});
		return (List<MaterialDto>) response.getBody();
	}
	
	public ReportDayDto handleReportStockDay(String stockCode, String period) {
		log.info("*********MANAGER::handleReportStockDay**********");
		ResponseEntity<?> response = restHelper.send(
				serviceProperties.getPaths().get(ApiEnum.PATH_REPORT_STOCK_DAY.val)
				, HttpMethod.POST
				, ReportDayDto.class
				, stockCode, period);
		return (ReportDayDto) response.getBody();
	}
	
	@SuppressWarnings("unchecked")
	public List<ReportInstockDto> handleReportInstock(ReportInstockDto criteria) {
		log.info("**********MANAGER::handleReportInstock");
		ResponseEntity<?> response = restHelper.send(
				serviceProperties.getPaths().get(ApiEnum.PATH_REPORT_INSTOCK.val)
				, HttpMethod.POST
				, criteria
				, new ParameterizedTypeReference<List<ReportInstockDto>>() {});
		return (List<ReportInstockDto>) response.getBody();
	}
	/*
	 * Báo cáo dự trù cám thuốc
	 */
	public ResponseResultDto reportPr(ReportPurchaseRequisitionDto criteria) {
		log.info("process='report-pr'");
		ResponseEntity<?> response = restHelper.send(
				serviceProperties.getPaths().get(ApiEnum.PATH_PURCHASE__REQUISITION_REPORT.val)
				, HttpMethod.POST
				, criteria
				, ResponseResultDto.class);
		return (ResponseResultDto) response.getBody();
	}
	
	/*
	 * Báo cáo dự trù vật tư dụng cụ
	 */
	@SuppressWarnings("unchecked")
	public List<ReportVTDCDto> handleReportPurchaseRequisitionVDC(ReportVTDCDto criteria) {
		log.info("**********MANAGER:process='handleReportPurchaseRequisitionVDC', stockCode={}, stage={}", criteria.getStockCode(), criteria.getStage());
		ResponseEntity<?> response = restHelper.send(
				serviceProperties.getPaths().get(ApiEnum.PATH_PURCHASE__REQUISITION_OTHER_REPORT.val)
				, HttpMethod.POST
				, criteria
				, new ParameterizedTypeReference<List<ReportVTDCDto>>() {});
		return (List<ReportVTDCDto>) response.getBody();
	}
	
	/*
	 * Báo cáo biểu cân
	 */
	public ReportWeightNoteDto handleReportDailyAverageWeight(EventDto criteria) {
		log.info("***********MANAGER::process=handle-report-daily-average-weight, criteria={}", criteria);
		ResponseEntity<?> response = restHelper.send(
				serviceProperties.getPaths().get(ApiEnum.PATH_REPORT_DAILY_AVERAGE_WEIGHT.val)
				, HttpMethod.POST
				, criteria
				, ReportWeightNoteDto.class);
		return (ReportWeightNoteDto) response.getBody();
	}
	
	/*
	 * Báo cáo tỉ lệ chết
	 */
	public ResponseResultDto handleReportDeadRate(ReportDeadRateDto criteria) {
		log.info("*********MANAGER::process=handle-report-dead-rate");
		ResponseEntity<?> response = restHelper.send(
				serviceProperties.getPaths().get(ApiEnum.PATH_REPORT_DEAD_RATE.val)
				, HttpMethod.POST
				, criteria
				, new ParameterizedTypeReference<ResponseResultDto>() {});
		return (ResponseResultDto) response.getBody();
	}
	
	/*
	 * Report FCR
	 */
	@SuppressWarnings("unchecked")
	public List<ReportFCRDto> handleReportFcr(ReportFCRDto criteria) {
		log.info("**********MANAGER::process=handle-report-fcr...");
		ResponseEntity<?> response = restHelper.send(
				serviceProperties.getPaths().get(ApiEnum.PATH_REPORT_FCR.val)
				, HttpMethod.POST
				, criteria
				, new ParameterizedTypeReference<List<ReportFCRDto>>() {});
		return (List<ReportFCRDto>) response.getBody();
	}
	
	/*
	 * Report ADG
	 */
	@SuppressWarnings("unchecked")
	public List<ReportADGDto> handleReportADG(ReportADGDto criteria) {
		log.info("*************MANAGER::process=handle-report-adg, criteria={}", criteria);
		ResponseEntity<?> response = restHelper.send(
				serviceProperties.getPaths().get(ApiEnum.PATH_REPORT_ADG.val)
				, HttpMethod.POST
				, criteria
				, new ParameterizedTypeReference<List<ReportADGDto>>() {});
		
		return (List<ReportADGDto>) response.getBody();
	}
	
	/*
	 * Report list material goods attrition
	 */
	public EntityResponse handleReportListMaterialGA(MaterialDetailDto criteria) {
		log.info("************MANAGER::process=handle-report-list-material-GA");
		ResponseEntity<?> response = restHelper.send(
				serviceProperties.getPaths().get(ApiEnum.PATH_REPORT_LIST_MATERIAL_GA.val)
				, HttpMethod.POST
				, criteria
				, EntityResponse.class);
		
		return (EntityResponse) response.getBody();
	}
	
	/*
	 * Report list goodsReceipt
	 */
	public EntityResponse handleReportListGoodsReceipt(ReportGoodsReceiptDto criteria) {
		log.info("*******MANAGER::process=handle-report-list-goodsReceipt, criteria={}", criteria);
		ResponseEntity<?> response = restHelper.send(
				serviceProperties.getPaths().get(ApiEnum.PATH_REPORT_LIST_GOODS_RECEIPT.val)
				, HttpMethod.POST
				, criteria
				, EntityResponse.class);
		return (EntityResponse) response.getBody();
	}
	
	/*
	 * Report day detail
	 */
	public EntityResponse handleReportDayDetail(ReportDayDetailDto criteria) {
		log.info("************MANAGER::process=handle-report-day-detail");
		ResponseEntity<?> response = restHelper.send(
				serviceProperties.getPaths().get(ApiEnum.PATH_REPORT_DAY_DETAIL.val)
				, HttpMethod.POST
				, criteria
				, EntityResponse.class);
		return (EntityResponse) response.getBody();
	}
	
	/*
	 * Report farm analyst
	 */
	public ReportFarmAnalystDto handleReportFarmAnalyst(ReportFarmAnalystDto criteria) {
		log.info("-----------------MANAGER:process='handleReportFarmAnalyst'");
		ResponseEntity<?> response = restHelper.send(
				serviceProperties.getPaths().get(ApiEnum.PATH_REPORT_FARM_ANALYST_SEARCH.val)
				, HttpMethod.POST
				, criteria
				, ReportFarmAnalystDto.class);
		
		return (ReportFarmAnalystDto) response.getBody();
	}
	
	/*
	 * Report farm analyst by pig level
	 */
	public ReportFarmAnalystDto handleReportFarmAnalystByPigLevel(ReportFarmAnalystDto criteria) {
		log.info("-----------------MANAGER:process='handleReportFarmAnalystByPigLevel'");
		ResponseEntity<?> response = restHelper.send(
				serviceProperties.getPaths().get(ApiEnum.PATH_REPORT_FARM_ANALYST_SEARCH_PIG_LEVEL.val)
				, HttpMethod.POST
				, criteria
				, ReportFarmAnalystDto.class);
		
		return (ReportFarmAnalystDto) response.getBody();
	}
	
	/*
	 * Report instock pig
	 */
	public EntityResponse handleReportInstockPig(ReportInstockPigDto criteria) {
		log.info("************MANAGER::process=handle-report-instock-pig");
		
		ResponseEntity<?> response = restHelper.send(
				serviceProperties.getPaths().get(ApiEnum.PATH_REPORT_INSTOCK_PIG.val)
				, HttpMethod.POST
				, criteria
				, EntityResponse.class);
		return (EntityResponse) response.getBody();
	}
	
	/*
	 * Report weight compare
	 */
	@SuppressWarnings("unchecked")
	public List<ReportWeightCompareDto> handleReportWeightCompare(ReportWeightCompareDto criteria) {
		log.info("************MANAGER::process=handle-report-weight-compare");
		ResponseEntity<?> response = restHelper.send(
				serviceProperties.getPaths().get(ApiEnum.PATH_REPORT_WEIGHT_COMPARE.val)
				, HttpMethod.POST
				, criteria
				, new ParameterizedTypeReference<List<ReportWeightCompareDto>>() {});
		return (List<ReportWeightCompareDto>) response.getBody();
	}
	
	/*
	 * Report weight compare by pig level
	 */
	@SuppressWarnings("unchecked")
	public List<ReportWeightCompareDto> handleReportWeightCompareByPigLevel(ReportWeightCompareDto criteria) {
		log.info("************MANAGER::process=handle-report-weight-compare-by-pigLevel");
		ResponseEntity<?> response = restHelper.send(
				serviceProperties.getPaths().get(ApiEnum.PATH_REPORT_WEIGHT_COMPARE_BY_PIGLEVEL.val)
				, HttpMethod.POST
				, criteria
				, new ParameterizedTypeReference<List<ReportWeightCompareDto>>() {});
		return (List<ReportWeightCompareDto>) response.getBody();
	}
	
	/*
	 * Báo cáo dự kiến năng suất theo lệnh
	 */
	@SuppressWarnings("unchecked")
	public List<ReportProdEstimateDto> handleReportProdEstimate(ReportProdEstimateDto criteria) {
		log.info("************MANAGER::process=handle-report-productivity-estimate");
		ResponseEntity<?> response = restHelper.send(
				serviceProperties.getPaths().get(ApiEnum.PATH_REPORT_PROD_ESTIMATE.val)
				, HttpMethod.POST
				, criteria
				, new ParameterizedTypeReference<List<ReportProdEstimateDto>>() {});
		return (List<ReportProdEstimateDto>) response.getBody();
	}
	
	/*
	 * Báo cáo dự kiến năng suất theo lứa heo
	 */
	@SuppressWarnings("unchecked")
	public List<ReportProdEstimateDto> handleReportProdEstimateByLevel(ReportProdEstimateDto criteria) {
		log.info("************MANAGER::process=handle-report-productivity-estimate-by-level");
		ResponseEntity<?> response = restHelper.send(
				serviceProperties.getPaths().get(ApiEnum.PATH_REPORT_PROD_ESTIMATE_BY_LEVEL.val)
				, HttpMethod.POST
				, criteria
				, new ParameterizedTypeReference<List<ReportProdEstimateDto>>() {});
		return (List<ReportProdEstimateDto>) response.getBody();
	}
	
	/*
	 * Báo cáo kết quả năng suất
	 */
	@SuppressWarnings("unchecked")
	public List<ReportProdResultDto> handleReportProdResult(ReportProdResultDto criteria) {
		log.info("************MANAGER::process=handle-report-productivity-result");
		ResponseEntity<?> response = restHelper.send(
				serviceProperties.getPaths().get(ApiEnum.PATH_REPORT_PROD_RESULT.val)
				, HttpMethod.POST
				, criteria
				, new ParameterizedTypeReference<List<ReportProdResultDto>>() {});
		return (List<ReportProdResultDto>) response.getBody();
	}
	
	/*
	 * Báo cáo kết quả năng suất
	 */
	@SuppressWarnings("unchecked")
	public List<ReportProdResultDto> handleReportProdResultByLevel(ReportProdResultDto criteria) {
		log.info("************MANAGER::process=handle-report-productivity-result-by-pig-level");
		ResponseEntity<?> response = restHelper.send(
				serviceProperties.getPaths().get(ApiEnum.PATH_REPORT_PROD_RESULT_BY_LEVEL.val)
				, HttpMethod.POST
				, criteria
				, new ParameterizedTypeReference<List<ReportProdResultDto>>() {});
		return (List<ReportProdResultDto>) response.getBody();
	}
	
	/*
	 * Báo cáo dự kiến đề xuất bán heo
	 */
	@SuppressWarnings("unchecked")
	public List<ReportSaleEstimateDto> handleReportSaleEstimate(ReportSaleEstimateDto criteria) {
		log.info("************MANAGER::process=handle-report-sale-estimate");
		ResponseEntity<?> response = restHelper.send(
				serviceProperties.getPaths().get(ApiEnum.PATH_REPORT_SALE_ESTIMATE.val)
				, HttpMethod.POST
				, criteria
				, new ParameterizedTypeReference<List<ReportSaleEstimateDto>>() {});
		return (List<ReportSaleEstimateDto>) response.getBody();
	}
	
	/*
	 * Báo cáo chi tiết nhập xuất tồn hàng ngày
	 */
	@SuppressWarnings("unchecked")
	public List<ReportDayGRGADto> handleReportDayGRGA(ReportDayGRGADto criteria) {
		log.info("************MANAGER::process=handle-report-day-grga");
		ResponseEntity<?> response = restHelper.send(
				serviceProperties.getPaths().get(ApiEnum.PATH_REPORT_DAY_GRGA.val)
				, HttpMethod.POST
				, criteria
				, new ParameterizedTypeReference<List<ReportDayGRGADto>>() {});
		return (List<ReportDayGRGADto>) response.getBody();
	}
	
	/*
	 * Báo cáo tra soát dữ liệu
	 */
	@SuppressWarnings("unchecked")
	public List<DataInvestDto> handleReportDataInvest(DataInvestDto criteria) {
		log.info("************MANAGER::process=handle-report-data-invest");
		ResponseEntity<?> response = restHelper.send(
				serviceProperties.getPaths().get(ApiEnum.PATH_REPORT_DATA_INVEST.val)
				, HttpMethod.POST
				, criteria
				, new ParameterizedTypeReference<List<DataInvestDto>>() {});
		return (List<DataInvestDto>) response.getBody();
	}

	/**
	 * Báo cáo công việc
	 */
	public EntityResponse handleReportTask(ReportTaskDto criteria) {
		log.info("process:handleReportTask()...");
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_REPORT_TASK.val), HttpMethod.POST, criteria, EntityResponse.class);
		return (EntityResponse) response.getBody();
	}

	@SuppressWarnings("unchecked")
	public List<ReportTaskDto> handleExportReportTask(ReportTaskDto criteria) {
		log.info("process: handleExportReportTask()..., criteria={}", criteria);
		ResponseEntity<?> response = restHelper.send(serviceProperties.getPaths().get(ApiEnum.PATH_REPORT_TASK_EXPORT.val), HttpMethod.POST, criteria, new ParameterizedTypeReference<List<ReportTaskDto>>() {});
		return (List<ReportTaskDto>) response.getBody();
	}
}
