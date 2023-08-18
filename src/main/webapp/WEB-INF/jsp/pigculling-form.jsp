<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="pigdead.form.title"/></title>
    <meta name="menu" content="processOrderMenu"/>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/assets/js/pigculling_form.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/ui/moment/moment.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/daterangepicker.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/anytime.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.date.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/legacy.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/jgrowl.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
    <!-- Map -->
</head>

<!-- Content area -->
<div class="content">
	<form:form id="pigcullingForm" modelAttribute="event" action="${ctx}/pigCulling/save" method="post" role="form">
		<form:hidden path="id" />
		<form:hidden path="createdBy" />
		<form:hidden path="modifiedBy" />
		<form:hidden path="code" id="code"/>
		<form:hidden path="createdDate" id="createdDate"/>
		<form:hidden path="postingDate" id="postingDate"/>
		<form:hidden path="modifiedDate" id="modifiedDate"/>
		<form:hidden path="status" id="status"/>
		<input type="hidden" id="processOrderCode" value="${event.processOrderCode }"/>
		<input type="hidden" id="pigCullingMaterialCode" value="${event.pigCulling.materialCode }"/>
		<input type="hidden" id="pigCullingMaterialName" value="${event.pigCulling.materialName }"/>
		<!-- Basic layout-->
		<div class="card">
			<div class="card-header header-elements-inline">
				<span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="pigdead.form.title" /> - <c:out value = "${processOrder.barn.farm.name}"/> - <c:out value = "${processOrder.barn.code}"/></span>
			</div>
			<div class="card-body">
				<p class="mb-4"><fmt:message key="pigdead.form.title.description" /></p>
				<fieldset class="mb-3">
					<legend class="text-uppercase font-size-sm font-weight-bold"><fmt:message key="template.legend" /></legend>
					<div class="card">
						<div class="card-body">
							<div class="row">
								<div class="col-xs-4 col-md-6">
									<div class="form-group">
										<label><fmt:message key="pigdead.processOrderCode" /><span class="help-block">*</span></label>
										<form:input type="text" id="pigdeadProcessOrderCode" path="processOrderCode" class="form-control" readonly="true" />
									</div>
								</div>
								<div class="col-xs-4 col-md-6">
									<div class="form-group">
										<label><fmt:message key="event.transCode" /><span class="help-block">*</span></label>
										<form:input type="text" id="transCode" path="transCode" class="form-control" readonly="true" />
									</div>
								</div>
							</div>
							
							<div class="row">
								<div class="col-xs-4 col-md-6">
									<div class="form-group">
										<label><fmt:message key="pigdead.type" /><span class="help-block">*</span></label>
										<select name="type" id="pigdeadType" class="form-control select2" data-placeholder="Chọn loại">
											<option value=""></option>
											<c:forEach var="item" items="${eventTypes}">
									            <option value="${item}" ${item == event.type ? 'selected="selected"' : ''}><fmt:message key="event.type.${item}"></fmt:message></option>
									        </c:forEach>
										</select>
									</div>
								</div>
								<div class="col-xs-4 col-md-6">
									<div class="form-group">
										<label><fmt:message key="material.code" /><span class="help-block">*</span></label>
										<form:hidden id="materialName" path="pigCulling.materialName" class="form-control"/>
										<select id="materialCode" name="pigCulling.materialCode" class="form-control select2" data-placeholder="Chọn loại" disabled="disabled">
											<option value=""></option>
											<c:forEach var="item" items="${materialDtos}">
									            <option value="${item.code}" ${item.code == event.pigCulling.materialCode ? 'selected="selected"' : ''}><c:out value = "${item.code} - ${item.name}"/></option>
									        </c:forEach>
										</select>
									</div>
								</div>
							</div>
							
							<div class="row">
								<div class="col-xs-4 col-md-6">
									<div class="form-group">
										<label><fmt:message key="pigdead.quantity" /><span class="help-block">*</span></label>
										<form:input type="text" id="pigdeadQuantity" path="pigCulling.quantity" class="form-control"/>
									</div>
								</div>
								<div class="col-xs-4 col-md-6">
									<div class="form-group">
										<label><fmt:message key="pigdead.weight" /><span class="help-block">*</span></label>
										<form:input type="text" id="pigdeadWeight" path="pigCulling.weight" class="form-control" />
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-xs-4 col-md-6">
									<div class="form-group">
										<label><fmt:message key="pigdead.reason" /><span class="help-block">*</span></label>
										<div id="reason1">
											<form:input type="text" id="pigdeadReason1" path="pigCulling.reason" class="form-control" />
										</div>
										<div id="reason2" class="hide">
											<select id="pigdeadReason2" name="pigCulling.reason" class="form-control select2" data-placeholder="Chọn loại" >
												<option value=""></option>
												<c:forEach var="item" items="${reasons}">
										            <option value="${item}" ${item == event.pigCulling.reason ? 'selected="selected"' : ''}><c:out value = "${item}"/></option>
										        </c:forEach>
											</select>
										</div>
									</div>
								</div>
								<div class="col-xs-12 col-md-6">
									<div class="form-group">
										<label><fmt:message key="pigdead.posting.date" /><span class="help-block">*</span></label>
										<input type="text" id="displayCreatedDate" value="${event.displayPostingDate}" class="form-control daterange-single" readonly="readonly" />
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="d-flex justify-content-end align-items-center">
						<a href="<c:url value="/pigCulling/list?poCode=${event.processOrderCode}"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i><fmt:message key="button.back" /></a>
						<security:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_PIG_CULLING_CREATE')">
							<c:if test="${empty event.id}">
								<button type="button" id="btnSubmit" class="btn btn-primary ml-3"><fmt:message key="button.save" /><i class="icon-database-insert ml-2"></i></button>
							</c:if>
						</security:authorize>
						<security:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_PIG_CULLING_CANCEL')">
							<c:if test="${not empty event.id and processOrder.status != 'closed' and event.status != 'cancel'}">
								<button type="button" id="btnCancel" class="btn btn-primary ml-3"><fmt:message key="button.cancel.transaction" /><i class="icon-database-insert ml-2"></i></button>
							</c:if>
						</security:authorize>
					</div>
				</fieldset>
			</div>
		</div>
		<!-- /basic layout -->
	</form:form>
</div>
<!-- /content area -->
<div class="modal hide" id="pleaseWaitDialog" data-backdrop="static" data-keyboard="false">
    <div class="modal-body">
        <div class="loading">Loading&#8230;</div>
    </div>
</div>