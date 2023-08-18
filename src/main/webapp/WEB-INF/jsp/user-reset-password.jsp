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

<form:form id="userform" action="${ctx}/user/resetpw" method="post" modelAttribute="user">
	
	<!-- Content area -->
	<div class="content">
		<!-- Basic layout-->
		<div class="card">
			<div class="card-header header-elements-inline">
				<span class="text-uppercase font-size-lg font-weight-bold">Thay đổi mật khẩu</span>
				<div class="header-elements">
					<div class="list-icons">
						<a class="list-icons-item" data-action="collapse"></a><a class="list-icons-item" data-action="reload"></a><a class="list-icons-item"
							data-action="remove"></a>
					</div>
				</div>
			</div>

			<div class="card-body">
				<p class="mb-4">
					Nhập đủ thông tin để thay đổi mật khẩu
				</p>
				<fieldset class="mb-3">
					<legend class="text-uppercase font-size-sm font-weight-bold">
						<fmt:message key="user.legend" /> <span class='text-danger'>(Chức năng đang phát triển)</span>
					</legend>
					<div class="row mt-3">
					   <div class="col-3 offset-md-4">
                           <label>Nhập mật khẩu mới<span class="text-danger"> *</span></label>
                           <input type="password" class="form-control" id="newPassword" name="password" autocomplete="off" required="required" placeholder="Vui lòng nhập mật khẩu mới" />
                       </div>
                       <div class="col-4 mt-4">
                           <p id="msgNewPassword"></p>
                       </div>
					</div>
					<div class="row mt-3">
					   <div class="col-3 offset-md-4">
                           <label>Nhập lại mật khẩu mới<span class="text-danger"> *</span></label>
                           <input type="password" class="form-control" name="confirmPassword" id="confirmPassword" autocomplete="off" required="required" placeholder="Vui lòng nhập lại mật khẩu mới" />
                       </div>
                       <div class="col-4 mt-4">
                           <p id="msgConfirmPassword"></p>
                       </div>
					</div>
					<div class="row mt-3">
					   <div class="col-3 offset-md-4">
					       <p id="comparePassword"></p>
					   </div>
					</div>
				</fieldset>

				<div class="d-flex justify-content-end align-items-center">
					<a href="<c:url value="/user/list"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i>
						<fmt:message key="button.back" /></a>
					<button type="submit" id="btnSubmitChangepw" class="btn btn-primary ml-3" disabled>
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

<script src="<c:url value='/themes/admin/assets/js/user-resetpw.js'/>"></script>

