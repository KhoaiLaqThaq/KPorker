<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="dailyAverageWeight.form.title"/></title>
    <meta name="menu" content="processOrderMenu"/>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/extensions/jquery_ui/interactions.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/switch.min.js'/>"></script>	
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/ui/moment/moment.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/uniform.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/pnotify.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/bootstrap_multiselect.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
    <!-- Map -->
    
    <!-- Datepicker -->
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/ui/moment/moment.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/daterangepicker.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/anytime.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.date.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.time.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/legacy.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/jgrowl.min.js'/>"></script>
    
    <script src="<c:url value='/themes/admin/global_assets/js/demo_pages/picker_date.js'/>"></script>
</head>

<!-- Content area -->
<div class="content">
<form:form id="dailyAverageWeightForm" modelAttribute="event" action="${ctx}/dailyAverageWeight/save" method="post" role="form">
	<form:hidden path="id" id="eventId"/>
	<form:hidden path="createdBy" />
	<form:hidden path="modifiedBy" />
	<form:hidden path="code" id="code"/>
	<form:hidden path="createdDate" id="createdDate"/>
	<form:hidden path="modifiedDate" id="modifiedDate"/>
	<form:hidden path="status" id="status"/>
	
	<!-- Basic layout-->
	<div class="card">
		<div class="card-header header-elements-inline">
			<span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="dailyAverageWeight.form.title"/> - <c:out value = "${processOrder.barn.farm.name}"/> - <c:out value = "${processOrder.barn.code}"/></span>
		</div>
		<div class="card-body">
			<p class="mb-4"><fmt:message key="dailyAverageWeight.form.title.description"/></p>
			<fieldset class="mb-3">
				<legend class="text-uppercase font-size-sm font-weight-bold"><fmt:message key="template.legend"/></legend>
				<div class="card">
					<div class="card-body">
						<div class="row">
							<div class="col-xs-12 col-md-4">
								<div class="form-group">
									<label ><fmt:message key="event.transCode"/></label>
									<form:input path="transCode" class="form-control" id="transCode" readonly="true"/>
								</div>
							</div>
							<div class="col-xs-12 col-md-4">
								<div class="form-group">
									<label ><fmt:message key="dailyAverageWeight.poOrder"/></label>
									<form:input path="processOrderCode" class="form-control" id="poCode" readonly="true"/>
									<div><span id="msgForProcessOrderCode" style="color:red"></span></div>
								</div>
							</div>
							<div class="col-xs-12 col-md-4">
								<div class="form-group">
									<label ><fmt:message key="dailyAverageWeight.averageWeight"/><span class="help-block"></span></label>
									<form:input path="weightNote.averageWeight" class="form-control" id="averageWeight" readonly="true"/>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-xs-12 col-md-4">
								<div class="form-group">
									<label ><fmt:message key="pigdead.posting.date"/><span class="help-block">*</span></label>
									<input type="text" id="stage" name="stage" placeholder="Ngày ghi nhận sự kiện" value="${event.displayPostingDate }" autocomplete="off" class="form-control" >
								</div>
							</div>
							<div class="col-xs-12 col-md-4">
								<div class="form-group">
									<label ><fmt:message key="report.table.th.title.pigRetained"/></label>
									<input class="form-control" id="pigRetain" readonly="true"/>
									<div style="padding-top: 1%;"><span id="msgForQuantity" style="color:red"></span></div>
								</div>
							</div>
						</div>	
						<div class="row">
							<div class="col-md-12">
							<!-- Grey header and footer -->
							<div class="card">
								<div class="card-header bg-light d-flex justify-content-between">
									<span class="font-size-sm text-uppercase font-weight-semibold"><fmt:message key="dailyAverageWeight.info"/></span>
									<span class="font-size-sm text-uppercase text-success font-weight-semibold">&nbsp;</span>
								</div>
								<div class="card-body">
									<div class="table-responsive">
						               	<table id="tblSelectedNote" class="table table-bordered table-striped">
											<thead>
												<tr class="table-success">
													<th width="3%">#</th>
													<th width="20%"><fmt:message key="dailyAverageWeight.range" /></th>
													<th width="15%"><fmt:message key="dailyAverageWeight.quantity" /></th>
													<th width="5%" class="text-center"><i class="icon-menu-open2"></i></th>
												</tr>
											</thead>
											<tbody class="chimneyClone">
												<c:forEach begin="0" items="${weightChartExistings}" var="item" varStatus="cnt">
													<tr id="rec-note${cnt.index}">
														
														<td><span class="no"><c:out value="${cnt.count+page.size*page.number}"></c:out></span><input type="hidden" class="index-table" value="${cnt.index}"/></td>
														<td>
															<select class="form-control selected-weight-range" name="weightNote.weightCharts[${cnt.index}].range" id="select2${cnt.index}" 
															data-placeholder="Chọn khối lượng" data-fouc></select>
															<input type="hidden" class="selected-weight" id="select-range${cnt.index}" value="${item.range}"/>
														</td>
														<td><input type="number" name="weightNote.weightCharts[${cnt.index}].quantity" class="form-control selected-item-quantity" id="selected-item-quantity${cnt.index}" value="${item.quantity}"></td>
														<td class="text-center">
												        	<div class="list-icons">
																<button type="button" class="btn-primary btn-xs" onclick="addRow()" title="Add Row" style="display: inline-block; float: none; border: none"><i class="fa fa-plus "></i></button>
																<button type="button" class="btn-danger btn-xs" onclick="removeRow(${cnt.index})" title="Remove Row" style="display: inline-block; float: none; border: none"><i class="fa fa-times"></i></button>
												        	</div>
												        </td>
													</tr>
												</c:forEach> 
											</tbody>
											
										</table>  
										          	
									</div>
						      			
								</div>
								
							</div>
							<!-- /grey header and footer -->
							</div>
						</div>						
					</div>
				</div>
				<div class="d-flex justify-content-end align-items-center">
					<a href="<c:url value="/dailyAverageWeight/list?code=${event.processOrderCode}"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i><fmt:message key="button.back"/></a>
					<security:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_WEIGHT_NOTE_CREATE')">
					<button type="button" id="btnSubmit" class="btn btn-primary ml-3"><fmt:message key="button.save"/><i class="icon-database-insert ml-2"></i></button>	
					</security:authorize>
				</div>			
			</fieldset>
		</div>
	</div>
	<!-- /basic layout -->
</form:form>
</div>
<!-- /content area -->
<div class="modal hide" id="pleaseWaitDialog" data-backdrop="static" data-keyboard="false">
    <div class="modal-body">
        <div class="loading">Loading&#8230;</div>
    </div>
</div>

<script src="<c:url value='/themes/admin/assets/js/dailyaverageweight_form.js'/>"></script>
