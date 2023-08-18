<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="purchaserequisition.list.title"/></title>
    <meta name="menu" content="purchaseRequisitionMenu"/>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
	<link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">
	<script src="<c:url value='/themes/admin/global_assets/js/main/bootstrap.bundle.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/loaders/blockui.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/switch.min.js'/>"></script>	
	<script	src="<c:url value='/themes/admin/assets/js/purchaserequisition_list.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>
</head>

<div class="row mb-3">
	<div class="col-12"><%@include file="/themes/admin/common/instock-actions.jsp"%></div>
</div>

<div class="content">
	<div class="row mb-3">
		<div class="col-12 col-md-6">
			<div class="text-color-primary fs-5"><fmt:message key="purchaserequisition.list.title" /></div>
		</div>
		<div class="col-12 col-md-6 text-right">
			<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_PURCHASE_REQUISITION_CREATE')">
				<button type="button" class="btn btn-sm bgc-warning text-color-primary mr-2 rounded-10" data-toggle="modal" data-target="#modal_template" data-backdrop="static" data-keyboard="false"><fmt:message key="button.import.template"/></button>
				<a href="<c:url value='/purchaseRequisition/form'/>" class="btn btn-sm bgc-warning text-color-primary rounded-10" title="<fmt:message key="button.add"/>"><i class="icon-plus22"></i><fmt:message key="button.add"/></a>
			</security:authorize>
		</div>
	</div>
<form:form id="purchaserequisitionForm" modelAttribute="criteria" action="${ctx}/purchaseRequisition/list"  method="post">
	<!-- \Searching -->
	<div class="card rounded-16">
		<div class="row"><div class="col-12 px-3 py-2 fw-bold"><fmt:message key="label.search" /></div></div>
		<div class="card-body py-0">
			<div class="row">
				<div class="col-10">
					<div class="row">
						<div class="col-3">
							<div class="form-group">
								<label> <fmt:message key="purchaserequisition.transCode"/></label>
								<input class="form-control rounded-10" id="transCode" type="text" name="transCode" value="${criteria.transCode}" placeholder="Nhập mã phiếu yêu cầu" />
							</div>
						</div>
						<div class="col-2">
							<div class="form-group">
								<label><fmt:message key="purchaserequisition.farmName"/></label>
								<input class="form-control rounded-10" id="stockName" type="text" name="stockName" value="${criteria.stockName}" placeholder="Nhập tên trại" />
							</div>
						</div>
						<div class="col-2">
							<label> <fmt:message key="purchaserequisition.status"/></label>
							<select class="form-control rounded-10 select2" name="status" id="status" data-placeholder="Chọn trạng thái" data-fouc>
								<option value="">&nbsp;</option>
								<c:forEach items="${prStatus}" var="item">
									<option value="${item}" ${criteria.status eq item ? 'selected' : ''}><fmt:message key="purchase.requisition.status.${item}"></fmt:message></option>
								</c:forEach>
							</select>
						</div>
						<div class="col-2">
							<label> <fmt:message key="purchaserequisition.type"/></label>
							<select class="form-control rounded-10 select2" name="type" id="type" data-placeholder="Chọn loại PR" data-fouc>
								<option value="">&nbsp;</option>
								<c:forEach items="${types}" var="item">
									<option value="${item}" ${criteria.type eq item ? 'selected' : ''}><fmt:message key="purchase.requisition.type.${item}"></fmt:message></option>
								</c:forEach>
							</select>
						</div>
						<div class="col-3">
							<label> <fmt:message key="purchaserequisition.prType"/></label>
							<select	id="purchaserequisitionPrType" name="prType" class="form-control select2" data-placeholder="Chọn loại yêu cầu">
								<option value="">&nbsp;</option>
								<c:forEach var="item" items="${prTypes}">
									<option value="${item}" ${item == criteria.prType ? 'selected="selected"' : ''}><fmt:message key="purchaserequisition.prType.${item}" /></option>
								</c:forEach>
							</select>
						</div>
					</div>
				</div>
				<div class="col-2 text-right mt-3">
					<button type="button" class="btn btn-secondary" id="btnReset">Đặt lại</button>
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
						<th class="bgc-primary border-primary text-white" style="width: 8%"><fmt:message key="purchaserequisition.transCode"/></th>
						<th class="bgc-primary border-primary text-white" style="width: 10%"><fmt:message key="purchaserequisition.prGroupCode"/></th>
						<th class="bgc-primary border-primary text-white" style="width: 10%"><fmt:message key="purchaserequisition.stockCode"/></th>							
						<th class="bgc-primary border-primary text-white" style="width: 10%"><fmt:message key="purchaserequisition.type"/></th>
						<th class="bgc-primary border-primary text-white" style="width: 10%"><fmt:message key="purchaserequisition.prType"/></th>
						<th class="bgc-primary border-primary text-white" style="width: 10%"><fmt:message key="purchaserequisition.purchasing.group"/></th>
						<th class="bgc-primary border-primary text-white" style="width: 10%"><fmt:message key="purchaserequisition.createdDate"/></th>
						<th class="bgc-primary border-primary text-white" style="width: 10%"><fmt:message key="purchaserequisition.status"/></th>
						<th class="text-center bgc-primary border-primary text-white" style="width: 5%;"><i class="icon-menu-open2"></i></th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${empty page.content}">
						<tr><td colspan="8" class="text-center text-none-data"><fmt:message key="not.data"/></td></tr>
					</c:if>
					<c:forEach var="purchaserequisition" items="${page.content}" varStatus="cnt">
						<tr>
							<td class="text-center"><c:out value="${cnt.count+page.size*page.number}" /></td>
							<td>${purchaserequisition.transCode}</td>
							<td>${purchaserequisition.prGroupCode}</td>
							<td>${purchaserequisition.stock.code}</td>						
							<td><fmt:message key="purchase.requisition.type.${purchaserequisition.type}"></fmt:message></td>
							<td><fmt:message key="purchaserequisition.prType.${purchaserequisition.prType}" /></td>
							<td>
								<c:if test="${not empty purchaserequisition.purchasingGroup}">
									<fmt:message key="purchaserequisition.purchasing.group.${purchaserequisition.purchasingGroup}" />
								</c:if>
							</td>
							<td>${purchaserequisition.displayCreatedDate}</td>
							<td>
								<c:choose>
									 <c:when test = "${purchaserequisition.status eq 'confirmed'}">
						            	<span class="badge bg-info-400"><fmt:message key="purchase.requisition.status.${purchaserequisition.status}"></fmt:message></span>
						         	</c:when>
						        	 <c:when test = "${purchaserequisition.status eq 'approved'}">
						            	<span class="badge bg-success-400"><fmt:message key="purchase.requisition.status.${purchaserequisition.status}"></fmt:message></span>
						         	</c:when>
						         	<c:when test = "${purchaserequisition.status eq 'synchronized'}">
						            	<span class="badge bg-primary-400"><fmt:message key="purchase.requisition.status.${purchaserequisition.status}"></fmt:message></span>
						         	</c:when>
						        	 <c:otherwise>
						            	<span class="badge bg-danger-400"><fmt:message key="purchase.requisition.status.${purchaserequisition.status}"></fmt:message></span>
						         	</c:otherwise>
						      	</c:choose>
							</td>
							<td class="text-center">
								<div class="list-icons">
									<div class="dropdown">
										<a href="#" class="list-icons-item" data-toggle="dropdown"><i class="icon-menu9"></i></a>
										<div class="dropdown-menu dropdown-menu-right">
											<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_PURCHASE_REQUISITION_EDIT')">
												<c:choose>
													 <c:when test = "${purchaserequisition.status eq 'unconfirmed'}">
										            	<a href="/purchaseRequisition/form?id=${purchaserequisition.id}" class="dropdown-item"><i class="icon-pencil7" style="color:blue"> <fmt:message key="button.edit"/></i></a>
										         	</c:when>
										        	 <c:otherwise>
										            	<a href="/purchaseRequisition/form?id=${purchaserequisition.id}" class="dropdown-item"><i class="icon-pencil7" style="color:blue"> <fmt:message key="button.detail"/></i></a>
										         	</c:otherwise>
										      	</c:choose>
											</security:authorize>
											<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_PURCHASE_REQUISITION_EXPORT')">
												<a href="/purchaseRequisition/Export/${purchaserequisition.id}/${purchaserequisition.prType}" class="dropdown-item"><i class="icon-file-upload"></i><span><fmt:message key="button.export"/></span></a>
											</security:authorize>
											<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_PURCHASE_REQUISITION_CREATE')">
												<c:if test = "${purchaserequisition.status ==  'reject'}">
											         <a href="/purchaseRequisition/form?id=${purchaserequisition.id}&clone=true" class="dropdown-item"><i class="icon-pencil7" style="color:blue"> <fmt:message key="button.clone"/></i></a>
											    </c:if>
											</security:authorize>
											<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_PURCHASE_REQUISITION_DELETE')">
												<c:if test = "${purchaserequisition.status eq 'unconfirmed'}">
													<a href="#" class="dropdown-item" onclick="return checkDelete(${purchaserequisition.id})"><i class="icon-cancel-square"  style="color:red"></i> <fmt:message key="button.delete"/></a>
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

<!-- modal list template -->
<form:form id="purchaserequisitionModalForm" action="${ctx}/purchaseRequisition/save" method="post" modelAttribute="criteria" enctype="multipart/form-data">
	<input type="hidden" name="id"/>
	<div id="modal_template" class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<span class="font-weight-semibold modal-title"><fmt:message key="template.purchase.requisition"/></span>
					<button type="button" class="close" data-dismiss="modal">&times;</button>
				</div>
				
				<div class="modal-body">
					<div class="form-group">
						<select id="selectTemplate" data-placeholder="Lựa chọn template" class="form-control select2" data-fouc>
							<option value="">&nbsp;</option>
							<c:forEach items="${prTemplates}" var="prItem">
								<option value="${prItem.id}"><c:out value="${prItem.stock.code} - ${prItem.stock.name} - ${prItem.templateName}"></c:out></option>
							</c:forEach>
						</select>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-link" data-dismiss="modal">Close</button>
					<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_PURCHASE_REQUISITION_DELETE')">
						<button type="button" id="btnDelete" name="btnImport" class="btn bg-primary"><i class="icon-close2 mr-2"></i>Delete</button>
					</security:authorize>
					<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_PURCHASE_REQUISITION_CREATE')">
						<button type="button" id="btnView" name="btnImport" class="btn bg-primary"><i class="icon-download7 mr-2"></i>View</button>
					</security:authorize>
					
				</div>
			</div>
		</div>
	</div>
</form:form>
<!-- /modal list template -->
