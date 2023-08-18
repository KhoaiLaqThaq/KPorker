<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="stock.count.list.title"/></title>
    <meta name="menu" content="stockCountMenu"/>
	<link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">
	<script src="<c:url value='/themes/admin/assets/js/stock_count_list.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/ui/moment/moment.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/daterangepicker.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/anytime.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.date.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/legacy.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/jgrowl.min.js'/>"></script>
</head>

<div class="row mb-3">
	<div class="col-12"><%@include file="/themes/admin/common/instock-actions.jsp"%></div>
</div>

<div class="content">
	<div class="row cus-tabs-container mb-3">
		<ul class="nav nav-tabs mb-0">
			<li class="nav-item"><a href="/instock/list" class="nav-link"><fmt:message key="menu.instock"/></a></li>
			<li class="nav-item"><a href="/stockCount/list" class="nav-link active show"><fmt:message key="menu.stock.count"/></a></li>
			<li class="nav-item"><a href="/instock-baseline/list" class="nav-link"><fmt:message key="menu.instock.baseline"/></a></li>
		</ul>
		<div class="tab-divider"></div>
	</div>
	<div class="row mb-3">
		<div class="col-12 col-md-6">
			<div class="text-color-primary fs-5"><fmt:message key="stock.count.list.title" /></div>
		</div>
	</div>

<form:form id="stockCountForm" modelAttribute="criteria" action="/stockCount/list" method="post">
	<input type="hidden" name="latest" value="${criteria.latest}">
	<%-- <input type="hidden" id="postingDate" name="postingDate" value="${criteria.postingDate}"> --%>
	<input type="hidden" id="displayPostingDate" value="${criteria.displayPostingDate}">
	<!-- \Searching -->
	<div class="card rounded-16">
		<div class="row"><div class="col-12 px-3 py-2 fw-bold"><fmt:message key="label.search" /></div></div>
		<div class="card-body py-0">
			<div class="row">
				<div class="col-md-4">
                   <div class="form-group">
                       <label><fmt:message key="instock.farmName" /></label>
                       <input class="form-control rounded-10" type="text" name="stockName" value="${criteria.stockName}" placeholder="Nhập tên trại" id="farmName" autocomplete="off"/>
                   </div>
                </div>
                <div class="col-md-4">
                   <div class="form-group">
                       <label><fmt:message key="instock.syncDate" /></label>
                       <input class="form-control rounded-10 daterange-single" type="text" placeholder="Chọn ngày ghi nhận DD/MM/YYYY" name="postingDateSearch" id="postingDateStr" value="${criteria.displayPostingDate}" autocomplete="off"/>
                   </div>
                </div>
				<div class="col-4 text-right mt-3">
					<button type="button" class="btn btn-secondary" id="btnReset">Đặt lại</button>
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
						<th class="text-center bgc-primary border-primary text-white" style="width: 5%">#</th>
						<th class="bgc-primary border-primary text-white"><fmt:message key="instock.farmCode"/></th>
						<th class="bgc-primary border-primary text-white"><fmt:message key="instock.farmName"/></th>
						<th class="bgc-primary border-primary text-white"><fmt:message key="stock.count.syncDate"/></th>
						<th class="bgc-primary border-primary text-white"><fmt:message key="instock.modifiedDate"/></th>
						<th class="text-center bgc-primary border-primary text-white" style="width:120px;"><i class="icon-menu-open2"></i></th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${empty page.content}">
						<tr><td colspan="5" class="text-center text-none-data"><fmt:message key="not.data"/></td></tr>
					</c:if>
					<c:forEach var="item" items="${page.content}" varStatus="cnt">
						<tr>
							<td class="text-center"><c:out value="${cnt.count+page.size*page.number}" /></td>
							<td>${item.stock.code}</td>
							<td>${item.stock.name}</td>
							<td>${item.displayPostingDate}</td>
							<td>${item.displayCreatedDate}</td>
							<td class="text-center">
								<div class="list-icons">
									<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_STOCK_COUNT_EDIT')">
										<a href="/stockCount/form?id=${item.id}"><i class="icon-file-eye fontSize18" title="Chi tiết"></i></a>
									</security:authorize>
								</div>
							</td>
						</tr> 
					</c:forEach>
				</tbody> 
			</table>
		</div>
		<!-- Pagination -->
        <jsp:include page="/themes/admin/common/pagination.jsp">
         	<jsp:param value="${page.number}" name="pageNumber"/>
         	<jsp:param value="${page.totalPages}" name="maxPages"/>
         	<jsp:param value="${page.size}" name="size"/>
         	<jsp:param value="${page.totalElements}" name="totalElements"/>
      	</jsp:include>
	</div>
	<!-- /Table -->
</form:form>
</div>
