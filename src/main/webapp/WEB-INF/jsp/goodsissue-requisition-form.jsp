<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
	<title><fmt:message key="goodsissue.requisition.form.title.internal" /></title>
	
	<meta name="menu" content="goodsIssueRequisitionMenu" />
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/extensions/jquery_ui/interactions.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/assets/js/goodsissue_requisition_form.js'/>"></script>
	<!-- Map -->
</head>

<!-- Content area -->
<div class="content">
	<form:form id="goodsissueForm" modelAttribute="goodsIssue" action="<c:url value='${ctx}/goodsissue/save'/>" method="post" role="form">
		<form:hidden path="id" />
		<!-- Basic layout-->
		<div class="card">
			<div class="card-header header-elements-inline">
				<span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="goodsissue.requisition.form.title.internal" /></span>
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
										<label><fmt:message key="goodsissue.fromStockCode" /><span class="help-block"></span></label>
										<select	id="goodsIssueFromStockCode" name="toStockCode" class="form-control select2" data-placeholder="Chọn mã kho">
											<option value="">&nbsp;</option>
											<c:forEach var="item" items="${stocks}">
									            <option value="${item.code}" ${item.code == goodsIssue.fromStockCode ? 'selected="selected"' : ''}><c:out value="${item.code} - ${item.name}"></c:out></option>
									        </c:forEach>
										</select>
									</div>
								</div>
								<div class="col-xs-4 col-md-4">
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
								<div class="col-xs-4 col-md-4">
									<div class="form-group">
										<label><fmt:message key="goodsissue.poCode" /><span class="help-block">*</span></label>
										<input type="text" id="GoodIssueDoCode" name="poCode" value="${goodsIssue.poCode}" class="form-control" readonly="readonly" />
									</div>
								</div>
							</div>
						
						
							<div class="row">
								<div class="col-xs-4 col-md-4">
									<div class="form-group">
										<label><fmt:message key="goodsissue.doCode" /><span class="help-block">*</span></label>
										<input type="text" id="GoodIssueDoCode" name="doCode" value="${goodsIssue.doCode}" class="form-control" readonly="readonly" />
									</div>
								</div>
								<div class="col-xs-4 col-md-4">
									<div class="form-group">
										<label><fmt:message key="goodsissue.customerCode" /><span class="help-block">*</span></label>
										<input id="GoodIssueCustomer" name="customer" value="${goodsIssue.customer}" class="form-control" readonly="readonly" />
									</div>
								</div>
								<div class="col-xs-4 col-md-4">
									<div class="form-group">
										<label><fmt:message key="goodsissue.customerName" /><span class="help-block">*</span></label>
										<input id="GoodIssueCustomer" name="customerName" value="${goodsIssue.customerName}" class="form-control" readonly="readonly" />
									</div>
								</div>
							</div>
							<jsp:include page="goodsissue-requisition-material-selector.jsp" />
						</div>
					</div>
					<div class="d-flex justify-content-end align-items-center">
						<a href="<c:url value="/goodsIssue-Requisition/list"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i> <fmt:message key="button.back" /></a>
						<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GOODS_ISSUE_CREATE')">
							<c:if test="${goodsIssue.checkRetained and goodsIssue.status ne 'finished' and goodsIssue.status ne 'block'}">
								<a href="<c:url value='/goodsIssue/form?grId=${goodsIssue.id}'/>" class="btn btn-sm btn-primary ml-3" title="<fmt:message key="button.goods.issue"/>"><i class="icon-plus22"></i><fmt:message key="button.goods.issue"/></a>
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