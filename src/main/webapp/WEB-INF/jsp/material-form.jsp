<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
<title><fmt:message key="material.form.title" /></title>
<meta name="menu" content="materialMenu" />
<script src="<c:url value='/themes/admin/global_assets/js/plugins/extensions/jquery_ui/interactions.min.js'/>"></script>
<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>

<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/uniform.min.js'/>"></script>
<script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/pnotify.min.js'/>"></script>
<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/bootstrap_multiselect.js'/>"></script>
<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
<!-- Map -->
</head>

<!-- Content area -->
<div class="content">
	<form:form id="materialForm" modelAttribute="material" action="${ctx}/material/save" method="post" role="form">
		<form:hidden path="id" />
		<form:hidden path="unsignedName"/>
		<form:hidden path="status"/>
		<!-- Basic layout-->
		<div class="card">
			<div class="card-header header-elements-inline">
				<span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="material.form.title" /></span>
			</div>
			<div class="card-body">
				<p class="mb-4">
					<fmt:message key="material.form.title.description" />
				</p>
				<fieldset class="mb-3">
					<legend class="text-uppercase font-size-sm font-weight-bold">
						<fmt:message key="template.legend" />
					</legend>
					<div class="card">
						<div class="card-body">
							<div class="row">
								<div class="col-xs-12 col-md-3">
									<div class="form-group">
										<label><fmt:message key="material.code" /><span class="help-block"></span></label>
										<form:input path="code" readonly="true" class="form-control"/>
									</div>
								</div>
								<div class="col-xs-12 col-md-3">
									<div class="form-group">
										<label><fmt:message key="material.fastcode" /><span class="help-block"></span></label>
										<form:input path="fastCode" readonly="true" class="form-control"/>
									</div>
								</div>
								<div class="col-xs-12 col-md-3">
									<div class="form-group">
										<label><fmt:message key="material.name" /><span class="help-block"></span></label>
										<form:input path="name" readonly="true" class="form-control"/>
									</div>
								</div>
								<div class="col-xs-12 col-md-3">
									<div class="form-group">
										<label><fmt:message key="material.suggest.name" /><span class="help-block"></span></label>
										<form:input path="suggestName" class="form-control"/>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-xs-12 col-md-3">
									<div class="form-group">
										<label><fmt:message key="material.groupCode" /><span class="help-block"></span></label>
										<form:input path="groupCode" class="form-control" readonly="true"/>
									</div>
								</div>
								<div class="col-xs-12 col-md-3">
									<div class="form-group">
										<label><fmt:message key="material.groupName" /><span class="help-block"></span></label>
										<form:input path="groupName" class="form-control" readonly="true"/>
									</div>
								</div>
								<div class="col-xs-12 col-md-3">
									<div class="form-group">
										<label><fmt:message key="material.unit" /><span class="help-block"></span></label>
										<form:input path="unit" class="form-control" readonly="true"/>
									</div>
								</div>
								<div class="col-xs-12 col-md-3">
									<div class="form-group">
										<label><fmt:message key="material.batch" /><span class="help-block"></span></label>
										<form:input path="batch" class="form-control" readonly="true"/>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-xs-12 col-md-6">
									<div class="form-group">
										<label><fmt:message key="material.purchasingGroup" /><span class="help-block"></span></label>
										<form:input path="purchasingGroup" class="form-control" readonly="true"/>
									</div>
								</div>
								<div class="col-xs-12 col-md-6">
									<div class="form-group">
										<label><fmt:message key="material.industryStandardDescription" /><span class="help-block"></span></label>
										<form:input path="industryStandardDescription" class="form-control" readonly="true"/>
									</div>
								</div>
							</div>
							<jsp:include page="material-conversion.jsp"/>
						</div>
					</div>
					<div class="d-flex justify-content-end align-items-center">
						<a href="<c:url value="/material/list"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i> <fmt:message key="button.back" /></a>
						<button type="submit" class="btn btn-primary ml-3"><fmt:message key="button.save" /><i class="icon-database-insert ml-2"></i></button>		
					</div>
				</fieldset>
			</div>
		</div>
		<!-- /basic layout -->
	</form:form>
</div>
<!-- /content area -->

<script src="<c:url value='/themes/admin/assets/js/material_form.js'/>"></script>