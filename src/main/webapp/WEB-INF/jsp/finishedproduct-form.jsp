<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="finishedproduct.form.title"/></title>
    <meta name="menu" content="finishProductMenu"/>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/uniform.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/assets/js/finishedproduct_form.js'/>"></script>
    <!-- Map -->
</head>

<!-- Content area -->
<div class="content">
<form:form id="finishedproductForm" modelAttribute="finishedProduct" action="${ctx}/finishedProduct/save" method="post" role="form">
	<form:hidden path="id"/>
	
	<!-- Basic layout-->
	<div class="card">
		<div class="card-header header-elements-inline"><span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="finishedproduct.form.title"/></span></div>
		<div class="card-body">
			<p class="mb-4"><fmt:message key="finishedproduct.form.title.description"/></p>
			<fieldset class="mb-3">
				<legend class="text-uppercase font-size-sm font-weight-bold"><fmt:message key="template.legend"/></legend>
				<div class="card">
					<div class="card-body">
						<div class="row">
							<div class="col-xs-4 col-md-4">
								<div class="form-group">
									<label ><fmt:message key="finishedproduct.stockCode"/><span class="help-block">*</span></label>
									<input type="text" id="finishedproductStockCode" name="stockCode" value="${finishedproduct.stockCode}" class="form-control"  maxlength="50"/>
								</div>
							</div>
					
							<div class="col-xs-4 col-md-4">
								<div class="form-group">
									<label ><fmt:message key="finishedproduct.processOrderCode"/><span class="help-block">*</span></label>
									<input type="text" id="finishedproductProcessOrderCode" name="processOrderCode" value="${finishedproduct.processOrderCode}" class="form-control"  maxlength="50"/>
								</div>
							</div>
							<div class="col-xs-4 col-md-4">
									<div class="form-group">
										<label><fmt:message key="pigentry.entryDate" /><span class="help-block">*</span></label>
										<input type="date" id="pigentryEntryDate"  name="entryDate" value="${pigEntry.entryDate}" class="form-control" />
										<div>
											<span id="msgForEntryDate" style="color: red"></span>
										</div>
									</div>
							</div>
							<%-- <div class="col-xs-4 col-md-4">
								<div class="form-group">
									<label ><fmt:message key="finishedproduct.pigType"/><span class="help-block">*</span></label>
									<select id="finishedproductPigType" name="pigType" class="form-control select2">
											<c:forEach var="pigType" items="${ pigTypes }" varStatus="cnt">
											<option value="${pigType}">${pigType}</option>
											</c:forEach>
									</select>
								</div>
							</div> --%>
						</div>							
						<div class="row">
							<div class="col-xs-4 col-md-4">
								<div class="form-group">
									<label ><fmt:message key="finishedproduct.quantity"/><span class="help-block">*</span></label>
									<input type="number" id="finishedproductQuantity" name="quantity" value="${finishedproduct.quantity}" class="form-control"  maxlength="9"/>
								</div>
							</div>
						
							<div class="col-xs-4 col-md-4">
								<div class="form-group">
									<label ><fmt:message key="finishedproduct.volumn"/><span class="help-block">*</span></label>
									<input type="number" id="finishedproductVolumn" name="volumn" value="${finishedproduct.volumn}" class="form-control"  maxlength="9"/>
								</div>
							</div>
							
							<div class="col-xs-4 col-md-4">
								<div class="form-group">
									<label ><fmt:message key="finishedproduct.batch"/><span class="help-block">*</span></label>
									<input type="text" id="finishedproductBatch" name="batch" value="${finishedproduct.batch}" class="form-control"  maxlength="50"/>
								</div>
							</div>
							
							
						</div>							
					</div>
				</div>
				<div class="d-flex justify-content-end align-items-center">
					<a href="<c:url value="/finishedProduct/list"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i><fmt:message key="button.back"/></a>
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

<script src="<c:url value='/themes/admin/assets/js/finishedproduct_form.js'/>"></script>