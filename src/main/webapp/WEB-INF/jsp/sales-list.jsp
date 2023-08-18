<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="sales.list.title"/></title>
    <meta name="menu" content="salesMenu"/>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
	<link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">
	<script src="<c:url value='/themes/admin/assets/js/sales_list.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/ui/moment/moment.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/daterangepicker.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/anytime.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.date.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/legacy.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/jgrowl.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/uploaders/fileinput/fileinput.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
</head>

<div class="content">
<form:form id="salesForm" modelAttribute="criteria" action="/sales/list" method="post">
<%--	<input type="hidden" name="postingDate" value="${criteria.postingDate}" id="postingDate">--%>
<%--	<input type="hidden" id="displayPostingDate" value="${criteria.displayPostingDate}">--%>
	<!-- \Searching -->
	<div class="card rounded-16">
		<div class="row">
			<div class="col-6 px-3 py-2 fw-bold"><fmt:message key="label.search" /></div>
			<div class="col-6 text-right">
				<button type="button" class="btn btn-secondary mt-2 mr-2" id="btnReset">Đặt lại</button>
				<button type="button" class="btn btn-secondary mt-2 mr-2" id="btnSubmit"><i class="mr-2 icon-search4"></i><fmt:message key="button.search" /></button>
			</div>
		</div>
		<div class="card-body py-0">
			<div class="row">
				<div class="col-md-3">
                   <div class="form-group">
                       <label class="text-label"><fmt:message key="sales.farmName" /></label>
                       <input class="form-control rounded-10" type="text" name="stockName" value="${criteria.stockName}" placeholder="Nhập tên trại" id="farmName" autocomplete="off"/>
                   </div>
                </div>
                <div class="col-md-3">
                   <div class="form-group">
                       <label class="text-label"><fmt:message key="sales.processOrderCode" /></label>
                       <input class="form-control rounded-10" type="text" name=processOrderCode value="${criteria.processOrderCode}" placeholder="Nhập lệnh sản xuất" id="processOrderCode" autocomplete="off"/>
                   </div>
                </div>
				<div class="offset-1 col-5">
					<label class="text-label"><fmt:message key="sales.postingDate" /></label>
					<div class="row">
						<div class="col-6">
							<div class="form-group row">
								<label class="col-form-label col-lg-2 text-label">Từ</label>
								<div class="col-lg-10">
									<input type="text" class="form-control rounded-10" placeholder="DD/MM/YYYY" id="fromDate" name="fromDate" value="${criteria.fromDate }" autocomplete="off" />
								</div>
							</div>
						</div>

						<div class="col-6">
							<div class="form-group row">
								<label class="col-form-label col-lg-2 text-label">đến</label>
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
			<div class="text-color-primary fs-3"><fmt:message key="sales.list.title" /></div>
		</div>
		<div class="col-12 col-md-6 text-right">
			<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_INSTOCK_IMPORT')">
				<a href="<c:url value='/sales/sync-from-sap'/>" class="btn bgc-warning text-white"><i class="icon-cloud-download2"></i> <fmt:message key="button.sync.master.data" /></a>
			</security:authorize>
			<a href="javascript:void(0)" id="btnSubmitToExport" class="btn bgc-warning text-white" title="<fmt:message key="button.export.excel"/>">
				<i class="icon-database-export pr-2"></i>
				<fmt:message key="button.export.excel" />
			</a>
		</div>
	</div>
	    
	<!-- \Table -->
	<div class="card">
		<div class="table-responsive">
			<table class="table table-bordered table-striped">
				<thead>
					<tr class="table-success">
						<th class="bgc-primary border-primary text-white text-center" style="width: 5%">#</th>
						<th class="bgc-primary border-primary text-white text-center"><fmt:message key="sales.farmCode"/></th>
						<th class="bgc-primary border-primary text-white text-center"><fmt:message key="sales.farmName"/></th>
						<th class="bgc-primary border-primary text-white text-center"><fmt:message key="sales.postingDate"/></th>
						<th class="bgc-primary border-primary text-white text-center"><fmt:message key="sales.materialCode"/></th>
						<th class="bgc-primary border-primary text-white text-center"><fmt:message key="sales.batch"/></th>
						<th class="bgc-primary border-primary text-white text-center"><fmt:message key="sales.quantity"/></th>
						<th class="bgc-primary border-primary text-white text-center"><fmt:message key="sales.weight"/></th>
						<th class="bgc-primary border-primary text-white text-center"><fmt:message key="sales.processOrderCode"/></th>
						<th class="bgc-primary border-primary text-white text-center"><fmt:message key="sales.distributionChannel"/></th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${empty page.content}">
						<tr><td colspan="9" class="text-center text-none-data"><fmt:message key="not.data"/></td></tr>
					</c:if>
					<c:forEach var="item" items="${page.content}" varStatus="cnt">
						<tr>
							<td class="text-center"><c:out value="${cnt.count+page.size*page.number}" /></td>
							<td class="text-center">${item.stock.code}</td>
							<td class="text-center">${item.stock.name}</td>
							<td class="text-center">${item.displayPostingDate}</td>
							<td class="text-center">${item.materialCode}</td>
							<td class="text-center">${item.batch}</td>
							<td class="text-center">${item.quantity}</td>
							<td class="text-center">${item.weight}</td>
							<td class="text-center">${item.processOrderCode}</td>
							<td class="text-center">${item.distributionChannel}</td>
						</tr> 
					</c:forEach>
				</tbody> 
			</table>
		</div>
		<!-- Pagination -->
        <jsp:include page="/themes/admin/common/pagination.jsp">
         	<jsp:param value="${page.number}" name="pageNumber"/>
         	<jsp:param value="${page.totalPages}" name="maxPages"/>
         	<jsp:param value="${page.size}" name="size"/>
         	<jsp:param value="${page.totalElements}" name="totalElements"/>
      	</jsp:include>
	</div>
	<!-- /Table -->
</form:form>
</div>

