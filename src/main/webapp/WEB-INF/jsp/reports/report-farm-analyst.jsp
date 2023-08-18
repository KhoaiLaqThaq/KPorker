<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="menu.report.process.analyst"/></title>
    <meta name="menu" content="reportProcessAnalyst"/>
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
    
</head>

<div class="content">
<form:form id="reportFarmAnalystForm" modelAttribute="criteria" action="/report/farm-analyst"  method="post">
    <input type="hidden" value="${criteria.processOrderCode}" id="poCodeHidden"/>
    <form:input type="hidden" path="barnCode" id="barnCodeSelected"/>
    
	<!-- \Searching -->
	<div class="card">
		<div class="card-header bg-navbar text-white header-elements-inline">
            <h6 class="card-title text-navbar"><fmt:message key="label.search" /></h6>
        </div>
        <div class="card-body">
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
                        <label>Lệnh sản xuất:<span class="text-danger"> *</span></label>
                        <select class="form-control select2" disabled="true" name="processOrderCode" id="poSelect" data-placeholder="Chọn lệnh...">
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
		            <table class="table table-bordered table-striped">
		                <thead>
		                    <tr class="table-success">
		                        <th><fmt:message key="report.table.th.sourceFarm" /></th>
		                        <th class="text-normal"><c:out value="${farmAnalyst.sourceFarmName }" /></th>
		                        <th><fmt:message key="report.table.th.title.amount" /></th>
		                        <th class="text-normal"><c:out value="${farmAnalyst.sumAmount }" /></th>
		                        <th><fmt:message key="report.table.th.title.tlHeo" /></th>
                                <th class="text-normal"><c:out value="${farmAnalyst.sumWeight }" /></th>
		                        <th><fmt:message key="report.table.th.title.average" /></th>
		                        <th class="text-normal"><c:out value="${farmAnalyst.averageWeight }" /></th>
		                        <th rowspan="2"><fmt:message key="dailyAverageWeight.avgWeight" /></th>
		                        <th><fmt:message key="report.table.th.title.entryDate" /></th>
	                            <th class="text-normal"><c:out value="${farmAnalyst.entryDate }" /></th>
	                            <th rowspan="2"><fmt:message key="report.table.th.title.currentWeek" /></th>
		                    </tr>
		                    <tr class="table-success">
		                       <th><fmt:message key="report.table.th.title.feedDay" /></th>
		                       <th><fmt:message key="report.table.th.title.sumFeed" /></th>
		                       <th><fmt:message key="report.table.th.title.sumFeedStandard" /></th>
		                       <th><fmt:message key="report.table.th.title.pigRetained" /></th>
		                       <th><fmt:message key="report.table.th.title.feedInDay" /></th>
		                       <th><fmt:message key="report.table.th.title.feedInDayStandard" /></th>
		                       <th><fmt:message key="report.table.th.title.amountDead" /></th>
		                       <th><fmt:message key="report.table.th.title.deadRate" /></th>
		                       <th><fmt:message key="report.table.th.title.weighInPigStandard" /></th>
		                       <th><fmt:message key="report.table.th.title.entryDate" /></th>
		                    </tr>
		                </thead>
		                <tbody id="tbodyReportFarmAnalyst">
		                  <c:forEach items="${farmAnalyst.subFarmAnalysts }" var="item">
		                      <tr class="${fn:contains(item.weekOfYear, 'T') ? 'active':'' }">
	                              <td class="text-center">${item.feedDay }</td>
	                              <td class="text-center">${item.sumAmountFeed }</td>
	                              <td class="text-center">${item.sumStandardAmountFeed }</td>
	                              <td class="text-center">${item.pigRetained }</td>
	                              <td class="text-center">${item.feedInPig }</td>
	                              <td class="text-center">${item.standardFeedInPig }</td>
	                              <td class="text-center">${item.amountDead }</td>
	                              <td class="text-center">${item.deadRate }</td>
	                              <td class="text-center">${item.avgWeightEstimate }</td>
	                              <td class="text-center">${item.standardAverageWeightInPig }</td>
	                              <td>${item.entryDate }</td>
	                              <td class="text-center">${item.weekOfYear }</td>
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
<script src="<c:url value='/themes/admin/assets/js/reportProcessAnalyst.js'/>"></script>
