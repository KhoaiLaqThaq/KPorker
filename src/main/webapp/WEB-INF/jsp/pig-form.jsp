<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="pig.form.title"/></title>
    <meta name="menu" content="pigMenu"/>
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
<form:form id="pigForm" modelAttribute="pig" action="<c:url value='/pig/save'/>" method="post" role="form">
	<form:hidden path="id"/>
	
	<!-- Basic layout-->
	<div class="card">
		<div class="card-header header-elements-inline"><span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="pig.form.title"/></span></div>
		<div class="card-body">
			<p class="mb-4"><fmt:message key="pig.form.title.description"/></p>
			<fieldset class="mb-3">
				<legend class="text-uppercase font-size-sm font-weight-bold"><fmt:message key="template.legend"/></legend>
				<div class="card">
					<div class="card-body">
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="pig.id"/><span class="help-block">*</span></label>
									<input type="text" id="pigId" name="id" value="${pig.id}" class="form-control" required="required" maxlength="19"/>
									<div><span id="msgForId" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="pig.indentifier"/><span class="help-block"></span></label>
									<input type="text" id="pigIndentifier" name="indentifier" value="${pig.indentifier}" class="form-control"  maxlength="50"/>
									<div><span id="msgForIndentifier" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="pig.batch"/><span class="help-block"></span></label>
									<input type="text" id="pigBatch" name="batch" value="${pig.batch}" class="form-control"  maxlength="30"/>
									<div><span id="msgForBatch" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="pig.pigGroup"/><span class="help-block"></span></label>
									<input type="text" id="pigPigGroup" name="pigGroup" value="${pig.pigGroup}" class="form-control"  maxlength="30"/>
									<div><span id="msgForPigGroup" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="pig.earTag"/><span class="help-block"></span></label>
									<input type="text" id="pigEarTag" name="earTag" value="${pig.earTag}" class="form-control"  maxlength="30"/>
									<div><span id="msgForEarTag" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="pig.birthDate"/><span class="help-block"></span></label>
									<input type="text" id="pigBirthDate" name="birthDate" value="${pig.birthDate}" class="form-control"  maxlength="10"/>
									<div><span id="msgForBirthDate" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="pig.type"/><span class="help-block"></span></label>
									<input type="text" id="pigType" name="type" value="${pig.type}" class="form-control"  maxlength="10"/>
									<div><span id="msgForType" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="pig.quantity"/><span class="help-block"></span></label>
									<input type="text" id="pigQuantity" name="quantity" value="${pig.quantity}" class="form-control"  maxlength="10"/>
									<div><span id="msgForQuantity" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="pig.createdBy"/><span class="help-block"></span></label>
									<input type="text" id="pigCreatedBy" name="createdBy" value="${pig.createdBy}" class="form-control"  maxlength="50"/>
									<div><span id="msgForCreatedBy" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="pig.createdDate"/><span class="help-block"></span></label>
									<input type="text" id="pigCreatedDate" name="createdDate" value="${pig.createdDate}" class="form-control"  maxlength="19"/>
									<div><span id="msgForCreatedDate" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="pig.modifiedBy"/><span class="help-block"></span></label>
									<input type="text" id="pigModifiedBy" name="modifiedBy" value="${pig.modifiedBy}" class="form-control"  maxlength="50"/>
									<div><span id="msgForModifiedBy" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="pig.modifiedDate"/><span class="help-block"></span></label>
									<input type="text" id="pigModifiedDate" name="modifiedDate" value="${pig.modifiedDate}" class="form-control"  maxlength="19"/>
									<div><span id="msgForModifiedDate" style="color:red"></span></div>
								</div>
							</div>
						</div>							
					</div>
				</div>
				<div class="d-flex justify-content-end align-items-center">
					<a href="<c:url value="/pig/list?id=${pig.id}"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i><fmt:message key="button.back"/></a>
					<button type="submit" id="pigSubmit" class="btn btn-primary ml-3"><fmt:message key="button.save"/><i class="icon-database-insert ml-2"></i></button>			
				</div>			
			</fieldset>
		</div>
	</div>
	<!-- /basic layout -->
</form:form>
</div>
<!-- /content area -->
