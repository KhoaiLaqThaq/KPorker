<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="userForm.title" /></title>
    <meta name="menu" content="userList" />

	<link href="<c:url 	value='/themes/admin/assets/css/components.min.css'/>" rel="stylesheet" type="text/css" />
	
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/extensions/jquery_ui/core.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/extensions/jquery_ui/effects.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/assets/js/staff_form.js'/>"></script>
	
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/uniform.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/pnotify.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/loaders/blockui.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/bootstrap_multiselect.js'/>"></script>
<%-- 	<script src="<c:url value='/themes/admin/global_assets/js/demo_pages/form_multiselect.js'/>"></script> --%>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
	
	<script src="<c:url value='/themes/admin/assets/js/app.js'/>"></script>
	
		<!-- script duallistbox -->
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/switch.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/inputs/duallistbox/duallistbox.min.js'/>"></script>
	<!-- script select -->
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/bootstrap_multiselect.js'/>"></script>
	<!-- script fancy -->
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/extensions/jquery_ui/interactions.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/trees/fancytree_all.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/trees/fancytree_childcounter.js'/>"></script>
    <!-- bootbox -->
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/demo_pages/components_modals.js'/>"></script>
	<script src="<c:url value='/themes/admin/assets/js/user_form.js'/>"></script>
</head>

<div class="content">
	<c:url var="urlSubmit" value="/user/save"></c:url>
	<!-- Start form user -->
	<div class="card">
		<div class="card-header header-elements-inline">
			<h4 class="text-uppercase font-size-lg font-weight-bold">
				<fmt:message key="userForm.title" />
			</h4>
			<div class="header-elements">
				<div class="list-icons">
					<a class="list-icons-item" data-action="collapse"></a>
				</div>
			</div>
		</div>
		<form:form class="form-validate-jquery" id="userForm" action="${urlSubmit}" method="POST" modelAttribute="appUser" autocomplete="off">
			<div class="card-body">
				<p class="mb-4"><fmt:message key="userForm.title.description" /></p>
				<form:hidden path="id" id="appUserId" />
				<form:hidden path="accountExpired" />
				<form:hidden path="password" />
				<form:hidden path="confirmPassword" />
				<form:hidden path="accountLocked" />
				<form:hidden path="credentialsExpired" />
				<form:hidden path="modifiedDate" />
				<form:hidden path="createdDate" />
				<form:hidden path="userLevel" />
				<form:hidden path="version" />
				<form:hidden path="passwordChangedDate" />
				<form:hidden path="createdBy" />
				<%-- <form:hidden path="farmCodes" id="farmCodes" value="${farmCodes}" /> --%>

				<fieldset class="mb-3">
					<legend class="text-uppercase font-size-sm font-weight-bold"><fmt:message key="brand.legend" /></legend>
					<div class="col-12">
						<div class="card">
							<div class="card-body">
								<ul class="nav nav-tabs nav-tabs-bottom nav-justified">
									<li class="nav-item"><a href="#user-information" class="nav-link active" data-toggle="tab"><i class="icon-file-text2 mr-2"></i><fmt:message key="user.info" /></a></li>
									<li class="nav-item"><a href="#user-authentication" id="userAuth" class="nav-link" data-toggle="tab"><i class="icon-file-text2 mr-2"></i><fmt:message key="role.auth" /></a>
									</li>
								</ul>

								<div class="tab-content">
									<div id="user-information" class="row tab-pane fade show active px-3">
									    <div class="row">
									       <div class="col-12 col-md-4">
									           <label><fmt:message key="profile.firstname" /></label>
									           <form:input type="text" path="firstName" class="form-control rounded-10" maxlength="20" autofocus="on" placeholder="Nhập họ..." />
									       </div>
									       <div class="col-12 col-md-4">
                                               <label><fmt:message key="profile.lastname" /></label>
                                               <form:input type="text" path="lastName" class="form-control rounded-10" maxlength="20" autofocus="on" placeholder="Nhập tên..." />
                                           </div>
									    </div>
										<div class="row mt-3">
											<!-- Ten dang nhap -->
											<div class="col-12 col-md-4">
												<div class="form-group">
													<label><fmt:message key="profile.username" /><span class="help-block"> *</span></label>
													<form:input id="username" path="username" type="text" class="form-control rounded-10" maxlength="100" required="required" placeholder="Tên đăng nhập..." />
													<p id="uMessage" class="mt-1"></p>
												</div>
											</div>
											<!-- /Ten dang nhap -->
											<%--mail main--%>
											<div class="col-12 col-md-4">
											     <label><fmt:message key="profile.email.main" /><span class="help-block"> *</span></label>
											     <form:input id="email" path="email" type="email" class="form-control rounded-10" maxlength="100" placeholder="Nhập địa chỉ mail chính..." />
											     <p id="eMessage" class="mt-1"></p>
											</div>
											<%--/mail main--%>
											<div class="col-12 col-md-4">
												<label><fmt:message key="profile.email.report" /></label>
												<form:input id="emailToReport" path="mailToReport" type="email" class="form-control rounded-10" maxlength="100" placeholder="Nhập mail nhận thông báo công việc..." />
											</div>
										</div>
										<div class="row">
										  <!-- Active -->
                                            <div class="col-sm-4 col-md-4">
                                                <div class="form-group form-check form-check-switch form-check-switch-left">
                                                    <c:if test="${(appUser.username) ne (pageContext.request.remoteUser)}">
                                                        <label class="d-flex align-items-center"><fmt:message key="userForm.accountEnabled" /></label>
                                                        <input type="checkbox" class="form-control form-check-input form-check-input-switch" name="accountEnabled" value="true" data-on-text="On" data-off-text="Off" data-on-color="success" data-off-color="danger" ${appUser.accountEnabled ? 'checked' : ''} />
                                                    </c:if>
                                                </div>
                                            </div>
                                            <!-- /Active -->
										</div>
									</div>
									<div id="user-authentication" class="tab-pane fade row">
										<div class="row">
											<!-- Nhóm quyền -->
											<div class="col-sm-12 col-md-4">
												<div class="form-group">
													<label><fmt:message key="userForm.group" /><span class="help-block"> *</span></label>
													<select class="form-control select2" name="groupName" id="groupSelect" data-placeholder="Chọn nhóm...">
														<option></option>
														<c:if test="${not empty groups}">
														<c:forEach var="group" items="${groups}">
															<option value="${group.name}" ${appUser.groupName eq group.name ? 'selected':'' }>${group.name}</option>
														</c:forEach>
														</c:if>
													</select>
												</div>
											</div>
											<!-- /Nhóm quyền -->
											<div class="col-md-12">
		                                        <div class="card">
		                                            <div class="card-body">
		                                                <p class="mb-3"><fmt:message key="user.roles.farm"/> <span class="help-block">*</span></p>
		                                                <input type="hidden" id="selectedFarmCodes" name="selectedFarmCodes">
		                                                <div id="tree_container">
		                                                   <div class="tree-checkbox-hierarchical border-left-danger border-left-2" id="tree"></div>
		                                                </div>
		                                            </div>
		                                        </div>
		                                    </div>
										</div>
									
								    </div>
							     </div>
						    </div>
					    </div>
				    </div>

				</fieldset>
				<div class="text-right">
					<a href="<c:url value="/user/list"/>" id="back" class="btn btn-light rounded-10 mr-2"><i class="icon-point-left "></i>&nbsp;&nbsp;&nbsp;<fmt:message key="button.back" /></a>
					<button type="submit" class="btn bgc-warning text-white rounded-10" id="btnSubmit"><fmt:message key="button.save" /><i class="icon-paperplane ml-2"></i></button>
				</div>
			</div>
		</form:form>
	</div>
	<!-- End form user -->
</div>
