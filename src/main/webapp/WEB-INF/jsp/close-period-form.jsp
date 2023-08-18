<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
	<c:choose>
		<c:when test = "${criteria.funcType eq 'close_ga'}">
			<title><fmt:message key="closeAttrition.list.title" /></title>
			<meta name="menu" content=closeAttritionMenu />
		</c:when>
		<c:otherwise>
			<title><fmt:message key="closePeriod.list.title" /></title>
			<meta name="menu" content=closePeriodMenu />
		</c:otherwise>
	</c:choose>
	
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
	<script	src="<c:url value='/themes/admin/assets/js/close-period-form.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
	
	<!-- Multi selecte -->
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/uniform.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/pnotify.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/bootstrap_multiselect.js'/>"></script>
    
    <script src="<c:url value='/themes/admin/global_assets/js/demo_pages/form_multiselect.js'/>"></script>
</head>

<!-- Content area -->
<div class="content">
	<form:form id="periodCloseExceptionForm" modelAttribute="criteria" action="${ctx}/periodClose/save" method="post">
		<input type="hidden" name="funcType" value="${criteria.funcType}"/>
		<!-- Basic layout-->
		<div class="card">
			<div class="card-body">
				<fieldset class="mb-3">
					<legend class="text-uppercase font-size-sm font-weight-bold">
						<fmt:message key="template.legend" />
					</legend>
					<div class="card">
						<div class="card-body">
							<div class="row">
								<div class="col-xs-6 col-md-6">
									<div class="form-group">
										<label><fmt:message key="closePeriod.fromDate" /><span class="help-block"></span></label>
										<form:input type="text" id="periodCloseStage" autocomplete="off" path="periodCloseStage" class="form-control"/>
									</div>
								</div>
								<div class="col-xs-6 col-md-6">
									<div class="form-group">
				                        <label>Trại:<span class="text-danger"> *</span></label>
				                        <select class="form-control multiselect-select-all-filtering" name="farmCodes[]" multiple="multiple" id="stockSelect" data-placeholder="Chọn trại...">
					                        
					                        <c:if test="${not empty farms}">
					                            <c:forEach var="farm" items="${farms}">
					                            	<option value="${farm.code}">${farm.code} - ${farm.name}</option>
					                            	
					                            </c:forEach>
					                        </c:if>
					                    </select>
				                    </div>
								</div>
								
							</div>
						</div>
					</div>
					<div class="d-flex justify-content-end align-items-center">
						<a href="<c:url value="/periodClose/list"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i><fmt:message key="button.back" /></a>
						
						<security:authorize access="hasAnyRole('ROLE_ADMIN')">
							<button type="submit" id="btnSubmit" class="btn bgc-warning ml-3">	<fmt:message key="button.save" /><i class="icon-database-insert ml-2"></i></button>
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

