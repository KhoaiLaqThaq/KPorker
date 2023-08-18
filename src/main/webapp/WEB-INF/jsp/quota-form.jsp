<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="quota.form.title"/></title>
    <meta name="menu" content="quotaMenu"/>
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
<form:form id="quotaForm" modelAttribute="quota" action="<c:url value='/quota/save'/>" method="post" role="form">
	<form:hidden path="id"/>
	
	<!-- Basic layout-->
	<div class="card">
		<div class="card-header header-elements-inline"><span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="quota.form.title"/></span></div>
		<div class="card-body">
			<p class="mb-4"><fmt:message key="quota.form.title.description"/></p>
			<fieldset class="mb-3">
				<legend class="text-uppercase font-size-sm font-weight-bold"><fmt:message key="template.legend"/></legend>
				<div class="card">
					<div class="card-body">
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="quota.id"/><span class="help-block">*</span></label>
									<input type="text" id="quotaId" name="id" value="${quota.id}" class="form-control" required="required" maxlength="19"/>
									<div><span id="msgForId" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="quota.processOrderCode"/><span class="help-block">*</span></label>
									<input type="text" id="quotaProcessOrderCode" name="processOrderCode" value="${quota.processOrderCode}" class="form-control" required="required" maxlength="10"/>
									<div><span id="msgForProcessOrderCode" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="quota.materialCode"/><span class="help-block"></span></label>
									<input type="text" id="quotaMaterialCode" name="materialCode" value="${quota.materialCode}" class="form-control"  maxlength="40"/>
									<div><span id="msgForMaterialCode" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="quota.materialName"/><span class="help-block"></span></label>
									<input type="text" id="quotaMaterialName" name="materialName" value="${quota.materialName}" class="form-control"  maxlength="40"/>
									<div><span id="msgForMaterialName" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="quota.quantity"/><span class="help-block"></span></label>
									<input type="text" id="quotaQuantity" name="quantity" value="${quota.quantity}" class="form-control"  maxlength="10"/>
									<div><span id="msgForQuantity" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="quota.requestDate"/><span class="help-block"></span></label>
									<input type="text" id="quotaRequestDate" name="requestDate" value="${quota.requestDate}" class="form-control"  maxlength="10"/>
									<div><span id="msgForRequestDate" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="quota.latest"/><span class="help-block"></span></label>
									<input type="text" id="quotaLatest" name="latest" value="${quota.latest}" class="form-control"  maxlength="1"/>
									<div><span id="msgForLatest" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="quota.createdDate"/><span class="help-block"></span></label>
									<input type="text" id="quotaCreatedDate" name="createdDate" value="${quota.createdDate}" class="form-control"  maxlength="19"/>
									<div><span id="msgForCreatedDate" style="color:red"></span></div>
								</div>
							</div>
						</div>							
					</div>
				</div>
				<div class="d-flex justify-content-end align-items-center">
					<a href="<c:url value="/quota/list?id=${quota.id}"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i><fmt:message key="button.back"/></a>
					<button type="submit" id="quotaSubmit" class="btn btn-primary ml-3"><fmt:message key="button.save"/><i class="icon-database-insert ml-2"></i></button>			
				</div>			
			</fieldset>
		</div>
	</div>
	<!-- /basic layout -->
</form:form>
</div>
<!-- /content area -->
