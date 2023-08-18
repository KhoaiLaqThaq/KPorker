<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="menu.report.process.analyst"/></title>
    <meta name="menu" content="reportProcessAnalystPigLevel"/>
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
    
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/tables/datatables/datatables.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/tables/datatables/extensions/fixed_columns.min.js'/>"></script>
    
</head>

<div class="content">
<form:form id="reportFarmAnalystForm" modelAttribute="criteria" action="/report/farm-analyst-pig-level"  method="post">
    <input type="hidden" value="${criteria.pigLevel}" id="pigLevelHidden"/>
    <form:input type="hidden" path="barnCode" id="barnCodeSelected"/>
    
	<!-- \Searching -->
	<div class="card rounded-16">
		<div class="row"><div class="col-12 px-3 py-2 fw-bold"><fmt:message key="label.search" /></div></div>
        <div class="card-body pt-0">
            <div class="row">
                <div class="col-md-3 col-sm-6 col-xs-12">
                    <div class="form-group">
                        <label>Trại:<span class="text-danger"> *</span></label>
                        <select class="form-control select2" name="stockCode" id="stockSelect" data-placeholder="Chọn trại...">
	                        <option></option>
	                        <c:if test="${not empty farms}">
	                            <c:forEach var="farm" items="${farms}">
	                                <option value="${farm.code}" ${farm.code eq criteria.stockCode ? 'selected':'' }>${farm.name}</option>
	                            </c:forEach>
	                        </c:if>
	                    </select>
                    </div>
                </div>
                
                <div class="col-md-3 col-sm-6 col-xs-12">
                    <div class="form-group">
                        <label>Chuồng:<span class="text-danger"> *</span></label>
                        <select class="form-control select2" disabled="true" name="barnCode" id="barnSelect" data-placeholder="Chọn chuồng...">
	                        <option></option>
	                    </select>
                    </div>
                </div>
                
                <div class="col-md-3 col-sm-6 col-xs-12">
                    <div class="form-group">
                        <label>Lứa heo:<span class="text-danger"> *</span></label>
                        <select class="form-control select2" disabled="true" name="pigLevel" id="pigLevelSelect" data-placeholder="Chọn lứa heo">
                            <option></option>
                        </select>
                    </div>
                </div>
                
                <div class="col-md-3 col-sm-6 col-xs-12">
                    <label>Ngày đặt báo cáo:<span class="text-danger"> *</span></label>
                    <div class="input-group">
                        <span class="input-group-prepend">
                            <span class="input-group-text"><i class="icon-calendar22"></i></span>
                        </span>
                        <input type="text" class="form-control daterange-single" id="stage" name="stage" value="${criteria.stage }" readonly="readonly">
                    </div>
                </div>
                
            </div>
            <div class="row">
            	<div class="col-md-12 col-sm-12 col-xs-12 text-right">
                    <button type="submit" id="btnSubmit" class="btn btn-secondary"><i class="icon-search4 mr-2"></i><fmt:message key="button.search"/></button>
                </div>
            </div>
        </div>
    </div>
    <!-- /Searching -->
	    
	<!-- \Table -->
	<div class="card">
		<div class="card-header">
			<span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="menu.report.farmAnalyst"/></span>
			<span class="text-warning font-weight-bold"><fmt:message key="report.pr.suggest" /></span>
		</div>
		<div class="card-body">
            <div class="row">
                <div class="col-md-6 col-xs-12">
                    <fmt:message key="report.farmAnalyst.title.description"/>
                </div>
                <div class="col-md-6 col-xs-12 text-right">
                    <a href="/report/farm-analyst-export-excel" id="exportReportFarmAnalyst" class="btn btn-primary"><i class="icon-database-export pr-2"></i>Xuất báo cáo</a>
                </div>
            </div>
            
            <c:if test="${not empty farmAnalyst}">
	            <c:if test="${not empty errorStatus }">
	               <div class="row">
	                    <div class="alert alert-danger">
	                        ${farmAnalyst.errorStatus } - ${farmAnalyst.errorMessage }
	                    </div>
	                </div>
	            </c:if>
	            <div class="table-responsive md-mt-2 table-scroll">
		            <table class="table table-bordered table-striped wrap" id="table-report" style="width:100%">
		                <thead>
		                    <tr class="table-success">
		                        <th style="width:5%"><fmt:message key="report.table.th.sourceFarm" /></th>
		                        <th style="width:10%" class="text-normal"><c:out value="${farmAnalyst.sourceFarmName }" /></th>
		                        <th style="width:10%"><fmt:message key="report.table.th.title.amount" /></th>
		                        <th style="width:5%" class="text-normal"><c:out value="${farmAnalyst.sumAmount }" /></th>
		                        <th style="width:10%"><fmt:message key="report.table.th.title.tlHeo" /></th>
                                <th style="width:10%" class="text-normal"><c:out value="${farmAnalyst.sumWeight }" /></th>
		                        <th style="width:5%"><fmt:message key="report.table.th.title.average" /></th>
		                        <th style="width:10%" class="text-normal"><c:out value="${farmAnalyst.averageWeight }" /></th>
		                        <th style="width:10%" rowspan="2"><fmt:message key="dailyAverageWeight.avgWeight" /></th>
		                        <th style="width:10%"><fmt:message key="report.table.th.title.entryDate" /></th>
	                            <th style="width:10%" class="text-normal"><c:out value="${farmAnalyst.displayEntryDate }" /></th>
	                            <th style="width:5%" rowspan="2"><fmt:message key="report.table.th.title.currentWeek" /></th>
		                    </tr>
		                    <tr class="table-success">
		                       <th style="width:5%"><fmt:message key="report.table.th.title.feedDay" /></th>
		                       <th style="width:10%"><fmt:message key="report.table.th.title.sumFeed" /></th>
		                       <th style="width:10%"><fmt:message key="report.table.th.title.sumFeedStandard" /></th>
		                       <th style="width:5%"><fmt:message key="report.table.th.title.pigRetained" /></th>
		                       <th style="width:10%"><fmt:message key="report.table.th.title.feedInDay" /></th>
		                       <th style="width:10%"><fmt:message key="report.table.th.title.feedInDayStandard" /></th>
		                       <th style="width:5%"><fmt:message key="report.table.th.title.amountDead" /></th>
		                       <th style="width:10%"><fmt:message key="report.table.th.title.deadRate" /></th>
		                       <th style="width:10%"><fmt:message key="report.table.th.title.weighInPigStandard" /></th>
		                       <th style="width:10%"><fmt:message key="report.table.th.title.entryDate" /></th>
		                    </tr>
		                </thead>
		                <tbody id="tbodyReportFarmAnalyst">
		                  <c:forEach items="${farmAnalyst.subFarmAnalysts }" var="item">
		                      <tr class="${fn:contains(item.weekOfYear, 'T') ? 'active':'' }">
	                              <td style="width:5%" class="text-center">${item.feedDay }</td>
	                              <td style="width:10%" class="text-center">${item.sumAmountFeed }</td>
	                              <td style="width:10%" class="text-center">${item.sumStandardAmountFeed }</td>
	                              <td style="width:5%" class="text-center">${item.pigRetained }</td>
	                              <td style="width:10%" class="text-center">${item.feedInPig }</td>
	                              <td style="width:10%" class="text-center">${item.standardFeedInPig }</td>
	                              <td style="width:5%" class="text-center">${item.amountDead }</td>
	                              <td style="width:10%" class="text-center">${item.deadRate }</td>
	                              <td style="width:10%" class="text-center">${item.avgWeightEstimate }</td>
	                              <td style="width:10%" class="text-center">${item.standardAverageWeightInPig }</td>
	                              <td style="width:10%">${item.displayEntryDate }</td>
	                              <td style="width:5%" class="text-center">${item.weekOfYear }</td>
	                           </tr>
		                  </c:forEach>
		                </tbody> 
		            </table>
		        </div>
	        </c:if>
		</div>
	</div>
	<!-- /Table -->
</form:form>
</div>

<script src="<c:url value='/themes/admin/assets/js/select2.js'/>"></script>
<script src="<c:url value='/themes/admin/assets/js/reportProcessAnalyst-byPigLevel.js'/>"></script>
