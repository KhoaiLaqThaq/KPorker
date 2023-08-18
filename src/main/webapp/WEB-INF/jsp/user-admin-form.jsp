<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="userForm.admin.title"/></title>
    <meta name="menu" content="orgMenu"/>
	<%-- <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script> --%>
	<%-- <script src="<c:url value='/themes/admin/assets/js/repository_form.js'/>"></script> --%>
	<link href="<c:url 	value='/themes/admin/assets/css/components.min.css'/>" rel="stylesheet" type="text/css" />
	<link href="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/bootstrap_multiselect.js'/>" rel="stylesheet" type="text/css" />
	
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/extensions/jquery_ui/core.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/extensions/jquery_ui/effects.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/switch.min.js'/>"></script>	
	<script src="<c:url value='/themes/admin/assets/js/staff_form.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/uniform.min.js'/>"></script>
	
	<script src="<c:url value='/themes/admin/global_assets/js/demo_pages/form_multiselect.js'/>"></script>
</head>

<div class="content">
	<!-- Start form user -->
	<div class="card">
		<div class="card-header header-elements-inline">
			<h4 class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="userForm.admin.title"/></h4>
			<div class="header-elements">
				<div class="list-icons">
               		<a class="list-icons-item" data-action="collapse"></a>
               	</div>
            </div>
		</div>
		<form:form class="form-validate-jquery" id="userAdminForm" action="${ctx}/user/admin/save" method="POST" modelAttribute="appUser" autocomplete="off">
			<div class="card-body">
				<p class="mb-4"><fmt:message key="userForm.admin.title.description"/></p>
				<form:hidden path="id" id="appUserId"/>
				<form:hidden path="accountExpired"/>
				<form:hidden path="password"/>
				<form:hidden path="confirmPassword"/>
				<form:hidden path="accountLocked"/>
				<form:hidden path="credentialsExpired"/>
				<form:hidden path="modifiedDate"/>
				<form:hidden path="createdDate"/>
				<form:hidden path="userLevel"/>
				<form:hidden path="version"/>
				<form:hidden path="passwordChangedDate"/>
				<form:hidden path="createdBy" />
				<form:hidden path="profileId"/>
				<form:hidden path="orgIdentityCode"/>
				
				<fieldset class="mb-3">
					<legend class="text-uppercase font-size-sm font-weight-bold"><fmt:message key="brand.legend"/></legend>
					
					<div class="row">
						 <div class="col-sm-3 col-md-3">
							<div class="form-group">
								<label><fmt:message key="profile.fullname"/><span class="help-block"> *</span></label>
								<form:input id="fullname" path="profile.fullname" class="form-control" maxlength="100" required="required" autofocus="on" />
							</div>
						</div>
						 <div class="col-sm-3 col-md-3">
							<div class="form-group">
								<label><fmt:message key="profile.phone"/></label>
								<form:input id="phone" path="profile.phone" class="form-control" maxlength="30"/>
							</div>
						</div>
						 <div class="col-sm-6 col-md-6">
							<div class="form-group">
								<label><fmt:message key="profile.address"/></label>
								<form:input id="address" path="profile.address" class="form-control" maxlength="200"/>
							</div>
						</div>
					
					</div>
					
					<div class="row">
						<!-- Tên đăng nhập -->
						 <div class="col-sm-6 col-md-6">
							<div class="form-group">
								<label><fmt:message key="userForm.username"/><span class="help-block"> *</span></label>
								<form:input id="username" path="username" type="email" class="form-control" 
									placeholder="Nhập địa chỉ email" minlength="5" maxlength="50" required="required"
									readonly="${appUser.id != null ? true : false}"
								 />
							</div>
						</div> 
						<!-- /Tên đăng nhập -->
						
						<!-- Active -->
						<div class="col-sm-2 col-md-4">
							<div class="form-group form-check form-check-switch form-check-switch-left">
								<label class="d-flex align-items-center"><fmt:message key="userForm.accountEnabled" /></label>
								<input type="checkbox" class="form-control form-check-input form-check-input-switch" name="accountEnabled" value="true" data-on-text="On" data-off-text="Off" data-on-color="success" data-off-color="danger" ${appUser.accountEnabled ? 'checked' : ''}>
							</div>
						</div>
						<!-- /Active -->
					</div>
				</fieldset>
				<div class="text-right">
					<a href="<c:url value="/user/admin/list?oic=${appUser.orgIdentityCode}"/>" id="back" class="btn btn-light"><i class="icon-point-left "></i>&nbsp;&nbsp;&nbsp;<fmt:message key="button.back"/></a>
					<c:choose>
						<c:when test="${appUser.id eq -1 }">
							<button type="button" class="btn btn-primary" data-target="#confirmUpdate" data-toggle="modal"  style="cursor: pointer;"><fmt:message key="button.save"/><i class="icon-paperplane ml-2"></i></button>
							<div class="modal fade" id="confirmUpdate" role="dialog">
								<div class="modal-dialog modal-md">
									<div class="modal-content">
										<div class="modal-header" style="background-color: #0F6CB2; color: #ffffff;">
											<h4 class="modal-title"><fmt:message key="admin.confirm.title"/></h4>
											<button type="button" class="close" data-dismiss="modal">&times;</button>
										</div>
										<div class="modal-body text-left">
											<p><fmt:message key="admin.confirm.success"/></p>
										</div>
										<div class="modal-footer">
											<button type="button" class="btn btn-warning" data-dismiss="modal"><fmt:message key="button.back"/></button>
											<button type="submit" id="confirm"  class="btn btn-primary"><fmt:message key="admin.confirm"/></button>
										</div>
									</div>
								</div>
							</div>
						</c:when>
						<c:otherwise><button type="submit" class="btn btn-primary"><fmt:message key="button.save"/><i class="icon-paperplane ml-2"></i></button></c:otherwise>
					</c:choose>
				</div>
			</div>
			
		</form:form>
	</div>
	<!-- End form user -->
</div>
<!-- script select -->
<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/inputs/duallistbox/duallistbox.min.js'/>"></script>
<script src="<c:url value='/themes/admin/global_assets/js/demo_pages/form_dual_listboxes.js'/>"></script>

<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/bootstrap_multiselect.js'/>"></script>
<script src="<c:url value='/themes/admin/global_assets/js/plugins/trees/fancytree_all.min.js'/>"></script>

<script src="<c:url value='/themes/admin/global_assets/js/plugins/extensions/jquery_ui/interactions.min.js'/>"></script>
<script src="<c:url value='/themes/admin/assets/js/user_form.js'/>"></script>
<script>
	$(document).ready(function() {
		$('#username').on('change', function(e){
			let username = document.getElementById("username");
			let nameRegex = /^[a-zA-Z0-9_\.]{5,32}@(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,})$/;
		    let validUsername = username.value.match(nameRegex);
		    if(validUsername == null){
		    	username.setCustomValidity("\u0054\u00ea\u006e \u0063\u1ee7\u0061 \u0062\u1ea1\u006e \u006b\u0068\u00f4\u006e\u0067 "
		    			+"\u0068\u1ee3\u0070 \u006c\u1ec7\u002e \u0043\u0068\u1ec9 \u0063\u00e1\u0063 \u006b\u00fd \u0074\u1ef1 "
		    			+"\u0041\u002d\u005a\u002c \u0061\u002d\u007a \u0076\u00e0 \u0030\u002d\u0039 \u006d\u1edb\u0069 "
		    			+"\u0111\u01b0\u1ee3\u0063 \u0063\u0068\u1ea5\u0070 \u006e\u0068\u1ead\u006e\u002e\u0022");
		    } else {
		    	$.ajax({
					url: getContext() + '/user/form/checkUsername',
					contextType: 'application/json',
					method: 'GET',
					data: {
						username: username.value
					},
					success: function(data) {
						if(data){
							username.setCustomValidity("\u0054\u00ea\u006e \u0074\u00e0\u0069 \u006b\u0068\u006f\u1ea3\u006e "
														+"\u0111\u0103\u006e\u0067 \u006e\u0068\u1ead\u0070 \u0027"
														+username.value+"\u0027 \u0111\u00e3 \u0074\u1ed3\u006e \u0074\u1ea1\u0069\u0021");
						}else {
							username.setCustomValidity('');
						}
					},
					error: function(err) {
						console.log(err)
					}
				});
		    }			
		});
		
		
	});
</script>
