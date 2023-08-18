<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<head>
	<title><fmt:message key="barn.plan.form.title" /></title>
	<meta name="menu" content="barnPlanMenu" />
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/extensions/jquery_ui/interactions.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/extensions/jquery_ui/widgets.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/extensions/jquery_ui/effects.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/assets/js/barnplan_form.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/ui/moment/moment.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/daterangepicker.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/anytime.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.date.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/legacy.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/jgrowl.min.js'/>"></script>
	
	<!-- Map -->
</head>

<!-- Content area -->
<div class="content">
	<form:form id="barnPlanForm" modelAttribute="barnPlan" action="${ctx}/barnPlan/confirm" method="post" role="form">
		<form:hidden path="id"/>
		<form:hidden path="barnEmptyDate"/>
		<form:hidden path="createdBy"/>
		<form:hidden path="createdDate"/>
		<form:hidden path="modifiedBy"/>
		<form:hidden path="modifiedDate"/>
		<form:hidden path="status" id = "barnPlanStatus"/>
		<form:hidden path="realBarnEmptyDate" id="realBarnEmptyDate"/>

		<!-- Basic layout-->
		<div class="card">
			<div class="card-header header-elements-inline">
				<span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="barn.plan.form.title"/> - <c:out value = "${barnPlan.barn.farm.name}"/></span>
			</div>
			<div class="card-body">
				<fieldset class="mb-3">
					<legend class="text-uppercase font-size-sm font-weight-bold">
						<fmt:message key="template.legend" />
					</legend>
					<div class="card">
						<div class="card-body">
							<div class="row">
								<div class="col-xs-6 col-md-3">
									<div class="form-group">
										<label><fmt:message key="plan.barnCode" /><span class="help-block"></span></label>
										<input type="text" id="planBarnCode" name="barnCode" value="${barnPlan.barn.code}" class="form-control" readonly="readonly" />
										<div><span id="msgForBarnCode" style="color: red"></span></div>
									</div>
								</div>
								<div class="col-xs-6 col-md-3">
									<div class="form-group">
										<label><fmt:message key="plan.pigType" /><span class="help-block"></span></label>
										<input type="text" id="planBarnType" name="pigType" value="${barnPlan.pigType}" class="form-control" readonly="readonly"/>
									</div>
								</div>
								<div class="col-xs-6 col-md-3">
									<div class="form-group">
										<label><fmt:message key="barnPlan.barnVolumn" /><span class="help-block"></span></label>
										<input type="text" id="barnVolumn" name="barnVolumn" value="${barnPlan.barnVolumn}" readonly="readonly" class="form-control" />
									</div>
								</div>
								<div class="col-xs-6 col-md-3">
									<div class="form-group">
										<label><fmt:message key="barnPlan.realBarnVolumn" /><span class="help-block" style="color:red">*</span></label>
										<input type="text" id="realBarnVolumn" name="realBarnVolumn" value="${barnPlan.realBarnVolumn}" class="form-control"/>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-xs-6 col-md-3">
									<div class="form-group">
										<label><fmt:message key="barnPlan.transCode" /><span class="help-block"></span></label>
										<form:input type="text" readonly="true" path="transCode" class="form-control" />
									</div>
								</div>
								<div class="col-xs-6 col-md-3">
									<div class="form-group">
										<label><fmt:message key="barnPlan.barnEmptyDate" /><span class="help-block"></span></label>
										<input type="text"  value="${barnPlan.barnEmptyDateDisplay}" readonly="readonly" class="form-control">
									</div>
								</div>
								<div class="col-xs-6 col-md-3">
									<div class="form-group">
										<label><fmt:message key="barnPlan.realBarnEmptyDate" /><span class="help-block" style="color:red"> *</span></label>
										<input type="text" id="realBarnEmptyDateDisplay" value="${barnPlan.realBarnEmptyDateDisplay}" class="form-control daterange-single">
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="d-flex justify-content-end align-items-center">
						<a href="<c:url value="/barnPlan/list"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i><fmt:message key="button.back" /></a>
						<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_BARN_PLAN_CREATE')">
							<button type="button" id="btnSubmit" class="btn bgc-warning ml-3">	<fmt:message key="button.confirm" /><i class="icon-database-insert ml-2"></i></button>
						</security:authorize>
					</div>
				</fieldset>
			</div>
		</div>
		<!-- /basic layout -->
	</form:form>
</div>
<!-- /content area -->