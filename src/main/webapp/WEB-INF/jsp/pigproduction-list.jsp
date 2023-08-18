<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
	<title><fmt:message key="pigprod.list.title" /></title>
	<meta name="menu" content="processOrderMenu" />
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
	<link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">
</head>

<div class="content">
	<form:form id="pigProductionForm" modelAttribute="criteria" action="${ctx}/pigProduction/list?poCode=${criteria.processOrderCode }" method="post">
	<form:hidden id="processOrderCode" path="processOrderCode"/>
	

		<!-- \Table -->
		<div class="card">
			<div class="card-header header-elements-inline">
				<span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="pigprod.list.title" /> - <c:out value = "${processOrder.barn.farm.name}"/> - <c:out value = "${processOrder.barn.code}"/></span>
				<security:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_FINISH_PRODUCT_CREATE')">
					<div class="header-elements">
						<div class="list-icons">
							<c:if test="${ processOrder.status != 'closed' and totalPigRetained > 0  }">
								<a href="<c:url value='/pigProduction/form?poCode=${criteria.processOrderCode}'/>" class="btn btn-sm btn-primary" title="<fmt:message key="button.add"/>"><i class="icon-plus22"></i>	<fmt:message key="button.add" /></a>
							</c:if>
							<a href="/pigProduction/export" id="exportReport" class="btn btn-sm btn-primary"><i class="icon-database-export pr-2"></i>Xuất báo cáo</a>
						</div>
					</div>
				</security:authorize>
			</div>
			<div class="card-body">
				<fmt:message key="pigprod.list.title.description" />
			</div>
			<div class="table-responsive">
				<table class="table table-bordered table-striped">
					<thead>
						<tr class="table-success">
							<th class="text-center" style="width: 5%">#</th>
							<th style="width: 10%"><fmt:message key="pigprod.processOrderCode"/></th>
							<th style="width: 10%"><fmt:message key="event.transCode"></fmt:message></th>
							<th style="width: 10%"><fmt:message key="pigdead.reason"></fmt:message></th>
							<th style="width: 10%"><fmt:message key="pigprod.quantity"/></th>
							<th style="width: 10%"><fmt:message key="pigdead.weight"/></th>
							<th style="width: 10%"><fmt:message key="dailyAverageWeight.avgWeight"/></th>
							<th style="width: 10%"><fmt:message key="pigdead.posting.date"/></th>
							<th style="width: 10%"><fmt:message key="pigprod.status"/></th>
							<th class="text-center" style="width: 5%"><i class="icon-menu-open2"></i></th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${empty page.content}">
							<tr>
								<td colspan="10" class="text-center text-none-data"><fmt:message key="not.data" /></td>
							</tr>
						</c:if>
						<c:forEach var="pigprod" items="${page.content}" varStatus="cnt">
							<tr>
								<td class="text-center"><c:out value="${cnt.count+page.size*page.number}" /></td>
								<td>${criteria.processOrderCode}</td>
								<td>${pigprod.transCode}</td>
								<td>${pigprod.pigProd.reason}</td>
								<td>${pigprod.quantity}</td>
								<td>${pigprod.pigProd.weight}</td>
								<td>${pigprod.pigProd.weight != null ? pigprod.pigProd.weight/pigprod.pigProd.quantity : 0}</td>
								<td>${pigprod.displayPostingDate}</td>
								<td>
									<c:choose>
										 <c:when test = "${pigprod.status eq 'confirmed'}">
							            	<span class="badge bg-info-400"><fmt:message key="purchase.requisition.status.${pigprod.status}"></fmt:message></span>
							         	</c:when>
							         	<c:when test = "${pigprod.status eq 'synchronized'}">
							            	<span class="badge bg-primary-400"><fmt:message key="purchase.requisition.status.${pigprod.status}"></fmt:message></span>
							         	</c:when>
							        	 <c:otherwise>
							            	<span class="badge bg-danger-400"><fmt:message key="purchase.requisition.status.${pigprod.status}"></fmt:message></span>
							         	</c:otherwise>
						      		</c:choose>
								</td>
								<td class="text-center">
									<div class="list-icons">
										<div class="dropdown">
											<a href="#" class="list-icons-item" data-toggle="dropdown"><i class="icon-menu9"></i></a>
											<div class="dropdown-menu dropdown-menu-right">
												<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_FINISH_PRODUCT_EDIT')">
													<a href="/pigProduction/form?poCode=${criteria.processOrderCode}&id=${pigprod.id}" class="dropdown-item"><i class="icon-pencil7" style="color:blue"> <fmt:message key="button.detail"/></i></a>
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
		<a href="<c:url value="/processOrder/list"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i><fmt:message key="button.back" /></a>
		<!-- /Table -->
	</form:form>
</div>

  <script src="<c:url value='/themes/admin/assets/js/pigproduction_list.js'/>"></script>