<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="report.pr.stockDay.title"/></title>
    <meta name="menu" content="reportStockDay"/>
	<link href="<c:url value='/themes/admin/assets/css/components.min.css'/>" rel="stylesheet" type="text/css" />
    <link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">
    <link href="<c:url value='/themes/admin/assets/css/material-support.css'/>" rel="stylesheet" type="text/css">
    
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/bootstrap_multiselect.js'/>"></script>
</head>

<div class="content">
<form:form id="planForm" modelAttribute="criteria" action="/report/pr/feed"  method="post">
	<!-- \Searching -->
	<div class="card">
		<div class="card-header bg-navbar text-white header-elements-inline">
            <h6 class="card-title text-navbar"><fmt:message key="label.search" /></h6>
        </div>
        <div class="card-body">
            <div class="row">
                <span class="offset-md-1" style="padding-top: 0.5%;">Trại:<span class="text-danger"> *</span></span>
                <div class="col-md-2">
                    <select class="form-control select2" name="stockCode" id="stockSelect" data-placeholder="Chọn trại...">
                        <option></option>
                        <c:if test="${not empty farms}">
                            <c:forEach var="farm" items="${farms}">
                                <option value="${farm.code}" ${farm.code eq criteria.stockCode ? 'selected':'' }>${farm.name}</option>
                            </c:forEach>
                        </c:if>
                    </select>
                </div>
                <span class="offset-md-1" style="padding-top: 0.5%;">Báo cáo tháng:<span class="text-danger"> *</span></span>
                <div class="col-md-2">
                    <select class="col-md-8 form-control select2" name="prType" id="prTypeSelect" data-placeholder="Chọn giai đoạn...">
                        <option></option>
                        <c:if test="${not empty months}">
                            <c:forEach var="item" items="${months}">
                                <option value="${item}" ${item eq criteria.period ? 'selected':'' }><fmt:message key="month.period.${item}" /></option>
                            </c:forEach>
                        </c:if>
                    </select>
                </div>
                <div class="col-md-2">
                    <input type="text" class="form-control year-string" id="year" maxlength="4" placeholder="Nhập năm..." />
                </div>
                
                <div class="col-md-1">
                    <button type="submit" id="btnSearch" class="btn btn-secondary"><i class="icon-search4 mr-2"></i><fmt:message key="button.search"/></button>
                </div>
            </div>
        </div>
    </div>
    <!-- /Searching -->
	    
	<!-- \Table -->
	<div class="card">
		<div class="card-header">
			<span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="report.stockDay.title"/></span>
			<span class="text-warning font-weight-bold"><fmt:message key="report.pr.suggest" /></span>
			<a class="list-icons-item d-none" id="btn_reload" data-action="reload"></a>
		</div>
        		
		<div class="table-responsive table-scroll" id="table__responsive">
			<table class="table table-bordered table-striped">
				<thead>
					<tr class="table-success" id="thTable"></tr>
					<tr class="table-success" id="thTypeTable"></tr>
				</thead>
				<tbody id="tbodyTable">
				</tbody> 
			</table>
		</div>
	</div>
	<!-- /Table -->
</form:form>
</div>

<script src="<c:url value='/themes/admin/assets/js/select2.js'/>"></script>
<script src="<c:url value='/themes/admin/assets/js/reportStockDay.js'/>"></script>
<script src="<c:url value='/themes/admin/global_assets/js/autoNumeric/autoNumeric.js'/>"></script>
<script src="<c:url value='/themes/admin/assets/js/format_number.js'/>"></script>

<script>
    $(document).ready(function(){
    	formatNumberComponent.initAutoNumeric();
    });
</script>
