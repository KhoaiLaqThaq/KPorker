<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="farm.form.title"/></title>
    <meta name="menu" content="farmMenu"/>
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
<form:form id="farmForm" modelAttribute="farm" action="<c:url value='/farm/save'/>" method="post" role="form">
	<form:hidden path="id"/>
	
	<!-- Basic layout-->
	<div class="card">
		<div class="card-header header-elements-inline"><span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="farm.form.title"/></span></div>
		<div class="card-body">
			<p class="mb-4"><fmt:message key="farm.form.title.description"/></p>
			<fieldset class="mb-3">
				<legend class="text-uppercase font-size-sm font-weight-bold"><fmt:message key="template.legend"/></legend>
				<div class="card">
					<div class="card-body">
						<div class="row">
							<div class="col-xs-12 col-md-4">
								<div class="form-group">
									<label ><fmt:message key="farm.code"/><span class="help-block">*</span></label>
									<input type="text" id="code" name="code" value="${farm.code}" class="form-control" required="required"  maxlength="30"/>
									<div><span id="messageCheckCode" style="color:red"></span></div>
								</div>
								
							</div>
							<div class="col-xs-12 col-md-4">
								<div class="form-group">
									<label><fmt:message key="farm.name"/><span class="help-block">*</span></label>
									<input type="text" name="name" id="name" value="${farm.name}" class="form-control" required="required" maxlength="200"/>
									<div><span id="messageCheckName" style=" color:red "></span></div>
								</div>
							</div>							
						</div>
					</div>
				</div>
				<div class="d-flex justify-content-end align-items-center">
					<a href="<c:url value="/farm/list?id=${farm.id}"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i><fmt:message key="button.back"/></a>
					<button type="submit" id="farmSubmit" class="btn btn-primary ml-3"><fmt:message key="button.save"/><i class="icon-database-insert ml-2"></i></button>			
				</div>			
			</fieldset>
		</div>
	</div>
	<!-- /basic layout -->
</form:form>
</div>
<!-- /content area -->

