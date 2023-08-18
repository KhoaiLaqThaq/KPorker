<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
	<title><fmt:message key="purchaserequisition.form.title" /></title>
	<meta name="menu" content="purchaseRequisitionMenu" />
	
	<script	src="<c:url value='/themes/admin/assets/js/purchaserequisition_form.js'/>"></script>
	<script	src="<c:url value='/themes/admin/assets/js/material_selector.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/switch.min.js'/>"></script>	
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/ui/moment/moment.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/daterangepicker.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/anytime.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.date.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/legacy.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/jgrowl.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
</head>

<!-- Content area -->
<div class="content">
	<form:form id="purchaserequisitionForm"	modelAttribute="purchaseRequisition" action="${ctx}/purchaseRequisition/save" method="post" role="form">
		<form:hidden path="id" id="prId" />
		<form:hidden path="type" id="type" />
		<form:hidden path="status" id="status" />
		<form:hidden id="contentJson" path="contentJson" />
		<form:hidden id="createdDate" path="createdDate"/>
		<form:hidden id="modifiedDate" path="modifiedDate"/>
		<form:hidden id="createdBy" path="createdBy"/>
		<form:hidden id="prCode" path="prCode"/>
		<form:hidden id="purchasingGroup" path="purchasingGroup"/>
		<form:hidden id="templateName" path="templateName"/>
		<form:hidden id="purchaserequisitionPlant" path="plant"/>
		<input type="hidden" id="prType" name="prType" value="${purchaseRequisition.prType}"/>
		
		<!-- Basic layout-->
		<div class="card">
			<div class="card-body">
				<fieldset class="mb-3">
					<legend class="text-uppercase font-size-sm font-weight-bold"><fmt:message key="template.legend" /></legend>
					<div class="row">
						<div class="col-xs-4 col-md-3">
							<div class="form-group">
								<label><fmt:message	key="purchaserequisition.stockCode" /><span	class="help-block">*</span></label> 
								<select	id="purchaserequisitionStockCode" class="form-control select2" data-placeholder="Chọn mã kho" name="stock.code">
									<%-- <c:choose>
								 		<c:when test = "${fn:length(farms) <= 1}">
								 			<c:forEach var="item" items="${farms}">
									            <option value="${item.code}" ${item.code == purchaseRequisition.stock.code ? 'selected="selected"' : ''}><c:out value="${item.code} - ${item.name}"></c:out></option>
									        </c:forEach>
							         	</c:when>
							        	 <c:otherwise>
							            	<option value=""></option>
											<c:forEach var="item" items="${farms}">
									            <option value="${item.code}" ${item.code == purchaseRequisition.stock.code ? 'selected="selected"' : ''}><c:out value="${item.code} - ${item.name}"></c:out></option>
									        </c:forEach>
							         	</c:otherwise>
							      	</c:choose> --%>
							      	<option value=""></option>
									<c:forEach var="item" items="${farms}">
							            <option value="${item.code}" ${item.code == purchaseRequisition.stock.code ? 'selected="selected"' : ''}><c:out value="${item.code} - ${item.name}"></c:out></option>
							        </c:forEach>
								</select>
							</div>
						</div>
						<div class="col-xs-4 col-md-3">
							<div class="form-group">
								<label><fmt:message	key="purchaserequisition.type" /><span class="help-block"></span></label> 
								<p class="form-control"><fmt:message key="purchase.requisition.type.${purchaseRequisition.type}"></fmt:message></p>
							</div>
						</div>
						<div class="col-xs-4 col-md-3">
							<div class="form-group">
								<label><fmt:message	key="purchaserequisition.prType" /><span class="help-block">*</span></label> 
								<select	id="purchaserequisitionPrType" class="form-control select2" data-placeholder="Chọn loại yêu cầu">
									<c:forEach var="item" items="${prTypes}">
							            <option value="${item}" ${item == purchaseRequisition.prType ? 'selected="selected"' : ''}><fmt:message	key="purchaserequisition.prType.${item}" /></option>
							        </c:forEach>
								</select>
							</div>
						</div>
						<div class="col-xs-4 col-md-3">
							<div class="form-group">
								<label><fmt:message	key="purchaserequisition.requisitioner" /><span	class="help-block"></span></label> 
								<form:input type="text" id="purchaserequisitionRequisitioner" path="requisitioner" class="form-control" readonly="true"/> 
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-xs-4 col-md-3">
							<div class="form-group">
								<label><fmt:message	key="purchaserequisition.transCode" /><span class="help-block"></span></label> 
								<form:input type="text" id="purchaserequisitionTransCode" path="transCode" class="form-control" readonly="true"/>
							</div>
						</div>
						<div class="col-xs-4 col-md-3">
							<div class="form-group">
								<label><fmt:message	key="purchaserequisition.status" /><span class="help-block"></span></label> 
								<p class="form-control"><fmt:message key="purchase.requisition.status.${purchaseRequisition.status}"></fmt:message></p>
							</div>
						</div>
						<div class="col-xs-4 col-md-3">
							<div class="form-group">
								<label><fmt:message	key="purchaserequisition.prGroupCode" /><span class="help-block"></span></label> 
								<form:input type="text" id="purchaserequisitionPrGroupCode" path="prGroupCode" class="form-control" readonly="true"/> 
							</div>
						</div>
						<c:if test="${not empty purchaseRequisition.id && not empty purchaseRequisition.purchasingGroup}">
							<div class="col-xs-4 col-md-3">
								<div class="form-group">
									<label><fmt:message	key="purchaserequisition.purchasing.group" /><span class="help-block"></span></label> 
									<p class="form-control"><fmt:message key="purchaserequisition.purchasing.group.${purchaseRequisition.purchasingGroup}"></fmt:message></p>
								</div>
							</div>
						</c:if>
						<div class="col-xs-4 col-md-3">
							<div id="estimateDateContainer" class="form-group d-none">
								<label><fmt:message	key="purchaserequisition.estimateDate" /><span class="help-block"></span></label> 
								<input type="text" id="estimateDate" class="form-control" autocomplete="off"/> 
							</div>
						</div>
					</div>
					<jsp:include page="material-selector.jsp"/>
					
					<div class="d-flex justify-content-end align-items-center">
						<a href="<c:url value="/purchaseRequisition/list"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i> <fmt:message	key="button.back" /></a>
						<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_PURCHASE_REQUISITION_CREATE')">
							<button type="button" class="btn btn-primary ml-3" data-toggle="modal" data-target="#modalTemplate" data-backdrop="static" data-keyboard="false"><fmt:message key="button.save.template" /><i class="icon-database-insert ml-2"></i></button>
						</security:authorize>
						<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_PURCHASE_REQUISITION_CANCEL')">
							<c:if test="${purchaseRequisition.status eq 'confirmed' }">
								<button type="button" id="btnCancel" class="btn btn-danger ml-3"><fmt:message key="button.cancel.purchase.requisition" /><i class="icon-cancel-square ml-2"></i></button>
							</c:if>
						</security:authorize>
						<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_PURCHASE_REQUISITION_CREATE')">
							<button type="button" id="btnSubmit" class="btn btn-primary ml-3"><fmt:message key="button.save" /><i class="icon-database-insert ml-2"></i></button>
						</security:authorize>
						<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_PURCHASE_REQUISITION_CONFIRM')">
							<button type="button" id="btnConfirmed" class="btn btn-primary ml-3"><fmt:message key="button.confirmed"/><i class="icon-database-insert ml-2"></i></button>
						</security:authorize>
					</div>
				</fieldset>
			</div>
		</div>
		<!-- /basic layout -->
		
		<!-- modal save template -->
		<div id="modalTemplate" class="modal fade" tabindex="-1">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title"><fmt:message key="purchase.requisition.template" /></h5>
						<button type="button" class="close" data-dismiss="modal">&times;</button>
					</div>
					<form action="#">
						<div class="modal-body">
							<div class="form-group">
								<div class="row">
									<div class="col-sm-12">
										<label><fmt:message key="purchase.requisition.template.name" /></label>
										<input type="text" id="templateNameModal" value="${purchaseRequisition.templateName}" class="form-control">
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
		<!--/modal save template -->
	</form:form>
</div>
<div class="modal hide" id="pleaseWaitDialog" data-backdrop="static" data-keyboard="false">
    <div class="modal-body">
        <div class="loading">Loading&#8230;</div>
    </div>
</div>
<!-- /content area -->

