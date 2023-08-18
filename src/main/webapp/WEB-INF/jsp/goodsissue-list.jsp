<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
<title><fmt:message key="goodsissue.list.title" /></title>
<meta name="menu" content="goodsIssueRequisitionMenu" />
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
	<link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">
	<script src="<c:url value='/themes/admin/global_assets/js/main/bootstrap.bundle.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/loaders/blockui.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/switch.min.js'/>"></script>	
	<script src="<c:url value='/themes/admin/assets/js/goodsissue_list.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/ui/moment/moment.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/daterangepicker.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/anytime.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.date.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/legacy.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/jgrowl.min.js'/>"></script>
</head>

<div class="row mb-3">
	<div class="col-12"><%@include file="/themes/admin/common/instock-actions.jsp"%></div>
</div>

<div class="content">
	<div class="row cus-tabs-container mb-3">
		<ul class="nav nav-tabs mb-0">
			<li class="nav-item"><a href="/goodsIssue-Requisition/list" class="nav-link" ><fmt:message key="menu.goods.issue.requisition"/></a></li>
			<li class="nav-item"><a href="/goodsIssue/list" class="nav-link active show" ><fmt:message key="menu.store.export.internal"/></a></li>
		</ul>
		<div class="tab-divider"></div>
	</div>
	<div class="row mb-3">
		<div class="col-12 col-md-6">
			<div class="text-color-primary fs-3"><fmt:message key="goodsissue.list.title" /></div>
		</div>
		<div class="col-12 col-md-6 text-right">
			<security:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_GOODS_ISSUE_CREATE')">
				<button type="button" class="btn btn-sm bgc-warning text-color-primary text-uppercase fw-bold mr-2 rounded-10" data-toggle="modal" data-target="#modal_template" data-backdrop="static" data-keyboard="false"><fmt:message key="button.import.template"/></button>
				<a href="<c:url value='/goodsIssue/form'/>" class="btn btn-sm bgc-warning text-color-primary text-uppercase fw-bold rounded-10" title="<fmt:message key="button.add"/>"><i class="icon-plus22"></i> <fmt:message key="button.add" /></a>
			</security:authorize>
		</div>
	</div>
	<form:form id="goodsissueForm" modelAttribute="criteria" action="${ctx}/goodsIssue/list" method="POST">
		<form:hidden path="type" />
		<input type="hidden" value="${criteria.postingDateSearch}" id="postingDateSearch"/>
		<!-- \Searching -->
		<div class="card rounded-16">
			<div class="row">
				<div class="col-6 px-3 py-2 fw-bold"><fmt:message key="label.search" /></div>
				<div class="col-6 text-right">
					<button type="button" class="btn btn-secondary" id="btnReset">Đặt lại</button>
					<button type="button" class="btn btn-secondary mt-2 mr-2" id="btnSubmit"><fmt:message key="button.search" /></button>
				</div>
			</div>
			<div class="card-body py-0">
				<div class="row">
					<div class="col-8">
						<div class="row">
							<div class="col-3">
								<div class="form-group">
									<label><fmt:message key="instock.farmName" /></label>
									<input class="form-control rounded-10" type="text" id="stockName" name="stockName" value="${criteria.stockName}" placeholder="Nhập tên trại"/>
								</div>
							</div>
							<div class="col-2">
								<div class="form-group">
									<label><fmt:message key="goodsissue.transCode"/></label>
									<input class="form-control rounded-10" type="text" id="transCode" name="transCode" placeholder="Nhập số phiếu xuất kho" value="${criteria.transCode }"/>
								</div>
							</div>
							<div class="col-2">
								<div class="form-group">
									<label> <fmt:message key="goodsissue.doCode"/></label>
									<input class="form-control rounded-10" type="text" id="doCode" name="doCode" value="${criteria.doCode}" placeholder="Nhập số DO" />
								</div>
							</div>
							<div class="col-2">
								<div class="form-group">
									<label> <fmt:message key="goodsissue.poCode"/></label>
									<input class="form-control rounded-10" type="text" id="poCode" name="poCode" value="${criteria.poCode}" placeholder="Nhập số PO" />
								</div>
							</div>
							<div class="col-2">
								<div class="form-group">
									<label> <fmt:message key="purchaserequisition.status"/></label>
									<select class="form-control rounded-10 select2" name="status" id="status" data-placeholder="Chọn trạng thái" data-fouc>
										<option value="">&nbsp;</option>
										<c:forEach items="${giStatus}" var="item">
											<option value="${item}" ${criteria.status eq item ? 'selected' : ''}><fmt:message key="purchase.requisition.status.${item}"></fmt:message></option>
										</c:forEach>
									</select>
								</div>
							</div>
						</div>
					</div>
					<div class="col-4">
						<label> <fmt:message key="goodsissue.from.posting.date"/></label>
						<div class="row">
							<div class="col-md-6 col-sm-12 col-xs-12">
								<div class="form-group row">
									<span class="flex-center-vertical">Từ</span>
									<div class="col-lg-10">
										<input type="text" class="form-control rounded-10" placeholder="DD/MM/YYYY" id="fromDate" name="searchFromDate" value="${criteria.searchFromDate}" autocomplete="off" />
									</div>
								</div>
							</div>
							<div class="col-md-6 col-sm-12 col-xs-12">
								<div class="form-group row">
									<span class="flex-center-vertical">đến</span>
									<div class="col-lg-10">
										<input type="text" class="form-control rounded-10" placeholder="DD/MM/YYYY" id="toDate" name="searchToDate" value="${criteria.searchToDate}" autocomplete="off" />
									</div>
								</div>
							</div>
						</div>
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
							<th class="bgc-primary border-primary text-white text-center" style="width: 10%"><fmt:message key="goodsissue.number" /></th>
							<th class="bgc-primary border-primary text-white text-center" style="width: 10%"><fmt:message key="goodsissue.stockCode" /></th>
							<th class="bgc-primary border-primary text-white text-center" style="width: 10%"><fmt:message key="goodsissue.doCode" /></th>
							<th class="bgc-primary border-primary text-white text-center" style="width: 10%"><fmt:message key="goodsissue.customer" /></th>
							<th class="bgc-primary border-primary text-white text-center" style="width: 10%"><fmt:message key="goodsissue.posting.date" /></th>
							<th class="bgc-primary border-primary text-white text-center" style="width: 10%"><fmt:message key="goodsissue.status" /></th>
							<th class="text-center bgc-primary border-primary text-white" style="width: 5%"><i class="icon-menu-open2"></i></th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${empty page.content}">
							<tr>
								<td colspan="7" class="text-center text-none-data">
									<fmt:message key="not.data" />
								</td>
							</tr>
						</c:if>
						<c:forEach var="goodsissue" items="${page.content}" varStatus="cnt">
							<tr>
								<td class="text-center"><c:out value="${cnt.count+page.size*page.number}" /></td>
								<td class="text-center">${goodsissue.transCode}</td>
								<td class="text-center">${goodsissue.stock.code}</td>
								<td class="text-center">${goodsissue.doCode}</td>
								<td class="text-center">${goodsissue.customer}</td>
								<td class="text-center">${goodsissue.displayPostingDate}</td>
								<td class="text-center">
							      	<c:choose>
							         	<c:when test = "${goodsissue.status eq 'synchronized'}">
							            	<span class="badge bg-success-400"><fmt:message key="purchase.requisition.status.${goodsissue.status}"></fmt:message></span>
							         	</c:when>
							         	<c:when test = "${goodsissue.status eq 'cancel'}">
							            	<span class="badge bg-danger-400"><fmt:message key="purchase.requisition.status.${goodsissue.status}"></fmt:message></span>
							         	</c:when>
							        	 <c:otherwise>
							            	<span class="badge bg-primary-400"><fmt:message key="purchase.requisition.status.${goodsissue.status}"></fmt:message></span>
							         	</c:otherwise>
							      	</c:choose>
								</td>
								<td class="text-center">
									<div class="list-icons">
										<div class="dropdown">
											<a href="#" class="list-icons-item" data-toggle="dropdown"><i class="icon-menu9"></i></a>
											<div class="dropdown-menu dropdown-menu-right">
											<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GOODS_ISSUE_EDIT')">
												<a href="/goodsIssue/form?id=${goodsissue.id}" class="dropdown-item"><i class="icon-pencil7"></i><span><fmt:message key="button.detail"/></span></a>
											</security:authorize>
											<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GOODS_ISSUE_EXPORT')">
												<c:if test="${goodsissue.status ne 'cancel'}">
													<a href="/goodsIssue/export/${goodsissue.id}" class="dropdown-item"><i class="icon-file-upload"></i><span><fmt:message key="button.export.word"/></span></a>
													<a href="/goodsIssue/export-excel/${goodsissue.id}" class="dropdown-item"><i class="icon-file-upload"></i><span><fmt:message key="button.export.excel"/></span></a>
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
				<jsp:param value="${page.number}" name="pageNumber" />
				<jsp:param value="${page.totalPages}" name="maxPages" />
				<jsp:param value="${page.size}" name="size" />
				<jsp:param value="${page.totalElements}" name="totalElements" />
			</jsp:include>
		</div>
		<!-- /Table -->
	</form:form>
</div> 

<!-- modal import -->
<form:form id="modalForm" action="${ctx}/goodsReceipt/save" method="post" modelAttribute="criteria" enctype="multipart/form-data">
	<input type="hidden" name="id"/>
	<div id="modal_template" class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<span class="font-weight-semibold modal-title"><fmt:message key="template.goods.issue"/></span>
					<button type="button" class="close" data-dismiss="modal">&times;</button>
				</div>
				
				<div class="modal-body">
					<div class="form-group">
						<select id="selectTemplate" data-placeholder="Lựa chọn template" class="form-control select2" data-fouc>
							<option value="">&nbsp;</option>
							<c:forEach items="${giTemplates}" var="giItem">
								<option value="${giItem.id}"><c:out value="${giItem.stock.code} - ${giItem.stock.name} - ${giItem.templateName}"></c:out></option>
							</c:forEach>
						</select>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-link" data-dismiss="modal">Close</button>
					<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GOODS_ISSUE_DELETE')">
						<button type="button" id="btnDelete" name="btnImport" class="btn bg-primary"><i class="icon-close2 mr-2"></i>Delete</button>
					</security:authorize>
					<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GOODS_ISSUE_CREATE')">
						<button type="button" id="btnView" name="btnImport" class="btn bg-primary"><i class="icon-download7 mr-2"></i>View</button>
					</security:authorize>
				</div>
			</div>
		</div>
	</div>
</form:form>
<!-- /modal import -->
