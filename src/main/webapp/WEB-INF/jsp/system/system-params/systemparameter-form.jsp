<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="systemParameter.form.title"/></title>
    <meta name="menu" content="parameterMenu"/>
    
    <script	src="<c:url value='/themes/admin/assets/js/systemParameter_form.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
</head>
<!-- Content area -->
<div class="content">
<form:form id="systemParameterForm" modelAttribute="systemParameter" action="${ctx}/systemParameter/save" method="post" role="form">
	<form:hidden path="id" id="id"/>
	<form:hidden path="version" />
	<!-- Basic layout-->
	<div class="card">
		<div class="card-header header-elements-inline"><span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="systemParameter.form.title"/></span></div>
		<div class="card-body">
			<p class="mb-4"><fmt:message key="systemParameter.form.title.description"/></p>
			<fieldset class="mb-3">
				<legend class="text-uppercase font-size-sm font-weight-bold"><fmt:message key="template.legend"/></legend>
				<div class="card">
					<div class="card-body">
						<div class="row">
							<div class="form-group col-lg-6">
								<label class="col-form-label"><fmt:message key="systemParameter.paramName"/>:</label>
								<div><form:input type="text" class="form-control rounded-10" path="paramName" id="paramName" placeholder="" maxlength="100"></form:input></div>
							</div>

							<div class="form-group col-lg-6">
								<label class="col-form-label"><fmt:message key="systemParameter.paramValue"/>:</label>
								<div><form:input type="text" class="form-control rounded-10" path="paramValue" placeholder="" maxlength="200"></form:input></div>
							</div>

							<div class="form-group col-lg-12">
								<label class="col-form-label"><fmt:message key="systemParameter.description"/>:</label>
								<div><form:input type="text" class="form-control rounded-10" path="description" placeholder="Mô tả" maxlength="200"></form:input></div>
							</div>
						</div>							
					</div>
				</div>
				<div class="d-flex justify-content-end align-items-center">
					<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_SYS_PARAM_VIEW')">
						<a href="<c:url value="/systemParameter/list"/>" id="back" class="btn btn-light mr-2 rounded-10"><i class="icon-point-left mr-2"></i><fmt:message key="button.back"/></a>
					</security:authorize>
					<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_SYS_PARAM_UPDATE')">
						<button type="submit" id="systemParameterSubmit" class="btn bgc-warning text-white rounded-10"><fmt:message key="button.save"/><i class="icon-database-insert ml-2"></i></button>
					</security:authorize>
				</div>			
			</fieldset>
		</div>
	</div>
	<!-- /basic layout -->
</form:form>
</div>
<!-- /content area -->

