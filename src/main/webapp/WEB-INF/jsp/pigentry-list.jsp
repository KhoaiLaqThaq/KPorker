<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
	<title><fmt:message key="pigentry.list.title" /></title>
	<meta name="menu" content="processOrderMenu" />
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
	<link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">
	<script src="<c:url value='/themes/admin/assets/js/pigentry_list.js'/>"></script>
</head>

<div class="content">
	<form:form id="pigEntryForm" modelAttribute="criteria" action="${ctx }/pigEntry/list?code=${criteria.processOrderCode }" method="post">
		<!-- \Searching -->
		<form:hidden path="toDate" id="toDate"/>
		<form:hidden path="fromDate"  id="fromDate"/> 
 		<input hidden="hidden" id="processOrderstatus" value="${processOrder.status}" />  
 		
		<!-- \Table -->
		<div class="card">
			<div class="card-header header-elements-inline">
				<span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="pigentry.list.title" /> - <c:out value = "${processOrder.barn.farm.name}"/> - <c:out value = "${processOrder.barn.code}"/></span>
				<security:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_PIG_ENTRY_CREATE')">
					<div class="header-elements">
						<div class="list-icons">
							<c:if test="${processOrder.status ne 'closed'}">
								<a href="<c:url value='/pigEntry/form?code=${criteria.processOrderCode}'/>" class="btn btn-sm btn-primary" title="<fmt:message key="button.add"/>"><i class="icon-plus22"></i>	<fmt:message key="button.add" /></a>
							</c:if>
						</div>
					</div>
				</security:authorize>
			</div>
			<div class="card-body">
 				<fmt:message key="pigentry.list.title.description" /> 
				<div class="row">
					<div class="col-xs-12 col-md-3">
							<div class="form-group">
								<label ><fmt:message key="goodsissue.processOrder"/>: <b class="ml-3"><c:out value="${processOrder.code }" /></b></label>
							</div>
					</div>
				</div>
				
			</div>
			<div class="table-responsive">
				<table class="table table-bordered table-striped">
					<thead>
						<tr class="table-success">
							<th class="text-center" style="width: 10px">#</th>
							<th><fmt:message key="pigentry.sourceFarm" /></th>
							<th><fmt:message key="pigentry.receiveFarm" /></th>
							<th><fmt:message key="pigentry.quantity" /></th>
							<th><fmt:message key="pigentry.entryVolumnTotal" /></th>
							<th><fmt:message key="pigentry.averageVolume" /></th>
							<th><fmt:message key="pigentry.entryDate" /></th>
							<th><fmt:message key="goodsreceipt.status"/></th>
							<th class="text-center" style="width: 20px;"><i class="icon-menu-open2"></i></th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${empty page.content}">
							<tr>
								<td colspan="9" class="text-center text-none-data">
									<fmt:message key="not.data" />
								</td>
							</tr>
						</c:if>
						<c:forEach var="pigentry" items="${page.content}" varStatus="cnt">
							<tr>
								<td class="text-center">
									<c:out value="${cnt.count+page.size*page.number}" />
								</td>
								<td>${pigentry.sourceFarmName}</td>
								<td>${pigentry.receiveFarmName}</td>
								<td>${pigentry.quantity}</td>
								<td>${pigentry.totalEntryVolumn}</td>
								<td>${pigentry.averageVolume}</td>
								<td>${pigentry.displayEntryDate}</td>
								<td>
							      	<c:choose>
							         	<c:when test = "${pigentry.status eq 'cancel'}">
							            	<span class="badge bg-danger-400"><fmt:message key="purchase.requisition.status.${pigentry.status}"></fmt:message></span>
							         	</c:when>
							        	 <c:otherwise>
							            	<span class="badge bg-primary-400"><fmt:message key="purchase.requisition.status.${pigentry.status}"></fmt:message></span>
							         	</c:otherwise>
							      	</c:choose>
								</td>
								<td class="text-center">
									<div class="list-icons">
										<div class="dropdown">
											<a href="#" class="list-icons-item" data-toggle="dropdown"><i class="icon-menu9"></i></a>
											<div class="dropdown-menu dropdown-menu-right">
												<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_PIG_ENTRY_EDIT')">
													<a href="/pigEntry/form?id=${pigentry.id }&code=${pigentry.processOrderCode}" class="dropdown-item"><i class="icon-pencil7" style="color: blue"><fmt:message key="button.detail" /></i></a>
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
		<a href="<c:url value="/processOrder/list"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i><fmt:message key="button.back" /></a>
		<!-- /Table -->
	</form:form>
</div>