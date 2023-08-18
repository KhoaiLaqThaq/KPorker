<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="event.form.title"/></title>
	<meta name="menu" content="processOrderMenu" />
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
<form:form id="eventForm" modelAttribute="goodsIssue" action="${ctx}/goodsAttrition/save" method="post" role="form">
	<form:hidden path="id"/>
	<form:hidden path="status" id="status" />
	<form:hidden path="type" id="type" />
	<form:hidden path="transCode" id="transCode" />
	<form:hidden id="contentJson" path="contentJson" />
	<form:hidden path="modifiedBy"  value="${goodsIssue.username}" />
	<form:hidden path="createdBy"  value="${goodsIssue.username}" />
	<form:hidden path="processOrderCode"/>
	<input type="hidden" name="production.code" value="${goodsIssue.production.code}"/>
	<form:hidden path="processOrderId"/>
	<input type="hidden" name="stock.code" id="stockCode" value="${stock.code}"> 
	<input type="hidden" name="fromStockCode" id="fromStockCode" value="${stock.code}"> 
	<!-- Basic layout-->
	<div class="card">
		<div class="card-header header-elements-inline">
			<span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="event.form.title"/> - <c:out value = "${processOrder.barn.farm.name}"/> - <c:out value = "${processOrder.barn.code}"/></span>
		</div>
		<div class="card-body">
			<p class="mb-4"><fmt:message key="event.form.title.description"/></p>
			<fieldset class="mb-3">
				<legend class="text-uppercase font-size-sm font-weight-bold"><fmt:message key="template.legend"/></legend>
				<div class="card">
					<div class="card-body">
						<div class="row">
							<div class="col-xs-12 col-md-3">
								<div class="form-group">
									<label ><fmt:message key="goodsissue.processOrder"/>: <b class="ml-3"><c:out value="${goodsIssue.processOrderCode }" /></b></label>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-xs-12 col-md-4">
								<div class="form-group">
									<label ><fmt:message key="goodsissue.form.stockCode"/><span class="help-block"></span></label>
									<p class="form-control"> <c:out value = "${stock.code} - ${stock.name}"/></p>
								</div>
							</div>
<!-- 							<div class="col-xs-12 col-md-4"> -->
<!-- 								<div class="form-group"> -->
<%-- 									<label ><fmt:message key="goodsissue.form.stockName"/><span class="help-block"></span></label> --%>
<%-- 									<p class="form-control"> <c:out value = "${stock.code} - ${stock.name}" /></p> --%>
<!-- 								</div> -->
<!-- 							</div> -->
							<div class="col-xs-12 col-md-4">
								<div class="form-group">
									<label><fmt:message key="goodsissue.postingDate" /><span class="help-block"></span></label>
									<input type="text" id="GoodIssuePostingDate" name="postingDate" value="${goodsIssue.displayPostingDate}" readonly="readonly"  class="form-control daterange-single" />
								</div>
							</div>
						</div>
						<!-- Add materials -->
						<jsp:include page="goodsissue-selector.jsp" />
						<!-- /Add materials -->
					</div>
				</div>
				<div class="d-flex justify-content-end align-items-center">
					<a href="<c:url value="/goodsAttrition/list?poCode=${goodsIssue.processOrderCode}"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i><fmt:message key="button.back"/></a>
					<security:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_GOODS_ATTRITION_CREATE')">
						<c:if test="${empty goodsIssue.id}">
							<button type="button" id="btnSubmit" class="btn btn-primary ml-3"><fmt:message key="button.save"/><i class="icon-database-insert ml-2"></i></button>		
						</c:if>	
					</security:authorize>
				</div>			
			</fieldset>
		</div>
	</div>
	<!-- /basic layout -->
</form:form>
</div>
<!-- /content area -->
<script src="<c:url value='/themes/admin/assets/js/event_form.js'/>"></script>
<script src="<c:url value='/themes/admin/assets/js/goodsissue-selector.js'/>"></script>