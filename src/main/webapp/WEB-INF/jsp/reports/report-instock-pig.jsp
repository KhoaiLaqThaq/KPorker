<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>  

<head>
    <title><fmt:message key="menu.report.instock.pig"/></title>
    <meta name="menu" content="reportInstockPig"/>
	<link href="<c:url value='/themes/admin/assets/css/components.min.css'/>" rel="stylesheet" type="text/css" />
    <link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">

    <link href="<c:url value='/themes/admin/assets/css/material-support.css'/>" rel="stylesheet" type="text/css">
    <link href="<c:url value='/themes/admin/assets/css/colors.min.css'/>" rel="stylesheet" type="text/css">
    
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
    <script src="<c:url value="/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js"/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/tables/datatables/datatables.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/tables/datatables/extensions/fixed_columns.min.js'/>"></script>
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
<form:form id="reportInstockForm" modelAttribute="criteria" action="/report/instock-pig"  method="post">
	<input type="hidden" id="barnCodeStrSelected" value="${criteria.barnCodeStr}"/>
	
	<input type="hidden" id="totalEarlyStage" value="${reportInstocks.totalAmountEarlyStage}"/>
	<input type="hidden" id="totalEntry" value="${reportInstocks.totalAmountEntry}"/>
	<input type="hidden" id="totalDead" value="${reportInstocks.totalAmountDead}"/>
	<input type="hidden" id="totalCulling" value="${reportInstocks.totalAmountCulling}"/>
	<input type="hidden" id="totalSell" value="${reportInstocks.totalAmountSell}"/>
	<input type="hidden" id="totalIssue" value="${reportInstocks.totalAmountIssue}"/>
	<input type="hidden" id="totalIssueFarm" value="${reportInstocks.totalAmountIssueInFarm}"/>
	<input type="hidden" id="totalFinalStage" value="${reportInstocks.totalAmountFinalStage}"/>
	
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
                <div class="col-md-3 col-sm-6 col-xs-12">
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
				<div class="col-md-3 col-sm-6 col-xs-12">
					<div class="form-group">
						<label>Chuồng:<span class="text-danger"> *</span></label>
						<select class="form-control" name="barnCodes[]" multiple="multiple" id="barnSelect" data-placeholder="Chọn chuồng..."></select>
					</div>
				</div>

				<div class="col-12 col-sm-6 col-md-5 offset-md-1">
					<label class="text-label">Giai đoạn:<span class="text-danger"> *</span></label>
					<div class="row">
						<div class="col-md-6">
							<div class="form-group row">
								<span class="flex-center-vertical">Từ</span>
								<div class="col-lg-10">
									<input type="text" class="form-control rounded-10" placeholder="DD/MM/YYYY" id="fromDate" name="fromDate" value="${criteria.fromDate }" autocomplete="off" />
								</div>
							</div>
						</div>
						<div class="col-md-6">
							<div class="form-group row">
								<span class="flex-center-vertical">đến</span>
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
            <div class="text-color-primary fs-5"><fmt:message key="report.instock" /><span class="text-warning font-weight-bold"><fmt:message key="report.pr.suggest" /></span></div>
        </div>
        <div class="col-12 col-md-6 text-right">
            <a href="/report/instock-pig-export-excel" id="exportReportInstock" class="btn bgc-warning text-white"><i class="icon-database-export pr-2"></i>Xuất báo cáo</a>
        </div>
    </div>
	    
	<!-- \Table -->
	<div class="card">
		<div class="table-responsive">
			<table class="table table-bordered table-striped" id="table-report">
				<thead>
					<tr class="table-success" id="tableHead">
						<th class="bgc-primary border-primary text-white">STT</th>
						<th class="bgc-primary border-primary text-white"><fmt:message key="processOrder.code" /></th>
						<th class="bgc-primary border-primary text-white"><fmt:message key="processOrder.pigType" /></th>
						<th class="bgc-primary border-primary text-white"><fmt:message key="processOrder.barn.code" /></th>
						<th class="bgc-primary border-primary text-white"><fmt:message key="instock.farmName" /></th>
						<th class="bgc-primary border-primary text-white text-wrap"><fmt:message key="report.table.th.slEarlyStage" /></th>
						<th class="bgc-primary border-primary text-white text-wrap"><fmt:message key="report.table.th.slNhap" /></th>
						<th class="bgc-primary border-primary text-white text-wrap"><fmt:message key="report.table.th.slChet" /></th>
						<th class="bgc-primary border-primary text-white text-wrap"><fmt:message key="report.table.th.slLoai" /></th>
						<th class="bgc-primary border-primary text-white text-wrap"><fmt:message key="report.table.th.slBan" /></th>
						<th class="bgc-primary border-primary text-white text-wrap"><fmt:message key="report.table.th.slDieuChuyen" /></th>
						<th class="bgc-primary border-primary text-white text-wrap"><fmt:message key="report.table.th.slChuyenLenh" /></th>
						<th class="bgc-primary border-primary text-white text-wrap"><fmt:message key="report.table.th.slFinalStage" /></th>
					</tr>
				</thead>
				<tbody id="tbodyReportInstock">
					<c:if test="${empty reportInstocks.listItem}">
						<tr>
							<td colspan="13" class="text-center text-none-data"><fmt:message key="not.data"/></td>
						</tr>
					</c:if>
					<c:forEach items="${reportInstocks.listItem}" var="rpInstock" varStatus="cnt">
						<tr>
							<td class="text-center"></td>
							<td class="text-center">${rpInstock.processOrderCode }</td>
                            <td class="text-center">${rpInstock.pigType }</td>
							<td class="text-center">${rpInstock.barnCode }</td>
							<td class="text-center">${rpInstock.farmName }</td>
							<td class="text-center">${rpInstock.amountEarlyStage }</td>
							<td class="text-center">${rpInstock.amountEntry }</td>
							<td class="text-center">${rpInstock.amountDead }</td>
							<td class="text-center">${rpInstock.amountCulling }</td>
							<td class="text-center">${rpInstock.amountSell }</td>
							<td class="text-center">${rpInstock.amountIssue }</td>
							<td class="text-center">${rpInstock.amountIssueInFarm }</td>
							<td class="text-center">${rpInstock.amountFinalStage }</td>
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
<script src="<c:url value='/themes/admin/assets/js/report-instock-pig.js'/>"></script>
