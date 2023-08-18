<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="stock.count.form.title"/></title>
    <meta name="menu" content="stockCountMenu"/>
    <script src="<c:url value='/themes/admin/assets/js/stock_count_form.js'/>"></script>
    <!-- Map -->
</head>

<!-- Content area -->
<div class="content">
<form:form id="instockForm" modelAttribute="stockCount" action="<c:url value='/stockCount/save'/>" method="post" role="form">
	<form:hidden path="id"/>
	<form:hidden path="transCode" id="transCode"/>
	<!-- Basic layout-->
	<div class="card">
		<div class="card-header header-elements-inline"><span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="stock.count.form.title"/></span></div>
		<div class="card-body">
			<fieldset class="mb-3">
				<legend class="text-uppercase font-size-sm font-weight-bold"><fmt:message key="template.legend"/></legend>
				<div class="card">
					<div class="card-body">
						<div class="row">
							<div class="col-xs-12 col-md-4">
								<div class="form-group">
									<label ><fmt:message key="instock.farmCode"/><span class="help-block"></span></label>
									<input type="text" id="stockCode" name="stockCode" value="${stockCount.stock.code}" class="form-control" readonly="readonly"/>
									<div><span id="msgForStockCode" style="color:red"></span></div>
								</div>
							</div>
							<div class="col-xs-12 col-md-4">
								<div class="form-group">
									<label ><fmt:message key="instock.farmName"/><span class="help-block"></span></label>
									<input type="text" name="stockName" value="${stockCount.stock.name}" class="form-control" readonly="readonly"/>
									<div><span id="msgForStockCode" style="color:red"></span></div>
								</div>
							</div>
							<div class="col-xs-12 col-md-4">
								<div class="form-group">
									<label ><fmt:message key="stock.count.syncDate"/><span class="help-block"></span></label>
									<input type="text" name="postingDate" value="${stockCount.displayPostingDate}" class="form-control" readonly="readonly"/>
									<div><span id="msgForSyncDate" style="color:red"></span></div>
								</div>
							</div>
						</div>		
						<jsp:include page="stock-count-material-selector.jsp"/>					
					</div>
				</div>
				<div class="d-flex justify-content-end align-items-center">
					<a href="<c:url value="/stockCount/list"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i><fmt:message key="button.back" /></a>
					<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_STOCK_COUNT_EXPORT')">
						<a href="<c:url value='/stockCount/Export/${stockCount.id}'/>" class="btn btn-sm btn-primary" title="<fmt:message key="button.export"/>"><i class="icon-file-upload"></i> <fmt:message key="button.export" /></a>
					</security:authorize>
				</div>	
			</fieldset>
		</div>
	</div>
	<!-- /basic layout -->
</form:form>
</div>
<!-- /content area -->