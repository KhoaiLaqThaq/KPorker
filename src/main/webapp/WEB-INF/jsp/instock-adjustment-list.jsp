<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="instockAdjustment.list.title"/></title>
    <meta name="menu" content="instockAdjustmentMenu"/>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
	<link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">
    <script src="<c:url value='/themes/admin/assets/js/instockAdjustment_list.js'/>"></script>
</head>

<div class="row mb-3">
	<div class="col-12"><%@include file="/themes/admin/common/instock-actions.jsp"%></div>
</div>

<div class="content">
	<div class="row mb-3">
		<div class="col-12 col-md-6">
			<div class="text-color-primary fs-5"><fmt:message key="instockAdjustment.list.title" /></div>
		</div>
		<div class="col-12 col-md-6 text-right">
			<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_INSTOCK_ADJUSTMENT_CREATE')">
				<a href="<c:url value='/instockAdjustment/form'/>" class="btn btn-sm bgc-warning rounded-10 text-white" title="<fmt:message key="button.add"/>"><i class="icon-plus22"></i><fmt:message key="button.add"/></a>
			</security:authorize>
		</div>
	</div>
<form:form id="instockAdjustmentForm" modelAttribute="criteria" action="${ctx}/instockAdjustment/list"  method="post">
	<!-- \Searching -->
	<div class="card rounded-16">
		<div class="row"><div class="col-12 px-3 py-2 fw-bold"><fmt:message key="label.search" /></div></div>
		<div class="card-body py-0">
			<div class="row">
			    <div class="col-md-5">
				    <div class="form-group">
				        <label><fmt:message key="instock.farmName" /></label>
				        <input class="form-control rounded-10" type="text" id="stockName" name="stockName" value="${criteria.stockName}" placeholder="Nhập tên trại"/>
				    </div>
				</div>
				<div class="col-md-5">
			         <div class="form-group">
			             <label><fmt:message key="instockAdjustment.transCode"/></label>
                        <input class="form-control rounded-10" type="text" id="transCode" name="transCode" placeholder="Nhập số phiếu điều chỉnh tồn" value="${criteria.transCode }"/>
			         </div>
			    </div>
				<div class="col-md-2 text-right mt-3">
					<button type="button" class="btn btn-secondary" id="btnSubmit"><i class="mr-2 icon-search4"></i><fmt:message key="button.search" /></button>
				</div>
	    	</div>
    	</div>
    </div>
    <!-- /Searching -->
	    
	<!-- \Table -->
	<div class="card">
		<div class="table-responsive">
			<table class="table table-bordered table-striped table-hover">
				<thead>
					<tr class="table-success">
						<th class="bgc-primary border-primary text-white text-center" style="width: 10px">#</th>
						<th class="bgc-primary border-primary text-white text-center"><fmt:message key="purchaserequisition.farmCode"/></th>
						<th class="bgc-primary border-primary text-white text-center"><fmt:message key="purchaserequisition.farmName"/></th>
						<th class="bgc-primary border-primary text-white text-center"><fmt:message key="instockAdjustment.transCode"/></th>
						<th class="bgc-primary border-primary text-white text-center"><fmt:message key="instockAdjustment.type"/></th>
						<th class="bgc-primary border-primary text-white text-center"><fmt:message key="goodsreceipt.createdDate"/></th>
						<th class="bgc-primary border-primary text-white text-center"><fmt:message key="goodsreceipt.status"/></th>
						<th class="bgc-primary border-primary text-white text-center" style="width:120px;"><i class="icon-menu-open2"></i></th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${empty page.content}">
						<tr><td colspan="6" class="text-center text-none-data"><fmt:message key="not.data"/></td></tr>
					</c:if>
					<c:forEach var="item" items="${page.content}" varStatus="cnt">
						<tr>
							<td class="text-center"><c:out value="${cnt.count+page.size*page.number}" /></td>
							<td class="text-center">${item.stock.code}</td>
							<td class="text-center">${item.stock.name}</td>
							<td class="text-center">${item.transCode}</td>
							<td class="text-center">
								<c:choose>
						         	<c:when test = "${item.type eq 'adjustment_increase'}">
						            	<span class="badge bg-success-400"><fmt:message key="instockAdjustment.type.${item.type}"></fmt:message></span>
						         	</c:when>
						        	 <c:otherwise>
						            	<span class="badge bg-primary-400"><fmt:message key="instockAdjustment.type.${item.type}"></fmt:message></span>
						         	</c:otherwise>
						      	</c:choose>
							</td>
							<td class="text-center">${item.displayCreatedDate}</td>
							<td class="text-center">
								<c:choose>
						         	<c:when test = "${item.status eq 'cancel'}">
						            	<span class="badge bg-danger-400"><fmt:message key="purchase.requisition.status.${item.status}"></fmt:message></span>
						         	</c:when>
						        	 <c:otherwise>
						            	<span class="badge bg-primary-400"><fmt:message key="purchase.requisition.status.${item.status}"></fmt:message></span>
						         	</c:otherwise>
						      	</c:choose>
							</td>
							<td class="text-center">
								<div class="list-icons">
									<div class="dropdown">
										<a href="#" class="list-icons-item" data-toggle="dropdown"><i class="icon-menu9"></i></a>
										<div class="dropdown-menu dropdown-menu-right">
											<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_INSTOCK_ADJUSTMENT_EDIT')">
												<a href="/instockAdjustment/form?id=${item.id}" class="dropdown-item"><i class="icon-pencil7"></i><span><fmt:message key="button.detail"/></span></a>
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