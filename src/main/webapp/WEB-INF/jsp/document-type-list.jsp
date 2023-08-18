<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
<title><fmt:message key="document.type.title" /></title>
<meta name="menu" content="documentTypeMenu" />
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/assets/js/document_type_list.js'/>"></script>
</head>

<div class="content">
	<div class="row mb-2">
		<div class="col-12 col-md-6">
			<div class="text-color-primary fs-5"><fmt:message key="document.type.title" /></div>
		</div>
		<div class="col-12 col-md-6 text-right">
			<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_DOCUMENT_TYPE_CREATE')">
				<a href="/documentType/form" class="btn btn-sm bgc-warning text-color-primary rounded-10" title="Thêm mới"><i class="icon-plus22"></i>Thêm mới</a>
			</security:authorize>
		</div>
	</div>
	<form:form id="documentTypeForm" modelAttribute="criteria" action="${ctx}/documentType/list" method="POST">
	<!-- \Searching -->
	<div class="card rounded-16">
		<div class="row">
			<div class="col-12 px-3 py-2 fw-bold">
				<fmt:message key="label.search" />
			</div>
		</div>
		<div class="card-body py-0">
			<div class="row">
				<div class="col-9">
					<div class="row">
						<div class="col-4">
							<div class="form-group">
								<label><fmt:message key="document.type.code" /></label>
								<input class="form-control rounded-10" type="text" id="code" name="code" value="${criteria.code}" placeholder="Nhập mã loại tài liệu"/>
							</div>
						</div>
						<div class="col-4">
							<div class="form-group">
								<label><fmt:message key="document.type.name" /></label>
								<input class="form-control rounded-10" type="text" id="name" name="name" value="${criteria.name}" placeholder="Nhập tên loại tài liệu"/>
							</div>
						</div>
						<div class="col-4">
							<div class="form-group">
								<label><fmt:message key="barnPlan.status" /></label>
								<select name="status" class="form-control rounded-10 select2" id="status">
									<option value="">&nbsp;</option>
									<c:forEach var="item" items = "${documentTypeStatus}">
										<option value="${item}" ${criteria.status eq item ? 'selected' : ''}><fmt:message key="status.${item}" /></option>
									</c:forEach>
								</select>
							</div>
						</div>
					</div>
				</div>
				<div class="col-3 text-right mt-3">
					<button type="button" class="btn btn-secondary" id="btnReset"><i class="mr-2 icon-reset"></i><fmt:message key="button.reset" /></button>
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
							<th class="bgc-primary border-primary text-white text-center" style="width: 2%">#</th>
							<th class="bgc-primary border-primary text-white " style="width: 10%"><fmt:message key="document.type.code" /></th>
							<th class="bgc-primary border-primary text-white " style="width: 10%"><fmt:message key="document.type.name" /></th>
							<th class="bgc-primary border-primary text-white " style="width: 20%"><fmt:message key="document.type.description" /></th>
							<th class="bgc-primary border-primary text-white " style="width: 5%" ><fmt:message key="document.type.status" /></th>
							<th class="bgc-primary border-primary text-white text-center" style="width: 5%"><i class="icon-menu-open2"></i></th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${empty page.content}">
							<tr>
								<td colspan="5" class="text-center text-none-data">
									<fmt:message key="not.data" />
								</td>
							</tr>
						</c:if>
						<c:forEach var="item" items="${page.content}" varStatus="cnt">
							<tr>
								<td class="text-center"><c:out value="${cnt.count+page.size*page.number}" /></td>
								<td>${item.code}</td>
								<td>${item.name}</td>
								<td>${item.description}</td>
								<td class="text-center"><span class="badge bg-${item.status eq 'inactive' ? 'danger' : 'success' }-400"><fmt:message key="status.${item.status}" /></span></td>
								<td class="text-center">
									<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_DOCUMENT_TYPE_UPDATE')">
										<a href="/documentType/form?id=${item.id}"><i class="icon-pencil7"></i><span> <fmt:message key="button.edit"/></span></a>
									</security:authorize>
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div> 
			 <!-- Pagination --> 
			 <jsp:include page="/themes/admin/common/pagination.jsp">
				<jsp:param value="${page.number}" name="pageNumber" />
				<jsp:param value="${page.totalPages}" name="maxPages" />
				<jsp:param value="${page.size}" name="size" />
				<jsp:param value="${page.totalElements}" name="totalElements" />
			</jsp:include>
		</div>
		<!-- /Table -->
	</form:form>
</div> 
<div class="modal hide" id="pleaseWaitDialog" data-backdrop="static" data-keyboard="false">
    <div class="modal-body">
        <div class="loading">Loading&#8230;</div>
    </div>
</div>