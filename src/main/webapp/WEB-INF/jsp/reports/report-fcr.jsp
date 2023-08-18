<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="menu.report.FCR"/></title>
    <meta name="menu" content="reportFCR"/>
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
<form:form id="reportFCRForm" modelAttribute="criteria" action="/report/fcr"  method="post">
    <input type="hidden" value="${criteria.poCode}" id="poCodeHidden"/>
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
                        <label>Lệnh sản xuất:<span class="text-danger"> *</span></label>
                        <select class="form-control select2" name="poCode" id="poSelect" data-placeholder="Chọn lệnh...">
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
			<span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="menu.report.FCR"/></span>
			<span class="text-warning font-weight-bold"><fmt:message key="report.pr.suggest" /></span>
		</div>
		<div class="card-body">
            <div class="row">
                <div class="col-md-6 col-xs-12">
                    <fmt:message key="report.fcr.title.description"/>
                </div>
                <div class="col-md-6 col-xs-12 text-right">
                    <a href="/report/day-detail-export-excel" id="exportReportFCR" class="btn btn-primary"><i class="icon-database-export pr-2"></i>Xuất báo cáo</a>
                </div>
            </div>
            <div class="table-responsive md-mt-2 table-scroll">
	            <table class="table table-bordered table-striped">
	                <thead>
	                    <tr class="table-success">
	                        <th><fmt:message key="report.table.th.STT" /></th>
	                        <%-- <th><fmt:message key="report.table.th.chuong" /></th> --%>
	                        <th><fmt:message key="report.table.th.processOrder" /></th>
	                        <th><fmt:message key="report.table.th.slEarlyStage" /></th>
	                        <th><fmt:message key="report.table.th.tlEarlyStage" /></th>
	                        <th><fmt:message key="report.table.th.averageEarlyStage" /></th>
	                        <th><fmt:message key="report.table.th.slFinalStage" /></th>
                            <th><fmt:message key="report.table.th.tlFinalStage" /></th>
                            <th><fmt:message key="report.table.th.averageFinalStage" /></th>
	                        <th><fmt:message key="report.table.th.sumAmountFeedUsed" /></th>
	                        <th><fmt:message key="report.table.th.fcr.reality" /></th>
	                        <th><fmt:message key="report.table.th.fcr.standard" /></th>
	                        <th><fmt:message key="report.table.th.fcr.range" /></th>
	                    </tr>
	                </thead>
	                <tbody id="tbodyReportInstock">
	                   <c:if test="${empty fcrLst}">
	                       <tr>
	                           <td colspan="12" class="text-center text-none-data"><fmt:message key="not.data"/></td>
	                       </tr>
	                   </c:if>
	                   <c:forEach items="${fcrLst}" var="rpInstock" varStatus="cnt">
	                       <tr>
	                           <td>${cnt.count }</td>
	                           <td>${rpInstock.poCode }</td>
	                           <td>${rpInstock.amountEarlyPig }</td>
	                           <td>${rpInstock.amountEarlyWeight }</td>
	                           <td>${rpInstock.averageEarly }</td>
	                           <td>${rpInstock.amountFinalPig }</td>
	                           <td>${rpInstock.amountFinalWeight }</td>
	                           <td>${rpInstock.averageFinal }</td>
	                           <td>${rpInstock.sumAmountFeed }</td>
	                           <td>${rpInstock.fcrReality }</td>
	                           <td>${rpInstock.fcrStandard }</td>
	                           <td>${rpInstock.fcrRange }</td>
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
<script src="<c:url value='/themes/admin/assets/js/reportFCR.js'/>"></script>
