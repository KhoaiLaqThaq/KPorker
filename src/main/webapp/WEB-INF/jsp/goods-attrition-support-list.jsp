<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
<title><fmt:message key="goods.attrition.support.list.title" /></title>
<meta name="menu" content="goodsAttritionSupportMenu" />
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/switch.min.js'/>"></script>	
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/ui/moment/moment.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/daterangepicker.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/anytime.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.date.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/legacy.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/jgrowl.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/assets/js/goods_attrition_support_list.js'/>"></script>
</head>

<div class="row mb-3">
	<div class="col-12"><%@include file="/themes/admin/common/actions.jsp"%></div>
</div>

<div class="content">
	<div class="row mb-2">
		<div class="col-12 col-md-6">
			<div class="text-color-primary fs-5"><fmt:message key="goods.attrition.support.list.title" /></div>
		</div>
		<div class="col-12 col-md-6 text-right">
			<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GOODS_ATTRITION_SUPPORT_CREATE')">
				<a href="<c:url value='/goodsAttritionSupport/form'/>" class="btn btn-sm bgc-warning text-white" title="<fmt:message key="button.add"/>"><i class="icon-plus22"></i> <fmt:message key="button.add" /></a>
			</security:authorize>
			<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_MATERIAL_SUPPORT_EDIT')">
				<a href="<c:url value='/materialSupport/form'/>" class="btn btn-sm bgc-warning text-white"><i class="icon-plus22"></i> <fmt:message key="button.add.material.support" /></a>
			</security:authorize>
			<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GOODS_ATTRITION_SUPPORT_EXPORT')">
				<a href="<c:url value='/goodsAttritionSupport/Export/form'/>" class="btn btn-sm bgc-warning text-white" title="<fmt:message key="button.add"/>"><i class="icon-file-upload"></i> <fmt:message key="button.export" /></a>
			</security:authorize>
		</div>
	</div>
	<form:form id="goodsAttritionSupportForm" modelAttribute="criteria" action="${ctx}/goodsAttritionSupport/list" method="POST">
		<input type="hidden" value="${criteria.postingDateSearch}" id="postingDateSearch"/>
	<!-- \Searching -->
	<div class="card rounded-16">
		<div class="row"><div class="col-12 px-3 py-2 fw-bold"><fmt:message key="label.search" /></div></div>
		<div class="card-body py-0">
			<div class="row">
				<div class="col-9">
					<div class="row">
						<div class="col-5">
							<div class="form-group">
								<label><fmt:message key="instock.farmName" /></label>
								<input class="form-control rounded-10" type="text" id="stockName" name="stockName" value="${criteria.stockName}" placeholder="Nhập tên trại"/>
							</div>
						</div>
						<div class="offset-1 col-6">
							<label> <fmt:message key="goodsattritionSupport.postingDate"/></label>
							<div class="row">
								<div class="col-md-6 col-sm-12 col-xs-12">
									<div class="form-group row">
										<span class="flex-center-vertical">Từ</span>
										<div class="col-lg-10">
											<input type="text" class="form-control rounded-10" placeholder="DD/MM/YYYY" id="fromDate" name="searchFromDate" value="${criteria.searchFromDate}" autocomplete="off" />
										</div>
									</div>
								</div>
								<div class="col-md-6 col-sm-12 col-xs-12">
									<div class="form-group row">
										<span class="flex-center-vertical">đến</span>
										<div class="col-lg-10">
											<input type="text" class="form-control rounded-10" placeholder="DD/MM/YYYY" id="toDate" name="searchToDate" value="${criteria.searchToDate}" autocomplete="off" />
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="col-3 text-right mt-3">
					<button type="button" class="btn btn-secondary" id="btnReset"><i class="mr-2 icon-reset"></i><fmt:message key="button.reset" /></button>
					<button type="button" class="btn btn-secondary" id="btnSubmit"><i class="mr-2 icon-search4"></i><fmt:message key="button.search" /></button>
				</div>
	    	</div>
    	</div>
    </div>
    <!-- /Searching -->
		<!-- \Table -->
		<div class="card">
			<div class="table-responsive">
				<table class="table table-bordered table-striped">
					<thead>
						<tr class="table-success">
							<th class="bgc-primary border-primary text-white text-center" style="width: 5%">#</th>
							<th class="bgc-primary border-primary text-white " style="width: 10%"><fmt:message key="goods.attrition.support.posting.date" /></th>
							<th class="bgc-primary border-primary text-white " style="width: 10%"><fmt:message key="goods.attrition.support.farm.name" /></th>
							<th class="bgc-primary border-primary text-white " style="width: 10%"><fmt:message key="goods.attrition.support.ratio" /></th>
							<th class="bgc-primary border-primary text-white text-center" style="width: 5%"><i class="icon-menu-open2"></i></th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${empty page.content}">
							<tr>
								<td colspan="5" class="text-center text-none-data">
									<fmt:message key="not.data" />
								</td>
							</tr>
						</c:if>
						<c:forEach var="item" items="${page.content}" varStatus="cnt">
							<tr>
								<td class="text-center"><c:out value="${cnt.count+page.size*page.number}" /></td>
								<td>${item.displayPostingDate}</td>
								<td>${item.stock.name}</td>
								<td><c:out value="${item.ratio}/${item.total}"></c:out></td>
								<td class="text-center">
									<div class="list-icons">
										<div class="dropdown">
											<a href="#" class="list-icons-item" data-toggle="dropdown"><i class="icon-menu9"></i></a>
											<div class="dropdown-menu dropdown-menu-right">
												<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GOODS_ATTRITION_SUPPORT_CREATE')">
													<a href="/goodsAttritionSupport/form?postingDate=${item.displayPostingDate}&action=new&stockCode=${item.stock.code}" class="dropdown-item"><i class="icon-pencil7"></i><span><fmt:message key="button.edit"/></span></a>
												</security:authorize>
												<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GOODS_ATTRITION_SUPPORT_COPY')">
													<a href="/goodsAttritionSupport/form?postingDate=${item.displayPostingDate}&action=copy&stockCode=${item.stock.code}" class="dropdown-item"><i class="icon-stack"></i><fmt:message key="button.copy"/></a>
												</security:authorize>
												<a href="/goodsAttritionSupport/stockCode/export?postingDate=${item.displayPostingDate}&stockCode=${item.stock.code}" class="dropdown-item"><i class="icon-stack"></i><fmt:message key="button.export.goodsAttrition"/></a>
											</div>
										</div>
									</div>
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div> 
			 <!-- Pagination --> 
			 <jsp:include page="/themes/admin/common/pagination.jsp">
				<jsp:param value="${page.number}" name="pageNumber" />
				<jsp:param value="${page.totalPages}" name="maxPages" />
				<jsp:param value="${page.size}" name="size" />
				<jsp:param value="${page.totalElements}" name="totalElements" />
			</jsp:include>
		</div>
		<!-- /Table -->
	</form:form>
</div>

<script>
	$('#sync-data-to-sap').on('click', function() {
		$('#pleaseWaitDialog').modal();
	});
</script>
<div class="modal hide" id="pleaseWaitDialog" data-backdrop="static" data-keyboard="false">
    <div class="modal-body">
        <div class="loading">Loading&#8230;</div>
    </div>
</div>