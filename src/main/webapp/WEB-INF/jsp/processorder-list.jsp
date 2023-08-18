<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
<title><fmt:message key="processOrder.list.title" /></title>
<meta name="menu" content="processOrderMenu" />
  	<script src="http://code.jquery.com/ui/1.10.2/jquery-ui.js"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/main/bootstrap.bundle.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/loaders/blockui.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/ui/moment/moment.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/daterangepicker.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.date.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/legacy.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/jgrowl.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
    
    <script	src="<c:url value='/themes/admin/assets/js/processOrder_list.js'/>"></script>
</head>

<div class="row mb-3">
	<div class="col-12"><%@include file="/themes/admin/common/actions.jsp"%></div>
</div>

<div class="content">
	<div class="row mb-3">
		<div class="col-12 col-md-6">
			<div class="text-color-primary fs-3"><fmt:message key="processOrder.list.title" /></div>
		</div>
		<div class="col-12 col-md-6 text-right">
		     <a href="/report/processOrder" id="exportProcessOrder" class="btn btn-primary"><i class="icon-database-export pr-2"></i>Xuất Excel</a>
		</div>
	</div>
	<form:form id="processOrderForm" modelAttribute="criteria" action="${ctx}/processOrder/list" method="post">
	<input type="hidden" value="${criteria.startDateSearch}" id="postingDateSearch"/>
		<!-- \Searching -->
		<div class="card rounded-16">
			<div class="row"><div class="col-12 px-3 py-2 fw-bold"><fmt:message key="label.search" /></div></div>
			<div class="card-body py-0">
				<div class="row">
					<div class="col-6">
						<div class="row">
							<div class="col-md-6">
								<div class="form-group"><label> <fmt:message key="processOrder.code" />
								</label> <input class="form-control rounded-10" type="text" name="code" id ="poCodeInput" value="${criteria.code}" placeholder="Nhập mã lệnh" /></div>
							</div>
							<div class="col-md-6">
								<div class="form-group"><label> <fmt:message key="processOrder.barn.code.wbs" />
								</label> <input type="text" id="barnCodeInput" name="barnCode" value="${criteria.barnCode }" class="form-control rounded-10" placeholder="Nhập mã chuồng (WBS)" >
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-md-6">
								<div class="form-group">
									<label> <fmt:message key="processOrder.status" /></label>
									<select name="statuses[]" id ="status" class="form-control select2" multiple data-placeholder="Chọn trạng thái " data-fouc  >
										<option value="">&nbsp;</option>
										<c:forEach var="s" items="${processOrderStatus}" >
											<option value="${s.value}" ${fn:contains(criteria.getStatusesStr() , s.value) ? 'selected' : ''}><fmt:message key="processOrder.status.${s.value}"></fmt:message></option>
										</c:forEach>
									</select>
								</div>
							</div>
						</div>
					</div>
					<div class="col-6">
						<div class="row">
							<div class="col-8">
								<div class="form-group">
									<label> Ngày bắt đầu</label>
<%--									<input type="text" id="startDateSearchInput" name="startDateSearch" class="form-control rounded-10 daterange-weeknumbers" autocomplete="off">--%>
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
							<div class="col-4 text-right mt-3">
								<button type="button" class="btn btn-secondary mr-2" id="btnReset">Đặt lại</button>
								<button type="button" class="btn btn-secondary" id="btnSubmit"><fmt:message key="button.search" /></button>
							</div>
						</div>
						<div class="row">
							<div class="col-8">
								<div class="form-group">
									<label> Ngày đóng lệnh</label>
<%--									<input type="text" id="startDateSearchInput" name="startDateSearch" class="form-control rounded-10 daterange-weeknumbers" autocomplete="off">--%>
									<div class="row">
										<div class="col-md-6 col-sm-12 col-xs-12">
											<div class="form-group row">
												<span class="flex-center-vertical">Từ</span>
												<div class="col-lg-10">
													<input type="text" class="form-control rounded-10" placeholder="DD/MM/YYYY" id="fromCloseDate" name="searchCloseFromDate" value="${criteria.searchCloseFromDate}" autocomplete="off" />
												</div>
											</div>
										</div>
										<div class="col-md-6 col-sm-12 col-xs-12">
											<div class="form-group row">
												<span class="flex-center-vertical">đến</span>
												<div class="col-lg-10">
													<input type="text" class="form-control rounded-10" placeholder="DD/MM/YYYY" id="toCloseDate" name="searchCloseToDate" value="${criteria.searchCloseToDate}" autocomplete="off" />
												</div>
											</div>
										</div>
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
			<div class="table-responsive mh-400">
				<table class="table table-bordered table-striped">
					<thead>
						<tr class="table-success">
							<th class="bgc-primary border-primary text-white text-center" style="width: 10px">#</th>
							<th class="bgc-primary border-primary text-white text-center"><fmt:message key="processOrder.code" /></th>
							<th class="bgc-primary border-primary text-white text-center"><fmt:message key="processOrder.barnCode" /></th>
							<th class="bgc-primary border-primary text-white text-center"><fmt:message key="processOrder.quantity.sap" /></th>
							<th class="bgc-primary border-primary text-white text-center"><fmt:message key="processOrder.realQuantity" /></th>
							<th class="bgc-primary border-primary text-white text-center"><fmt:message key="processOrder.pigType" /></th>
							<th class="bgc-primary border-primary text-white text-center"><fmt:message key="processOrder.startDate.sap" /></th>
							<th class="bgc-primary border-primary text-white text-center"><fmt:message key="processOrder.endDate.sap" /></th>
							<th class="bgc-primary border-primary text-white text-center"><fmt:message key="processOrder.closeDate.app" /></th>
							<th class="bgc-primary border-primary text-white text-center"><fmt:message key="processOrder.batch" /></th>
							<th class="bgc-primary border-primary text-white text-center"><fmt:message key="processOrder.status" /></th>
							<th class="bgc-primary border-primary text-white text-center" style="width: 120px;"><i class="icon-menu-open2"></i></th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${empty page.content}">
							<tr><td colspan="14" class="text-center text-none-data"><fmt:message key="not.data"/></td></tr>
						</c:if>
						<c:forEach var="processOrder" items="${page.content}" varStatus="cnt">
							<tr>
								<td class="text-center"><c:out value="${cnt.count+page.size*page.number}" /></td>
								<td class="text-center">${processOrder.code}</td>
								<td class="text-center">${processOrder.barn.code}</td> 
								<td class="text-center">${Math.floor(processOrder.quantity)}</td>
								<td class="text-center">${Math.floor(processOrder.realQuantity)}</td>
								<td class="text-center">${processOrder.pigType }</td>
								<td class="text-center">${processOrder.startDateDisplay}</td>
								<td class="text-center">${processOrder.endDateDisplay}</td> 
								<td class="text-center">${processOrder.closedDateDisplay}</td> 
								<td class="text-center">${processOrder.batch}</td>							
								<td class="text-center"><span class="badge bg-${processOrder.status eq 'unconfirmed' ? 'danger' : 'success' }-400"><fmt:message key="processOrder.status.${processOrder.status}" /></span></td>
								<td class="text-center">
									<div class="list-icons">
										<div class="dropdown">
											<a href="#" class="list-icons-item" data-toggle="dropdown" data-boundary="viewport"><i class="icon-menu7"></i></a>
											<div class="dropdown-menu dropdown-menu-right">
												<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_PROCESS_ORDER_EDIT')">												
													<a href="<c:url value="/processOrder/form?id=${processOrder.id}"/>" class="dropdown-item"><i class="icon-pencil7"></i><fmt:message key="button.detail"/></a>
												</security:authorize>
												<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_PIG_ENTRY_VIEW')">
													<a href="/pigEntry/list?code=${processOrder.code}" class="dropdown-item"><i class="icon-square-right"></i><fmt:message key="menu.production.PigEntry"/></a>
												</security:authorize>
<%-- 												<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GOODS_ATTRITION_VIEW')">	 --%>
<%-- 													<a href="<c:url value='/goodsAttrition/list?poCode=${processOrder.code}'/>" class="dropdown-item"><i class="icon-cancel-square"></i><fmt:message key="menu.production.attrition"/></a> --%>
<%-- 												</security:authorize> --%>
												<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_WEIGHT_NOTE_VIEW')">
													<a href="/dailyAverageWeight/list?code=${processOrder.code}" class="dropdown-item"><i class="icon-menu2"></i><fmt:message key="menu.production.daily.average.weight"/></a>
												</security:authorize>
												<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_PROPOSAL_VIEW')">
													<a href="/proposal/list?poCode=${processOrder.code}" class="dropdown-item"><i class="icon-cancel-square"></i><fmt:message key="menu.production.proposal"/></a>
												</security:authorize>
												<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_PIG_CULLING_VIEW')">
													<a href="/pigCulling/list?poCode=${processOrder.code}" class="dropdown-item"><i class="icon-cancel-square2"></i><fmt:message key="menu.production.change.pigdied"/></a>
												</security:authorize>
												<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_FINISH_PRODUCT_VIEW')">
													<a href="/pigProduction/list?poCode=${processOrder.code }" class="dropdown-item"><i class="icon-cancel-square"></i><fmt:message key="menu.production.pigProduction"/></a>
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

<div class="modal hide" id="pleaseWaitDialog" data-backdrop="static" data-keyboard="false">
    <div class="modal-body">
        <div class="loading">Loading&#8230;</div>
    </div>
</div>
