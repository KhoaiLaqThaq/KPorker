<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
	<title><fmt:message key="user.list.title" /></title>
	<meta name="menu" content="userList" />
	
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
	<%-- <script src="<c:url value='/themes/admin/assets/js/repository_form.js'/>"></script> --%>
	<script src="<c:url value='/themes/admin/assets/css/custom_style.css'/>"></script>

    <!-- bootbox -->
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/demo_pages/components_modals.js'/>"></script>
</head>

<div class="row mb-3">
	<div class="col-12"><%@include file="/themes/admin/common/actions.jsp"%></div>
</div>

<div class="content">
	<div class="row mb-3">
		<div class="col-12 col-md-6">
			<div class="text-color-primary fs-5"><fmt:message key="user.list.title" /></div>
		</div>
		<div class="col-12 col-md-6 text-right">
			<security:authorize access="hasAnyRole(' ROLE_ADMIN,ROLE_ORG_ADMIN,ROLE_USER_EDIT')">
				<a href="<c:url value='/user/form'/>" class="btn rounded-10 px-3 bgc-warning text-white" title="<fmt:message key="button.add"/>"><i class="icon-plus22"></i><fmt:message key="button.add" /></a>
			</security:authorize>
		</div>
	</div>

	<div id="message_content">
		<span id="message_success"></span>
	</div>
	<form:form id="userListForm" modelAttribute="userCriteria" action="${ctx}/user/list" method="post">
		<security:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_ORG_ADMIN, ROLE_USER_VIEW')">
			<div class="card rounded-16">
				<div class="row"><div class="col-12 px-3 py-2 fw-bold"><fmt:message key="label.search" /></div></div>
				<div class="card-body py-0">
					<div class="row">
						<div class="col-md-8">
						    <div class="form-group">
								<label>Nhập tên đăng nhập:</label>
								<input class="form-control rounded-10" type="text" name="username" value="${userCriteria.username}"
									   data-toggle="dropdown" data-popup="tooltip" title="Nhập 3 ký tự" placeholder="Nhập tên đăng nhập..."
								/>
							</div>
						</div>
						<div class="col-md-4 text-right mt-3"><button type="submit" class="btn btn-secondary rounded-10"><i class="icon-search4"></i><fmt:message key="button.search" /></button></div>
					</div>
				</div>
			</div>
		</security:authorize>
		<!-- Start form user -->
		<div class="card">
			<div class="table-responsive">
				<table class="table table-bordered table-striped">
					<thead>
						<tr class="table-success">
							<th class="text-center bgc-primary border-primary text-white" style="width: 10px">#</th>
							<th class=" bgc-primary border-primary text-white"><fmt:message key="user.username" /></th>
							<th class=" bgc-primary border-primary text-white"><fmt:message key="user.email" /></th>
							<th class=" bgc-primary border-primary text-white"><fmt:message key="user.email.report" /></th>
							<th class=" bgc-primary border-primary text-white"><fmt:message key="user.group" /></th>
							<th class="text-center bgc-primary border-primary text-white"><fmt:message key="user.accountEnabled" /></th>
							<th class="text-center bgc-primary border-primary text-white" width="5%">Reset password</th>
							<th class="text-center bgc-primary border-primary text-white" style="width: 100px;"><i class="icon-menu-open2"></i></th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${page.content }" var="user" varStatus="cnt">
						<tr>
						    <td>${cnt.count + page.size*page.number}</td>
						    <td class="text-decoration-underline text-primary">${ user.username }</td>
						    <td>${ user.email }</td>
						    <td>${ user.mailToReport }</td>
						    <td>${ user.groupName }</td>
					        <td class="text-center"><i class="icon-circle2 ${ user.accountEnabled ? 'icon-green':'icon-red' }"></i> </td>
					        <td class="text-center">
					           <security:authorize access="hasAnyRole('ROLE_ADMIN')">
					           <c:if test="${user.groupName ne 'Administration' }">
					               <button type="button" id="resetPw_${user.id }" onclick="resetPassword('${user.id}')" class="btn btn-sm bgc-warning text-white"><i class="icon-reset"></i></button>
					           </c:if>
                                </security:authorize>
					        </td>
						    <td class="text-center">
						    	<security:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_USER_UPDATE')">
							         <a href="<c:url value='/user/form?id=${user.id}'/>" class="list-icons-item text-primary-600" title="Sửa"><i class="icon-pencil7"></i></a>
						    	</security:authorize>
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
	</form:form>
	<script src="/themes/admin/assets/js/user-list.js"></script>
	<div class="modal hide" id="pleaseWaitDialog" data-backdrop="static" data-keyboard="false">
		<div class="modal-body">
			<div class="loading">Loading&#8230;</div>
		</div>
	</div>

</div>
<script src="<c:url value='/themes/admin/assets/js/user-list.js'/>"></script>

