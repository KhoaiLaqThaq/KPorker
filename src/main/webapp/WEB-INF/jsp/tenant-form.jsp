<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="tenant.form.title"/></title>
    <meta name="menu" content="orgMenu"/>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/extensions/jquery_ui/interactions.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/demo_pages/form_select2.js'/>"></script>
	
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/uniform.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/pnotify.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/bootstrap_multiselect.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/demo_pages/form_multiselect.js'/>"></script>
    <link href="${ctx }/themes/admin/assets/css/tenant_form.css" rel="stylesheet" type="text/css">
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
</head>


<!-- Content area -->
<div class="content">
<form:form id="tenantForm" modelAttribute="tenant" action="${ctx}/tenant/save" method="post" role="form">
	<form:hidden path="id"/>
	
	<!-- Basic layout-->
	<div class="card">
		<div class="card-header header-elements-inline"><span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="tenant.form.title"/></span></div>
		<div class="card-body">
			<p class="mb-4"><fmt:message key="tenant.form.title.description"/></p>
			<fieldset class="mb-3">
				<legend class="text-uppercase font-size-sm font-weight-bold"><fmt:message key="template.legend"/></legend>
				<div class="card">
					<div class="card-body">
						<div class="row">
							<div class="col-xs-12 col-md-4">
								<div class="form-group">
									<label ><fmt:message key="tenant.code"/><span class="help-block">*</span></label>
									<input type="text" id="code" name="code" value="${tenant.code}" class="form-control" required="required"  maxlength="50"/>
									<div><span id="messageCheckCode" style=" color:red "></span></div>
								</div>
								
							</div>
							<div class="col-xs-12 col-md-8">
								<div class="form-group">
									<label><fmt:message key="tenant.name"/><span class="help-block">*</span></label>
									<input type="text" name="name" id="name" value="${tenant.name}" class="form-control" required="required" maxlength="200"/>
									<div><span id="messageCheckName" style=" color:red "></span></div>
								</div>
							</div>

							<div class="col-xs-12 col-md-6">
								<div class="form-group">
									<label ><fmt:message key="tenant.adminUsername"/><span class="help-block">*</span></label>
									<input type="text" id="adminUsername" name="adminUsername" value="${tenant.adminUsername}" class="form-control" required="required"  maxlength="50"/>
									<div><span id="messageCheckName" style=" color:red "></span></div>
								</div>
								
							</div>

							<div class="col-xs-12 col-md-6">
								<div class="form-group">
									<label ><fmt:message key="tenant.adminPassword"/><span class="help-block">*</span></label>
									<input type="password" id="adminPassword" name="adminPassword" value="${tenant.adminPassword}" class="form-control" required="required"  maxlength="50"/>
									<div><span id="messageCheckName" style=" color:red "></span></div>
								</div>
								
							</div>
							
							<%-- 
							<div class="col-xs-12 col-md-4">
								<div class="form-group">
									<label><fmt:message key="tenant.status"/><span class="help-block">*</span></label>
									<select class="form-control select " name="status">
										<c:forEach items="${listStatus}" var="status">
									        <option value="${status.status}" ${tenant.status == status.status ? 'selected' : ''}>${status}</option>
									    </c:forEach>
								    </select>
								</div>
							</div>
	        				--%>
	        			</div>
					</div>
				</div>
				<div class="d-flex justify-content-end align-items-center">
					<a href="<c:url value="/tenantomer/list"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i><fmt:message key="button.back"/></a>
					<button onclick="return validate()" type="submit" id="tenantSubmit" class="btn btn-primary ml-3"><fmt:message key="button.save"/><i class="icon-database-insert ml-2"></i></button>
			
				</div>			
			</fieldset>
		</div>
	</div>
	<!-- /basic layout -->
</form:form>
</div>
<!-- /content area -->

