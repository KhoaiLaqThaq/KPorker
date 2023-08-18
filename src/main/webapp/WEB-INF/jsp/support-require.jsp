<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
	<title><fmt:message key="menu.support" /></title>
	<meta name="menu" content="supportRequire" />	
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
	<link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/ui/moment/moment.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/daterangepicker.js'/>"></script>    
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.date.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/legacy.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/jgrowl.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/demo_pages/picker_date.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>	
</head>

<div class="content">
	<form:form id="supportQuire" modelAttribute="criteria" action="${ctx}//help/list" method="post">
		
		<!-- \Table -->
		<div class="card">
			<div class="card-header header-elements-inline">
				<span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="support.list" /></span>
					<div class="header-elements">
						 <div class="list-icons">
						 	<c:url var="supportRequire" value="/help/form"></c:url>
 							<a href="${supportRequire }" class="btn bgc-warning text-white" title="<fmt:message key="button.add"/>"><i class="icon-plus22"></i>	<fmt:message key="button.add" /></a>
 						</div>
					</div>
			</div>
			<div class="table-responsive">
				<table class="table table-bordered table-striped">
					<thead>
						<tr class="table-success">
							<th class="text-center bgc-primary border-primary text-white" style="width: 5%">#</th>
							<th class="text-center bgc-primary border-primary text-white"><fmt:message key="support.sdp.subject"/></th>		
							<th class="text-center bgc-primary border-primary text-white"><fmt:message key="support.sdp.subCategory"/></th>
							<th class="text-center bgc-primary border-primary text-white"><fmt:message key="support.sdp.item"/></th>
							<th class="text-center bgc-primary border-primary text-white"><fmt:message key="support.sdp.type"/></th>
							<th class="text-center bgc-primary border-primary text-white"><fmt:message key="support.sdp.createdDate"/></th>
							<th class="text-center bgc-primary border-primary text-white" style="width: 5%"><i class="icon-menu-open2"></i></th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${empty page.content}">
							<tr>
								<td colspan="7" class="text-center text-none-data"><fmt:message key="not.data" /></td>
							</tr>
						</c:if>
						<c:forEach var="item" items="${page.content}" varStatus="cnt">
							<tr>
								<td class="text-center"><c:out value="${cnt.count+page.size*page.number}" /></td>
								<td class="text-center">${item.subject}</td>
								<td class="text-center">${item.subCategory}</td>
								<td class="text-center">${item.itemName}</td>
								<td class="text-center">${item.udfField_902}</td>
								<td class="text-center">${item.displayCreatedDate}</td>
								
 								<td class="text-center">
 									<c:choose>
										<c:when test="${item.status eq 'reject'}">
											<i class="icon-file-eye fontSize18" data-popup="tooltip" title="${item.error}"></i>
										</c:when>
										<c:otherwise>
											<div class="list-icons">
		 										<div class="dropdown">
		 											<a href="#" class="list-icons-item" data-toggle="dropdown"><i class="icon-menu9"></i></a>
													<div class="dropdown-menu dropdown-menu-right">
														<security:authorize access="hasAnyRole('ROLE_ADMIN','ROLE_PIG_CULLING_UPDATE')">
															<a href="/help/form?id=${item.id}" class="dropdown-item"><i class="icon-pencil7" style="color:blue"> <fmt:message key="button.edit"/></i></a>
		 												</security:authorize>
													</div>
		 										</div>
											</div>
										</c:otherwise>
									</c:choose>
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

<div class="modal hide" id="pleaseWaitDialog" data-backdrop="static" data-keyboard="false">
    <div class="modal-body">
        <div class="loading">Loading&#8230;</div>
    </div>
</div>
