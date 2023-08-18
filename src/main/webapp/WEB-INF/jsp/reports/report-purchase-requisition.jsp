<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="report.pr.title"/></title>
    <meta name="menu" content="reportPurchaseRequisitionMenu"/>
	<link href="<c:url value='/themes/admin/assets/css/components.min.css'/>" rel="stylesheet" type="text/css" />
    <link href="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/bootstrap_multiselect.js'/>" rel="stylesheet" type="text/css" />
    <link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">
    <link href="<c:url value='/themes/admin/assets/css/material-support.css'/>" rel="stylesheet" type="text/css">
    
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>
    
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
<form:form id="reportPurchaseRequisitionForm" modelAttribute="criteria" action="/report/purchase-requisition"  method="post">
	<!-- \Searching -->
	<div class="card rounded-16">
		<div class="row"><div class="col-12 px-3 py-2 fw-bold"><fmt:message key="label.search" /></div></div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-4 col-sm-6 col-xs-12">
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

                <div class="col-md-4 col-sm-6 col-xs-12">
                    <div class="form-group">
                        <label>Loại dự trù:<span class="text-danger"> *</span></label>
                        <select class="form-control select2" name="prType" id="prTypeSelect" data-placeholder="Chọn loại dự trù...">
	                        <option></option>
	                        <c:if test="${not empty prTypes}">
	                            <c:forEach var="item" items="${prTypes}">
	                                <option value="${item}" ${item eq criteria.prType ? 'selected':'' }>${item eq 'Z1' ? 'Tuần': 'Tháng'}</option>
	                            </c:forEach>
	                        </c:if>
	                    </select>
                    </div>
                </div>

                <div class="col-md-4 col-sm-6 col-xs-12">
                    <div class="form-group">
                        <label>Nhóm dự trù:<span class="text-danger"> *</span></label>
                        <select class="form-control select2" name="purchasingGroup" id="purchasingGroupSelect" data-placeholder="Chọn nhóm dự trù...">
                            <option></option>
                            <c:if test="${not empty purchasingGroups}">
                                <c:forEach var="item" items="${purchasingGroups}">
                                    <option value="${item}" ${item eq criteria.purchasingGroup ? 'selected':'' }><fmt:message key="report.instock.purchasingGroup.${item}"/></option>
                                </c:forEach>
                            </c:if>
                        </select>
                    </div>
                </div>
            </div>

            <label>Ngày giao hàng:<span class="text-danger"> *</span></label>
            <div class="row">
                <div class="col-md-6 col-sm-6 col-xs-12">
                    <div class="form-group row">
                        <label class="col-form-label col-lg-2 text-label">Từ</label>
                        <div class="col-lg-10">
                            <input type="text" class="form-control rounded-10" placeholder="Chọn ngày từ DD/MM/YYYY" id="deliveryFromDate" name="deliveryFromDate" value="${criteria.deliveryFromDate }" />
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-sm-6 col-xs-12">
                    <div class="form-group row">
                        <label class="col-form-label col-lg-2 text-label">đến</label>
                        <div class="col-lg-10">
                            <input type="text" class="form-control rounded-10" placeholder="Chọn ngày đến DD/MM/YYYY" id="deliveryToDate" name="deliveryToDate" value="${criteria.deliveryToDate }" />
                        </div>
                    </div>
                </div>
            </div>

            <div class="row float-right mr-2">
                <button type="button" id="btnSubmit" class="btn btn-secondary"><i class="icon-search4 mr-2"></i><fmt:message key="button.search"/></button>
            </div>
        </div>
    </div>
    <!-- /Searching -->
	    
	<!-- \Table -->
	<div class="card">
		<div class="card-header">
			<span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="report.pr.title"/></span>
			<span class="text-warning font-weight-bold"><fmt:message key="report.pr.suggest" /></span>
		</div>
		<div class="card-body">
		    <div class="mb-2"><fmt:message key="report.title.description"/></div>
		    <div class="alert alert-danger d-none" id="errorMessage"></div>
			<div class="table-responsive">
				<table class="table table-bordered table-striped" id="tblReportPrWeek"></table>
				<table class="table table-bordered table-striped" id="tblReportPrMonth"></table>
			</div>
		</div>
	</div>
	<!-- /Table -->
</form:form>
</div>

<script src="<c:url value='/themes/admin/assets/js/select2.js'/>"></script>
<script src="<c:url value='/themes/admin/assets/js/reportPurchaseRequisition.js'/>"></script>
