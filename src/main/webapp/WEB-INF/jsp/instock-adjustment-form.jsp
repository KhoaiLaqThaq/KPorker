<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
	<c:choose>
        <c:when test = "${empty instockAdjustment.id}">
           <title><fmt:message key="instockAdjustment.form.title" /></title>
        </c:when>
        <c:otherwise>
           <title><fmt:message key="instockAdjustment.form.detail" /></title>
        </c:otherwise>
     </c:choose>
	<meta name="menu" content="instockAdjustmentMenu" />
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/extensions/jquery_ui/interactions.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/uniform.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/pnotify.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/assets/js/instockAdjustment_form.js'/>"></script>
	<script src="<c:url value='/themes/admin/assets/js/instockAdjustment_material_selector.js'/>"></script>
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
	<form:form id="instockAdjustmentForm" modelAttribute="instockAdjustment" action="${ctx}/instockAdjustment/save" method="post" role="form">
		<form:hidden path="id" id="id" />
		<form:hidden path="postingDate" id="postingDate"/>
		<form:hidden path="status" id="status" />
		<form:hidden id="createdDate" path="createdDate"/>
		<form:hidden id="modifiedDate" path="modifiedDate"/>
		<input type="hidden" name="createdBy" value="${instockAdjustment.username}">
		<!-- Basic layout-->
		<div class="card">
			<div class="card-header header-elements-inline">
				<c:choose>
			        <c:when test = "${empty instockAdjustment.id}">
			           <span class="text-uppercase font-size-lg font-weight-bold"><fmt:message	key="instockAdjustment.form.title" /></span>
			        </c:when>
			        <c:otherwise>
			           <span class="text-uppercase font-size-lg font-weight-bold"><fmt:message	key="instockAdjustment.form.detail" /></span>
			        </c:otherwise>
			     </c:choose>
			</div>
			<div class="card-body">
				<fieldset class="mb-3">
					<legend class="text-uppercase font-size-sm font-weight-bold">
						<fmt:message key="template.legend" />
					</legend>
					<div class="card">
						<div class="card-body">
							<div class="row">
								<div class="col-xs-12 col-md-3">
									<div class="form-group">
										<label><fmt:message key="instockAdjustment.stockCode" /><span class="help-block">*</span></label>
										<select	id="instockAdjustmentFromStockCode" name="stock.code" class="form-control select2" data-placeholder="Chọn mã kho">
										    <option value=""></option>
											<c:forEach var="item" items="${farms}">
									            <option value="${item.code}" ${item.code == instockAdjustment.stock.code ? 'selected="selected"' : ''}><c:out value="${item.code} - ${item.name}"></c:out></option>
									        </c:forEach>
										</select>
									</div>
								</div>
								<div class="col-xs-12 col-md-3">
									<div class="form-group">
										<label><fmt:message key="instockAdjustment.type" /><span class="help-block">*</span></label>
										<select	id="instockAdjustmentType" class="form-control select2" name="type" data-placeholder="Chọn loại điều chỉnh">
											<c:forEach var="item" items="${types}">
									            <option value="${item}" ${item == instockAdjustment.type ? 'selected="selected"' : ''}><fmt:message key="instockAdjustment.type.${item}"></fmt:message></option>
									        </c:forEach>
										</select>
									</div>
								</div>
								<div class="col-xs-4 col-md-3">
									<div class="form-group">
										<label><fmt:message key="goodsreceipt.postingDate" /><span class="help-block">*</span></label>
										<input type="text" id="instockAdjustmentDisplayPostingDate" name="displayPostingDate" value="${instockAdjustment.displayPostingDate}" class="form-control daterange-single" readonly />
									</div>
								</div>
								<div class="col-xs-12 col-md-3">
									<div class="form-group">
										<label><fmt:message key="instockAdjustment.transCode" /><span class="help-block"></span></label>
										<form:input type="text" id="instockAdjustmentTransCode" class="form-control" readonly="true" path="transCode"/>
									</div>
								</div>
							</div>
							<jsp:include page="instock-adjustment-material-selector.jsp" />
						</div>
					</div>
					<div class="d-flex justify-content-end align-items-center">
						<a href="<c:url value="/instockAdjustment/list"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i> <fmt:message key="button.back" /></a>
						<c:if test ="${not empty instockAdjustment.id && instockAdjustment.status eq 'confirmed' && instockAdjustment.type ne 'import'}">
							<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_INSTOCK_ADJUSTMENT_CANCEL')">
								<button type="button" class="btn btn-danger ml-3" data-toggle="modal" data-target="#modalCancel" data-backdrop="static" data-keyboard="false"><fmt:message key="button.cancel.transaction" /><i class="icon-cancel-square ml-2"></i></button>
							</security:authorize>
						</c:if>
						<c:if test ="${empty instockAdjustment.id }">
							<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_INSTOCK_ADJUSTMENT_CREATE')">
								<button type="button" id="btnSubmit" class="btn btn-primary ml-3"><fmt:message key="button.save" /><i class="icon-database-insert ml-2"></i></button>
							</security:authorize>
						</c:if>
						
					</div>
				</fieldset>
			</div>
		</div>
		<!-- /basic layout -->
		
		<!-- cancel form modal -->
		<div id="modalCancel" class="modal fade" tabindex="-1">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title"><fmt:message key="cancel.transaction" /></h5>
						<button type="button" class="close" data-dismiss="modal">&times;</button>
					</div>
					<form action="#">
						<div class="modal-body">
							<div class="form-group">
								<div class="row">
									<div class="col-sm-12">
										<label><fmt:message key="instock.adjustment.cancel.transaction.description" /></label>
									</div>
								</div>
							</div>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-link" data-dismiss="modal"><fmt:message key="button.close.modal" /></button>
							<button type="button" id="btnCancelTrans" class="btn bg-primary"><fmt:message key="button.confirm" /></button>
						</div>
					</form>
				</div>
			</div>
		</div>
		<!-- /cancel form modal -->
	</form:form>
</div>
<!-- /content area -->

<div class="modal hide" id="pleaseWaitDialog" data-backdrop="static" data-keyboard="false">
    <div class="modal-body">
        <div class="loading">Loading&#8230;</div>
    </div>
</div>