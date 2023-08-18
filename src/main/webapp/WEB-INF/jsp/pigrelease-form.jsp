<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="pigrelease.form.title"/></title>
    <meta name="menu" content="pigReleaseMenu"/>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/uniform.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/assets/js/pigrelease_form.js'/>"></script>
    <!-- Map -->
</head>

<!-- Content area -->
<div class="content">
<form:form id="pigreleaseForm" modelAttribute="pigRelease" action="${ctx}/pigRelease/save" method="post" role="form">
	<form:hidden path="id"/>
	<!-- Basic layout-->
	<div class="card">
		<div class="card-header header-elements-inline"><span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="pigrelease.form.title"/></span></div>
		<div class="card-body">
			<p class="mb-4"><fmt:message key="pigrelease.form.title.description"/></p>
			<fieldset class="mb-3">
				<legend class="text-uppercase font-size-sm font-weight-bold"><fmt:message key="template.legend"/></legend>
				<div class="card">
					<div class="card-body">
						<div class="row">
							<div class="col-xs-4 col-md-4">
								<div class="form-group">
									<label ><fmt:message key="pigrelease.processOrderCode"/><span class="help-block">*</span></label>
									<input type="text" id="pigreleaseProcessOrderCode" name="processOrderCode" value="${pigrelease.processOrderCode}" class="form-control"  maxlength="50"/>
								</div>
							</div>
							
							<div class="col-xs-4 col-md-4">
								<div class="form-group">
									<label ><fmt:message key="pigrelease.pigType"/><span class="help-block"></span></label>
									<select id="pigreleasePigType" name="pigType" value="${pigrelease.pigType}" class="form-control select2">
											<option value="01">Heo thương phẩm ba máu</option>
											<option value="02">Heo thương phẩm hai máu</option>
											<option value="023">Heo hậu bị đực</option>
											<option value="023">Heo hậu bị cái</option>
										</select>
								</div>
							</div>
						
							<div class="col-xs-4 col-md-4">
								<div class="form-group">
									<label ><fmt:message key="pigrelease.depotCode"/><span class="help-block"></span></label>
									<input type="text" id="pigreleaseDepotCode" name="depotCode" value="${pigrelease.depotCode}" class="form-control"  maxlength="50"/>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-4 col-md-4">
								<div class="form-group">
									<label ><fmt:message key="pigrelease.quantity"/><span class="help-block"></span></label>
									<input type="text" id="pigreleaseQuantity" name="quantity" value="${pigrelease.quantity}" class="form-control"  maxlength="9"/>
								</div>
							</div>
							<div class="col-xs-4 col-md-4">
								<div class="form-group">
									<label ><fmt:message key="pigrelease.releaseVolumnTotal"/><span class="help-block"></span></label>
									<input type="text" id="pigreleaseReleaseVolumnTotal" name="releaseVolumnTotal" value="${pigrelease.releaseVolumnTotal}" class="form-control"  maxlength="9"/>
								</div>
							</div>
						
							<div class="col-xs-4 col-md-4">
								<div class="form-group">
									<label ><fmt:message key="pigrelease.averageVolumn"/><span class="help-block"></span></label>
									<input type="text" id="pigreleaseAverageVolumn" name="averageVolumn" value="${pigrelease.averageVolumn}" class="form-control"  maxlength="9"/>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-4 col-md-4">
								<div class="form-group">
									<label ><fmt:message key="pigrelease.releaseDate"/><span class="help-block">*</span></label>
									<input type="date" id="pigreleaseReleaseDate" name="releaseDate" value="${pigrelease.releaseDate}" class="form-control"  maxlength="10"/>
									<div><span id="msgForReleaseDate" style="color:red"></span></div>
								</div>
							</div>
						</div>							
					</div>
				</div>
				<div class="d-flex justify-content-end align-items-center">
					<a href="<c:url value="/pigRelease/list"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i><fmt:message key="button.back"/></a>
					<button type="submit" id="btnSubmit" class="btn btn-primary ml-3"><fmt:message key="button.save"/><i class="icon-database-insert ml-2"></i></button>		
					<button type="button" id="btnSendData" class="btn btn-primary ml-3"><fmt:message key="button.send.data"/><i class="icon-database-insert ml-2"></i></button>		
				</div>			
			</fieldset>
		</div>
	</div>
	<!-- /basic layout -->
</form:form>
</div>
<!-- /content area -->