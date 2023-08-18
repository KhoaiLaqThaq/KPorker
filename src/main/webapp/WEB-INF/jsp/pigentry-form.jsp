<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
<title><fmt:message key="pigentry.form.title" /></title>
<meta name="menu" content="processOrderMenu" />
<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/switch.min.js'/>"></script>	
	<script	src="<c:url value='/themes/admin/assets/js/goodsreceipt_material_selector.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>
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
	<form:form id="pigentryForm" modelAttribute="pigEntry" action="${ctx}/pigEntry/save" method="post" role="form">
		<form:hidden path="id" id="pigEntryId"/>
		<form:hidden path="entryDate" id="entryDate"/>
		<form:hidden path="status" id="status"/>
		<form:hidden path="transCode" id="transCode"/>
		<form:hidden  path="receiveFarm"  id="receiveFarmInput" value="${receiveFarm.code}"/>
		<input type="text" hidden="hidden" id="processOrderStatus" value = "${processOrder.status}" />
		<input type="text" hidden="hidden" id="processOrderStartDate" value = "${processOrder.startDate}"/>
		<!-- Basic layout-->
		<div class="card">
			<div class="card-header header-elements-inline">
				<span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="pigentry.form.title" /> - <c:out value = "${processOrder.barn.farm.name}"/> - <c:out value = "${processOrder.barn.code}"/></span>
			</div>
			<div class="card-body">
				<p class="mb-4">
					<fmt:message key="pigentry.form.title.description" />
				</p>
				<fieldset class="mb-3">
					<legend class="text-uppercase font-size-sm font-weight-bold">
						<fmt:message key="template.legend" />
					</legend>
					<div class="card">
						<div class="card-body">

							<div class="row">
								<div class="col-xs-4 col-md-4">
									<div class="form-group">
										<label><fmt:message key="pigentry.processOrderCode" /><span class="help-block">*</span></label>
										<input type="text" id="pigentryProcessOrderCode" readOnly name="processOrderCode" value="${pigEntry.processOrderCode}" class="form-control"
											required="required" maxlength="50" />
										<div>
											<span id="msgForProcessOrderCode" style="color: red"></span>
										</div>
									</div>
								</div>
								<div class="col-xs-4 col-md-4">
									<div class="form-group">
										<label><fmt:message key="pigentry.ageWeek" /><span class="help-block">*</span></label>
										<input type="text" id="pigentryAgeWeek" name="ageWeek" value="${pigEntry.ageWeek}" class="form-control" maxlength="10" />
										<div>
											<span id="msgForAgeWeek" style="color: red"></span>
										</div>
									</div>
								</div>


								<div class="col-xs-4 col-md-4">
									<div class="form-group">
										<label><fmt:message key="pigentry.entryDate" /><span class="help-block">*</span></label>
										<input type="text" id="displayPigEntryDate"  name="entryDate" value="${pigEntry.displayEntryDate}" class="form-control daterange-single"/>
										<div>
											<span id="msgForEntryDate" style="color: red"></span>
										</div>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-xs-4 col-md-4">
									<div class="form-group">
										<label><fmt:message key="pigentry.sourceFarm" /><span class="help-block"></span></label>
										<select id="pigentrySourceFarm"  name="sourceFarm" value="${pigEntry.sourceFarm}" class="form-control select2">
											<c:forEach items="${ sourceFarms }" var="sFarm" varStatus="cnt">
											<option value="${sFarm.code}" ${pigEntry.sourceFarm == sFarm.code ? 'selected="selected"' : '' }>${sFarm.name}</option>
											</c:forEach>
										</select>
										<div>
											<span id="msgForSourceFarm" style="color: red"></span>
										</div>
									</div>
								</div> 
								<div class="col-xs-4 col-md-4">
									<div class="form-group">
										<label><fmt:message key="pigentry.receiveFarm" /><span class="help-block"></span></label>
											<input id="pigentryReceiveFarm"   value="${receiveFarm.name}"  class="form-control" readonly="readonly">
										<div>
											<span id="msgForReceiveFarm" style="color: red"></span>
										</div>
									</div>
								</div>
								<div class="col-xs-4 col-md-4">
									<div class="form-group">
										<label><fmt:message key="material.code" /><span class="help-block">*</span></label>
										<select id="materialCode" name="materialCode" class="form-control select2" data-placeholder="Chọn loại">
											<option value=""></option>
											<c:forEach var="item" items="${materialDtos}">
									            <option value="${item.code}" ${item.code == pigEntry.materialCode ? 'selected="selected"' : ''}><c:out value = "${item.code} - ${item.name}"/></option>
									        </c:forEach>
										</select>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-xs-4 col-md-4">
									<div class="form-group">
										<label><fmt:message key="pigentry.materialBatch" /><span class="help-block"></span></label>
										<input type="text" id="pigentryMaterialBatch" name="materialBatch" value="${pigEntry.materialBatch}" class="form-control" />
									</div>
								</div>
								<div class="col-xs-4 col-md-4">
									<div class="form-group">
										<label><fmt:message key="pigentry.quantity" /><span class="help-block">*</span></label>
										<input type="text" id="pigentryQuantity" name="quantity" value="${pigEntry.quantity}" class="form-control"/>
										<div>
											<span id="msgForQuantity" style="color: red"></span>
										</div>
									</div>
								</div>
								<div class="col-xs-4 col-md-4">
									<div class="form-group">
										<label><fmt:message key="pigentry.entryVolumnTotal" /><span class="help-block">*</span></label>
										<input type="text" id="pigentryEntryVolumnTotal" name="totalEntryVolumn" value="${pigEntry.totalEntryVolumn}" class="form-control"
											maxlength="9" />
										<div>
											<span id="msgForEntryVolumnTotal" style="color: red"></span>
										</div>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-xs-4 col-md-4">
									<div class="form-group">
										<label><fmt:message key="pigentry.averageVolume" /><span class="help-block"></span></label>
										<input type="text" id="pigentryAverageVolume" readOnly name="averageVolume" value="${pigEntry.averageVolume}" class="form-control" maxlength="9" />
										<div>
											<span id="msgForAverageVolume" style="color: red"></span>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="d-flex justify-content-end align-items-center">
						<a href="<c:url value="/pigEntry/list?code=${pigEntry.processOrderCode}"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i><fmt:message key="button.back" /></a>
						<security:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_PIG_ENTRY_CREATE')">
							<%-- <c:if test="${empty pigEntry.id}">
								<button type="button" id="btnSubmit" class="btn btn-primary ml-3"><fmt:message key="button.save" /><i class="icon-database-insert ml-2"></i></button>
							</c:if> --%>
							<button type="button" id="btnSubmit" class="btn btn-primary ml-3"><fmt:message key="button.save" /><i class="icon-database-insert ml-2"></i></button>
						</security:authorize>
						<security:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_PIG_ENTRY_CANCEL')">
							<c:if test="${not empty pigEntry.id and processOrder.status != 'closed' and pigEntry.status != 'cancel'}">
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

<script src="<c:url value='/themes/admin/assets/js/pigentry_form.js'/>"></script>
<script src="<c:url value='/themes/admin/assets/js/agent_form.js'/>"></script>

<div class="modal hide" id="pleaseWaitDialog" data-backdrop="static" data-keyboard="false">
    <div class="modal-body">
        <div class="loading">Loading&#8230;</div>
    </div>
</div>