<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="menu.report.death.rate"/></title>
    <meta name="menu" content="reportPercentDead"/>
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
<form:form id="reportDeadRateForm" modelAttribute="criteria" action="/report/deadRate"  method="post">
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
                    <label>Ngày đặt báo cáo:<span class="text-danger"> *</span></label>
                    <div class="input-group">
                        <span class="input-group-prepend">
                            <span class="input-group-text"><i class="icon-calendar22"></i></span>
                        </span>
                        <input type="text" class="form-control daterange-single" id="stage" name="stage" value="${criteria.stage }" readonly="readonly">
                    </div>
                </div>
                
                <div class="md-mt-2 col-md-3 col-sm-6 col-xs-12">
                    <button type="submit" id="btnSubmit" class="btn btn-secondary"><i class="icon-search4 mr-2"></i><fmt:message key="button.search"/></button>
                </div>
            </div>
        </div>
    </div>
    <!-- /Searching -->
	    
	<!-- \Table -->
	<div class="card">
		<div class="card-header">
			<span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="menu.report.death.rate"/></span>
			<span class="text-warning font-weight-bold"><fmt:message key="report.pr.suggest" /></span>
		</div>
		<div class="card-body">
            <div class="row">
                <div class="col-md-6 col-xs-12">
                    <fmt:message key="report.deadRate.title.description"/>
                </div>
                <div class="col-md-6 col-xs-12 text-right">
                    <a href="/report/deadRate-export-excel" id="exportReportDeadRate" class="btn btn-primary"><i class="icon-database-export pr-2"></i>Xuất báo cáo</a>
                </div>
            </div>
            <div class="table-responsive md-mt-2 table-scroll">
	            <table class="table table-bordered table-striped">
	                <thead>
	                    <tr class="table-success">
	                        <th><fmt:message key="report.table.th.STT" /></th>
	                        <th><fmt:message key="report.table.th.processOrder" /></th>
	                        <th><fmt:message key="report.table.th.chuong" /></th>
	                        <th class="text-center"><fmt:message key="report.table.th.slNhap" /></th>
	                        <th class="text-center"><fmt:message key="report.table.th.slChet" /></th>
	                        <th class="text-center"><fmt:message key="report.table.th.tlChet" /> (%)</th>
	                    </tr>
	                </thead>
	                <tbody id="tbodyReportDeadRate">
	                   <c:if test="${empty result}">
	                       <tr>
	                           <td colspan="6" class="text-center text-none-data"><fmt:message key="not.data"/></td>
	                       </tr>
	                   </c:if>
	                   <c:forEach items="${result.results}" var="item" varStatus="cnt">
	                       <tr>
	                           <td>${cnt.count }</td>
	                           <td>${item.processOrderCode }</td>
	                           <td>${item.barnName }</td>
	                           <td class="text-center">${item.totalPig }</td>
	                           <td class="text-center">${item.totalPigDead }</td>
	                           <td class="text-center">${item.rate }</td>
	                       </tr>
	                   </c:forEach>
	                </tbody> 
	            </table>
	        </div>
		</div>
	</div>
	<!-- /Table -->
</form:form>
</div>

<script src="<c:url value='/themes/admin/assets/js/select2.js'/>"></script>
<script src="<c:url value='/themes/admin/assets/js/reportDeadRate.js'/>"></script>
