<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="stockbalance.form.title"/></title>
    <meta name="menu" content="stockbalanceMenu"/>
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
<form:form id="stockbalanceForm" modelAttribute="stockbalance" action="<c:url value='/stockbalance/save'/>" method="post" role="form">
	<form:hidden path="id"/>
	
	<!-- Basic layout-->
	<div class="card">
		<div class="card-header header-elements-inline"><span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="stockbalance.form.title"/></span></div>
		<div class="card-body">
			<p class="mb-4"><fmt:message key="stockbalance.form.title.description"/></p>
			<fieldset class="mb-3">
				<legend class="text-uppercase font-size-sm font-weight-bold"><fmt:message key="template.legend"/></legend>
				<div class="card">
					<div class="card-body">
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="stockbalance.id"/><span class="help-block">*</span></label>
									<input type="text" id="stockbalanceId" name="id" value="${stockbalance.id}" class="form-control" required="required" maxlength="19"/>
									<div><span id="msgForId" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="stockbalance.stockCode"/><span class="help-block">*</span></label>
									<input type="text" id="stockbalanceStockCode" name="stockCode" value="${stockbalance.stockCode}" class="form-control" required="required" maxlength="30"/>
									<div><span id="msgForStockCode" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="stockbalance.content"/><span class="help-block">*</span></label>
									<input type="text" id="stockbalanceContent" name="content" value="${stockbalance.content}" class="form-control" required="required" maxlength="1,073,741,824"/>
									<div><span id="msgForContent" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="stockbalance.eventCode"/><span class="help-block"></span></label>
									<input type="text" id="stockbalanceEventCode" name="eventCode" value="${stockbalance.eventCode}" class="form-control"  maxlength="30"/>
									<div><span id="msgForEventCode" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="stockbalance.eventType"/><span class="help-block"></span></label>
									<input type="text" id="stockbalanceEventType" name="eventType" value="${stockbalance.eventType}" class="form-control"  maxlength="30"/>
									<div><span id="msgForEventType" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="stockbalance.latest"/><span class="help-block">*</span></label>
									<input type="text" id="stockbalanceLatest" name="latest" value="${stockbalance.latest}" class="form-control" required="required" maxlength="1"/>
									<div><span id="msgForLatest" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="stockbalance.createdDate"/><span class="help-block"></span></label>
									<input type="text" id="stockbalanceCreatedDate" name="createdDate" value="${stockbalance.createdDate}" class="form-control"  maxlength="19"/>
									<div><span id="msgForCreatedDate" style="color:red"></span></div>
								</div>
							</div>
						</div>							
					</div>
				</div>
				<div class="d-flex justify-content-end align-items-center">
					<a href="<c:url value="/stockbalance/list?id=${stockbalance.id}"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i><fmt:message key="button.back"/></a>
					<button type="submit" id="stockbalanceSubmit" class="btn btn-primary ml-3"><fmt:message key="button.save"/><i class="icon-database-insert ml-2"></i></button>			
				</div>			
			</fieldset>
		</div>
	</div>
	<!-- /basic layout -->
</form:form>
</div>
<!-- /content area -->
