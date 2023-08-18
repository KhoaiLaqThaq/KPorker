<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="instock.list.title"/></title>
    <meta name="menu" content="instockMenu"/>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
	<link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">
	<script src="<c:url value='/themes/admin/assets/js/instock_list.js'/>"></script>
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

<div class="row mb-3">
	<div class="col-12"><%@include file="/themes/admin/common/instock-actions.jsp"%></div>
</div>

<div class="content">
	<div class="row cus-tabs-container mb-3">
		<ul class="nav nav-tabs mb-0">
			<li class="nav-item"><a href="/instock/list" class="nav-link active show"><fmt:message key="menu.instock"/></a></li>
			<li class="nav-item"><a href="/stockCount/list" class="nav-link"><fmt:message key="menu.stock.count"/></a></li>
			<li class="nav-item"><a href="/instock-baseline/list" class="nav-link"><fmt:message key="menu.instock.baseline"/></a></li>
		</ul>
		<div class="tab-divider"></div>
	</div>
	<div class="row mb-3">
		<div class="col-12 col-md-6">
			<div class="text-color-primary fs-5"><fmt:message key="instock.list.title" /></div>
		</div>
		<div class="col-12 col-md-6 text-right">
			<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_INSTOCK_IMPORT')">
				<button type="button" class="btn bgc-warning rounded-10 px-3 text-white" data-toggle="modal" data-target="#modal_import" data-backdrop="static" data-keyboard="false"> <i class="icon-cloud-download2 mr-2"></i> <fmt:message key="button.import.material"/></button>
			</security:authorize>
		</div>
	</div>
<form:form id="instockForm" modelAttribute="criteria" action="/instock/list" method="post">
	<input type="hidden" name="latestOfDay" value="${criteria.latestOfDay}">
	<%-- <input type="hidden" name="syncDate" value="${criteria.syncDate}" id="syncDate"> --%>
	<input type="hidden" id="displaySyncDate" value="${criteria.displaySyncDate}">
	<!-- \Searching -->
	<div class="card rounded-16">
		<div class="row"><div class="col-12 px-3 py-2 fw-bold"><fmt:message key="label.search" /></div></div>
		<div class="card-body py-0">
			<div class="row">
				<div class="col-md-4">
                   <div class="form-group">
                       <label><fmt:message key="instock.farmName" /></label>
                       <input class="form-control rounded-10" type="text" name="farmName" value="${criteria.farmName}" placeholder="Nhập tên trại" id="farmName" autocomplete="off"/>
                   </div>
                </div>
                <div class="col-md-4">
                   <div class="form-group">
                       <label><fmt:message key="instock.syncDate" /></label>
                       <input class="form-control rounded-10 daterange-single" type="text" placeholder="Chọn ngày ghi nhận DD/MM/YYYY" name="syncDateSearch" id="syncDateStr" value="${criteria.displaySyncDate}" autocomplete="off"/>
                   </div>
                </div>
				<div class="col-4 text-right mt-3">
					<button type="button" class="btn btn-secondary" id="btnReset">Đặt lại</button>
					<button type="button" class="btn btn-secondary" id="btnSubmit"><i class="mr-2 icon-search4"></i><fmt:message key="button.search" /></button>
				</div>
			</div>
		</div>
	</div>
	<!-- /Searching -->
	    
	<!-- \Table -->
	<div class="card">
		<div class="table-responsive">
			<table class="table table-bordered table-striped">
				<thead>
					<tr class="table-success">
						<th class="text-center bgc-primary text-white border-primary" style="width: 5%">#</th>
						<th class="bgc-primary text-white border-primary"><fmt:message key="instock.farmCode"/></th>
						<th class="bgc-primary text-white border-primary"><fmt:message key="instock.farmName"/></th>
						<th class="bgc-primary text-white border-primary"><fmt:message key="instock.syncDate"/></th>
						<th class="bgc-primary text-white border-primary"><fmt:message key="instock.modifiedDate"/></th>
						<th class="text-center bgc-primary text-white border-primary" style="width:120px;"><i class="icon-menu-open2"></i></th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${empty page.content}">
						<tr><td colspan="6" class="text-center text-none-data"><fmt:message key="not.data"/></td></tr>
					</c:if>
					<c:forEach var="item" items="${page.content}" varStatus="cnt">
						<tr>
							<td class="text-center"><c:out value="${cnt.count+page.size*page.number}" /></td>
							<td>${item.stock.code}</td>
							<td>${item.stock.name}</td>
							<td>${item.displaySyncDate}</td>
							<td>${item.displayCreatedDate}</td>
							<td class="text-center">
								<div class="list-icons">
									<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_INSTOCK_EDIT')">
									<a href="/instock/form?id=${item.id}"><i class="icon-file-eye fontSize18" title="Chi tiết"></i></a>
									</security:authorize>
								</div>
							</td>
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

<!-- modal import -->
<form:form id="instockImport" action="${ctx}/instock/import" method="post" modelAttribute="instock" enctype="multipart/form-data">
	<div id="modal_import" class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<span class="font-weight-semibold modal-title">LỰA CHỌN FILE CẦN IMPORT</span>
					<button type="button" class="close" data-dismiss="modal">&times;</button>
				</div>
				<div class="modal-body">
					<div class="form-group row">
						<div class="col-lg-12">
							<input type="file" name="inputImport" class="file-input" data-show-preview="false" accept=".xls,.xlsx" data-fouc>
						</div>
					</div>
					
					<div class="form-group row">
						<div class="col-lg-12">
							<select	id="instockStockCode" name="stockCode" class="form-control select2" data-placeholder="Chọn mã kho">
								<c:forEach var="item" items="${farms}">
						            <option value="${item.code}"><c:out value="${item.code} - ${item.name}"></c:out></option>
						        </c:forEach>
							</select>
						</div>
					</div>
				</div>
	
				<div class="modal-footer">
					<button type="button" class="btn btn-link" data-dismiss="modal">Close</button>
					<button type="submit" id="btnImport" class="btn bg-primary"><i class="icon-download7 mr-2"></i>Import Excel</button>
				</div>
			</div>
		</div>
	</div>
</form:form>