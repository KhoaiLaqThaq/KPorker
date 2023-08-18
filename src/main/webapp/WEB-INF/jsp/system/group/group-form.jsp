<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
<title><fmt:message key="group.form.title" /></title>
<meta name="menu" content="groupMenu" />
    <link href="<c:url 	value='/themes/admin/assets/css/components.min.css'/>" rel="stylesheet" type="text/css">

	<script src="<c:url value='/themes/admin/global_assets/js/plugins/extensions/jquery_ui/core.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/extensions/jquery_ui/effects.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/switch.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/uniform.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/assets/js/staff_form.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/uniform.min.js'/>"></script>

	<script src="<c:url value='/themes/admin/global_assets/js/main/bootstrap.bundle.min.js' />"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/loaders/blockui.min.js' />"></script>

	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/inputs/duallistbox/duallistbox.min.js' />"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/demo_pages/form_dual_listboxes.js' />"></script>
</head>

<div class="content">
	<div class="card">
		<div class="card-header header-elements-inline">
			<span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="group.form.title" /></span>
			<div class="header-elements"></div>
		</div>
		<div class="card-body ">
			<p class="mb-4">
				<fmt:message key="group.form.title.description" />
			</p>
			<form:form id="formSubmit" class="form-validate-jquery" action="${ctx}/group/save" method="POST" modelAttribute="group">
				<form:hidden path="id" />
				<form:hidden path="systemGroup" />

				<fieldset class="mb-3">
					<legend class="text-uppercase font-size-sm font-weight-bold">
						<fmt:message key="brand.legend" />
					</legend>
					<div class="row">
						<div class="col-md-5 form-group">
							<label><fmt:message key="group.name" /> <span class="help-block">*</span></label>
							<form:input type="text" class="form-control rounded-10" path="name" required="required" maxlength="100" />
						</div>
						<div class="col-md-1 form-group form-check form-check-switch form-check-switch-left">
							<label class="d-flex align-items-center"><fmt:message key="group.enabled" /></label>
							<input type="checkbox" class="form-control form-check-input form-check-input-switch" name="enabled" value="true" data-on-text="On"
								data-off-text="Off" data-on-color="success" data-off-color="danger" ${group.enabled == true ? 'checked' : ''}>
						</div>
					</div>
					<div class="row">
						<div class="col-12">
							<div class="card">
			                    <div class="card-header header-elements-inline">
			                        <h5 class="card-title"><fmt:message key="group.title.role" /></h5>
			                        <div class="header-elements">
			                            <div class="list-icons">
			                                <a class="list-icons-item" data-action="collapse"></a>
			                                <a class="list-icons-item" data-action="reload"></a>
			                                <!-- <a class="list-icons-item" data-action="remove"></a> -->
			                            </div>
			                        </div>
			                    </div>
			
			                    <div class="card-body">
			                        <p class="mb-3"><fmt:message key="group.title.role.desc" /></p>
			                        
			                        <select name="roleNames" id="roleNames" multiple="multiple" class="form-control listbox-no-selection" data-fouc>
			                         <c:forEach items="${ roles }" var="item">
			                             <option value="${ item.name }" class="${ empty item.name ? 'text-danger' : '' }" ${item.selected ? 'selected':'' }>
			                                 ${item.name } - ${item.description }
			                             </option>
			                         </c:forEach>
			                        </select>
			                    </div>
			                </div>
						</div>
					</div>
					
					<div class="text-right">
						<a href="<c:url value="/group/list"/>" id="back" class="btn btn-light">
						  <i class="icon-point-left mr-3"></i>
						  <fmt:message key="button.back" />
					   </a>
						<button type="submit" class="btn bg-blue" id="groupSubmit">
							<fmt:message key="button.save" />
							<i class="icon-database-insert ml-3"></i>
						</button>
					</div>
				</fieldset>
			</form:form>
		</div>
	</div>
</div>

<script src="<c:url value='/themes/admin/assets/js/group_form.js'/>"></script>
