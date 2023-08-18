<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="goodsreceipt.requisition.list.title"/></title>
    <meta name="menu" content="goodsReceiptRequisitionMenu"/>

	<link href="<c:url 	value='/themes/admin/assets/css/components.min.css'/>" rel="stylesheet" type="text/css" />
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/switchery.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/switch.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/assets/js/goodsreceipt_requisition_list.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>

</head>

<div class="row mb-3">
	<div class="col-12"><%@include file="/themes/admin/common/instock-actions.jsp"%></div>
</div>

<div class="content">
	<div class="row cus-tabs-container mb-3">
		<ul class="nav nav-tabs mb-0">
			<li class="nav-item"><a href="/goodsReceipt-Requisition/list" class="nav-link active show" ><fmt:message key="menu.goods.receipt.requisition"/></a></li>
			<li class="nav-item"><a href="/goodsReceipt/list" class="nav-link" ><fmt:message key="menu.confirm.goods.receipt"/></a></li>
		</ul>
		<div class="tab-divider"></div>
	</div>
	<div class="row mb-3">
		<div class="col-12 col-md-6">
			<div class="text-color-primary fs-5"><fmt:message key="goodsreceipt.requisition.list.title" /></div>
		</div>
	</div>
	<form:form id="goodsreceiptForm" modelAttribute="criteria" action="${ctx}/goodsReceipt-Requisition/list"  method="post">
		<form:hidden path="type" />
		<!-- \Searching -->
		<div class="card rounded-16">
			<div class="row"><div class="col-12 px-3 py-2 fw-bold"><fmt:message key="label.search" /></div></div>
			<div class="card-body py-0">
				<div class="row">
					<div class="col-10">
						<div class="row">
							<div class="col-3">
								<div class="form-group">
									<label><fmt:message key="instock.farmName" /></label>
									<input class="form-control rounded-10" type="text" id="stockName" name="stockName" value="${criteria.stockName}" placeholder="Nhập tên trại"/>
								</div>
							</div>
							<div class="col-3">
								<div class="form-group">
									<label> <fmt:message key="goodsissue.doCode"/></label>
									<input class="form-control rounded-10" type="text" id="doCode" name="doCode" value="${criteria.doCode}" placeholder="Nhập số DO" />
								</div>
							</div>
							<div class="col-3">
								<div class="form-group">
									<label> <fmt:message key="goodsissue.poCode"/></label>
									<input class="form-control rounded-10" type="text" id="poCode" name="poCode" value="${criteria.poCode}" placeholder="Nhập số PO" />
								</div>
							</div>
							<div class="col-3">
								<label> <fmt:message key="purchaserequisition.status"/></label>
								<select class="form-control rounded-10 select2" name="status" id="status" data-placeholder="Chọn trạng thái" data-fouc>
									<option value="">&nbsp;</option>
									<c:forEach items="${grStatus}" var="item">
										<option value="${item}" ${criteria.status eq item ? 'selected' : ''}><fmt:message key="goods.receipt.status.${item}"></fmt:message></option>
									</c:forEach>
								</select>
							</div>
						</div>
					</div>
					<div class="col-2 mt-3 text-right">
						<button type="button" class="btn btn-secondary mr-2" id="btnReset">Đặt lai</button>
						<button type="button" class="btn btn-secondary" id="btnSubmit"><fmt:message key="button.search" /></button>
					</div>
				</div>
			</div>
		</div>
		<!-- /Searching -->

		<!-- \Table -->
		<div class="card">
			<div class="table-responsive">
				<table class="table table-bordered table-striped">
					<thead>
						<tr class="table-success">
							<th class="text-center bgc-primary border-primary text-white" style="width: 5%">#</th>
							<th class="bgc-primary border-primary text-white text-center"><fmt:message key="purchaserequisition.farmCode"/></th>
							<th class="bgc-primary border-primary text-white text-center"><fmt:message key="goodsissue.doCode" /></th>
							<th class="bgc-primary border-primary text-white text-center"><fmt:message key="goodsissue.poCode" /></th>
							<th class="bgc-primary border-primary text-white text-center"><fmt:message key="goodsreceipt.createdDate"/></th>
							<th class="text-center bgc-primary border-primary text-white"><fmt:message key="goodsreceipt.status"/></th>
							<th class="text-center bgc-primary border-primary text-white" style="width:120px;"><i class="icon-menu-open2"></i></th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${empty page.content}">
							<tr><td colspan="7" class="text-center text-none-data"><fmt:message key="not.data"/></td></tr>
						</c:if>
						<c:forEach var="goodsreceipt" items="${page.content}" varStatus="cnt">
							<tr>
								<td class="text-center"><c:out value="${cnt.count+page.size*page.number}" /></td>
								<td class=" text-center">${goodsreceipt.toStockCode}</td>
								<td class=" text-center">${goodsreceipt.doCode}</td>
								<td class=" text-center">${goodsreceipt.poCode}</td>
								<td class=" text-center">${goodsreceipt.displayCreatedDate}</td>
								<td class="text-center">
									<c:choose>
										<c:when test = "${goodsreceipt.status eq 'processing'}">
											<span class="badge bg-info-400"><fmt:message key="goods.receipt.status.${goodsreceipt.status}"></fmt:message></span>
										</c:when>
										<c:when test = "${goodsreceipt.status eq 'finished'}">
											<span class="badge bg-success-400"><fmt:message key="goods.receipt.status.${goodsreceipt.status}"></fmt:message></span>
										</c:when>
										 <c:otherwise>
											<span class="badge bg-danger-400"><fmt:message key="purchase.requisition.status.${goodsreceipt.status}"></fmt:message></span>
										</c:otherwise>
									</c:choose>
								</td>
								<td class="text-center">
									<div class="list-icons">
										<div class="dropdown">
											<a href="#" class="list-icons-item" data-toggle="dropdown"><i class="icon-menu9"></i></a>
											<div class="dropdown-menu dropdown-menu-right">
												<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GOODS_RECEIPT_REQUISITION_EDIT')">
													<a href="/goodsReceipt-Requisition/form?id=${goodsreceipt.id}" class="dropdown-item"><i class="icon-pencil7"></i><span><fmt:message key="button.detail"/></span></a>
												</security:authorize>
												<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GOODS_RECEIPT_REQUISITION_DELETE')">
													<c:if test = "${goodsreceipt.status eq 'received' || goodsreceipt.status eq 'block'}">
														<a href="#" class="dropdown-item" onclick="return checkDelete(${goodsreceipt.id})"><i class="icon-cancel-square"  style="color:red"></i> <fmt:message key="button.delete"/></a>
													</c:if>
												</security:authorize>
											</div>
										</div>
									</div>
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			<!-- Pagination -->
			<jsp:include page="/themes/admin/common/pagination.jsp">
				<jsp:param value="${page.number}" name="pageNumber"/>
				<jsp:param value="${page.totalPages}" name="maxPages"/>
				<jsp:param value="${page.size}" name="size"/>
				<jsp:param value="${page.totalElements}" name="totalElements"/>
			</jsp:include>
		</div>
		<!-- /Table -->
	</form:form>
</div>
