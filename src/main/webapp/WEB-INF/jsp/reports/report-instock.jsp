<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="menu.report.instock"/></title>
    <meta name="menu" content="reportInstock"/>
	<link href="<c:url value='/themes/admin/assets/css/components.min.css'/>" rel="stylesheet" type="text/css" />
    <link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">

    <link href="<c:url value='/themes/admin/assets/css/material-support.css'/>" rel="stylesheet" type="text/css">
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
<form:form id="reportInstockForm" modelAttribute="criteria" action="/report/instock"  method="post">
	<!-- \Searching -->
	<div class="card rounded-16">
		<div class="row"><div class="col-12 px-3 py-2 fw-bold"><fmt:message key="label.search" /></div></div>
        <div class="card-body pt-0">
            <div class="row">
            	<div class="col-9">
            		<div class="row">
            			<div class="col-md-4 col-sm-6 col-xs-12">
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
		                
		                <div class="col-md-4 col-sm-6 col-xs-12">
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
		                
		                <div class="col-md-4 col-sm-6 col-xs-12">
		                    <div class="form-group">
		                        <label class="text-label">Mã vật tư<span class="text-danger"> *</span></label>
		                        <select class="form-control select2" name="materialCode" id="material" disabled="true" data-placeholder="Chọn vật tư"></select>
		                    </div>
		                </div>
            		</div>
            		
            		<!-- row 2 -->
					<label class="text-label">Giai đoạn:<span class="text-danger"> *</span></label>
            		<div class="row">
            			<div class="col-md-6 col-sm- col-xs-12">
							<div class="form-group row">
								<label class="col-form-label col-lg-2 text-label">Từ</label>
								<div class="col-lg-10">
									<input type="text" class="form-control rounded-10" placeholder="Chọn ngày từ DD/MM/YYYY" id="fromDate" name="fromDate" value="${criteria.fromDate }" />
								</div>
							</div>
				        </div>
            			<div class="col-md-6 col-sm-6 col-xs-12">
							<div class="form-group row">
								<label class="col-form-label col-lg-2 text-label">đến</label>
								<div class="col-lg-10">
									<input type="text" class="form-control rounded-10" placeholder="Chọn ngày đến DD/MM/YYYY" id="toDate" name="toDate" value="${criteria.toDate }" />
								</div>
							</div>
						</div>
            		</div>
            	</div>
            	<div class="col-3 text-right mt-4">
            		<button type="submit" id="btnSubmit" class="btn btn-secondary"><i class="icon-search4 mr-2"></i><fmt:message key="button.search"/></button>
            	</div>
            </div>
        </div>
        
        
    </div>
    <!-- /Searching -->

	<div class="row mb-3">
		<div class="col-12 col-md-6">
			<div class="text-color-primary fs-4"><span><fmt:message key="report.instock" /></span></div>
		</div>
		<div class="col-12 col-md-6 text-right">
			<a href="/report/instock-export-excel" id="exportReportInstock" class="btn bgc-warning text-white"><i class="icon-database-export pr-2"></i>Xuất báo cáo</a>
		</div>
	</div>
	    
	<!-- \Table -->
	<div class="card">
		<div class="table-responsive">
			<table class="table table-bordered table-striped">
				<thead>
					<tr class="table-success">
						<th class="bgc-primary border-primary text-white">STT</th>
						<th class="bgc-primary border-primary text-white"><fmt:message key="material.code" /></th>
						<th class="bgc-primary border-primary text-white"><fmt:message key="material.name" /></th>
						<th class="bgc-primary border-primary text-white"><fmt:message key="material.dvt" /></th>
						<th class="bgc-primary border-primary text-white"><fmt:message key="material.amountEarlyStage" /></th>
						<th class="bgc-primary border-primary text-white"><fmt:message key="material.goodsReceipt" /></th>
						<th class="bgc-primary border-primary text-white"><fmt:message key="material.goodsIssue" /></th>
						<th class="bgc-primary border-primary text-white"><fmt:message key="material.goodsIssueToStock" /></th>
						<th class="bgc-primary border-primary text-white"><fmt:message key="material.amountFinalStage" /></th>
					</tr>
				</thead>
				<tbody id="tbodyReportInstock">
					<c:if test="${empty reportInstocks}">
						<tr>
							<td colspan="9" class="text-center text-none-data"><fmt:message key="not.data"/></td>
						</tr>
					</c:if>
					<c:forEach items="${reportInstocks}" var="rpInstock" varStatus="cnt">
						<tr>
							<td>${cnt.count }</td>
							<td>${rpInstock.materialCode }</td>
							<td>${rpInstock.materialName }</td>
							<td>${rpInstock.unit }</td>
							<td>${rpInstock.amountEarlyStage }</td>
							<td>${rpInstock.amountGR }</td>
							<td>${rpInstock.amountGA }</td>
							<td>${rpInstock.amountGI }</td>
							<td>${rpInstock.amountFinalStage }</td>
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
<script src="<c:url value='/themes/admin/assets/js/reportInstock.js'/>"></script>
