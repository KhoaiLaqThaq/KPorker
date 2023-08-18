<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="menu.report.day.detail"/></title>
    <meta name="menu" content="reportDayDetailMenu"/>
	<link href="<c:url value='/themes/admin/assets/css/components.min.css'/>" rel="stylesheet" type="text/css" />
    <link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">

    <link href="<c:url value='/themes/admin/assets/css/material-support.css'/>" rel="stylesheet" type="text/css">
    <link href="<c:url value='/themes/admin/assets/css/colors.min.css'/>" rel="stylesheet" type="text/css">
    
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
    <script src="<c:url value="/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js"/>"></script>
    <!-- Multi selecte -->
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/uniform.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/pnotify.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/bootstrap_multiselect.js'/>"></script>
    
    <script src="<c:url value='/themes/admin/global_assets/js/demo_pages/form_multiselect.js'/>"></script>
    <!-- Datepicker -->
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/ui/moment/moment.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/daterangepicker.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/anytime.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.date.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.time.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/legacy.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/jgrowl.min.js'/>"></script>
    
    <script src="<c:url value='/themes/admin/global_assets/js/demo_pages/picker_date.js'/>"></script>
    
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/tables/datatables/datatables.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/tables/datatables/extensions/fixed_columns.min.js'/>"></script>
    
</head>

<div class="content">
<form:form id="reportDayDetailForm" modelAttribute="criteria" action="/report/day-detail"  method="post">
	<input type="hidden" id="searchingProcessOrder" value="${criteria.processOrderCode}"/>
	<!-- \Searching -->
	<div class="card rounded-16">
		<div class="row">
			<div class="col-6 px-3 py-2 fw-bold"><fmt:message key="label.search" /></div>
			<div class="col-6 text-right">
				<button type="submit" id="btnSubmit" class="btn btn-secondary rounded-10 mt-2 mr-2"><i class="icon-search4 mr-2"></i><fmt:message key="button.search"/></button>
			</div>
		</div>
        <div class="card-body py-0">
            <div class="row mb-3">
                <div class="col-md-3 col-sm-3 col-xs-12">
                    <div class="form-group">
                        <label>Trại:<span class="text-danger"> *</span></label>
                        <select class="form-control" name="stockCode[]" multiple="multiple" id="stockSelect" data-placeholder="Chọn trại...">
	                        <c:if test="${not empty farms}">
	                            <c:forEach var="farm" items="${farms}">
	                                <option value="${farm.code}" ${fn:contains(criteria.stockCode, farm.code)  ? 'selected': '' }>${farm.name}</option>
	                            </c:forEach>
	                        </c:if>
	                    </select>
                    </div>
                </div>

				<div class="col-6">
					<label class="text-label"><fmt:message key="sales.postingDate" /> <span class="text-danger">*</span></label>
					<div class="row">
						<div class="col-6">
							<div class="form-group row">
								<label class="col-form-label col-lg-2 text-label">Từ</label>
								<div class="col-lg-10">
									<input type="text" class="form-control rounded-10" placeholder="DD/MM/YYYY" id="startDateStr" name="startDateStr" value="${criteria.startDateStr }" />
								</div>
							</div>
						</div>

						<div class="col-6">
							<div class="form-group row">
								<label class="col-form-label col-lg-2 text-label">đến</label>
								<div class="col-lg-10">
									<input type="text" class="form-control rounded-10" placeholder="DD/MM/YYYY" id="endDateStr" name="endDateStr" value="${criteria.endDateStr }" />
								</div>
							</div>
						</div>
					</div>
				</div>

				<div class="col-md-3 col-sm-3 col-xs-12">
					<div class="form-group">
						<label>Lệnh sản xuất:<span class="text-danger"> *</span></label>
						<select class="form-control" disabled="true" name="processOrderCode[]" multiple="multiple" id="poSelect" data-placeholder="Chọn lệnh..."></select>
					</div>
				</div>
            </div>

        </div>
    </div>
    <!-- /Searching -->

	<div class="row mb-3">
		<div class="col-12 col-md-6">
			<div class="text-color-primary fs-5"><fmt:message key="report.day.detail" /> <span class="text-warning font-weight-bold"><fmt:message key="report.pr.suggest" /></span></div>
		</div>
		<div class="col-12 col-md-6 text-right">
			<a href="/report/day-detail-export-excel" id="exportReportDayDetail" class="btn bgc-warning text-white rounded-10"><i class="icon-database-export pr-2"></i>Xuất báo cáo</a>
		</div>
	</div>
	    
	<!-- \Table -->
	<div class="card">
		<div class="table-responsive table-scroll">
			<table class="table table-bordered table-striped" id="table-report">
				<thead>
					<tr class="table-success">
						<th class="bgc-primary border-primary text-white" style="width: 15px;"><fmt:message key="report.table.th.STT" /></th>
						<th class="bgc-primary border-primary text-white" style="width: 110px;"><fmt:message key="report.table.th.reportDate" /></th>
						<th class="bgc-primary border-primary text-white" style="width: 100px;"><fmt:message key="report.table.th.processOrder" /></th>
						<th class="bgc-primary border-primary text-white"><fmt:message key="processOrder.pigType" /></th>
						<th class="bgc-primary border-primary text-white"><fmt:message key="report.table.th.chuong" /></th>
						<th class="bgc-primary border-primary text-white"><fmt:message key="report.table.createDate" /></th>
						<th class="bgc-primary border-primary text-white"><fmt:message key="report.table.th.title.receiveFarm" /></th>
						<th class="bgc-primary border-primary text-white"><fmt:message key="report.table.th.title.amount.import" /></th>
						<th class="bgc-primary border-primary text-white"><fmt:message key="report.table.th.title.weight.import" /></th>
						<th class="bgc-primary border-primary text-white"><fmt:message key="report.table.th.title.average.import" /></th>
						<th class="bgc-primary border-primary text-white"><fmt:message key="report.table.th.title.amountEarlyStage" /></th>
						<th class="bgc-primary border-primary text-white"><fmt:message key="report.table.th.title.amountGoodsReceipt" /></th>
						<th class="bgc-primary border-primary text-white"><fmt:message key="report.table.th.title.pigDead" /></th>
						<th class="bgc-primary border-primary text-white"><fmt:message key="report.table.th.title.accumulatedDead" /></th>
						<th class="bgc-primary border-primary text-white"><fmt:message key="report.table.th.title.deadRatio" /></th>
						<th class="bgc-primary border-primary text-white"><fmt:message key="report.table.th.title.material.type" /></th>
						<th class="bgc-primary border-primary text-white"><fmt:message key="report.table.th.title.sales" /></th>
						<th class="bgc-primary border-primary text-white"><fmt:message key="report.table.th.title.amountGIDoCode" /></th>
						<th class="bgc-primary border-primary text-white"><fmt:message key="report.table.th.title.amountGIPOCode" /></th>
						<th class="bgc-primary border-primary text-white"><fmt:message key="report.table.th.title.amountFinalStage" /></th>
						<th class="bgc-primary border-primary text-white"><fmt:message key="report.table.th.title.feedinDay" /></th>
						<th class="bgc-primary border-primary text-white"><fmt:message key="report.table.th.title.feedinPig" /></th>
						<th class="bgc-primary border-primary text-white"><fmt:message key="report.table.th.title.feedinPigStandard" /></th>
						<th class="bgc-primary border-primary text-white"><fmt:message key="report.table.th.title.feedinPigStandardDiff" /></th>
					</tr>
				</thead>
				<tbody id="tbodyReportDayDetail">
					<c:if test="${empty reportDayDetails}">
						<tr>
							<td colspan="22" class="text-center text-none-data"><fmt:message key="not.data"/></td>
						</tr>
					</c:if>
					<c:forEach items="${reportDayDetails}" var="item" varStatus="cnt">
						<tr>
							<td style="width: 15px;">${cnt.count }</td>
							<td style="width: 110px;">${item.displayReportDate}</td>
							<td style="width: 110px;">${item.poCode}</td>
							<td>${item.pigType }</td>
							<td>${item.barnCode }</td>
							<td>${item.displayReceiveDate }</td>
							<td>${item.fromStockName }</td>
							<td>${item.importedAmount }</td>
							<td>${item.importedWeight }</td>
							<td>${item.importedAverage }</td>
							<td>${item.sumAmountEarly }</td>
							<td>${item.amountPigEntry }</td>
							<td>${item.sumAmountPigDead }</td>
							<td>${item.accumulatedDead }</td>
							<td>${item.deadRatio }</td>
							<td>${item.sumAmountPigCulling }</td>
							<td>${item.amountSales }</td>
							<td>${item.amountGIDoCode }</td>
							<td>${item.amountGIPOCode }</td>
							<td>${item.sumAmountFinal }</td>
							<td>${item.sumAmountFeed }</td>
							<td>${item.feedInPig }</td>
							<td>${item.feedInPigStandard }</td>
							<td>${item.feedInPigDiff }</td>
						</tr>
					</c:forEach>
				</tbody> 
			</table>
		</div>
	</div>
	<!-- /Table -->
</form:form>
</div>

<script src="<c:url value='/themes/admin/assets/js/select2.js'/>"></script>
<script src="<c:url value='/themes/admin/assets/js/reportDayDetail.js'/>"></script>
