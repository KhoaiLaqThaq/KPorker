<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="pigprofile.list.title"/></title>
    <meta name="menu" content="pigprofileMenu"/>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
	<link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">
</head>

<div class="content">
<form:form id="pigprofileForm" modelAttribute="criteria" action="<c:url value='/pigprofile/list'/>"  method="post">
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
			<span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="pigprofile.list.title"/></span>
			<security:authorize access="hasAnyRole('ROLE_ADMIN')">
			<div class="header-elements">
				<div class="list-icons">
					<a href="<c:url value='/pigprofile/form'/>" class="btn btn-sm btn-primary" title="<fmt:message key="button.add"/>"><i class="icon-plus22"></i><fmt:message key="button.add"/></a>
               	</div>
        	</div>
        	</security:authorize>
		</div>
		<div class="card-body"><fmt:message key="pigprofile.list.title.description"/></div>
		<div class="table-responsive">
			<table class="table table-bordered table-striped">
				<thead>
					<tr class="table-success">
						<th class="text-center" style="width: 10px">#</th>
						<th><fmt:message key="pigprofile.id"/></th>
						<th><fmt:message key="pigprofile.pigId"/></th>
						<th><fmt:message key="pigprofile.content"/></th>
						<th><fmt:message key="pigprofile.createdBy"/></th>
						<th><fmt:message key="pigprofile.createdDate"/></th>
						<th><fmt:message key="pigprofile.modifiedBy"/></th>
						<th><fmt:message key="pigprofile.modifiedDate"/></th>
						<th class="text-center" style="width:120px;"><i class="icon-menu-open2"></i></th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${empty page.content}">
						<tr><td colspan="6" class="text-center text-none-data"><fmt:message key="not.data"/></td></tr>
					</c:if>
					<c:forEach var="pigprofile" items="${page.content}" varStatus="cnt">
						<tr>
							<td class="text-center"><c:out value="${cnt.count+page.size*page.number}" /></td>
							<td>${pigprofile.id}</td>
							<td>${pigprofile.pigId}</td>
							<td>${pigprofile.content}</td>
							<td>${pigprofile.createdBy}</td>
							<td>${pigprofile.createdDate}</td>
							<td>${pigprofile.modifiedBy}</td>
							<td>${pigprofile.modifiedDate}</td>
							
							<td class="text-center">
								<div class="list-icons">
									<div class="dropdown">
										<a href="#" class="list-icons-item" data-toggle="dropdown"><i class="icon-menu9"></i></a>
										<div class="dropdown-menu dropdown-menu-right">
											<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_PIGPROFILE_EDIT')">
											<a href="#" class="dropdown-item"><i class="icon-pencil7" style="color:blue"> <fmt:message key="button.edit"/></i><></a>
											</security:authorize>
											<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_PIGPROFILE_DEL')">
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


