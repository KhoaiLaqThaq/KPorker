<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
<title><fmt:message key="document.title" /></title>
<meta name="menu" content="documentMenu" />
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
	<script src="<c:url value='/themes/admin/assets/js/document_list.js'/>"></script>
</head>

<div class="content">
	<div class="row mb-2">
		<div class="col-12 col-md-6">
			<div class="text-color-primary fs-5"><fmt:message key="document.title" /></div>
		</div>
	</div>
	<form:form id="documentForm" modelAttribute="criteria" action="${ctx}/document/list" method="POST">
	<!-- \Searching -->
	<div class="card rounded-16">
		<div class="row">
			<div class="col-6 px-3 py-2 fw-bold">
				<fmt:message key="label.search" />
			</div>
			<div class="col-6 text-right">
              <button type="button" id="btnReset" class="btn btn-secondary rounded-10 mt-2 mr-2">Đặt lại</button>
              <button type="submit" id="btnSubmit" class="btn btn-secondary rounded-10 mt-2 mr-2"><i class="mr-2 icon-search4"></i><span class="mr-2"><fmt:message key="label.search"/></span></button>
            </div>
		</div>
		<div class="card-body py-0">
			<div class="row">
				<div class="col-12 col-md-8">
					<div class="row">
						<div class="col-12 col-sm-6 col-md-3">
							<div class="form-group">
								<label><fmt:message key="farm.code" /></label>
								<input class="form-control rounded-10" type="text" id="farmCode" name="farmCode" value="${criteria.farmCode}" placeholder="Nhập mã trại"/>
							</div>
						</div>
						<div class="col-12 col-sm-6 col-md-3">
							<div class="form-group">
								<label><fmt:message key="farm.name" /></label>
								<input class="form-control rounded-10" type="text" id="farmName" name="farmName" value="${criteria.farmName}" placeholder="Nhập tên trại"/>
							</div>
						</div>
						<div class="col-12 col-sm-6 col-md-3">
							<div class="form-group">
								<label><fmt:message key="barnPlan.status" /></label>
								<select name="status" class="form-control rounded-10 select2" id="status">
									<option value="">&nbsp;</option>
									<c:forEach var="item" items = "${documentStatus}">
										<option value="${item}" ${criteria.status eq item ? 'selected' : ''}><fmt:message key="document.status.${item}" /></option>
									</c:forEach>
								</select>
							</div>
						</div>
					</div>
				</div>
				<div class="col-12 col-md-4">
					<label class="text-label">Trong khoảng:</label>
					<div class="row">
						<div class="col-md-6 col-sm- col-xs-12">
							<div class="form-group row">
								<span class="flex-center-vertical">Từ</span>
								<div class="col-lg-10">
									<input type="text" class="form-control rounded-10" placeholder="DD/MM/YYYY" id="from__date" name="searchFromDateStr" value="${criteria.searchFromDateStr }" autocomplete="off" />
								</div>
							</div>
						</div>
						<div class="col-md-6 col-sm-6 col-xs-12">
							<div class="form-group row">
								<span class="flex-center-vertical">đến</span>
								<div class="col-lg-10">
									<input type="text" class="form-control rounded-10" placeholder="DD/MM/YYYY" id="to__date" name="searchToDateStr" value="${criteria.searchToDateStr }" autocomplete="off" />
								</div>
							</div>
						</div>
					</div>
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
							<th class="bgc-primary border-primary text-white text-center" style="width: 2%">#</th>
							<th class="bgc-primary border-primary text-white " style="width: 10%"><fmt:message key="document.created-date" /></th>
							<th class="bgc-primary border-primary text-white " style="width: 5%"><fmt:message key="import.farmCode" /></th>
							<th class="bgc-primary border-primary text-white " style="width: 10%"><fmt:message key="goods.attrition.support.farm.name" /></th>
							<th class="bgc-primary border-primary text-white " style="width: 10%"><fmt:message key="document.type.description" /></th>
							<th class="bgc-primary border-primary text-white " style="width: 5%" ><fmt:message key="document.status" /></th>
							<th class="bgc-primary border-primary text-white text-center" style="width: 5%"><i class="icon-menu-open2"></i></th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${empty page.content}">
							<tr>
								<td colspan="7" class="text-center text-none-data">
									<fmt:message key="not.data" />
								</td>
							</tr>
						</c:if>
						<c:forEach var="item" items="${page.content}" varStatus="cnt">
							<tr>
								<td class="text-center"><c:out value="${cnt.count + page.size * page.number}" /></td>
								<td>${item.displayCreatedDate}</td>
								<td>${item.farm.code}</td>
								<td>${item.farm.name}</td>
								<td>${item.description}</td>
								<td class="text-center"><span class="badge bg-${item.status eq 'send-failed' ? 'danger' : 'success' }-400"><fmt:message key="document.status.${item.status}" /></span></td>
								<td class="text-center">
									<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_DOCUMENT_UPDATE')">
										<a href="/document/form?id=${item.id}"><i class="icon-pencil7"></i><span> <fmt:message key="button.edit"/></span></a>
									</security:authorize>
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