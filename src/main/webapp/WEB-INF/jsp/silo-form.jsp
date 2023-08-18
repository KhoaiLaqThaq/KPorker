<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="silo.form.title"/></title>
	<meta name="menu" content="siloMenu" />
    <script src="/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js"></script>
	<script src="/themes/admin/global_assets/js/plugins/forms/styling/switch.min.js"></script>	
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>
	<script src="/themes/admin/global_assets/js/plugins/ui/moment/moment.min.js"></script>
	<script src="/themes/admin/global_assets/js/plugins/pickers/daterangepicker.js"></script>
	<script src="/themes/admin/global_assets/js/plugins/pickers/anytime.min.js"></script>
	<script src="/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.js"></script>
	<script src="/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.date.js"></script>
	<script src="/themes/admin/global_assets/js/plugins/pickers/pickadate/legacy.js"></script>
	<script src="/themes/admin/global_assets/js/plugins/notifications/jgrowl.min.js"></script>
	<script src="/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js"></script>
	<script src="<c:url value='/themes/admin/assets/js/silo_form.js'/>"></script>
</head>

<!-- Content area -->
<div class="content">
<form:form id="siloForm" modelAttribute="silo" action="${ctx}/silo/save" method="post" role="form">	
	<form:hidden path="id"/>
	<form:hidden path="farmCode" value = "${farm.code}"/>
	<form:hidden path="username" value= ""/>
	<form:hidden path="transCode"/>
	<form:hidden path="createdDate"/>
	<form:hidden path="createdBy"/>
	<div class="card">
		<div class="card-header header-elements-inline">
			<span class="text-uppercase font-size-lg font-weight-bold"> <c:out value = "${farm.name}"/> - <c:out value = "${farm.code}"/></span>
		</div>
		<div class="card-body">
			<p class="mb-4"><fmt:message key="silo.form.title.description"/></p>
			<fieldset class="mb-3">
				<legend class="text-uppercase font-size-sm font-weight-bold"><fmt:message key="template.legend"/></legend>
				<div class="card">
					<div class="card-body">
						<div class="row">
							<div class="col-xs-12 col-md-6">
								<div class="form-group">
									<label ><fmt:message key="silo.form.barn"/><span class="help-block">*</span></label>
									<form:input type="text" id="barnCode" path="barn.code" class="form-control" readonly="true"/>
								</div>
							</div>
							<div class="col-xs-12 col-md-6">
								<div class="form-group">
									<label><fmt:message key="silo.amount" /><span class="help-block">*</span></label>
									<form:input type="text" id="amountId" path="amount" class="form-control" />
									<div><span id="msgForId" style="color:red"></span></div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="d-flex justify-content-end align-items-center">
					<a href="<c:url value="/silo/list?farmCode=${farm.code}"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i><fmt:message key="button.back"/></a>					
					<button type="button" id="btnSubmit" class="btn btn-primary ml-3"><fmt:message key="button.save"/><i class="icon-database-insert ml-2"></i></button>		
				</div>			
			</fieldset>
		</div>
	</div>
	<!-- /basic layout -->
</form:form>
</div>
