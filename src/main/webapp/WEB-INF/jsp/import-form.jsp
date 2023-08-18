<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
<title><fmt:message key="import.form.title" /></title>
<meta name="menu" content="importMenu" />
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
	<form:form id="purchaserequisitionForm" modelAttribute="purchaseRequisition" action="<c:url value='/purchaserequisition/save'/>" method="post"
		role="form">
		<form:hidden path="id" />

		<!-- Basic layout-->
		<div class="card">
			<div class="card-header header-elements-inline">
				<span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="import.form.title" /></span>
			</div>
			<div class="card-body">
				<p class="mb-4">
					<fmt:message key="import.form.title.description" />
				</p>
				<fieldset class="mb-3">
					<legend class="text-uppercase font-size-sm font-weight-bold">
						<fmt:message key="template.legend" />
					</legend>
					<div class="card">
						<div class="card-body">
							<div class="row">
								<div class="col-xs-4 col-md-4">
									<div class="form-group">
										<label><fmt:message key="import.id" /><span class="help-block">*</span></label>
										<input type="text" id="purchaserequisitionId" name="id" value="${purchaserequisition.id}" class="form-control" required="required"
											maxlength="19" />
										<div>
											<span id="msgForId" style="color: red"></span>
										</div>
									</div>
								</div>


								<div class="col-xs-4 col-md-4">
									<div class="form-group">
										<label><fmt:message key="import.stockCode" /><span class="help-block">*</span></label>
										<select id="purchaserequisitionStockCode" name="stockCode" value="${purchaserequisition.stockCode}" class="form-control">
											<option value="volvo">12</option>
											<option value="saab">13</option>

										</select>
										<div>
											<span id="msgForStockCode" style="color: red"></span>
										</div>
									</div>
								</div>


								<div class="col-xs-4 col-md-4">
									<div class="form-group">
										<label><fmt:message key="import.materialCode" /><span class="help-block">*</span></label>
										<select id="purchaserequisitionMaterialCode" name="materialCode" value="${purchaserequisition.materialCode}" class="form-control">
											<option value="volvo">01-Cám trộn</option>
											<option value="saab">02-Cám thường</option>
										</select>
										<div>
											<span id="msgForMaterialCode" style="color: red"></span>
										</div>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-xs-6 col-md-6">
									<div class="form-group">
										<label><fmt:message key="import.materialName" /><span class="help-block"></span></label>
										<input type="text" id="purchaserequisitionMaterialName" name="materialName" value="${purchaserequisition.materialName}" class="form-control"
											maxlength="200" />
										<div>
											<span id="msgForMaterialName" style="color: red"></span>
										</div>
									</div>
								</div>

								<!-- 						<div class="row"> -->
								<!-- 							<div class="col-xs-12 col-md-12"> -->
								<!-- 								<div class="form-group"> -->
								<%-- 									<label ><fmt:message key="import.materialGroup"/><span class="help-block"></span></label> --%>
								<%-- 									<input type="text" id="purchaserequisitionMaterialGroup" name="materialGroup" value="${purchaserequisition.materialGroup}" class="form-control"  maxlength="200"/> --%>
								<!-- 									<div><span id="msgForMaterialGroup" style="color:red"></span></div> -->
								<!-- 								</div> -->
								<!-- 							</div> -->
								<!-- 						</div>							 -->

								<div class="col-xs-3 col-md-3">
									<div class="form-group">
										<label><fmt:message key="import.unit" /><span class="help-block"></span></label>
										<input type="text" id="purchaserequisitionUnit" name="unit" value="${purchaserequisition.unit}" class="form-control" maxlength="50" />
										<div>
											<span id="msgForUnit" style="color: red"></span>
										</div>
									</div>
								</div>

								<!-- 						<div class="row"> -->
								<!-- 							<div class="col-xs-12 col-md-12"> -->
								<!-- 								<div class="form-group"> -->
								<%-- 									<label ><fmt:message key="import.orderUnit"/><span class="help-block"></span></label> --%>
								<%-- 									<input type="text" id="purchaserequisitionOrderUnit" name="orderUnit" value="${purchaserequisition.orderUnit}" class="form-control"  maxlength="50"/> --%>
								<!-- 									<div><span id="msgForOrderUnit" style="color:red"></span></div> -->
								<!-- 								</div> -->
								<!-- 							</div> -->
								<!-- 						</div>							 -->

								<div class="col-xs-3 col-md-3">
									<div class="form-group">
										<label><fmt:message key="import.quantity" /><span class="help-block"></span></label>
										<input type="text" id="purchaserequisitionQuantity" name="quantity" value="${purchaserequisition.quantity}" class="form-control"
											maxlength="9" />
										<div>
											<span id="msgForQuantity" style="color: red"></span>
										</div>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-xs-6 col-md-6">
									<div class="form-group">
										<label><fmt:message key="import.deliveryDate" /><span class="help-block"></span></label>
										<input type="date" id="purchaserequisitionDeliveryDate" name="deliveryDate" value="${purchaserequisition.deliveryDate}" class="form-control" />
										<div>
											<span id="msgForDeliveryDate" style="color: red"></span>
										</div>
									</div>
								</div>
								<div class="col-xs-6 col-md-6">
									<div class="form-group">
										<label><fmt:message key="import.farmCode" /><span class="help-block">*</span></label>
										<select id="purchaserequisitionStockCode" name="stockCode" value="${purchaserequisition.stockCode}" class="form-control">
											<option value="volvo">12</option>
											<option value="saab">13</option>

										</select>
										<div>
											<span id="msgForStockCode" style="color: red"></span>
										</div>
									</div>
								</div>
							</div>
							<!-- 						<div class="row"> -->
							<!-- 							<div class="col-xs-12 col-md-12"> -->
							<!-- 								<div class="form-group"> -->
							<%-- 									<label ><fmt:message key="import.prType"/><span class="help-block"></span></label> --%>
							<%-- 									<input type="text" id="purchaserequisitionPrType" name="prType" value="${purchaserequisition.prType}" class="form-control"  maxlength="50"/> --%>
							<!-- 									<div><span id="msgForPrType" style="color:red"></span></div> -->
							<!-- 								</div> -->
							<!-- 							</div> -->
							<!-- 						</div>							 -->
							<!-- 						<div class="row"> -->
							<!-- 							<div class="col-xs-12 col-md-12"> -->
							<!-- 								<div class="form-group"> -->
							<%-- 									<label ><fmt:message key="import.plant"/><span class="help-block"></span></label> --%>
							<%-- 									<input type="text" id="purchaserequisitionPlant" name="plant" value="${purchaserequisition.plant}" class="form-control"  maxlength="50"/> --%>
							<!-- 									<div><span id="msgForPlant" style="color:red"></span></div> -->
							<!-- 								</div> -->
							<!-- 							</div> -->
							<!-- 						</div>							 -->
							<!-- 						<div class="row"> -->
							<!-- 							<div class="col-xs-12 col-md-12"> -->
							<!-- 								<div class="form-group"> -->
							<%-- 									<label ><fmt:message key="purchaserequisition.requisitioner"/><span class="help-block"></span></label> --%>
							<%-- 									<input type="text" id="purchaserequisitionRequisitioner" name="requisitioner" value="${purchaserequisition.requisitioner}" class="form-control"  maxlength="100"/> --%>
							<!-- 									<div><span id="msgForRequisitioner" style="color:red"></span></div> -->
							<!-- 								</div> -->
							<!-- 							</div> -->
							<!-- 						</div>							 -->
							<!-- 						<div class="row"> -->
							<!-- 							<div class="col-xs-12 col-md-12"> -->
							<!-- 								<div class="form-group"> -->
							<%-- 									<label ><fmt:message key="purchaserequisition.status"/><span class="help-block"></span></label> --%>
							<%-- 									<input type="text" id="purchaserequisitionStatus" name="status" value="${purchaserequisition.status}" class="form-control"  maxlength="50"/> --%>
							<!-- 									<div><span id="msgForStatus" style="color:red"></span></div> -->
							<!-- 								</div> -->
							<!-- 							</div> -->
							<!-- 						</div>							 -->
							<!-- 					</div> -->
						</div>
						<div class="d-flex justify-content-end align-items-center">
							<a href="<c:url value="/purchaserequisition/list?id=${purchaserequisition.id}"/>" id="back" class="btn btn-light"><i
									class="icon-point-left mr-2"></i>
								<fmt:message key="button.back" /></a>
							<button type="submit" id="purchaserequisitionSubmit" class="btn btn-primary ml-3">
								<fmt:message key="button.save" />
								<i class="icon-database-insert ml-2"></i>
							</button>
						</div>
				</fieldset>
			</div>
		</div>
		<!-- /basic layout -->
	</form:form>
</div>
<!-- /content area -->

<script src="<c:url value='/themes/admin/assets/js/purchaserequisition_form.js'/>"></script>