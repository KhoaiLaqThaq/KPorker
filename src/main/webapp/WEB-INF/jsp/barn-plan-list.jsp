<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>
<head>
<title><fmt:message key="barn.plan.list.title" /></title>
<meta name="menu" content="barnPlanMenu" />
	<script src="<c:url value='/themes/admin/assets/js/barnplan_list.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/main/bootstrap.bundle.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/loaders/blockui.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/ui/moment/moment.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/daterangepicker.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.date.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/legacy.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/jgrowl.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
</head>

<div class="row mb-3">
	<div class="col-12"><%@include file="/themes/admin/common/actions.jsp"%></div>
</div>

<div class="content">
	<div class="row mb-3">
		<div class="col-12 col-md-6">
			<div class="text-color-primary fs-5"><fmt:message key="barn.plan.list.title" /></div>
		</div>
	</div>
	<form:form id="barnPlanForm" modelAttribute="criteria" action="${ctx}/barnPlan/list" method="post">
	<input type="hidden" value="${criteria.barnEmptyDateSearchPeriod}" id="postingDateSearch"/>
		<!-- \Searching -->
		<div class="card rounded-16">
			<div class="row">
				<div class="col-6 px-3 py-2 fw-bold"><fmt:message key="label.search" /></div>
				<div class="col-6 text-right">
					<button type="button" class="btn btn-secondary mt-2 mr-2" id="btnReset">Đặt lại</button>
					<button type="button" class="btn btn-secondary mt-2 mr-2" id="btnSubmit"><fmt:message key="button.search" /></button>
				</div>
			</div>
			<div class="card-body py-0">
				<div class="row">
					<div class="col-8">
						<div class="row">
							<div class="col-4">
								<div class="form-group">
									<label><fmt:message key="purchaserequisition.farmName"/></label>
									<input class="form-control rounded-10" id="farmName" type="text" name="farmName" value="${criteria.farmName}" placeholder="Nhập tên trại" />
								</div>
							</div>
							<div class="col-4">
								<div class="form-group">
									<label> <fmt:message key="barnPlan.barnCode" /></label>
									<input class="form-control rounded-10" type="text" id="barnCode" name="barnCode" value="${criteria.barnCode}" placeholder="Nhập mã chuồng" />
								</div>
							</div>
							<div class="col-3">
								<div class="form-group">
									<label><fmt:message key="barnPlan.status" /></label>
									<select name="status" class="form-control rounded-10 select2" id="status">
										<option value="">&nbsp;</option>
										<c:forEach var="item" items = "${barnPlanStatus}">
											<option value="${item}" ${criteria.status eq item ? 'selected' : ''}><fmt:message key="barnPlan.status.${item}" /></option>
										</c:forEach>
									</select>
								</div>
							</div>
						</div>
					</div>

					<div class="col-4">
						<label><fmt:message key="barnPlan.barnEmptyDate" /></label>
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

		</div>
		<!-- /Searching -->

		<!-- \Table -->
		<div class="card">
			<div class="table-responsive">
				<table class="table table-bordered table-striped">
					<thead>
						<tr class="table-success">
							<th class="bgc-primary border-primary text-white text-center" style="width: 10px">#</th>
							<th class="bgc-primary border-primary text-white text-center"><fmt:message key="barnPlan.farmName" /></th>
							<th class="bgc-primary border-primary text-white text-center"><fmt:message key="barnPlan.barnCode" /></th>
							<th class="bgc-primary border-primary text-white text-center"><fmt:message key="barnPlan.pigType" /></th>
							<th class="bgc-primary border-primary text-white text-center"><fmt:message key="barnPlan.barnVolumn" /></th>
							<th class="bgc-primary border-primary text-white text-center"><fmt:message key="barnPlan.realBarnVolumn" /></th>
							<th class="bgc-primary border-primary text-white text-center"><fmt:message key="barnPlan.barnEmptyDate" /></th>
							<th class="bgc-primary border-primary text-white text-center"><fmt:message key="barnPlan.realBarnEmptyDate" /></th>
							<th class="bgc-primary border-primary text-white text-center"><fmt:message key="barnPlan.status" /></th>
							<th class="bgc-primary border-primary text-white text-center" style="width: 120px;"><i class="icon-menu-open2"></i></th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${empty page.content}">
							<tr>
								<td colspan="9" class="text-center text-none-data"><fmt:message key="not.data" /></td>
							</tr>
						</c:if>
						<c:forEach var="barnPlan" items="${page.content}" varStatus="cnt">
							<tr>
								<td class="text-center"><c:out value="${cnt.count+page.size*page.number}" /></td>
								<td class="text-center">${barnPlan.barn.farm.name}</td>
								<td class="text-center">${barnPlan.barn.code}</td>
								<td class="text-center">${barnPlan.pigType}</td>
								<td class="text-center">${barnPlan.barnVolumn}</td>
								<td class="text-center">${barnPlan.realBarnVolumn}</td>
								<td class="text-center">${barnPlan.barnEmptyDateDisplay}</td>
								<td class="text-center">${barnPlan.realBarnEmptyDateDisplay}</td>
								<td class="text-center"><span class="badge bg-${barnPlan.status eq 'unconfirmed' ? 'danger' : 'success' }-400"><fmt:message	key="barnPlan.status.${barnPlan.status}" /></span></td>
								<td class="text-center">
									<div class="list-icons">
										<div class="dropdown"><a href="#" class="list-icons-item" data-toggle="dropdown"> <i class="icon-menu9"></i></a>
											<div class="dropdown-menu dropdown-menu-right">
												<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_BARN_PLAN_EDIT')">
													<a href="/barnPlan/form?id=${barnPlan.id}" class="dropdown-item"> <i class="icon-pencil7" style="color: blue"> <fmt:message key="button.detail" /></i></a>
												</security:authorize>
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