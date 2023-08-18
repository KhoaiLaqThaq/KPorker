<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="menu.report.invest"/></title>
    <meta name="menu" content="reportDataInvest"/>
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
<form:form id="reportDataInvesetForm" modelAttribute="criteria" action="/report/data-invest"  method="post">
	<!-- \Searching -->
	<div class="card rounded-16">
		<div class="row">
            <div class="col-6 px-3 py-2 fw-bold"><fmt:message key="label.search" /></div>
        </div>
        <div class="card-body py-0">
            <div class="row">
                <div class="col-md-4 col-sm-6 col-xs-12">
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
                
                <div class="col-md-4 col-sm-6 col-xs-12">
                    <label>Ngày:<span class="text-danger"> *</span></label>
                    <div class="input-group">
                        <span class="input-group-prepend">
                            <span class="input-group-text"><i class="icon-calendar22"></i></span>
                        </span>
                        <input type="text" class="form-control" autocomplete="off" id="stage" name="stage" value="${criteria.stage}" readonly="readonly"> 
                    </div>
                </div>
                <div class="col-12 col-md-4 text-right mt-3">
                    <button type="submit" id="btnSubmit" class="btn btn-secondary mt-2 mr-2"><i class="icon-search4 mr-2"></i><fmt:message key="button.search"/></button>
                </div>
            </div>
        </div>
    </div>
    <!-- /Searching -->

    <div class="row mb-3">
        <div class="col-12 col-md-6">
            <div class="text-color-primary fs-5"><fmt:message key="menu.report.invest" /><span class="text-warning font-weight-bold"><fmt:message key="report.pr.suggest" /></span></div>
        </div>
        <div class="col-12 col-md-6 text-right">
            <a href="/report/data-invest-export-excel" id="exportReportInvest" class="btn bgc-warning text-white"><i class="icon-database-export pr-2"></i>Xuất báo cáo</a>
        </div>
    </div>
	    
	<!-- \Table -->
	<div class="card">
        <div class="table-responsive">
            <table class="table table-bordered table-striped">
                <thead>
                    <tr class="table-success">
                        <th class="bgc-primary border-primary text-white text-center">STT</th>
                        <th class="bgc-primary border-primary text-white text-center"><fmt:message key="processOrder.code" /></th>
                        <th class="bgc-primary border-primary text-white text-center"><fmt:message key="barn.farmCode" /></th>
                        <th class="bgc-primary border-primary text-white text-center"><fmt:message key="processOrder.barn.code" /></th>
                        <th class="bgc-primary border-primary text-white text-center"><fmt:message key="processOrder.startDate" /></th>
                        <th class="bgc-primary border-primary text-white text-center"><fmt:message key="processOrder.nearest.goods_attrition" /></th>
                        <th class="bgc-primary border-primary text-white text-center"><fmt:message key="enter.label.evaluateAmount" /></th>
                        <th class="bgc-primary border-primary text-white text-center"><fmt:message key="processOrder.nearest.WeightNote" /></th>
                        <th class="bgc-primary border-primary text-white text-center">Lệnh Trước</th>
                        <th class="bgc-primary border-primary text-white text-center">Lứa Heo</th>
                        
                    </tr>
                </thead>
                <tbody id="tbodyReportInstock">
                    <c:if test="${empty reportInvest}">
                        <tr>
                            <td colspan="9" class="text-center text-none-data"><fmt:message key="not.data"/></td>
                        </tr>
                    </c:if>
                    <c:forEach items="${reportInvest}" var="data" varStatus="cnt">
                        <tr>
                            <td class="text-center">${cnt.count }</td>
                            <td class="text-center">${data.processOrderCode }</td>
                            <td class="text-center">${data.farmName }</td>
                            <td class="text-center">${data.barnName }</td>
                            <td class="text-center">${data.displayStartDate }</td>
                            <td class="text-center">${data.displayNearestGA }</td>
                            <td class="text-center">${data.evaluteAmount }</td>
                            <td class="text-center">${data.displayNearesrWeightNote }</td>
                            <td class="text-center">${data.earlyProcessOrder }</td>
                            <td class="text-center">${data.pigLevel}</td>
                            
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
<script src="<c:url value='/themes/admin/assets/js/reportDataInvest.js'/>"></script>
