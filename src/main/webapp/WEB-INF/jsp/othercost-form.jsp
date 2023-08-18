<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="othercost.form.title"/></title>
    <meta name="menu" content="othercostMenu"/>
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
<form:form id="othercostForm" modelAttribute="othercost" action="<c:url value='/othercost/save'/>" method="post" role="form">
	<form:hidden path="id"/>
	
	<!-- Basic layout-->
	<div class="card">
		<div class="card-header header-elements-inline"><span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="othercost.form.title"/></span></div>
		<div class="card-body">
			<p class="mb-4"><fmt:message key="othercost.form.title.description"/></p>
			<fieldset class="mb-3">
				<legend class="text-uppercase font-size-sm font-weight-bold"><fmt:message key="template.legend"/></legend>
				<div class="card">
					<div class="card-body">
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="othercost.id"/><span class="help-block">*</span></label>
									<input type="text" id="othercostId" name="id" value="${othercost.id}" class="form-control" required="required" maxlength="19"/>
									<div><span id="msgForId" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="othercost.type"/><span class="help-block">*</span></label>
									<input type="text" id="othercostType" name="type" value="${othercost.type}" class="form-control" required="required" maxlength="50"/>
									<div><span id="msgForType" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="othercost.cost"/><span class="help-block">*</span></label>
									<input type="text" id="othercostCost" name="cost" value="${othercost.cost}" class="form-control" required="required" maxlength="19"/>
									<div><span id="msgForCost" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="othercost.unit"/><span class="help-block"></span></label>
									<input type="text" id="othercostUnit" name="unit" value="${othercost.unit}" class="form-control"  maxlength="30"/>
									<div><span id="msgForUnit" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="othercost.month"/><span class="help-block"></span></label>
									<input type="text" id="othercostMonth" name="month" value="${othercost.month}" class="form-control"  maxlength="10"/>
									<div><span id="msgForMonth" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="othercost.year"/><span class="help-block"></span></label>
									<input type="text" id="othercostYear" name="year" value="${othercost.year}" class="form-control"  maxlength="10"/>
									<div><span id="msgForYear" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="othercost.recordDate"/><span class="help-block"></span></label>
									<input type="text" id="othercostRecordDate" name="recordDate" value="${othercost.recordDate}" class="form-control"  maxlength="19"/>
									<div><span id="msgForRecordDate" style="color:red"></span></div>
								</div>
							</div>
						</div>							
					</div>
				</div>
				<div class="d-flex justify-content-end align-items-center">
					<a href="<c:url value="/othercost/list?id=${othercost.id}"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i><fmt:message key="button.back"/></a>
					<button type="submit" id="othercostSubmit" class="btn btn-primary ml-3"><fmt:message key="button.save"/><i class="icon-database-insert ml-2"></i></button>			
				</div>			
			</fieldset>
		</div>
	</div>
	<!-- /basic layout -->
</form:form>
</div>
<!-- /content area -->

