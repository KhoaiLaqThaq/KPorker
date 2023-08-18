<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="consumingWater.form.title"/></title>
    <meta name="menu" content="consumingWaterMenu"/>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/extensions/jquery_ui/interactions.min.js'/>"></script>
	
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/uniform.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/pnotify.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/bootstrap_multiselect.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/switch.min.js'/>"></script> 
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>
    
    <script src="/themes/admin/global_assets/js/plugins/ui/moment/moment.min.js"></script>
    <script src="/themes/admin/global_assets/js/plugins/pickers/daterangepicker.js"></script>
    <script src="/themes/admin/global_assets/js/plugins/pickers/anytime.min.js"></script>
    <script src="/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.js"></script>
    <script src="/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.date.js"></script>
    <script src="/themes/admin/global_assets/js/plugins/pickers/pickadate/legacy.js"></script>
    <script src="/themes/admin/global_assets/js/plugins/notifications/jgrowl.min.js"></script>
    <script src="/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js"></script>
    <!-- Map -->
</head>

<!-- Content area -->
<div class="content">
<form:form id="consumingWaterForm" modelAttribute="otherCost" action="/consumingWater/save" method="post" role="form">
	<form:hidden path="id"/>
	<form:hidden path="unit"/>
	<form:hidden path="month"/>
	<form:hidden path="year"/>
	<form:hidden path="transCode"/>
	
	<!-- Basic layout-->
	<div class="card">
		<div class="card-header header-elements-inline"><span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="consumingWater.form.title"/></span></div>
		<div class="card-body">
			<p class="mb-4"><fmt:message key="consumingWater.form.title.description"/></p>
			<fieldset class="mb-3">
				<legend class="text-uppercase font-size-sm font-weight-bold"><fmt:message key="template.legend"/></legend>
				<div class="card">
					<div class="card-body">
						<div class="row">
							<div class="col-xs-4 col-md-6">
								<div class="form-group">
									<label ><fmt:message key="consumingWater.barnCode"/><span class="help-block">*</span></label>
									<select class="form-control select2" name="farm.code" id="farm" data-placeholder="Chọn trại" required="required" data-fouc>
			                            <option value=""></option>
			                            <c:forEach items="${farms}" var="item">
			                                <option value="${item.code}" ${otherCost.farm.code eq item.code ? 'selected' : ''}>${item.name}</option>
			                            </c:forEach>
			                        </select>
								</div>
							</div>
							
							<div class="col-xs-4 col-md-6">
								<div class="form-group">
									<label ><fmt:message key="consumingWater.type"/><span class="help-block">*</span></label>
									<select id="otherCostType" name="type" class="select2 form-control" data-placeholder="Chọn loại tiêu thụ" required="required">
										<option value=""></option>
										<c:forEach items="${otherCostTypes}" var="item">
										   <option value="${item}" ${item eq otherCost.type ? 'selected':'' }><fmt:message key="otherCost.type.${item}"></fmt:message></option>
										</c:forEach>
									</select>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-xs-4 col-md-6">
								<div class="form-group">
									<label ><fmt:message key="consumingWater.createdDate"/><span class="help-block">*</span></label>
									<input type="text" id="recordDate" name="consumingDate" value="${otherCost.consumingDate}" required="required" class="form-control daterange-single"/>
								</div>
							</div>
							<div class="col-xs-4 col-md-6">
								<div class="form-group">
								    <label class="col-form-label col-lg-2 pt-0 px-0"><fmt:message key="consumingWater.total"/><span class="help-block">*</span></label>
                                    <div class="col-lg-12 px-0">
                                        <div class="input-group">
                                            <form:input id="cost" path="cost" required="required" class="form-control currency" placeholder="Nhập thành tiền..."  maxlength="9"/>
                                            <span class="input-group-append">
                                                <span class="input-group-text">VNĐ</span>
                                            </span>
                                        </div>
                                    </div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="d-flex justify-content-end align-items-center">
					<a href="<c:url value="/pigrelease/list?id=${pigrelease.id}"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i><fmt:message key="button.back"/></a>
					<button type="submit" id="otherCostSubmit" class="btn btn-primary ml-3"><fmt:message key="button.save"/><i class="icon-database-insert ml-2"></i></button>		
				</div>			
			</fieldset>
		</div>
	</div>
	<!-- /basic layout -->
</form:form>
</div>
<!-- /content area -->

<%-- <script src="<c:url value='/themes/admin/assets/js/consumingwater_form.js'/>"></script> --%>
<script src="<c:url value='/themes/admin/assets/js/select2.js'/>"></script>
<script src="<c:url value='/themes/admin/assets/js/datepicker.js'/>"></script>
<script src="<c:url value='/themes/admin/global_assets/js/autoNumeric/autoNumeric.js'/>"></script>
<script src="<c:url value='/themes/admin/assets/js/format_number.js'/>"></script>
<script>
$(document).ready(function() {
	formatNumberComponent.initAutoNumeric();

	$("#otherCostSubmit").on('click', function(e) {
	   e.preventDefault();
	   formatNumberComponent.disableAutoNumeric();   
	   $('#consumingWaterForm').submit();
	})
});
</script>