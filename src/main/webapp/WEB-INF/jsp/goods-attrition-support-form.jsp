<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <c:choose>
         <c:when test = "${goodsIssue.action eq 'new'}">
         	<title><fmt:message key="event.form.title"/></title>
         </c:when>
         <c:otherwise>
         	<title><fmt:message key="goods.attrition.support.form.title"/></title>
         </c:otherwise>
    </c:choose>
	<meta name="menu" content="goodsAttritionSupportMenu" />
    <script src="/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js"></script>
	<script src="/themes/admin/global_assets/js/plugins/forms/styling/switch.min.js"></script>	
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>
	<script src="/themes/admin/global_assets/js/plugins/ui/moment/moment.min.js"></script>
	<script src="/themes/admin/global_assets/js/plugins/pickers/daterangepicker.js"></script>
	<script src="/themes/admin/global_assets/js/plugins/pickers/anytime.min.js"></script>
	<script src="/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.js"></script>
	<script src="/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.date.js"></script>
	<script src="/themes/admin/global_assets/js/plugins/pickers/pickadate/legacy.js"></script>
	<script src="/themes/admin/global_assets/js/plugins/notifications/jgrowl.min.js"></script>
	<script src="/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js"></script>
</head>

<!-- Content area -->
<div class="content">
<form:form id="goodsAttritionSupportForm" modelAttribute="goodsIssue" action="${ctx}/goodsAttritionSupport/save" method="post" role="form">
	<form:hidden path="id"/>
	<form:hidden path="status" id="status" />
	<form:hidden path="type" id="type" />
	<form:hidden path="transCode" id="transCode" />
	<form:hidden path="createdBy" id="createdBy" />
	<form:hidden path="processOrderCode" id="processOrderCode"/>
	<input type="hidden" name="stock.code" id="stockCode" value="${stockCode}"> 
	<form:hidden path="postingDate" id="postingDate"/>
	<form:hidden path="action" id="action"/>
	<input type="hidden" name="fromStockCode" id="fromStockCode">
	<security:authorize access="hasAnyRole('ROLE_GOODS_ATTRITION_SUPPORT_NOT_DELETE')">
		<input type="hidden" id="checkRoleDelete" value="inactive">
	</security:authorize>
	<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GOODS_ATTRITION_SUPPORT_DELETE')">
		<input type="hidden" id="checkRoleDelete" value="active">
	</security:authorize>
	<!-- Basic layout-->
	<div class="card rounded-16">
	   <div class="card-header header-elements-inline">
            <c:choose>
                 <c:when test = "${goodsIssue.action eq 'new'}"><span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="event.form.title"/></span></c:when>
                 <c:otherwise><span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="goods.attrition.support.form.title"/></span></c:otherwise>
            </c:choose>
        </div>
		<div class="card-body">
			<fieldset class="mb-3">
				<c:choose>
			         <c:when test = "${goodsIssue.action eq 'new'}">
			           <div class="row">
							<div class="col-xs-12 col-md-12">
								<div class="form-group">
									<label><fmt:message key="goodsattritionSupport.postingDate" />:<span class="help-block">*</span></label>
								    <input type="text" id="goodsIssuePostingDate" name="postingDate" value="${goodsIssue.displayPostingDate}" readonly="readonly"  class="form-control rounded-10 daterange-single"/>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-md-12">
								<div class="card">
									<div class="card-header bg-light d-flex justify-content-between">
										<span class="font-size-sm text-uppercase font-weight-semibold"><fmt:message key="processOrder.info"/></span>
										<span class="font-size-sm text-uppercase text-success font-weight-semibold">&nbsp;</span>
									</div>
									<div class="card-body">
										<div class="table-responsive maxH-300 table-scroll">  
							               	<table id="tblSelectedProcessOrders" class="table table-bordered table-striped">
												<thead>
													<tr class="table-success">
														<th class="bgc-primary border-primary text-white" width="3%">#</th>
														<th class="bgc-primary border-primary text-white" width="17%"><fmt:message key="goods.attrition.farmcode" /></th>
														<th class="bgc-primary border-primary text-white" width="20%"><fmt:message key="goods.attrition.farmname" /></th>
														<th class="bgc-primary border-primary text-white" width="15%"><fmt:message key="processOrder.barn.name" /></th>
														<th class="bgc-primary border-primary text-white" width="13%"><fmt:message key="processOrder.batch" /></th>
														<th class="bgc-primary border-primary text-white" width="18%"><fmt:message key="processOrder.code" /></th>
														<th class="bgc-primary border-primary text-white" width="19%"><fmt:message key="processOrder.status" /></th>
													</tr>
												</thead>
												<tbody id="dataProcesOrders">
													<c:forEach begin="0" items="${processOrders}" var="item" varStatus="cnt">
														<tr id="rec-process-order${cnt.index}" class="tr showable">
															<td>
																<c:choose>
																	<c:when test="${processOrderSelected != null && item.code eq processOrderSelected}">
																		<input type="checkbox" checked class="item-check" name="item[]" id="checked${cnt.index}" value="${cnt.index}" onchange="changeCheckBox(${cnt.index})">
																	</c:when>
																	<c:otherwise>
																		<input type="checkbox" class="item-check" name="item[]" id="checked${cnt.index}" value="${cnt.index}" onchange="changeCheckBox(${cnt.index})">
																	</c:otherwise>
																</c:choose>
																
															</td>
															<td><input type="text" class="form-control" value="${item.barn.farm.code}" id="selected-farm-code${cnt.index}" readonly="readonly"/></td>
															<td><input type="text" class="form-control" value="${item.barn.farm.name}" id="selected-farm-name${cnt.index}" readonly="readonly"/></td> 
															<td><input type="text" class="form-control" value="${item.barn.name.substring(item.barn.name.indexOf('@ ') + 1)}" id="selected-barn-name${cnt.index}" readonly="readonly"/></td>
															<td><input type="text" class="form-control" value="${item.batch}" id="selected-process-order-batch${cnt.index}" readonly="readonly"/></td>
															<td><input type="text" class="form-control" name="processOrderCodes" title="${item.code}" value="${item.code}" id="selected-process-order-code${cnt.index}" readonly="readonly"/></td>
															<td><input type="text" class="form-control" value="" id="selected-process-order-status${cnt.index}" readonly="readonly"/></td>
														</tr>
													</c:forEach>
												</tbody>
											</table>
										</div>
									</div>
								</div>
							</div>
						</div>
						<!-- Add materials -->
						<jsp:include page="goods-attrition-material-selector.jsp" />
						<!-- /Add materials -->
			         </c:when>
			         <c:otherwise>
			            <div class="row">
			            	<div class="col-xs-12 col-md-4">
								<div class="form-group">
									<label><fmt:message	key="purchaserequisition.stockCode" /><span	class="help-block">*</span></label>
									<input type="text" value="${farm.code} - ${farm.name}" readonly="readonly" class="form-control" />
									<input type="hidden" id="farmCode" name="stockCode" value="${farm.code}" class="form-control" />
								</div>
							</div>
							<div class="col-xs-12 col-md-4">
								<div class="form-group">
									<label><fmt:message key="goodsissue.copy.postingDate" /><span class="help-block">*</span></label>
									<input type="text" id="goodsIssueCopyFromPostingDate" name="postingDateSearch" value="${goodsIssue.displayPostingDate}" readonly="readonly" class="form-control daterange-single" />
								</div>
							</div>
							<div class="col-xs-12 col-md-4">
								<div class="form-group">
									<label><fmt:message key="goodsattritionSupport.postingDate" /><span class="help-block"></span></label>
									<input type="text" id="goodsIssuePostingDate" name="postingDate" readonly="readonly"  class="form-control daterange-single" />
								</div>
							</div>
						</div>
			         </c:otherwise>
			      </c:choose>
				<div class="d-flex justify-content-end align-items-center">
					<a href="<c:url value='/goodsAttritionSupport/list'/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i><fmt:message key="button.back"/></a>
					<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GOODS_ATTRITION_SUPPORT_CREATE')">
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
<script src="<c:url value='/themes/admin/assets/js/goods_attrition_support_form.js'/>"></script>
<script src="<c:url value='/themes/admin/assets/js/goods_attrition_material_selector.js'/>"></script>

<div class="modal hide" id="pleaseWaitDialog" data-backdrop="static" data-keyboard="false">
    <div class="modal-body">
        <div class="loading">Loading&#8230;</div>
    </div>
</div>
