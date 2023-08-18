<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
	<c:choose>
        <c:when test = "${empty goodsReceipt.id}">
           <title><fmt:message key="goodsreceipt.form.title" /></title>
        </c:when>
        <c:otherwise>
           <title><fmt:message key="goodsreceipt.form.detail" /></title>
        </c:otherwise>
     </c:choose>
	<meta name="menu" content="goodsReceiptRequisitionMenu"/>
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
	<script	src="<c:url value='/themes/admin/assets/js/goodsreceipt_form.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
</head>

<!-- Content area -->
<div class="content">
	<form:form id="goodsreceiptForm" modelAttribute="goodsReceipt" action="${ctx}/goodsReceipt/save" method="post" role="form">
		<form:hidden path="id" id="goodsReceiptId"/>
		<form:hidden path="postingDate" id="postingDate"/>
		<form:hidden path="status" id="status" />
		<form:hidden path="type" id="type" />
		<form:hidden id="templateName" path="templateName"/>
		<form:hidden path="movementType" id="movementType" />
		<form:hidden id="createdDate" path="createdDate"/>
		<form:hidden id="modifiedDate" path="modifiedDate"/>
		<input type="hidden" name="createdBy" value="${goodsReceipt.createdPerson}">
		<form:hidden path="goodsRequisitionId" id="goodsRequisitionId" />
		<form:hidden path="markDel" id="markDel" />
		<input type="hidden" id="stockCode" name="stock.code" value="${goodsReceipt.stock.code}"> 
		<input type="hidden" id="transType" name="transType" value="${goodsReceipt.transType}"> 
		<!-- Basic layout-->
		<div class="card">
			<div class="card-header header-elements-inline">
				<c:choose>
			        <c:when test = "${empty goodsReceipt.id}">
			           <span class="text-uppercase font-size-lg font-weight-bold"><fmt:message	key="goodsreceipt.form.title" /></span>
			        </c:when>
			        <c:otherwise>
			           <span class="text-uppercase font-size-lg font-weight-bold"><fmt:message	key="goodsreceipt.form.detail" /></span>
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
								<div class="col-xs-4 col-md-3">
									<div class="form-group">
										<label><fmt:message key="goodsreceipt.fromStockCode" /><span class="help-block"></span></label>
										<select	id="goodsReceiptFromStockCode" name="fromStockCode" class="form-control select2" data-placeholder="Chọn mã kho">
											<option value="">&nbsp;</option>
											<c:forEach var="item" items="${stocks}">
									            <option value="${item.code}" ${item.code == goodsReceipt.fromStockCode ? 'selected="selected"' : ''}><c:out value="${item.code} - ${item.name}"></c:out></option>
									        </c:forEach>
										</select>
									</div>
								</div>
								<div class="col-xs-4 col-md-3">
									<div class="form-group">
										<label><fmt:message key="goodsreceipt.toStockCode" /><span class="help-block">*</span></label>
										<select	id="goodsReceiptToStockCode" name="toStockCode" class="form-control select2" data-placeholder="Chọn mã kho">
											<c:forEach var="item" items="${farms}">
									            <option value="${item.code}" ${item.code == goodsReceipt.toStockCode ? 'selected="selected"' : ''}><c:out value="${item.code} - ${item.name}"></c:out></option>
									        </c:forEach>
										</select>
									</div>
								</div>
								<div class="col-xs-4 col-md-3">
									<div class="form-group">
										<label><fmt:message key="goodsreceipt.transCode" /><span class="help-block">*</span></label>
										<form:input type="text" id="goodsReceiptTransCode" path="transCode" class="form-control rounded-10" readonly="true"/>
									</div>
								</div>
								<div class="col-xs-4 col-md-3">
									<div class="form-group">
										<label><fmt:message key="goodsreceipt.poCode" /><span class="help-block"></span></label>
										<form:input type="text" id="goodsReceiptPoCode" path="poCode" class="form-control rounded-10"/>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-xs-4 col-md-3">
									<div class="form-group">
										<label><fmt:message key="goodsreceipt.doCode" /><span class="help-block"></span></label>
										<form:input type="text" id="goodsReceiptDoCode" path="doCode" class="form-control rounded-10"/>
									</div>
								</div>
								<div class="col-xs-4 col-md-3">
									<div class="form-group">
										<label><fmt:message key="goodsreceipt.vendor" /><span class="help-block"></span></label>
										<form:input type="text" id="goodsReceiptVendor" path="vendor" class="form-control rounded-10"/>
									</div>
								</div>
								<div class="col-xs-4 col-md-3">
									<div class="form-group">
										<label><fmt:message key="goodsreceipt.vendorName" /><span class="help-block"></span></label>
										<form:input type="text" id="goodsReceiptVendorName" path="vendorName" class="form-control rounded-10"/>
									</div>
								</div>
								<div class="col-xs-4 col-md-3">
									<div class="form-group">
										<label><fmt:message key="goodsreceipt.createdPerson" /><span class="help-block"></span></label>
										<form:input type="text" id="goodsReceiptCreatedPerson" path="createdPerson" class="form-control rounded-10"/>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-xs-4 col-md-3">
									<div class="form-group">
										<label><fmt:message key="goodsreceipt.postingDate" /><span class="help-block">*</span></label>
										<input type="text" id="goodsReceiptDisplayPostingDate" name="displayPostingDate" value="${goodsReceipt.displayPostingDate}" class="form-control rounded-10 daterange-single" readonly />
									</div>
								</div>
								<div class="col-xs-4 col-md-3">
									<div class="form-group">
										<label><fmt:message key="goodsissue.typeTransaction" /><span class="help-block"></span></label>
										<p class="form-control rounded-10"><fmt:message key="goodsreceipt.movement.type.${goodsReceipt.movementType}"></fmt:message></p>
									</div>
								</div>
							</div>
							<jsp:include page="goodsreceipt-material-selector.jsp"/>
						</div>
					</div>
					<div class="d-flex justify-content-end align-items-center">
						<a href="<c:url value='/goodsReceipt/list'/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i><fmt:message key="button.back" /></a>
						<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GOODS_RECEIPT_CREATE')">
							<button type="button" class="btn btn-primary ml-3" data-toggle="modal" data-target="#modalTemplate" data-backdrop="static" data-keyboard="false"><fmt:message key="button.save.template" /><i class="icon-database-insert ml-2"></i></button>
						</security:authorize>
						<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GOODS_RECEIPT_CANCEL')">
							<button type="button" class="btn btn-danger ml-3" data-toggle="modal" data-target="#modalCancel" data-backdrop="static" data-keyboard="false"><fmt:message key="button.cancel.transaction" /><i class="icon-cancel-square ml-2"></i></button>
						</security:authorize>
						<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GOODS_RECEIPT_CREATE')">
							<button type="button" id="btnSubmit" class="btn btn-primary ml-3">	<fmt:message key="button.save" /><i class="icon-database-insert ml-2"></i></button>
						</security:authorize>
					</div>
				</fieldset>
			</div>
		</div>
		<!-- /basic layout -->
		
		<!-- Vertical form modal -->
		<div id="modalTemplate" class="modal fade" tabindex="-1">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title"><fmt:message key="created.goods.receipt.template" /></h5>
						<button type="button" class="close" data-dismiss="modal">&times;</button>
					</div>
					<form action="#">
						<div class="modal-body">
							<div class="form-group">
								<div class="row">
									<div class="col-sm-12">
										<label><fmt:message key="purchase.requisition.template.name" /></label>
										<input type="text" id="templateNameModal" value="${goodsReceipt.templateName}" class="form-control">
									</div>
								</div>
							</div>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-link" data-dismiss="modal"><fmt:message key="button.close.modal" /></button>
							<button type="button" id="btnSaveTemplate" class="btn bg-primary"><fmt:message key="button.save.template" /></button>
						</div>
					</form>
				</div>
			</div>
		</div>
		<!-- /vertical form modal -->
		
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
										<label><fmt:message key="goods.receipt.cancel.transaction.description" /></label>
									</div>
								</div>
							</div>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-link" data-dismiss="modal"><fmt:message key="button.close.modal" /></button>
							<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GOODS_RECEIPT_CANCEL')">
								<button type="button" id="btnCancelTrans" class="btn bg-primary"><fmt:message key="button.confirm" /></button>
							</security:authorize>
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

