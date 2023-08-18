<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
	<c:choose>
        <c:when test = "${empty goodsIssue.id}">
           <title><fmt:message key="goodsissue.form.title" /></title>
        </c:when>
        <c:otherwise>
           <title><fmt:message key="goodsIssue.form.detail" /></title>
        </c:otherwise>
     </c:choose>
	<meta name="menu" content="goodsIssueRequisitionMenu" />
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/extensions/jquery_ui/interactions.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/uniform.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/pnotify.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/assets/js/goodsissue_form.js'/>"></script>
	<script src="<c:url value='/themes/admin/assets/js/goodsissue_material_selector.js'/>"></script>
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
	<form:form id="goodsissueForm" modelAttribute="goodsIssue" action="<c:url value='${ctx}/goodsIssue/save'/>" method="post" role="form">
		<form:hidden path="id" id="id" />
		<form:hidden path="postingDate" id="postingDate"/>
		<form:hidden path="status" id="status" />
		<form:hidden path="type" id="type" />
		<form:hidden id="templateName" path="templateName"/>
		<form:hidden id="createdDate" path="createdDate"/>
		<form:hidden id="modifiedDate" path="modifiedDate"/>
		<form:hidden path="transType" id="transType" />
		<form:hidden path="goodsRequisitionId" id="goodsRequisitionId" />
		<input type="hidden" value="${goodsIssue.barnCode}" id="barnCodeSelected">
		<form:hidden path="markDel" id="markDel" />
		<input type="hidden" name="createdBy" value="${goodsIssue.createdPerson}">
		<input type="hidden" name="stock.code" id="stockCode" value="${goodsIssue.stock.code}"> 
		<input type="hidden" name="movementType" id="movementType" value="${goodsIssue.movementType}"> 
		<!-- Basic layout-->
		<div class="card">
			<div class="card-header header-elements-inline">
				<c:choose>
			        <c:when test = "${empty goodsIssue.id}">
			           <span class="text-uppercase font-size-lg font-weight-bold"><fmt:message	key="goodsissue.form.title" /></span>
			        </c:when>
			        <c:otherwise>
			           <span class="text-uppercase font-size-lg font-weight-bold"><fmt:message	key="goodsIssue.form.detail" /></span>
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
										<label><fmt:message key="goodsissue.fromStockCode" /><span class="help-block">*</span></label>
										<select	id="goodsIssueFromStockCode" name="fromStockCode" class="form-control select2" data-placeholder="Chọn mã kho">
										    <option value=""></option>
											<c:forEach var="item" items="${farms}">
									            <option value="${item.code}" ${item.code == goodsIssue.fromStockCode ? 'selected="selected"' : ''}><c:out value="${item.code} - ${item.name}"></c:out></option>
									        </c:forEach>
										</select>
									</div>
								</div>
								<div class="col-xs-12 col-md-3">
									<div class="form-group">
										<label><fmt:message key="goodsissue.toStockCode" /><span class="help-block"></span></label>
										<select	id="goodsIssueToStockCode" name="toStockCode" class="form-control select2" data-placeholder="Chọn mã kho">
											<option value="">&nbsp;</option>
											<c:forEach var="item" items="${stocks}">
									            <option value="${item.code}" ${item.code == goodsIssue.toStockCode ? 'selected="selected"' : ''}><c:out value="${item.code} - ${item.name}"></c:out></option>
									        </c:forEach>
										</select>
									</div>
								</div>
								<div class="col-xs-12 col-md-3">
									<div class="form-group">
										<label><fmt:message key="goodsissue.transCode" /><span class="help-block"></span></label>
										<form:input type="text" id="GoodIssueTransCode" class="form-control" readonly="true" path="transCode"/>
									</div>
								</div>
								<div class="col-xs-12 col-md-3">
									<div class="form-group">
										<label><fmt:message key="goodsissue.posting.date" /><span class="help-block">*</span></label>
										<input type="text" id="goodsIssueDisplayPostingDate" value="${goodsIssue.displayPostingDate}" class="form-control daterange-single" readonly />
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-xs-12 col-md-3">
									<div class="form-group">
										<label><fmt:message key="goodsissue.poCode" /><span class="help-block"></span></label>
										<form:input type="text" id="goodsIssuePoCode" path="poCode" class="form-control" placeholder="Nhập số PO..." />
									</div>
								</div>
								<div class="col-xs-12 col-md-3">
									<div class="form-group">
										<label><fmt:message key="goodsissue.doCode" /><span class="help-block"></span></label>
										<form:input type="text" id="goodsIssueDoCode" path="doCode" class="form-control" placeholder="Nhập số DO..."/>
									</div>
								</div>
								<div class="col-xs-12 col-md-3">
									<div class="form-group">
										<label><fmt:message key="goodsissue.customerCode" /><span class="help-block"></span></label>
										<form:input type="text" id="goodsIssueCustomer" path="customer" class="form-control" placeholder="Nhập mã khách hàng..."/>
									</div>
								</div>
								<div class="col-xs-12 col-md-3">
									<div class="form-group">
										<label><fmt:message key="goodsissue.customerName" /><span class="help-block"></span></label>
										<form:input type="text" id="goodsIssueCustomerName" path="customerName" class="form-control" placeholder="Nhập tên khách hàng..."/>
									</div>
								</div>
							</div>
							
							<div class="row">
								<div class="col-xs-12 col-md-3">
									<div class="form-group">
										<label><fmt:message key="goodsissue.createdPerson" /><span class="help-block"></span></label>
										<input type="text" id="GoodIssueCreatedPerson" name="createdPerson" value="${goodsIssue.createdPerson}" class="form-control" readonly="readonly"/>
									</div>
								</div>
								<div class="col-xs-12 col-md-3">
									<div class="form-group">
										<label><fmt:message key="goodsissue.licensePlate" /><span class="help-block">*</span></label>
										<form:input type="text" id="licensePlate" path="licensePlate" class="form-control" placeholder="Nhập biển số xe..."/>
										<div><span id="msgForId" style="color: red"></span></div>
									</div>
								</div>
								<div class="col-xs-12 col-md-3">
									<div class="form-group">
										<label><fmt:message key="goodsissue.typeTransaction" /><span class="help-block"></span></label>
										<select id="goodsissueMovementType" class="form-control select2">
											<c:forEach var="item" items="${transTypes}">
											 	 <c:if test="${item eq '641' }">
											        <security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GOODS_ISSUE_641')">
                                                        <option value="${item}" ${item == goodsIssue.movementType ? 'selected="selected"' : ''}><fmt:message key="goodsissue.movement.type.${item}" /></option>
                                                    </security:authorize>
											     </c:if>
											     <c:if test="${item eq '201' }">
											        <security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GOODS_ISSUE_201')">
                                                        <option value="${item}" ${item == goodsIssue.movementType ? 'selected="selected"' : ''}><fmt:message key="goodsissue.movement.type.${item}" /></option>
                                                    </security:authorize>
											     </c:if>
											     <c:if test="${item eq 'Z09' }">
                                                    <security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GOODS_ISSUE_Z09')">
                                                        <option value="${item}" ${item == goodsIssue.movementType ? 'selected="selected"' : ''}><fmt:message key="goodsissue.movement.type.${item}" /></option>
                                                    </security:authorize>
                                                 </c:if>
                                                 <c:if test="${item eq 'Z15' }">
                                                    <security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GOODS_ISSUE_Z15')">
                                                        <option value="${item}" ${item == goodsIssue.movementType ? 'selected="selected"' : ''}><fmt:message key="goodsissue.movement.type.${item}" /></option>
                                                    </security:authorize>
                                                 </c:if>
                                                 <c:if test="${item eq '551' }">
                                                    <security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GOODS_ISSUE_551')">
                                                        <option value="${item}" ${item == goodsIssue.movementType ? 'selected="selected"' : ''}><fmt:message key="goodsissue.movement.type.${item}" /></option>
                                                    </security:authorize>
                                                 </c:if>
									        </c:forEach>
										</select>
									</div>
								</div>
							</div>
							
							<jsp:include page="goodsissue-material-selector.jsp" />
						</div>
					</div>
					<div class="d-flex justify-content-end align-items-center">
						<a href="<c:url value="/goodsIssue/list"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i> <fmt:message key="button.back" /></a>
						<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GOODS_ISSUE_CREATE')">
							<button type="button" class="btn btn-primary ml-3" data-toggle="modal" data-target="#modalTemplate" data-backdrop="static" data-keyboard="false"><fmt:message key="button.save.template" /><i class="icon-database-insert ml-2"></i></button>
						</security:authorize>
						<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GOODS_ISSUE_CANCEL')">
							<button type="button" class="btn btn-danger ml-3" data-toggle="modal" data-target="#modalCancel" data-backdrop="static" data-keyboard="false"><fmt:message key="button.cancel.transaction" /><i class="icon-cancel-square ml-2"></i></button>
						</security:authorize>
						<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GOODS_ISSUE_CREATE')">
							<button type="button" id="btnSubmit" class="btn btn-primary ml-3"><fmt:message key="button.save" /><i class="icon-database-insert ml-2"></i></button>
						</security:authorize>
					</div>
				</fieldset>
			</div>
		</div>
		<!-- /basic layout -->
		
		<!-- form modal -->
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
		<!-- /form modal -->
		
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
										<label><fmt:message key="goods.issue.cancel.transaction.description" /></label>
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