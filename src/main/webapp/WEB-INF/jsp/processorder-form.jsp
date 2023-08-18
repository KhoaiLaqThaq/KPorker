<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
	<title><fmt:message key="processOrder.form.title" /></title>
	<meta name="menu" content="processOrderMenu" />
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/extensions/jquery_ui/interactions.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
	
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/uniform.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/pnotify.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/bootstrap_multiselect.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/extensions/jquery_ui/interactions.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/extensions/jquery_ui/widgets.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/extensions/jquery_ui/effects.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/assets/js/processorder_form.js'/>"></script>
	
	<!-- Map -->
</head>

<div class="row mb-3">
	<div class="col-12"><%@include file="/themes/admin/common/actions.jsp"%></div>
</div>

<!-- Content area -->
<div class="content">
	<div class="row mb-3">
		<div class="col-12 col-md-6">
			<div class="text-color-primary fs-3">Chi tiết thông tin lệnh sản xuất</div>
		</div>
	</div>
	<form:form id="processOrderForm" modelAttribute="processOrder" action="/processOrder/confirm" method="post" role="form">
		<form:hidden path="id"/>
		<form:hidden path="week"/>
 		<form:hidden path="weekFromDate" />
 		<form:hidden path="weekToDate"/>
		<input type="text" hidden="hidden" name="status" id="processOrderStatus" value="${processOrder.status }" />
		<input type="hidden" name="realAmount" id="realAmountPO" value="${processOrder.realAmount }" />
		<input type="hidden" name="realWeigh" id="realWeighPO" value="${processOrder.realWeigh }" />
		<input type="hidden" name="confirmType" id="confirmType" />
		<input type="hidden" name="evaluateAmount" id="evaluateAmountPO" value="${processOrder.evaluateAmount }" />
        <input type="hidden" name="evaluateWeigh" id="evaluateWeighPO" value="${processOrder.evaluateWeigh }" />
		<form:hidden path="createdDate"/>
		<form:hidden path="latest"/>
		<form:hidden path="transCode"/>
		<form:hidden path="endDate"/>
		<form:hidden path="closedDate"/>
		<form:hidden path="startDate"/>
		<form:hidden path="realStartDate" id="realStartDate"/>
		<form:hidden path="realEndDate" id="realEndDate"/>
		<form:hidden path="pigIdentifier" value="${processOrder.pig.identifier}" />
		
		<!-- Basic layout-->
		<div class="card rounded-10">
			<div class="card-body">
				<div class="row">
					<div class="col-xs-12 col-md-3">
						<div class="form-group">
							<label><fmt:message key="processOrder.code" /><span class="help-block"></span></label>
							<input type="text" id="processOrderId" name="code" value="${processOrder.code}" class="form-control" required="required" readonly="readonly" />
							<div><span id="msgForId" style="color: red"></span></div>
						</div>
					</div>
					<div class="col-xs-12 col-md-3">
						<div class="form-group">
							<label><fmt:message key="processOrder.barnCode" /><span class="help-block"></span></label>
							<input type="text" id="processOrderBarnCode" name="barnCode" value="${processOrder.barn.code}"  readonly="readonly" class="form-control" required="required" />
							<div><span id="msgForId" style="color: red"></span></div>
						</div>
					</div>
					<div class="col-xs-4 col-md-3">
						<div class="form-group">
							<label><fmt:message key="processOrder.pigType" /><span class="help-block"></span></label>
							<input type="text" id="pigType" name="pigType" value="${processOrder.pigType}" class="form-control" readonly="readonly" />
							<div><span id="msgForId" style="color: red"></span></div>
						</div>
					</div>
					<div class="col-xs-4 col-md-3">
						<div class="form-group">
							<label><fmt:message key="processOrder.materialName" /><span class="help-block"></span></label>
							<input type="text" id="materialName" name="materialName" value="${processOrder.materialName}" class="form-control" readonly="readonly" />
							<div><span id="msgForId" style="color: red"></span></div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-12 col-md-3">
						<div class="form-group">
							<label><fmt:message key="processOrder.quantity" /><span class="help-block"></span></label>
							<form:input path="quantity" readonly="true" class="form-control"/>
							<div><span id="msgForId" style="color: red"></span></div>
						</div>
					</div>
					<div class="col-xs-12 col-md-3">
						<div class="form-group">
							<label><fmt:message key="processOrder.startDate" /><span class="help-block"></span></label>
							<form:input path="startDateDisplay" readonly="true" class="form-control"/>
							<div><span id="msgForId" style="color: red"></span></div>
						</div>
					</div>
					<div class="col-xs-12 col-md-3">
						<div class="form-group">
							<label><fmt:message key="processOrder.endDate" /><span class="help-block"></span></label>
							<form:input path="endDateDisplay" readonly="true" class="form-control"/>
							<div><span id="msgForId" style="color: red"></span>	</div>
						</div>
					</div>
					<div class="col-xs-12 col-md-3">
						<div class="form-group">
							<label><fmt:message key="processOrder.real.quantity" /><span class="help-block"></span></label>
							<form:input path="realQuantity" readonly="true" class="form-control"/>
							<div><span id="msgForId" style="color: red"></span></div>
						</div>
					</div>
				</div>

				<div class="row">
					<div class="col-xs-12 col-md-3">
						<div class="form-group">
							<label><fmt:message key="processOrder.real.startDate" /><span class="help-block"></span></label>
							<input type="text" id="processOrderRealStartDate" value="${processOrder.displayRealStartDate}" readonly="readonly" class="form-control datepicker" required="required" maxlength="19" />
							<div><span id="msgForId" style="color: red"></span></div>
						</div>
					</div>
					<div class="col-xs-12 col-md-3">
						<div class="form-group">
							<label><fmt:message key="processOrder.real.endDate" /><span class="help-block"></span></label>
							<input type="text" id="processOrderRealEndDate" value="${processOrder.displayRealEndDate}"  readonly ="readonly"  class="form-control datepicker" required="required"	maxlength="19" />
							<div><span id="msgForId" style="color: red"></span>	</div>
						</div>
					</div>
					<div class="col-xs-12 col-md-3">
						<div class="form-group">
							<label><fmt:message key="processOrder.batch" /><span class="help-block"></span></label>
							<input type="text" id="processOrderBatch" name="batch" value="${processOrder.batch}" class="form-control" required="required" maxlength="19" readonly="readonly" />
							<div><span id="msgForId" style="color: red"></span></div>
						</div>
					</div>
					<div class="col-xs-12 col-md-3">
						<div class="form-group">
							<label><fmt:message key="processOrder.pigLevel" /><span class="help-block"></span></label>
							<input type="text" id="pigLevel" name="pigLevel" value="${processOrder.pigLevel}" class="form-control" required="required" maxlength="19" readonly="readonly"/>
							<div><span id="msgForId" style="color: red"></span></div>
						</div>
					</div>
				</div>

				<div class="row">
					<div class="col-md-3 col-xs-12">
						<label>Số lượng đánh giá</label>
						<input type="text" id="processOrderRealStartDate" value="${processOrder.evaluateAmount}" readonly="readonly" class="form-control" />
					</div>
					<div class="col-md-3 col-xs-12">
						<label>Khối lượng đánh giá</label>
						<input type="text" id="processOrderRealStartDate" value="${processOrder.evaluateWeigh}" readonly="readonly" class="form-control" />
					</div>

					<div class="col-xs-12 col-md-3">
						<div class="form-group">
							<label><fmt:message key="processOrder.real.out.quantity" /><span class="help-block"></span></label>
							<form:input path="realAmount" readonly="true" class="form-control"/>
						</div>
					</div>
					<div class="col-xs-12 col-md-3">
						<div class="form-group">
							<label><fmt:message key="processOrder.real.out.weight" /><span class="help-block"></span></label>
							<form:input path="realWeigh" readonly="true" class="form-control"/>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-md-3 col-xs-12">
						<label>Production Version</label>
						<form:input type="text" id="processOrderProductionVer" path="productionVer" readonly="true" class="form-control" />
					</div>
				</div>

				<div class="row" id="tableQuota">
					<div class="col-md-12">
						<div class="card">
							<div class="card-header bg-light d-flex justify-content-between"><span class="font-size-sm text-uppercase font-weight-semibold"><fmt:message key="quota.list" /></span> <span
									class="font-size-sm text-uppercase text-success font-weight-semibold">&nbsp;</span></div>
							<div class="card-body">

								<div class="table-responsive">
									<table id="tblSelectedMaterials" class="table table-bordered table-striped">
										<thead>
										<tr class="table-success">
											<th width="5%">#</th>
											<th width="15%"><fmt:message key="purchaserequisition.materialCode" /></th>
											<th width="20"><fmt:message key="purchaserequisition.materialName" /></th>
											<th width="20"><fmt:message key="purchaserequisition.quantity" /></th>
											<th width="20%"><fmt:message key="processOrder.requestDate" /></th>
											<th width="20%"><fmt:message key="processOrder.manufacturedDate" /></th>
											<th width="20">	<fmt:message key="purchaserequisition.expiredDate" /></th>
										</tr>
										</thead>
										<tbody>
										<c:forEach items="${processOrder.quotas}" var="quota" varStatus="cnt">
											<tr>
												<td>
													<c:out value="${cnt.count}"></c:out>
												</td>
												<td>${quota.materialCode }</td>
												<td>${quota.materialName }</td>
												<td>${quota.quantity }</td>
												<td>${quota.requestDate }</td>
												<td>${quota.manufacturedDate }</td>
												<td>${quota.expiredDate }</td>
											</tr>
										</c:forEach>
										</tbody>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="d-flex justify-content-end align-items-center">
					<a href="<c:url value="/processOrder/list"/>" id="back" class="btn btn-light"> <i class="icon-point-left mr-2"> </i> <fmt:message key="button.back" /></a>
						<%-- <c:if test="${ processOrder.status ne 'closed'}">
						  <button type="button" class="btn btn-light ml-3" id="openModalForEvaluate" data-toggle="modal" data-target="#confirmForEvaluate"><fmt:message key="button.enter.evaluate" /><i class="icon-pencil7 ml-3"></i></button>
						</c:if> --%>
					<button type="button" class="btn btn-light ml-3" id="openModalForOther" data-toggle="modal" data-target="#confirmOther"><fmt:message key="button.enter.other" /><i class="icon-pencil7 ml-3"></i></button>
					<button type="button" class="btn btn-light ml-3" id="openModalForEvaluate" data-toggle="modal" data-target="#confirmForEvaluate"><fmt:message key="button.enter.evaluate" /><i class="icon-pencil7 ml-3"></i></button>
					<button type="button" class="btn btn-light ml-3" id="openModalToClosePo" data-toggle="modal" data-target="#confirmToClose"><fmt:message key="button.enter.realValue" /><i class="icon-pencil7 ml-3"></i></button>
					<button type="button" id="hideTblQuotas" class="btn btn-primary ml-3"><fmt:message key="button.show.quota" /><i class="icon-pencil5 ml-2"></i></button>
					<button type="button"  id="processOrderConfirm" class="btn btn-primary ml-3"><fmt:message key="button.save" /><i class="icon-database-insert ml-2"></i></button>
					<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_PROCESS_ORDER_CLOSE')">
						<c:if test="${processOrder.status ne 'unconfirmed' && processOrder.status ne 'closed' && totalPigRetained == 0}">
							<button type="button"  id="processOrderClose" class="btn btn-primary ml-3"><fmt:message key="button.close" /><i class="icon-database-insert ml-2"></i></button>
						</c:if>
					</security:authorize>
				</div>
			</div>
		</div>
		<!-- /basic layout -->
	</form:form>
	
	<!-- modal to evaluate processOrder -->
	<%-- <c:if test="${processOrder.status ne 'closed'}"> --%>
    <div id="confirmForEvaluate" class="modal fade" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><fmt:message key="action.evaluate"></fmt:message></h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
    
                <div class="modal-body">
                    <h6 class="font-weight-semibold"><fmt:message key="enter.label.evaluateInfo"></fmt:message></h6>
                    <div class="form-group form-item__inner">
                        <label for="evaluateAmount"><fmt:message key="enter.label.evaluateAmount"/>: <span class="text-danger">*</span></label>
                        <input type="text" id="evaluateAmount" class="form-control number" placeholder="Nhập số lượng đánh giá..." />
                    </div>
                    
                    <div class="form-group form-item__inner">
                        <label for="evaluateWeigh"><fmt:message key="enter.label.evaluateWeigh"/>: <span class="text-danger">*</span></label>
                        <input type="text" id="evaluateWeigh" class="form-control float" placeholder="Nhập tổng khối lượng đánh giá (kg)..." />
                    </div>
                    <hr>
                    <p><fmt:message key="enter.label.info.evaluate" /> <span class="font-weight-bold"><fmt:message key="enter.label.confirmRequired" /></span></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-link" data-dismiss="modal"><fmt:message key="action.cancel" /></button>
                    <button type="button" id="btnEvaluate" class="btn bg-primary"><fmt:message key="action.confirm" /></button>
                </div>
            </div>
        </div>
    </div>
   <%--  </c:if> --%>
    <!-- /modal to evaluate processOrder -->
	
	<!-- modal to close processOrder -->
	<%-- <c:if test="${processOrder.status ne 'unconfirmed' && processOrder.status ne 'closed' && totalPigRetained == 0}"> --%>
	<div id="confirmToClose" class="modal fade" tabindex="-1">
	    <div class="modal-dialog">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title"><fmt:message key="action.confirm"></fmt:message></h5>
	                <button type="button" class="close" data-dismiss="modal">&times;</button>
	            </div>
	
	            <div class="modal-body">
	                <h6 class="font-weight-semibold"><fmt:message key="enter.label.realInfo"></fmt:message></h6>
	                <div class="form-group form-item__inner">
	                    <label for="realAmount"><fmt:message key="enter.label.realAmount"/>: <span class="text-danger">*</span></label>
	                    <input type="text" id="realAmount" class="form-control number" placeholder="Nhập số lượng đóng chuồng thực tế..." value="" />
	                </div>
	                
	                <div class="form-group form-item__inner">
	                    <label for="realWeigh"><fmt:message key="enter.label.realWeigh"/>: <span class="text-danger">*</span></label>
	                    <input type="text" id="realWeigh" class="form-control float" placeholder="Nhập tổng khối lượng đóng chuồng thực tế..." value="" />
	                </div>
	                <hr>
	                <p><fmt:message key="enter.label.info" /> <span class="font-weight-bold"><fmt:message key="enter.label.confirmRequired" /></span></p>
	            </div>
	            <div class="modal-footer">
	                <button type="button" class="btn btn-link" data-dismiss="modal"><fmt:message key="action.cancel" /></button>
	                <button type="button" id="btnRealValueConfirm" class="btn bg-primary"><fmt:message key="action.confirm" /></button>
	            </div>
	        </div>
	    </div>
	</div>
	<%-- </c:if> --%>
	<!-- /modal to close processOrder -->
	
	<!-- modal để nhập thong tin lứa heo, production version -->
	<div id="confirmOther" class="modal fade" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Nhập thông tin lứa heo, production version</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
    
                <div class="modal-body">
                    <div class="form-group form-item__inner">
                        <label for="inputPigLevel"><fmt:message key="enter.label.pigLevel"/>: <span class="text-danger">*</span></label>
                        <input type="text" id="inputPigLevel" class="form-control" placeholder="Nhập lứa heo" />
                    </div>
                    
                    <div class="form-group form-item__inner">
                        <label for="inputProdVer"><fmt:message key="enter.label.productionVer"/>: <span class="text-danger">*</span></label>
                        <input type="text" id="inputProdVer" class="form-control" placeholder="Nhập Production Version" />
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-link" data-dismiss="modal"><fmt:message key="action.cancel" /></button>
                    <button type="button" id="btnOther" class="btn bg-primary"><fmt:message key="action.confirm" /></button>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- /content area -->

<script src="<c:url value='/themes/admin/assets/js/functions.js'/>"></script>
<script src="<c:url value='/themes/admin/global_assets/js/autoNumeric/autoNumeric.js'/>"></script>
<script src="<c:url value='/themes/admin/assets/js/format_number.js'/>"></script>

<script>
    $(document).ready(function(){
        formatNumberComponent.initAutoNumeric();
    });
</script>

