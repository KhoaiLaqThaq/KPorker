<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
	<title><fmt:message key="group.list.title" /></title>
	<meta name="menu" content="groupMenu" />
	<script src="<c:url value='/themes/admin/assets/css/custom_style.css'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
</head>

<div class="row mb-3">
	<div class="col-12"><%@include file="/themes/admin/common/actions.jsp"%></div>
</div>

<div class="content">
	<div class="row mb-3">
		<div class="col-12 col-md-6">
			<div class="text-color-primary fs-5"><fmt:message key="group.list.title" /></div>
		</div>
		<div class="col-12 col-md-6 text-right">
			<security:authorize access="hasAnyRole(' ROLE_ADMIN,ROLE_ORG_ADMIN,ROLE_USER_EDIT')">
				<a href="<c:url value='/group/form'/>" class="btn rounded-10 px-3 bgc-warning text-white" title="<fmt:message key="button.add"/>"><i class="icon-plus22"></i><fmt:message key="button.add" /></a>
				<a href="<c:url value='/group/form/newDesign'/>" class="btn rounded-10 px-3 bgc-warning text-white" title="<fmt:message key="button.add"/>"><i class="icon-plus22"></i><fmt:message key="button.add" /> new design</a>
			</security:authorize>
		</div>
	</div>
	
	<form:form id="groupListForm" modelAttribute="groupCriteria" action="${ctx}/group/list" method="post">
		<security:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_ORG_ADMIN,ROLE_USER_VIEW')">
			<div class="card rounded-16">
				<div class="row"><div class="col-12 px-3 py-2 fw-bold"><fmt:message key="label.search" /></div></div>
				<div class="card-body py-0">
					<div class="row mb-3">
						<div class="col-md-7 offset-md-2"><input class="form-control rounded-10" type="text" name="name" placeholder="Nhập tên nhóm..." /></div>
						<div class="col-md-2"><button type="submit" class="btn btn-secondary rounded-10"><i class="icon-search4"></i><fmt:message key="button.search" /></button></div>
					</div>
				</div>
			</div>
		</security:authorize>
		
		<!-- Start list group -->
		<div class="card">
			<div class="table-responsive">
				<table class="table table-bordered table-striped">
					<thead>
						<tr class="table-success">
							<th class="text-center bgc-primary text-white border-primary" style="width: 10px">#</th>
							<th class=" bgc-primary text-white border-primary"><fmt:message key="group.name" /></th>
							<th class="text-center bgc-primary text-white border-primary"><fmt:message key="group.enabled" /></th>
							<th class="text-center bgc-primary text-white border-primary" style="width: 100px;"><i class="icon-menu-open2"></i></th>
						</tr>
					</thead>
					<tbody>
	 					<c:if test="${empty groups}">
							<tr><td colspan="6" class="text-center text-none-data"><fmt:message key="not.data"/></td></tr>
						</c:if>
						<c:forEach var="group" items="${groups}" varStatus="cnt">
	 						<tr>
								<td class="text-center"><c:out value="${cnt.count+page.size*page.number}" /></td>
								<td>${group.name}</td>
								<td class="text-center"><i class="icon-circle2 ${ group.enabled ? 'icon-green' : 'icon-red'}"></i></td>
								<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GROUP_EDIT')">
	 							<td class="text-center">
	 								<div class="list-icon">
	 								  <a href="<c:url value="/group/form?id=${group.id}"/>" class="list-icons-item " title="Sửa"><i class="icon-pencil7"></i></a>
	 								</div>
	 							</td>
								</security:authorize>
	 						</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			<!-- End list group -->
		</div>
	</form:form>
</div>