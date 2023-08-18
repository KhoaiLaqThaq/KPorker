<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="production.form.title"/></title>
    <meta name="menu" content="productionMenu"/>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/extensions/jquery_ui/interactions.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
	
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/uniform.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/pnotify.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/bootstrap_multiselect.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
    <!-- Map -->
</head>

<!-- Content area -->
<div class="content">
<form:form id="productionForm" modelAttribute="production" action="<c:url value='/production/save'/>" method="post" role="form">
	<form:hidden path="id"/>
	
	<!-- Basic layout-->
	<div class="card">
		<div class="card-header header-elements-inline"><span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="production.form.title"/></span></div>
		<div class="card-body">
			<p class="mb-4"><fmt:message key="production.form.title.description"/></p>
			<fieldset class="mb-3">
				<legend class="text-uppercase font-size-sm font-weight-bold"><fmt:message key="template.legend"/></legend>
				<div class="card">
					<div class="card-body">
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="production.id"/><span class="help-block">*</span></label>
									<input type="text" id="productionId" name="id" value="${production.id}" class="form-control" required="required" maxlength="19"/>
									<div><span id="msgForId" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="production.processOrderCode"/><span class="help-block">*</span></label>
									<input type="text" id="productionProcessOrderCode" name="processOrderCode" value="${production.processOrderCode}" class="form-control" required="required" maxlength="10"/>
									<div><span id="msgForProcessOrderCode" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="production.feedDay"/><span class="help-block">*</span></label>
									<input type="text" id="productionFeedDay" name="feedDay" value="${production.feedDay}" class="form-control" required="required" maxlength="10"/>
									<div><span id="msgForFeedDay" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="production.feedDate"/><span class="help-block"></span></label>
									<input type="text" id="productionFeedDate" name="feedDate" value="${production.feedDate}" class="form-control"  maxlength="10"/>
									<div><span id="msgForFeedDate" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="production.feedWeek"/><span class="help-block">*</span></label>
									<input type="text" id="productionFeedWeek" name="feedWeek" value="${production.feedWeek}" class="form-control" required="required" maxlength="10"/>
									<div><span id="msgForFeedWeek" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="production.feedWeekStartDate"/><span class="help-block"></span></label>
									<input type="text" id="productionFeedWeekStartDate" name="feedWeekStartDate" value="${production.feedWeekStartDate}" class="form-control"  maxlength="10"/>
									<div><span id="msgForFeedWeekStartDate" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="production.feedWeekToDate"/><span class="help-block"></span></label>
									<input type="text" id="productionFeedWeekToDate" name="feedWeekToDate" value="${production.feedWeekToDate}" class="form-control"  maxlength="10"/>
									<div><span id="msgForFeedWeekToDate" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="production.totalPig"/><span class="help-block"></span></label>
									<input type="text" id="productionTotalPig" name="totalPig" value="${production.totalPig}" class="form-control"  maxlength="10"/>
									<div><span id="msgForTotalPig" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="production.totalPigRetained"/><span class="help-block"></span></label>
									<input type="text" id="productionTotalPigRetained" name="totalPigRetained" value="${production.totalPigRetained}" class="form-control"  maxlength="10"/>
									<div><span id="msgForTotalPigRetained" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="production.totalPigDead"/><span class="help-block"></span></label>
									<input type="text" id="productionTotalPigDead" name="totalPigDead" value="${production.totalPigDead}" class="form-control"  maxlength="10"/>
									<div><span id="msgForTotalPigDead" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="production.moreInfo"/><span class="help-block"></span></label>
									<input type="text" id="productionMoreInfo" name="moreInfo" value="${production.moreInfo}" class="form-control"  maxlength="1,073,741,824"/>
									<div><span id="msgForMoreInfo" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="production.createdBy"/><span class="help-block"></span></label>
									<input type="text" id="productionCreatedBy" name="createdBy" value="${production.createdBy}" class="form-control"  maxlength="50"/>
									<div><span id="msgForCreatedBy" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="production.createdDate"/><span class="help-block"></span></label>
									<input type="text" id="productionCreatedDate" name="createdDate" value="${production.createdDate}" class="form-control"  maxlength="19"/>
									<div><span id="msgForCreatedDate" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="production.modifiedBy"/><span class="help-block"></span></label>
									<input type="text" id="productionModifiedBy" name="modifiedBy" value="${production.modifiedBy}" class="form-control"  maxlength="50"/>
									<div><span id="msgForModifiedBy" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="production.modifiedDate"/><span class="help-block"></span></label>
									<input type="text" id="productionModifiedDate" name="modifiedDate" value="${production.modifiedDate}" class="form-control"  maxlength="19"/>
									<div><span id="msgForModifiedDate" style="color:red"></span></div>
								</div>
							</div>
						</div>							
						<div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label ><fmt:message key="production.latest"/><span class="help-block"></span></label>
									<input type="text" id="productionLatest" name="latest" value="${production.latest}" class="form-control"  maxlength="1"/>
									<div><span id="msgForLatest" style="color:red"></span></div>
								</div>
							</div>
						</div>							
					</div>
				</div>
				<div class="d-flex justify-content-end align-items-center">
					<a href="<c:url value="/production/list?id=${production.id}"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i><fmt:message key="button.back"/></a>
					<button type="submit" id="productionSubmit" class="btn btn-primary ml-3"><fmt:message key="button.save"/><i class="icon-database-insert ml-2"></i></button>			
				</div>			
			</fieldset>
		</div>
	</div>
	<!-- /basic layout -->
</form:form>
</div>
<!-- /content area -->
