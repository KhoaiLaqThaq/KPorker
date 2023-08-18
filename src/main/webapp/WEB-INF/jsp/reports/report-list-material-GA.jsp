<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="menu.report.ListMaterialGA"/></title>
    <meta name="menu" content="handleListMaterialGA"/>
	<link href="<c:url value='/themes/admin/assets/css/components.min.css'/>" rel="stylesheet" type="text/css" />
    <link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">
    <link href="<c:url value='/themes/admin/assets/css/material-support.css'/>" rel="stylesheet" type="text/css">
    <link href="<c:url value='/themes/admin/assets/css/colors.min.css'/>" rel="stylesheet" type="text/css">

    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
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
<form:form id="reportListMaterialGAForm" modelAttribute="criteria" action="/report/listMaterialGA"  method="post">
    <input type="hidden" value="${criteria.poCode}" id="poCodeHidden"/>
    <input type="hidden" id="barnCodeStrSelected" value="${criteria.barnCodeStr}"/>
	<!-- \Searching -->
	<div class="card rounded-16">
		<div class="row">
            <div class="col-6 px-3 py-2 fw-bold"><fmt:message key="label.search" /></div>
            <div class="col-6 text-right">
                <button type="submit" id="btnSubmit" class="btn btn-secondary mt-2 mr-2"><i class="icon-search4 mr-2"></i><fmt:message key="button.search"/></button>
            </div>
        </div>
        <div class="card-body py-0">
            <div class="row">
                <div class="col-8">
                    <div class="row">
                        <div class="col-3">
                            <div class="form-group">
                                <label class="text-label">Trại:<span class="text-danger"> *</span></label>
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
                        <div class="col-3">
                            <div class="form-group barn-select2">
                                <label>Chuồng:<span class="text-danger"> *</span></label>
                                <select class="form-control" name="barnCodes[]" multiple="multiple" id="barnSelect" data-placeholder="Chọn chuồng...">
                                    <option></option>
                                </select>
                            </div>
                        </div>
                        <div class="col-3">
                            <div class="form-group">
                                <label class="text-label">Nhóm vật tư:<span class="text-danger"> *</span></label>
                                <select class="form-control multiselect-select-all" multiple="multiple" name="purchasingGroups" id="purchasingGroupCode" data-placeholder="Chọn nhóm vật tư">
                                    <c:if test="${not empty purchasingGroupCodes}">
                                        <c:forEach var="item" items="${purchasingGroupCodes}">
                                            <option value="${item}" ${fn:contains(criteria.purchasingGroups, item) ? 'selected':''}><fmt:message key="report.instock.purchasingGroup.${item}"/></option>
                                        </c:forEach>
                                    </c:if>
                                </select>
                            </div>
                        </div>
                        <div class="col-3">
                            <div class="form-group">
                                <label class="text-label">Mã vật tư<span class="text-danger"> *</span></label>
                                <select class="form-control select2" name="code" id="material" disabled="true" data-placeholder="Chọn vật tư"></select>

                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-4">
                    <label class="text-label">Giai đoạn:<span class="text-danger"> *</span></label>
                    <div class="row">
                        <div class="col-6">
                            <div class="form-group row">
                                <span class="flex-center-vertical">Từ</span>
                                <div class="col-lg-10">
                                    <input type="text" class="form-control rounded-10" placeholder="DD/MM/YYYY" id="fromDate" name="fromDate" value="${criteria.fromDate }" autocomplete="off" />
                                </div>
                            </div>
                        </div>
                        <div class="col-6">
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
			<div class="text-color-primary fs-5"><fmt:message key="menu.report.ListMaterialGA" /><span class="text-warning font-weight-bold"><fmt:message key="report.pr.suggest" /></span></div>
		</div>
		<div class="col-12 col-md-6 text-right">
			<a href="/report/listMaterialGA-export-excel" id="exportListMaterialGA" class="btn bgc-warning text-white"><i class="icon-database-export pr-2"></i>Xuất báo cáo</a>
		</div>
	</div>
	    
	<!-- \Table -->
	<div class="card">
        <div class="table-responsive table-scroll">
            <table class="table table-bordered table-striped">
                <thead>
                    <tr class="table-success">
                        <th class="bgc-primary border-primary text-white"><fmt:message key="report.table.th.STT" /></th>
                        <th class="bgc-primary border-primary text-white"><fmt:message key="materialDetail.postingDate" /></th>
                        <th class="bgc-primary border-primary text-white"><fmt:message key="material.code" /></th>
                        <th class="bgc-primary border-primary text-white"><fmt:message key="material.name" /></th>
                        <th class="bgc-primary border-primary text-white"><fmt:message key="material.batch" /></th>
                        <th class="bgc-primary border-primary text-white"><fmt:message key="material.dvt" /></th>
                        <th class="bgc-primary border-primary text-white"><fmt:message key="material.amount" /></th>
                        <th class="bgc-primary border-primary text-white"><fmt:message key="goodsIssue.fromStockCode" /></th>
                        <th class="bgc-primary border-primary text-white"><fmt:message key="goodsIssue.toStockCode" /></th>
                        <th class="bgc-primary border-primary text-white"><fmt:message key="goodsIssue.type" /></th>
                        <th class="bgc-primary border-primary text-white"><fmt:message key="report.table.th.processOrder" /></th>
                        <th class="bgc-primary border-primary text-white"><fmt:message key="goodsissue.barnCode" /></th>
                    </tr>
                </thead>
                <tbody id="tbodyReportInstock">
                    <c:if test="${empty materialDetails}">
                        <tr>
                            <td colspan="12" class="text-center text-none-data"><fmt:message key="not.data"/></td>
                        </tr>
                    </c:if>
                    <c:forEach items="${materialDetails}" var="md" varStatus="cnt">
                        <tr>
                            <td>${cnt.count }</td>
                            <td>${md.displayPostingDate}</td>
                            <td>${md.code}</td>
                            <td>${md.name }</td>
                            <td>${md.batch }</td>
                            <td>${md.unit }</td>
                            <td>${md.actuallyExported}</td>
                            <td>${md.fromStockCode }</td>
                            <td>${md.toStockCode }</td>
                            <td>${md.recordTypeName }</td>
                            <td>${md.poCode }</td>
                            <td>${md.barnCode }</td>
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
<script src="<c:url value='/themes/admin/assets/js/reportListMaterialGA.js'/>"></script>
