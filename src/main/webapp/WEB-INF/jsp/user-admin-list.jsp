<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="user.list.title"/></title>
    <meta name="menu" content="orgMenu"/>

	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/assets/css/custom_style.css'/>"></script>
</head>

<div class="content">
<form:form id="userListForm" modelAttribute="userCriteria" action="${ctx}/user/admin/list"  method="post">
	<input type="hidden" name="orgIdentityCode" value="${orgIdentityCode}">
	<security:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_USER_VIEW')">
		<div class="card">
			<div class="card-body">
				<div class="row">
					<div class="col-md-8 offset-md-2"><input class="form-control" type="text" name="username" placeholder="Nhập tên đăng nhập..."/></div>
					<div class="col-md-2"><button type="submit" class="btn btn-secondary"> <i class="icon-search4"></i> <fmt:message key="button.search"/></button></div>
		    	</div>	
	    	</div>
	    </div>
	</security:authorize>
	<%-- <c:url var="urlSubmit" value="/appUser/save"></c:url> --%>
	<!-- Start form user -->
	<div class="card">
		<div class="card-header header-elements-inline">
			<span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="user.list.title"/></span>
			<security:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_USER_EDIT')">
			<div class="header-elements">
				<div class="list-icons">
					<a href="<c:url value='/user/admin/form?oic=${orgIdentityCode}'/>" class="btn btn-sm btn-primary" title="<fmt:message key="button.add"/>"><i class="icon-plus22"></i><fmt:message key="button.add"/></a>
               	</div>
        	</div>
        	</security:authorize>
		</div>
		<div class="card-body"><fmt:message key="user.list.title.description"/></div>
		<div class="table-responsive">
			<table class="table table-bordered table-striped">
				<thead>
					<tr class="table-success">
						<th class="text-center" style="width: 10px">#</th>
						<th><fmt:message key="user.username"/></th>
						<th><fmt:message key="user.group"/></th>
						<th><fmt:message key="user.roles"/></th>
						<th class="text-center"><fmt:message key="user.accountEnabled"/></th>
						<%-- <th><fmt:message key="user.profile"/></th> --%>
						<security:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_USER_EDIT')">
						<th class="text-center" style="width:100px;"><i class="icon-menu-open2"></i></th>
						</security:authorize>
					</tr>
				</thead>
				<tbody>
					<c:if test="${empty page.content}">
						<tr>
							<td colspan="6" class="text-center text-none-data"><fmt:message key="not.data"/></td>
						</tr>
					</c:if>
					<c:forEach var="user" items="${page.content}" varStatus="cnt">
						<tr>
							<td class="text-center"><c:out value="${cnt.count+page.size*page.number}" /></td>
							<td>${user.username}</td>
							<td><c:forEach var="group" items="${user.appGroups}"><p>${group.name}</p> </c:forEach></td>
							<td><c:forEach var="role" items="${user.roles}"><span>${role.description},</span>&nbsp;&nbsp;</c:forEach></td>
							<td class="text-center">
								<c:choose>
									<c:when test="${user.accountEnabled}">
										<i class="icon-circle2 icon-green" style="color: green;"></i>
									</c:when>
									<c:otherwise>
										<i class="icon-circle2" style="color: red;"></i>
									</c:otherwise>
								</c:choose>
							</td>
							<%-- <td>${user.profileType}</td>  --%>
							<security:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_USER_EDIT')">
							<td class="text-center"> 
							<div class="list-icon"> 
								<a href="<c:url value="/user/admin/form?oic=${orgIdentityCode}&id=${user.id}"/>" class="list-icons-item text-primary-600" data-popup="tooltip" title="Sửa"><i class="icon-pencil7"></i></a>
							</div> 
							</td>
							</security:authorize>
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
</form:form>
</div>
