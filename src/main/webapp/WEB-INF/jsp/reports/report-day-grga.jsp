<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="menu.report.day.GRGA"/></title>
    <meta name="menu" content="reportDayGRGA"/>
	<link href="<c:url value='/themes/admin/assets/css/components.min.css'/>" rel="stylesheet" type="text/css" />
    <link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">

    <link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">
    <link href="<c:url value='/themes/admin/assets/css/material-support.css'/>" rel="stylesheet" type="text/css">
    <link href="<c:url value='/themes/admin/assets/css/components.min.css'/>" rel="stylesheet" type="text/css">
    <link href="<c:url value='/themes/admin/assets/css/colors.min.css'/>" rel="stylesheet" type="text/css">
    
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>
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
    
    <!-- Data Table -->
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/tables/datatables/datatables.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/tables/datatables/extensions/fixed_columns.min.js'/>"></script>
    
</head>

<div class="content">
<form:form id="reportInstockForm" modelAttribute="criteria" action="/report/day-grga"  method="post">
	<!-- \Searching -->
	<div class="card rounded-16">
		<div class="row"><div class="col-12 px-3 py-2 fw-bold"><fmt:message key="label.search" /></div></div>
        <div class="card-body pt-0">
            <div class="row">
                <div class="col-md-3 col-sm-6 col-xs-12">
                    <div class="form-group">
                        <label>Trại:<span class="text-danger"> *</span></label>
                        <select class="form-control select2" name="farmCode" id="stockSelect" data-placeholder="Chọn trại...">
	                        <option></option>
	                        <c:if test="${not empty farms}">
	                            <c:forEach var="farm" items="${farms}">
	                                <option value="${farm.code}" ${farm.code eq criteria.farmCode ? 'selected':'' }>${farm.name}</option>
	                            </c:forEach>
	                        </c:if>
	                    </select>
                    </div>
                </div>
                
                <div class="col-md-2 col-sm-6 col-xs-12">
	                <div class="form-group">
	                    <label>Nhóm vật tư:<span class="text-danger"> *</span></label>
	                    <select class="form-control multiselect-select-all" multiple="multiple" name=purchaseGroups id="purchasingGroupCode" data-placeholder="Chọn nhóm vật tư">
	                        <c:if test="${not empty purchasingGroupCodes}">
	                            <c:forEach var="item" items="${purchasingGroupCodes}">
	                                <option value="${item}" ${fn:contains(criteria.purchasingGroupsStr, item) ? 'selected':''}><fmt:message key="report.instock.purchasingGroup.${item}"/></option>
	                            </c:forEach>
	                        </c:if>
	                    </select>
	                </div>
                </div>
				<div class="offset-md-1 col-md-5 col-sm-6 col-xs-12">
					<label>Giai đoạn:<span class="text-danger"> *</span></label>
					<div class="row">
						<div class="col-md-6">
							<div class="form-group row">
								<label class="col-form-label col-lg-2 text-label">Từ</label>
								<div class="col-lg-10">
									<input type="text" class="form-control rounded-10" placeholder="DD/MM/YYYY" id="fromDate" name="fromDate" value="${criteria.fromDate }" autocomplete="off" />
								</div>
							</div>
						</div>
						<div class="col-md-6">
							<div class="form-group row">
								<label class="col-form-label col-lg-2 text-label">đến</label>
								<div class="col-lg-10">
									<input type="text" class="form-control rounded-10" placeholder="DD/MM/YYYY" id="toDate" name="toDate" value="${criteria.toDate }" autocomplete="off" />
								</div>
							</div>
						</div>
					</div>
				</div>
            </div>
			<div class="row">
				<div class="col-12 text-right">
                    <button type="button" id="btnSubmit" class="btn btn-secondary"><i class="icon-search4 mr-2"></i><fmt:message key="button.search"/></button>
                </div>
			</div>
        </div>
    </div>
    <!-- /Searching -->

	<div class="row mb-3">
        <div class="col-12 col-md-6">
            <div class="text-color-primary fs-5"><fmt:message key="menu.report.day.GRGA" /><span class="text-warning font-weight-bold"><fmt:message key="report.pr.suggest" /></span></div>
        </div>
        <div class="col-12 col-md-6 text-right">
            <a href="/report/instock-export-excel" id="exportReportInstock" class="btn bgc-warning text-white"><i class="icon-database-export pr-2"></i>Xuất báo cáo</a>
        </div>
    </div>
	    
	<!-- \Table -->
	<div class="card">
		<div class="table-responsive">
			<table class="table table-bordered table-striped" id="table-report">
				<c:choose>
					<c:when test="${empty reportDayDetails}">
						<thead>
							<tr class="table-success">
								<th class="bgc-primary text-white text-center mw-50" rowspan="2">TT</th>
								<th class="bgc-primary text-white text-center mw-200" rowspan="2"><fmt:message key="material.code" /></th>
								<th class="bgc-primary text-white text-center mw-300" rowspan="2"><fmt:message key="material.name" /></th>
								<th class="bgc-primary text-white text-center mw-100" rowspan="2"><fmt:message key="material.dvt" /></th>
								<th class="bgc-primary text-white text-center" rowspan="2"><fmt:message key="material.amountEarlyStage" /></th>
								<th class="bgc-primary text-white text-center" colspan="3"><fmt:message key="report.table.th.dateExample" /></th>
								<th class="bgc-primary text-white text-center" colspan="3"><fmt:message key="report.table.th.total" /></th>
							</tr>
							<tr class="table-success">
								<th class="bgc-primary text-white text-center"><fmt:message key="report.table.th.title.amountGoodsReceipt" /></th>
								<th class="bgc-primary text-white text-center"><fmt:message key="report.table.th.title.amountGoodsIssue" /></th>
								<th class="bgc-primary text-white text-center"><fmt:message key="report.table.th.title.amountGoodsReceiptEstimate" /></th>
								<th class="bgc-primary text-white text-center"><fmt:message key="report.table.th.title.total.amountGoodsReceipt" /></th>
								<th class="bgc-primary text-white text-center"><fmt:message key="report.table.th.title.total.amountGoodsIssue" /></th>
								<th class="bgc-primary text-white text-center"><fmt:message key="report.table.th.title.amountFinalStage" /></th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td colspan="11" class="text-center text-none-data"><fmt:message key="not.data"/></td>
							</tr>
						</tbody> 
					</c:when>
					<c:otherwise>
						<thead>
							<tr class="table-success">
								<th class="bgc-primary text-white text-center mw-50" rowspan="2">TT</th>
								<th class="bgc-primary text-white text-center mw-200" rowspan="2"><fmt:message key="material.code" /></th>
								<th class="bgc-primary text-white text-center mw-200" rowspan="2"><fmt:message key="material.name" /></th>
								<th class="bgc-primary text-white text-center mw-100" rowspan="2"><fmt:message key="material.dvt" /></th>
								<th class="bgc-primary text-white text-center" rowspan="2"><fmt:message key="material.amountEarlyStage" /></th>
								
								<c:forEach items="${daysDisplay}" var="date" varStatus="cnt">
									<th class="bgc-primary text-white text-center" colspan="3">${date}</th>
								</c:forEach>
								
								<th class="bgc-primary text-white text-center" colspan="3"><fmt:message key="report.table.th.total" /></th>
							</tr>
							<tr class="table-success">
								<c:forEach items="${daysDisplay}" var="date" varStatus="cnt">
									<th class="bgc-primary text-white text-center"><fmt:message key="report.table.th.title.amountGoodsReceipt" /></th>
									<th class="bgc-primary text-white text-center"><fmt:message key="report.table.th.title.amountGoodsIssue" /></th>
									<th class="bgc-primary text-white text-center"><fmt:message key="report.table.th.title.amountGoodsReceiptEstimate" /></th>
								</c:forEach>
								<th class="bgc-primary text-white text-center"><fmt:message key="report.table.th.title.total.amountGoodsReceipt" /></th>
								<th class="bgc-primary text-white text-center"><fmt:message key="report.table.th.title.total.amountGoodsIssue" /></th>
								<th class="bgc-primary text-white text-center"><fmt:message key="report.table.th.title.amountFinalStage" /></th>
							</tr>
						</thead>
						<tbody id="tbodyReportDay">
							<c:forEach items="${reportDayDetails}" var="report" varStatus="cnt">
								<tr>
									<td class="text-center mw-50">${cnt.count }</td>
									<td class="text-center mw-200">${report.materialCode }</td>
									<td class="text-center mw-200">${report.materialName }</td>
									<td class="text-center mw-100">${report.materialUnit }</td>
									<td class="text-center">${report.earlyQuantity }</td>
									
									<c:forEach items="${report.listDdays}" var="dayDetail">
										<td class="text-center">${dayDetail.receiptQuantity }</td>
										<td class="text-center">${dayDetail.issueQuantity }</td>
										<td class="text-center">${dayDetail.receiptEstimate }</td>
									</c:forEach>
									
									<td class="text-center">${report.totalReceiptQuantity }</td>
									<td class="text-center">${report.totalIssueQuantity }</td>
									<td class="text-center">${report.finalQuantity }</td>
								</tr>
							</c:forEach>
						</tbody> 
					</c:otherwise>
				</c:choose>
			</table>
		</div>
	</div>
	<!-- /Table -->
</form:form>
</div>

<script src="<c:url value='/themes/admin/assets/js/select2.js'/>"></script>
<%-- <script src="<c:url value='/themes/admin/assets/js/reportPurchaseRequisition.js'/>"></script> --%>
<script src="<c:url value='/themes/admin/assets/js/report_day_grga.js'/>"></script>
