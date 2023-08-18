<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
	<title><fmt:message key="proposal.form.title" /></title>
	<meta name="menu" content="processOrderMenu"/>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/switch.min.js'/>"></script>	
	<script	src="<c:url value='/themes/admin/assets/js/goodsreceipt_material_selector.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/ui/moment/moment.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/daterangepicker.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/anytime.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.date.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/legacy.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/jgrowl.min.js'/>"></script>
	<script	src="<c:url value='/themes/admin/assets/js/proposal_form.js'/>"></script>
	<script	src="<c:url value='/themes/admin/assets/js/proposal_selector.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
</head>

<!-- Content area -->
<div class="content">
	<form:form id="proposalForm" modelAttribute="proposal" action="${ctx}/proposal/save" method="post" role="form">
		<form:hidden path="id" id="goodsReceiptId"/>
		<form:hidden path="recordDate" id="recordDate"/>
		<form:hidden path="status" id="status" />
		<form:hidden id="createdDate" path="createdDate"/>
		<form:hidden id="createdBy" path="createdBy"/>
		<form:hidden id="modifiedDate" path="modifiedDate"/>
		<input type="hidden" id="farmCode" name="farm.code" value="${farm.code}"> 
		<!-- Basic layout-->
		<div class="card">
			<div class="card-header header-elements-inline">
				<span class="text-uppercase font-size-lg font-weight-bold"><fmt:message	key="proposal.form.title" /></span>
			</div>
			<div class="card-body">
				<p class="mb-4">
					<fmt:message key="proposal.form.title.description" />
				</p>
				<fieldset class="mb-3">
					<legend class="text-uppercase font-size-sm font-weight-bold">
						<fmt:message key="template.legend" />
					</legend>
					<div class="card">
						<div class="card-body pb-0">
							<div class="row">
								<div class="col-xs-4 col-md-3">
									<div class="form-group">
										<label><fmt:message key="sales.farmName" /><span class="help-block"></span></label>
										<input type="text" id="farmName" value="${processOrder.barn.name }" class="form-control rounded-10" readonly="true"/>
									</div>
								</div>
								<div class="col-xs-4 col-md-3">
									<div class="form-group">
										<label><fmt:message key="proposal.processOrderCode" /><span class="help-block"></span></label>
										<form:input type="text" id="processOrderCode" path="processOrderCode" class="form-control rounded-10" readonly="true"/>
									</div>
								</div>
								<div class="col-xs-4 col-md-3">
									<div class="form-group">
										<label><fmt:message key="proposal.transCode" /><span class="help-block"></span></label>
										<form:input type="text" id="transCode" path="transCode" class="form-control rounded-10" readonly="true"/>
									</div>
								</div>
								<div class="col-xs-4 col-md-3">
									<div class="form-group">
										<label><fmt:message key="proposal.pigType" /><span class="help-block"></span></label>
										<form:input type="text" id="pigType" path="pigType" class="form-control rounded-10" readonly="true"/>
									</div>
								</div>
								
							</div>
							<div class="row">
								<div class="col-xs-4 col-md-3">
									<div class="form-group">
										<label><fmt:message key="proposal.saleEstimate" /><span class="help-block"></span></label>
										<input type="text" id="saleEstimate" name="estimateDateStr" value="${proposal.displayEstimateDate}" class="form-control rounded-10 daterange-single"/>
									</div>
								</div>
								<div class="col-xs-4 col-md-3">
									<div class="form-group">
										<label><fmt:message key="report.table.th.slNhap" /><span class="help-block"></span></label>
										<form:input type="text" id="entryQuantity" path="entryQuantity" class="form-control rounded-10" readonly="true"/>
									</div>
								</div>
								<div class="col-xs-4 col-md-3">
									<div class="form-group">
										<label><fmt:message key="report.table.th.avgEntryVolumn" /><span class="help-block"></span></label>
										<form:input type="text" id="avgEntryVolumn" path="avgEntryWeight" class="form-control rounded-10" readonly="true"/>
									</div>
								</div>
								<div class="col-xs-4 col-md-3">
									<div class="form-group">
										<label><fmt:message key="report.table.th.slTon" /><span class="help-block"></span></label>
										<form:input type="text" id="pigRetained" path="pigRetained" class="form-control rounded-10" readonly="true"/>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-xs-4 col-md-3">
									<div class="form-group">
										<label><fmt:message key="goodsissue.reason" /><span class="help-block"></span></label>
										<form:input type="text" id="reason" path="reason" class="form-control rounded-10"/>
									</div>
								</div>
								<div class="col-xs-4 col-md-3">
									<div class="form-group">
										<label><fmt:message key="proposal.totalQuantity" /><span class="help-block"></span></label>
										<input type="text" id="totalProposal" name="totalProposal" value="${proposal.totalProposal != null ? proposal.totalProposal : 0}" class="form-control rounded-10" readonly="true"/>
										
									</div>
								</div>
								<div class="col-xs-4 col-md-3">
									<div class="form-group">
										<label><fmt:message key="proposal.avgProposalWeight" /><span class="help-block"></span></label>
										<input type="text" id="avgProposalWeight" name="avgProposalWeight" value="${proposal.avgProposalWeight != null ? proposal.avgProposalWeight : 0 }" class="form-control rounded-10" readonly="true"/>
									</div>
								</div>
								<div class="col-xs-4 col-md-3">
									<div class="form-group">
										<label><fmt:message key="proposal.postingDate" /><span class="help-block"></span></label>
										<input type="text" id="displayRecordDate" name="displayRecordDate" value="${proposal.displayRecordDate}" class="form-control rounded-10" readonly="true"/>
									</div>
								</div>
							</div>
							<jsp:include page="proposal-selector.jsp"/>
						</div>
					</div>
					<div class="d-flex justify-content-end align-items-center">
						<a href="<c:url value="/proposal/list?poCode=${proposal.processOrderCode}"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i><fmt:message key="button.back" /></a>
						<c:if test="${proposal.status ne 'approve' && proposal.status ne 'cancel'}">
							<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_PROPOSAL_CREATE, ROLE_PROPOSAL_EDIT')">
								<button type="button" id="btnSubmit" class="btn btn-primary ml-3">	<fmt:message key="button.save" /><i class="icon-database-insert ml-2"></i></button>
							</security:authorize>
							<c:if test="${proposal.id != null}">
								<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_PROPOSAL_CONFIRM')">
									<button type="button" id="btnConfirm" class="btn btn-primary ml-3">	<fmt:message key="button.approve" /><i class="icon-database-insert ml-2"></i></button>
								</security:authorize>
								<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_PROPOSAL_CONFIRM')">
									<button type="button" id="btnCancel" class="btn btn-primary ml-3">	<fmt:message key="button.reject" /><i class="icon-database-insert ml-2"></i></button>
								</security:authorize>
							</c:if>
						</c:if>
					</div>
				</fieldset>
			</div>
		</div>
		<!-- /basic layout -->
	</form:form>
</div>
<div class="modal hide" id="pleaseWaitDialog" data-backdrop="static" data-keyboard="false">
    <div class="modal-body">
        <div class="loading">Loading&#8230;</div>
    </div>
</div>
<!-- /content area -->
