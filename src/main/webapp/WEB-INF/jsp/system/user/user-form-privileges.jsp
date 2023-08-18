<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
<title><fmt:message key="user.form.title" /></title>
<meta name="menu" content="userMenu" />

<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/uniform.min.js'/>"></script>
<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/switchery.min.js'/>"></script>
<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/switch.min.js'/>"></script>
<script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>

<script src="<c:url value='/themes/admin/assets/js/user.js'/>"></script>
</head>

<form:form id="userform" action="${ctx}/user/save/privileges" method="post" modelAttribute="user">
	<form:hidden path="id" id="userId" />

	<!-- Content area -->
	<div class="content">
		<!-- Basic layout-->
		<div class="card">
			<div class="card-header header-elements-inline">
				<span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="user.form.title" /></span>
				<div class="header-elements">
					<div class="list-icons">
						<a class="list-icons-item" data-action="collapse"></a><a class="list-icons-item" data-action="reload"></a><a class="list-icons-item"
							data-action="remove"></a>
					</div>
				</div>
			</div>

			<div class="card-body">
				<p class="mb-4">
					<fmt:message key="user.form.title.description" />
				</p>
				<fieldset class="mb-3">
					<legend class="text-uppercase font-size-sm font-weight-bold">
						<fmt:message key="user.legend" />
					</legend>

					<ul class="nav nav-tabs nav-tabs-bottom nav-justified">
						<li class="nav-item">
							<a href="<c:url value="/user/form/info?id=${user.id}"/>" class="nav-link"><i class="icon-file-text2 mr-2"></i>
								<fmt:message key="tab.user.info" /></a>
						</li>
						<li class="nav-item">
							<a href="#" class="nav-link active"><i class="icon-hammer-wrench mr-2"></i>
								<fmt:message key="tab.user.privileges" /></a>
						</li>
					</ul>

					<div class="tab-content">
						<div class="card">
							<div class="card-header header-elements-inline">
								<%--
							<span class="text-uppercase font-size-lg font-weight-bold">&nbsp;</span>
							<div class="header-elements">
								<div class="list-icons"><a href="<c:url value='/user/form'/>" class="btn btn-sm bgc-warning" title="<fmt:message key="button.add"/>"><i class="icon-plus22"></i><fmt:message key="button.add"/></a></div>
		                	</div>
		                	 --%>
							</div>
							<div class="card-body">
								<div class="tab-content">
									<div id="user-information" class="row tab-pane fade show active">

										<div class="row">
											<!-- Nhóm quyền -->
											<div class="col-sm-6 col-md-4">
												<div class="form-group">
													<label><fmt:message key="userForm.group" /><span class="help-block"> *</span></label>
													<select class="form-control select2" name="groupId" id="groupId" data-placeholder="Chọn nhóm..." required="required">
														<c:if test="${not empty appGroups}">
															<c:forEach var="group" items="${appGroups}">
																<c:if test="${group.enabled}">
																	<option value="${group.id}" ${user.appGroups[0].id == group.id ? 'selected' : '' }>${group.name}</option>
																</c:if>
															</c:forEach>
														</c:if>
													</select>
												</div>
											</div>
											<!-- /Nhóm quyền -->
										</div>


									</div>
								</div>
							</div>
						</div>
					</div>
			</div>
		</div>

		</fieldset>

		<div class="d-flex justify-content-end align-items-center">
			<a href="<c:url value="/user/list"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i>
				<fmt:message key="button.back" /></a>
			<button type="submit" id="btnSubmit" class="btn bgc-warning text-white ml-3">
				<fmt:message key="button.save" />
				<i class="icon-database-insert ml-2"></i>
			</button>
		</div>
	</div>
	</div>
	<!-- /basic layout -->
	</div>
	<!-- /content area -->
</form:form>



