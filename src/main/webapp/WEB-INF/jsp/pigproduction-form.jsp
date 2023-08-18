<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="pigprod.form.title"/></title>
    <meta name="menu" content="processOrderMenu"/>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/assets/js/pigproduction_form.js'/>"></script>
    <script src="<c:url value='/themes/admin/assets/js/material_selector.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>
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
	<form:form id="pigProductionForm" modelAttribute="event" action="${ctx}/pigProduction/save" method="post" role="form">
		<form:hidden path="id" />
		<form:hidden path="createdBy" />
		<form:hidden path="modifiedBy" />
		<form:hidden path="code" id="code"/>
		<form:hidden path="createdDate" id="createdDate"/>
		<form:hidden path="modifiedDate" id="modifiedDate"/>
		<form:hidden path="postingDate" id="postingDate"/>
		<form:hidden path="status" id="status"/>
		<form:hidden path="type" id="type"/>
		<input type="hidden" id="processOrderCode" value="${event.processOrderCode }"/>
		<input type="hidden" id="pigProdMaterialCode" value="${event.pigProd.materialCode }"/>
		<input type="hidden" id="pigProdMaterialName" value="${event.pigProd.materialName }"/>
		<!-- Basic layout-->
		<div class="card">
			<div class="card-header header-elements-inline">
				<span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="pigprod.form.title" /> - <c:out value = "${processOrder.barn.farm.name}"/> - <c:out value = "${processOrder.barn.code}"/></span>
			</div>
			<div class="card-body">
				<p class="mb-4"><fmt:message key="pigprod.form.title.description" /></p>
				<fieldset class="mb-3">
					<legend class="text-uppercase font-size-sm font-weight-bold"><fmt:message key="template.legend" /></legend>
					<div class="card">
						<div class="card-body">
							<div class="row">
								<div class="col-xs-4 col-md-4">
									<div class="form-group">
										<label><fmt:message key="pigprod.processOrderCode" /><span class="help-block">*</span></label>
										<form:input type="text" id="pigProdProcessOrderCode" path="processOrderCode" class="form-control" readonly="true" />
									</div>
								</div>
								<div class="col-xs-4 col-md-4">
									<div class="form-group">
										<label><fmt:message key="event.transCode" /><span class="help-block">*</span></label>
										<form:input type="text" id="transCode" path="transCode" class="form-control" readonly="true" />
									</div>
								</div>
								<div class="col-xs-4 col-md-4">
									<div class="form-group">
										<label><fmt:message key="material.code" /><span class="help-block">*</span></label>
										<form:hidden id="materialName" path="pigProd.materialName" class="form-control"/>
										<select id="materialCode" name="pigProd.materialCode" class="form-control select2" data-placeholder="Chọn loại">
											<option value=""></option>
											<c:forEach var="item" items="${materialDtos}">
									            <option value="${item.code}" ${item.code == event.pigProd.materialCode ? 'selected="selected"' : ''}><c:out value = "${item.code} - ${item.name}"/></option>
									        </c:forEach>
										</select>
									</div>
								</div>
							</div>
							
							<div class="row">
								<div class="col-xs-4 col-md-4">
									<div class="form-group">
										<label><fmt:message key="pigprod.quantity" /><span class="help-block">*</span></label>
										<form:input type="text" id="pigProdQuantity" path="pigProd.quantity" class="form-control"/>
										<span id="msgQuantity" style="color:red"></span>
									</div>
								</div>
								<div class="col-xs-6 col-md-4">
									<div class="form-group">
										<label><fmt:message key="pigdead.weight" /><span class="help-block"></span></label>
										<form:input type="text" id="pigProdWeight" path="pigProd.weight" class="form-control"/>
										<span id="msgWeight" style="color:red"></span>
									</div>
								</div>
								<div class="col-xs-6 col-md-4">
									<div class="form-group">
										<label><fmt:message key="pigprod.reason" /><span class="help-block"></span></label>
										<%-- <form:input type="text" id="pigProdReason" path="pigProd.reason" class="form-control" /> --%>
										<c:choose>
											<c:when test="${empty event.id}">
												<form:select id="pigProdReason" class="form-control select2" path="pigProd.reason" data-placeholder="Chọn nguyên nhân...">
													<c:forEach items="${ reasons }" var="reason" varStatus="cnt">
														<option value="${reason}" ${event.pigProd.reason == reason ? 'selected="selected"' : '' }>${reason}</option>
													</c:forEach>
												</form:select>
											</c:when>
											<c:when test="${!empty event.id && fn:contains(reasonStr, event.pigProd.reason)}">
												<form:select id="pigProdReason" class="form-control select2" path="pigProd.reason" data-placeholder="Chọn nguyên nhân...">
													<c:forEach items="${ reasons }" var="reason" varStatus="cnt">
														<option value="${reason}" ${event.pigProd.reason == reason ? 'selected="selected"' : '' }>${reason}</option>
													</c:forEach>
												</form:select>
											</c:when>
											<c:otherwise>
												<form:input type="text" id="pigProdReason" path="pigProd.reason" class="form-control"/>
											</c:otherwise>
										</c:choose>
										<span id="msgReason" style="color:red"></span>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-xs-12 col-md-4">
									<div class="form-group">
										<label><fmt:message key="pigdead.posting.date" /><span class="help-block">*</span></label>
										<input type="text" id="displayCreatedDate" value="${event.displayPostingDate}" class="form-control daterange-single" readonly="readonly" />
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="d-flex justify-content-end align-items-center">
						<a href="<c:url value="/pigProduction/list?poCode=${event.processOrderCode}"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i><fmt:message key="button.back" /></a>
						<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_FINISH_PRODUCT_CREATE')">
						<c:if test="${empty event.id}">
							<button type="button" id="btnSubmit" class="btn btn-primary ml-3"><fmt:message key="button.save" /><i class="icon-database-insert ml-2"></i></button>
						</c:if>
						</security:authorize>
						<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_FINISH_PRODUCT_CANCEL')">
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