<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
<title><fmt:message key="document.type.form.title" /></title>
<meta name="menu" content="documentTypeMenu" />
<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
<script	src="<c:url value='/themes/admin/assets/js/document_type_form.js'/>"></script>
<!-- Map -->
</head>

<!-- Content area -->
<div class="content">
	<form:form id="documentTypeForm" modelAttribute="documentType" action="${ctx}/documentType/save" method="post" role="form">
		<form:hidden path="id" id="id" />
		<!-- Basic layout-->
		<div class="card">
			<div class="card-header header-elements-inline">
				<span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="document.type.form.title" /></span>
			</div>
			<div class="card-body">
				<fieldset class="mb-3">
					<div class="row">
						<div class="col-md-4">
							<div class="form-group">
								<label><fmt:message key="document.type.code" /><span class="help-block">*</span></label>
								<c:choose>
									<c:when test="${not empty documentType.id}"> 
										<form:input path="code" id="code" class="form-control" readonly="true"/>
									</c:when>
									<c:otherwise>
										<form:input path="code" id="code" class="form-control" required="required"/>
									</c:otherwise>
								</c:choose>
							</div>
						</div>
						<div class="col-md-4">
							<div class="form-group">
								<label><fmt:message key="document.type.name" /><span class="help-block">*</span></label>
								<form:input path="name" id="name" class="form-control" required="required"/>
							</div>
						</div>
						<div class="col-md-4">
							<div class="form-group">
								<label>
									<fmt:message key="document.type.status" />
									<span class="help-block">*</span>
								</label> 
								<form:select id="status" path="status" class="form-control select2" data-placeholder="Chọn trạng thái" required="required">
							      	<option value="" disabled hidden="hidden"></option>
									<c:forEach var="item" items="${documentTypeStatus}">
							            <option value="${item}" ${item == documentType.status ? 'selected="selected"' : ''}><fmt:message key="status.${item}" /></option>
							        </c:forEach>
								</form:select>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-12">
							<div class="form-group">
								<label>
									<fmt:message key="document.type.description" />
									<span class="help-block"></span>
								</label>
								<form:input path="description" id="description" class="form-control" />
							</div>
						</div>
					</div>
					<div class="d-flex justify-content-end align-items-center">
						<a href="<c:url value="/documentType/list"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i> <fmt:message key="button.back" /></a>
						<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_DOCUMENT_TYPE_CREATE')">
							<button type="submit" class="btn btn-primary ml-3"><fmt:message key="button.save" /><i class="icon-database-insert ml-2"></i></button>
						</security:authorize>
					</div>
				</fieldset>
			</div>
		</div>
		<!-- /basic layout -->
	</form:form>
</div>
<!-- /content area -->
