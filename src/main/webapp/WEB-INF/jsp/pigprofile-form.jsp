<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="pigprofile.form.title"/></title>
    <meta name="menu" content="pigprofileMenu"/>
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
<form:form id="pigprofileForm" modelAttribute="pigprofile" action="<c:url value='/pigprofile/save'/>" method="post" role="form">
	<form:hidden path="id"/>
	
	<!-- Basic layout-->
	<div class="card">
		<div class="card-header header-elements-inline"><span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="pigprofile.form.title"/></span></div>
		<div class="card-body">
			<p class="mb-4"><fmt:message key="pigprofile.form.title.description"/></p>
			<fieldset class="mb-3">
				<legend class="text-uppercase font-size-sm font-weight-bold"><fmt:message key="template.legend"/></legend>
				<div class="card">
					<div class="card-body">
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="pigprofile.id"/><span class="help-block">*</span></label>
									<input type="text" id="pigprofileId" name="id" value="${pigprofile.id}" class="form-control" required="required" maxlength="19"/>
									<div><span id="msgForId" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="pigprofile.pigId"/><span class="help-block">*</span></label>
									<input type="text" id="pigprofilePigId" name="pigId" value="${pigprofile.pigId}" class="form-control" required="required" maxlength="19"/>
									<div><span id="msgForPigId" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="pigprofile.content"/><span class="help-block"></span></label>
									<input type="text" id="pigprofileContent" name="content" value="${pigprofile.content}" class="form-control"  maxlength="1,073,741,824"/>
									<div><span id="msgForContent" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="pigprofile.createdBy"/><span class="help-block"></span></label>
									<input type="text" id="pigprofileCreatedBy" name="createdBy" value="${pigprofile.createdBy}" class="form-control"  maxlength="50"/>
									<div><span id="msgForCreatedBy" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="pigprofile.createdDate"/><span class="help-block"></span></label>
									<input type="text" id="pigprofileCreatedDate" name="createdDate" value="${pigprofile.createdDate}" class="form-control"  maxlength="19"/>
									<div><span id="msgForCreatedDate" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="pigprofile.modifiedBy"/><span class="help-block"></span></label>
									<input type="text" id="pigprofileModifiedBy" name="modifiedBy" value="${pigprofile.modifiedBy}" class="form-control"  maxlength="50"/>
									<div><span id="msgForModifiedBy" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="pigprofile.modifiedDate"/><span class="help-block"></span></label>
									<input type="text" id="pigprofileModifiedDate" name="modifiedDate" value="${pigprofile.modifiedDate}" class="form-control"  maxlength="19"/>
									<div><span id="msgForModifiedDate" style="color:red"></span></div>
								</div>
							</div>
						</div>							
					</div>
				</div>
				<div class="d-flex justify-content-end align-items-center">
					<a href="<c:url value="/pigprofile/list?id=${pigprofile.id}"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i><fmt:message key="button.back"/></a>
					<button type="submit" id="pigprofileSubmit" class="btn btn-primary ml-3"><fmt:message key="button.save"/><i class="icon-database-insert ml-2"></i></button>			
				</div>			
			</fieldset>
		</div>
	</div>
	<!-- /basic layout -->
</form:form>
</div>
<!-- /content area -->
