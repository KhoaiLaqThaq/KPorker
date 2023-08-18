<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="production.list.title"/></title>
    <meta name="menu" content="productionMenu"/>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
	<link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">
</head>

<div class="content">
<form:form id="productionForm" modelAttribute="criteria" action="<c:url value='/production/list'/>"  method="post">
	<!-- \Searching -->
	<div class="card">
		<div class="card-body">
			<div class="row">
				<div class="col-md-8 offset-md-2"><input class="form-control" type="text" name="name" value="" placeholder="Enter keyword..."/></div>
				<div class="col-md-2"><button type="submit" class="btn btn-secondary"> <i class="icon-search4"></i> <fmt:message key="button.search"/></button></div>
	    	</div>
    	</div>
    </div>
    <!-- /Searching -->
	    
	<!-- \Table -->
	<div class="card">
		<div class="card-header header-elements-inline">
			<span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="production.list.title"/></span>
			<security:authorize access="hasAnyRole('ROLE_ADMIN')">
			<div class="header-elements">
				<div class="list-icons">
					<a href="<c:url value='/production/form'/>" class="btn btn-sm btn-primary" title="<fmt:message key="button.add"/>"><i class="icon-plus22"></i><fmt:message key="button.add"/></a>
               	</div>
        	</div>
        	</security:authorize>
		</div>
		<div class="card-body"><fmt:message key="production.list.title.description"/></div>
		<div class="table-responsive">
			<table class="table table-bordered table-striped">
				<thead>
					<tr class="table-success">
						<th class="text-center" style="width: 10px">#</th>
						<th><fmt:message key="production.id"/></th>
						<th><fmt:message key="production.processOrderCode"/></th>
						<th><fmt:message key="production.feedDay"/></th>
						<th><fmt:message key="production.feedDate"/></th>
						<th><fmt:message key="production.feedWeek"/></th>
						<th><fmt:message key="production.feedWeekStartDate"/></th>
						<th><fmt:message key="production.feedWeekToDate"/></th>
						<th><fmt:message key="production.totalPig"/></th>
						<th><fmt:message key="production.totalPigRetained"/></th>
						<th><fmt:message key="production.totalPigDead"/></th>
						<th><fmt:message key="production.moreInfo"/></th>
						<th><fmt:message key="production.createdBy"/></th>
						<th><fmt:message key="production.createdDate"/></th>
						<th><fmt:message key="production.modifiedBy"/></th>
						<th><fmt:message key="production.modifiedDate"/></th>
						<th><fmt:message key="production.latest"/></th>
						<th class="text-center" style="width:120px;"><i class="icon-menu-open2"></i></th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${empty page.content}">
						<tr><td colspan="6" class="text-center text-none-data"><fmt:message key="not.data"/></td></tr>
					</c:if>
					<c:forEach var="production" items="${page.content}" varStatus="cnt">
						<tr>
							<td class="text-center"><c:out value="${cnt.count+page.size*page.number}" /></td>
							<td>${production.id}</td>
							<td>${production.processOrderCode}</td>
							<td>${production.feedDay}</td>
							<td>${production.feedDate}</td>
							<td>${production.feedWeek}</td>
							<td>${production.feedWeekStartDate}</td>
							<td>${production.feedWeekToDate}</td>
							<td>${production.totalPig}</td>
							<td>${production.totalPigRetained}</td>
							<td>${production.totalPigDead}</td>
							<td>${production.moreInfo}</td>
							<td>${production.createdBy}</td>
							<td>${production.createdDate}</td>
							<td>${production.modifiedBy}</td>
							<td>${production.modifiedDate}</td>
							<td>${production.latest}</td>
							
							<td class="text-center">
								<div class="list-icons">
									<div class="dropdown">
										<a href="#" class="list-icons-item" data-toggle="dropdown"><i class="icon-menu9"></i></a>
										<div class="dropdown-menu dropdown-menu-right">
											<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_PRODUCTION_EDIT')">
											<a href="#" class="dropdown-item"><i class="icon-pencil7" style="color:blue"> <fmt:message key="button.edit"/></i><></a>
											</security:authorize>
											<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_PRODUCTION_DEL')">
											<a href="#" class="dropdown-item"><i class="icon-cancel-square"  style="color:red"></i> <fmt:message key="button.delete"/></a>
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

