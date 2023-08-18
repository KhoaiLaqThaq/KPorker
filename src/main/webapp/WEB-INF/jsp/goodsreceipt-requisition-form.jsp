<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
	<title><fmt:message key="goodsreceipt.requisition.form.title" /></title>
	<meta name="menu" content="goodsReceiptRequisitionMenu" />
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/switch.min.js'/>"></script>	
	<script	src="<c:url value='/themes/admin/assets/js/goodsreceipt_requisition_form.js'/>"></script>
</head>

<!-- Content area -->
<div class="content">
	<form:form id="goodsreceiptForm" modelAttribute="goodsReceipt" action="${ctx}/goodsReceipt-Requisition/save" method="post" role="form">
		<form:hidden path="id" />
		<form:hidden path="prCode" />
		<form:hidden path="movementType" />
		<form:hidden path="status" />
		<form:hidden path="createdDate" />
		<form:hidden path="modifiedDate" />
		<form:hidden path="toStockCode"/>
		<form:hidden path="poCode"/>
		<form:hidden path="postingDate"/>
		<!-- Basic layout-->
		<div class="card">
			<div class="card-header header-elements-inline">
				<span class="text-uppercase font-size-lg font-weight-bold"><fmt:message	key="goodsreceipt.requisition.form.title" /></span>
			</div>
			<div class="card-body">
				<fieldset class="mb-3">
					<legend class="text-uppercase font-size-sm font-weight-bold">
						<fmt:message key="template.legend" />
					</legend>
					<div class="card">
						<div class="card-body">
							<div class="row">
							
								<div class="col-xs-4 col-md-4">
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
								<div class="col-xs-4 col-md-4">
									<div class="form-group">
										<label><fmt:message key="goodsreceipt.toStockCode" /><span class="help-block"></span></label>
										<select	id="goodsReceiptToStockCode" name="toStockCode" class="form-control select2" data-placeholder="Chọn mã kho">
											<c:forEach var="item" items="${stocks}">
									            <option value="${item.code}" ${item.code == goodsReceipt.toStockCode ? 'selected="selected"' : ''}><c:out value="${item.code} - ${item.name}"></c:out></option>
									        </c:forEach>
										</select>
									</div>
								</div>
								<div class="col-xs-4 col-md-4">
									<div class="form-group">
										<label ><fmt:message key="goodsreceipt.poCode"/><span class="help-block"></span></label>
										<form:input type="text" id="goodsreceiptPoCode" path="poCode" class="form-control" readonly="true"/>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-xs-4 col-md-4">
									<div class="form-group">
										<label ><fmt:message key="goodsreceipt.doCode"/><span class="help-block"></span></label>
										<form:input type="text" id="goodsreceiptPostingDate" path="doCode"  class="form-control" readonly="true"/>
									</div>
								</div>
								<div class="col-xs-4 col-md-4">
									<div class="form-group">
										<label ><fmt:message key="goodsreceipt.vendor"/><span class="help-block"></span></label>
										<input type="text" id="goodsreceiptVendor" name="vendor" value="${goodsReceipt.vendor }" class="form-control" readonly="readonly"/>
									</div>
								</div>
								<div class="col-xs-4 col-md-4">
									<div class="form-group">
										<label ><fmt:message key="goodsreceipt.vendorName"/><span class="help-block"></span></label>
										<form:input type="text" id="goodsreceiptVendorName" path="vendorName" class="form-control" readonly="true"/>
									</div>
								</div>
							</div>
							<jsp:include page="goodsreceipt-requisition-material-selector.jsp"/>
						</div>
					</div>
					<div class="d-flex justify-content-end align-items-center">
						<a href="<c:url value="/goodsReceipt-Requisition/list"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i><fmt:message key="button.back" /></a>
						<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GOODS_RECEIPT_CREATE')">
							<c:if test="${goodsReceipt.checkRetained and goodsReceipt.status ne 'finished' and goodsReceipt.status ne 'block'}">
								<a href="<c:url value='/goodsReceipt/form?grId=${goodsReceipt.id}'/>" class="btn btn-sm btn-primary ml-3" title="<fmt:message key="button.goods.receipt"/>"><i class="icon-plus22"></i><fmt:message key="button.goods.receipt"/></a>
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