<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="event.form.title"/></title>
	<meta name="menu" content="goodsAttritionSupportMenu" />
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
	  <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/bootstrap_multiselect.js'/>"></script>
	<script src="<c:url value='/themes/admin/assets/js/goods_attrition_support_export_form.js'/>"></script>
	<script src="<c:url value='/themes/admin/assets/js/goods_attrition_support_export_selector.js'/>"></script>
</head>

<!-- Content area -->
<div class="content">
<form:form id="goodsAttritionSupportExportForm" modelAttribute="goodsIssue" action="${ctx}/goodsAttritionSupport/export" method="post" role="form">
	
	<form:hidden path="postingDateSearch" id="postingDateSearch"/>
	<form:hidden path="type" id="type"/>
	<!-- Basic layout-->
	<div class="card">
		<div class="card-header header-elements-inline">
			<span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="event.form.title"/></span>
		</div>
		<div class="card-body">
			<p class="mb-4"><fmt:message key="event.form.title.description"/></p>
			<fieldset class="mb-3">
				<legend class="text-uppercase font-size-sm font-weight-bold"><fmt:message key="template.legend"/></legend>
				<div class="card">
					<div class="card-body">
						<div class="row">
							<div class="col-xs-12 col-md-4">
								<div class="form-group">
									<label><fmt:message	key="purchaserequisition.stockCode" /><span	class="help-block">*</span></label>
									<select id="selectFarmCode" data-placeholder="Lựa chọn trại muốn export" class="form-control multiselect-select-all-filtering" name="farmCodeSelected" multiple="multiple" data-fouc>
										<c:forEach items="${farms}" var="item">
											<option value="${item.code}"><c:out value="${item.code} - ${item.name}"></c:out></option>
										</c:forEach>
									</select>
								</div>
							</div>
							<div class="col-xs-12 col-md-8">
								<div class="form-group">
									<label><fmt:message key="goodsissue.postingDate" /><span class="help-block">*</span></label>
									<input type="text" id="goodsIssuePostingDate" class="form-control daterange-basic" />
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="d-flex justify-content-end align-items-center">
					<a href="<c:url value="/goodsAttritionSupport/list"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i><fmt:message key="button.back"/></a>
					<button type="button" id="btnSubmit" class="btn btn-primary ml-3"><fmt:message key="button.export"/><i class="icon-database-insert ml-2"></i></button>		
				</div>			
			</fieldset>
		</div>
	</div>
	<!-- /basic layout -->
</form:form>
</div>
<!-- /content area -->