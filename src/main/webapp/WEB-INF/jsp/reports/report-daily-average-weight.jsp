<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="menu.report.dailyaverageweight"/></title>
    <meta name="menu" content="reportDailyAverageWeight"/>
	<link href="<c:url value='/themes/admin/assets/css/components.min.css'/>" rel="stylesheet" type="text/css" />
    <link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">

    <link href="<c:url value='/themes/admin/assets/css/material-support.css'/>" rel="stylesheet" type="text/css">
    <link href="<c:url value='/themes/admin/assets/css/components.min.css'/>" rel="stylesheet" type="text/css">
    <link href="<c:url value='/themes/admin/assets/css/colors.min.css'/>" rel="stylesheet" type="text/css">
    
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>
    <!-- Multi select -->
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
<form:form id="reportInstockForm" modelAttribute="criteria" action="/report/daily-average-weight"  method="post">
	<!-- \Searching -->
	<input type="hidden" value="${criteria.processOrderCode}" id="poCodeHidden"/>
	<div class="card rounded-16">
		<div class="row"><div class="col-12 px-3 py-2 fw-bold"><fmt:message key="label.search" /></div></div>
        <div class="card-body py-0">
            <div class="row">
                <div class="col-md-3 col-sm-6 col-xs-12">
                    <div class="form-group">
                        <label>Trại:<span class="text-danger"> *</span></label>
                        <select class="form-control select2" id="stockSelect" data-placeholder="Chọn trại...">
	                        <option></option>
	                        <c:if test="${not empty farms}">
	                            <c:forEach var="farm" items="${farms}">
	                                <option value="${farm.code}" ${fn:contains(criteria.barnCode, farm.code) ? 'selected':'' }>${farm.name}</option>
	                            </c:forEach>
	                        </c:if>
	                    </select>
                    </div>
                </div>
                
                <div class="col-md-3 col-sm-6 col-xs-12">
	                <div class="form-group">
	                    <label>Lệnh sản xuất:<span class="text-danger"> *</span></label>
	                    <select class="form-control select2" name="processOrderCode" id="poCodes" data-placeholder="Chọn lệnh...">
                            <option value=""></option>
	                    </select>
	                </div>
                </div>
                
                <div class="col-md-3 col-sm-6 col-xs-12">
                    <label>Ngày đặt báo cáo:<span class="text-danger"> *</span></label>
                    <div class="input-group">
                        <span class="input-group-prepend"><span class="input-group-text"><i class="icon-calendar22"></i></span></span>
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

    <div class="row mb-3">
		<div class="col-12 col-md-6">
			<div class="text-color-primary fs-4"><fmt:message key="report.dailyaverageweight" /><span class="text-warning font-weight-bold"><fmt:message key="report.pr.suggest" /></span></div>
		</div>
		<div class="col-12 col-md-6 text-right">
			<a href="/report/daily-average-weight-export-excel" id="exportReportDailyAverageWeight" class="btn btn-primary"><i class="icon-database-export pr-2"></i>Xuất báo cáo</a>
		</div>
	</div>
	    
	<!-- \Table -->
	<div class="card">
		<div class="card-header">
			<span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="report.dailyaverageweight"/></span>
			<span class="text-warning font-weight-bold"><fmt:message key="report.pr.suggest" /></span>
		</div>
        <div class="row">
            <div class="col-md-6 col-xs-12">
                <fmt:message key="report.dailyaverageweight.title.description"/>
            </div>
            <div class="col-md-6 col-xs-12 text-right">
                <a href="/report/daily-average-weight-export-excel" id="exportReportDailyAverageWeight" class="btn btn-primary"><i class="icon-database-export pr-2"></i>Xuất báo cáo</a>
            </div>
        </div>
        <div class="table-responsive md-mt-2">
            <table class="table table-bordered table-striped">
                <thead>
                    <tr class="table-success">
                        <th class="bgc-primary border-primary text-white">STT</th>
                        <th class="bgc-primary border-primary text-white"><fmt:message key="report.table.th.chuong"></fmt:message></th>
                        <th class="bgc-primary border-primary text-white"><fmt:message key="report.dailyaverageweight.table.th.bieuheo" /></th>
                        <th class="bgc-primary border-primary text-white"><fmt:message key="report.dailyaverageweight.table.th.amount" /></th>
                        <th class="bgc-primary border-primary text-white"><fmt:message key="report.dailyaverageweight.table.th.weigh" /></th>
                    </tr>
                </thead>
                <tbody id="tbodyReportInstock">
                    <c:forEach items="${weightNote.weightCharts}" var="wc" varStatus="cnt">
                        <tr>
                            <td>${cnt.count }</td>
                            <td>${weightNote.barnName}</td>
                            <td>${wc.range }</td>
                            <td>${wc.quantity }</td>
                            <td>${wc.weight }</td>
                        </tr>
                    </c:forEach>
                    <tr>
                        <td colspan="3">Tổng</td>
                        <td>${weightNote.sumQuantity}</td>
                        <td>${weightNote.sumWeight }</td>
                    </tr>
                    <tr>
                        <td colspan="3">Trung bình</td>
                        <td></td>
                        <td>${weightNote.averageWeight }</td>
                    </tr>
                </tbody> 
            </table>
        </div>
	</div>
	<!-- /Table -->
</form:form>
</div>

<script src="<c:url value='/themes/admin/assets/js/select2.js'/>"></script>
<script src="<c:url value='/themes/admin/assets/js/reportDailyAverageWeight.js'/>"></script>
