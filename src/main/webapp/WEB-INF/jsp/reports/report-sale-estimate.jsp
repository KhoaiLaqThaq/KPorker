<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>  

<head>
    <title><fmt:message key="menu.report.saleEstimate"/></title>
    <meta name="menu" content="reportSaleResult"/>
	<link href="<c:url value='/themes/admin/assets/css/components.min.css'/>" rel="stylesheet" type="text/css" />
    <link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">

    <link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">
    <link href="<c:url value='/themes/admin/assets/css/material-support.css'/>" rel="stylesheet" type="text/css">
    <link href="<c:url value='/themes/admin/assets/css/components.min.css'/>" rel="stylesheet" type="text/css">
    <link href="<c:url value='/themes/admin/assets/css/colors.min.css'/>" rel="stylesheet" type="text/css">
    
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/tables/datatables/datatables.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/tables/datatables/extensions/fixed_columns.min.js'/>"></script>
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
    
</head>

<div class="content">
<form:form id="reportForm" modelAttribute="criteria" action="/report/sale-estimate"  method="post">
	
	<!-- \Searching -->
	<div class="card rounded-16">
		<div class="row">
			<div class="col-6 px-3 py-2 fw-bold"><fmt:message key="label.search" /></div>
			<div class="col-6 text-right">
				<button type="button" class="btn btn-secondary mt-2 mr-2" id="btnReset">Đặt lại</button>
				<button type="button" id="btnSubmit" class="btn btn-secondary mt-2 mr-2"><i class="icon-search4 mr-2"></i><fmt:message key="button.search"/></button>
			</div>
		</div>
        <div class="card-body py-0">
            <div class="row">
                <div class="col-md-3 col-xs-12">
                    <div class="form-group">
                        <label>Trại:<span class="text-danger"> *</span></label>
                        <select class="form-control" name="farmCodes[]" multiple="multiple" id="stockSelect" data-placeholder="Chọn trại...">
	                        
	                        <c:if test="${not empty farms}">
	                            <c:forEach var="farm" items="${farms}">
	                            	<option value="${farm.code}" ${fn:contains(criteria.farmCodesStr , farm.code) ? 'selected' : ''}>${farm.name}</option>
	                            	
	                            </c:forEach>
	                        </c:if>
	                    </select>
                    </div>
                </div>
				<div class="col-md-9 col-12">
					<label class="text-label">Giai đoạn:<span class="text-danger"> *</span></label>
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
        </div>
    </div>
    <!-- /Searching -->

	<div class="row mb-3">
        <div class="col-12 col-md-6">
            <div class="text-color-primary fs-5"><fmt:message key="menu.report.saleEstimate" /><span class="text-warning font-weight-bold"><fmt:message key="report.pr.suggest" /></span></div>
        </div>
        <div class="col-12 col-md-6 text-right">
            <a href="/report/prod-result-export-excel" id="exportReportInstock"class="btn bgc-warning text-white"><i class="icon-database-export pr-2"></i>Xuất báo cáo</a>
        </div>
    </div>
	    
	<!-- \Table -->
	<div class="card">
		<div class="table-responsive">
			<table class="table table-bordered table-striped" id="table-report">
				<thead>
					<tr class="table-success">
						<th  class="bgc-primary border-primary text-white text-center">STT</th>
						<th class="bgc-primary border-primary text-white text-center"><fmt:message key="processOrder.code" /></th>
						<th class="bgc-primary border-primary text-white text-center"><fmt:message key="barn.farmCode" /></th>
						<th class="bgc-primary border-primary text-white text-center"><fmt:message key="processOrder.barn.code" /></th>
						<th class="bgc-primary border-primary text-white text-center"><fmt:message key="report.table.th.totalSale" /></th>
						<th class="bgc-primary border-primary text-white text-center"><fmt:message key="report.table.th.chart.greater130" /></th>
						<th class="bgc-primary border-primary text-white text-center"><fmt:message key="report.table.th.chart.greater120" /></th>
						<th class="bgc-primary border-primary text-white text-center"><fmt:message key="report.table.th.chart.greater110" /></th>
						<th class="bgc-primary border-primary text-white text-center"><fmt:message key="report.table.th.chart.greater100" /></th>
						<th class="bgc-primary border-primary text-white text-center"><fmt:message key="report.table.th.chart.greater90" /></th>
						<th class="bgc-primary border-primary text-white text-center"><fmt:message key="report.table.th.chart.greater80" /></th>
						<th class="bgc-primary border-primary text-white text-center"><fmt:message key="report.table.th.chart.greater70" /></th>
						<th class="bgc-primary border-primary text-white text-center"><fmt:message key="report.table.th.chart.less70" /></th>
						<th class="bgc-primary border-primary text-white text-center"><fmt:message key="report.table.th.chart.issue" /></th>
						<th class="bgc-primary border-primary text-white text-center"><fmt:message key="report.table.th.avgVolumnEstimate" /></th>
						<th class="bgc-primary border-primary text-white text-center"><fmt:message key="report.table.th.greater100Ratio" /></th>
						<th class="bgc-primary border-primary text-white text-center"><fmt:message key="barnPlan.pigType" /></th>
						
					</tr>
				</thead>
				<tbody id="tbodyReportInstock">
					<c:if test="${empty reports}">
						<tr>
							<td colspan="17" class="text-center text-none-data"><fmt:message key="not.data"/></td>
						</tr>
					</c:if>
					<c:forEach items="${reports}" var="rp" varStatus="cnt">
						<tr>
							<td class="text-center"></td>
							<td class="text-center">${rp.processOrderCode }</td>
							<td class="text-center">${rp.farmCode }</td>
							<td class="text-center">${rp.barnCode }</td>
							
							<td class="text-center">${rp.totalSale }</td>
							<td class="text-center">${rp.greater130 }</td>
							<td class="text-center">${rp.greater120 }</td>
							<td class="text-center">${rp.greater110 }</td>
							<td class="text-center">${rp.greater100 }</td>
							<td class="text-center">${rp.greater90 }</td>
							<td class="text-center">${rp.greater80 }</td>
							<td class="text-center">${rp.greater70 }</td>
							<td class="text-center">${rp.less70 }</td>
							<td class="text-center">${rp.issue }</td>
							<td class="text-center">${rp.avgWeight }</td>
							<td class="text-center">${rp.greater100Ratio }</td>
							<td class="text-center">${rp.pigType }</td>
							
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
<script src="<c:url value='/themes/admin/assets/js/report-sale-estimate.js'/>"></script>
