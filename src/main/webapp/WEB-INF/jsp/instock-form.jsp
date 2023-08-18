<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="instock.form.title"/></title>
    <meta name="menu" content="instockMenu"/>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/extensions/jquery_ui/interactions.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
    <script src="/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js"></script>
    <!-- Multi selecte -->
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/uniform.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/pnotify.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/bootstrap_multiselect.js'/>"></script>
    
    <script src="<c:url value='/themes/admin/global_assets/js/demo_pages/form_multiselect.js'/>"></script>
    <!-- Datepicker -->
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/ui/moment/moment.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/daterangepicker.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/anytime.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.date.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.time.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/legacy.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/jgrowl.min.js'/>"></script>
    
    <script src="<c:url value='/themes/admin/assets/js/instock_form.js'/>"></script>
</head>

<!-- Content area -->
<div class="content">
<form:form id="instockForm" modelAttribute="instock" action="<c:url value='/instock/save'/>" method="post" role="form">
	<form:hidden path="id"/>
	<!-- Basic layout-->
	<div class="card">
		<div class="card-header header-elements-inline"><span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="instock.form.title"/></span></div>
		<div class="card-body">
			<fieldset class="mb-3">
				<legend class="text-uppercase font-size-sm font-weight-bold"><fmt:message key="template.legend"/></legend>
				<div class="card">
					<div class="card-body">
						<div class="row">
							<div class="col-xs-12 col-md-4">
								<div class="form-group">
									<label ><fmt:message key="instock.farmCode"/><span class="help-block"></span></label>
									<input type="text" id="instockStockCode" name="stockCode" value="${instock.stock.code}" class="form-control" required="required" maxlength="30" readonly="readonly"/>
									<div><span id="msgForStockCode" style="color:red"></span></div>
								</div>
							</div>
							<div class="col-xs-12 col-md-4">
								<div class="form-group">
									<label ><fmt:message key="instock.farmName"/><span class="help-block"></span></label>
									<input type="text" id="instockStockname" name="stockName" value="${instock.stock.name}" class="form-control" required="required" maxlength="30" readonly="readonly"/>
									<div><span id="msgForStockCode" style="color:red"></span></div>
								</div>
							</div>
							<div class="col-xs-12 col-md-4">
								<div class="form-group">
									<label ><fmt:message key="instock.syncDate"/><span class="help-block"></span></label>
									<input type="text" id="instockSyncDate" name="syncDate" value="${instock.displaySyncDate}" class="form-control daterange-single" required="required" maxlength="19" readonly="readonly"/>
									<div><span id="msgForSyncDate" style="color:red"></span></div>
								</div>
							</div>
						</div>		
						<jsp:include page="instock-material-selector.jsp"/>					
					</div>
				</div>
				<div class="d-flex justify-content-end align-items-center">
					<a href="<c:url value="/instock/list"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i><fmt:message key="button.back"/></a>
					<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_INSTOCK_EXPORT')">
						<a href="<c:url value='/instock/Export/${instock.id}'/>" class="btn btn-sm btn-primary" title="<fmt:message key="button.export"/>"><i class="icon-file-upload"></i> <fmt:message key="button.export" /></a>
					</security:authorize>
				</div>			
			</fieldset>
		</div>
	</div>
	<!-- /basic layout -->
</form:form>
</div>
<!-- /content area -->
