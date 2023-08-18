<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
<title><fmt:message key="proposal.confirm.list" /></title>
<meta name="menu" content="proposalConfirmMenu" />
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
    
    <script	src="<c:url value='/themes/admin/assets/js/proposal-all-list.js'/>"></script>
</head>

<div class="row mb-3">
	<div class="col-12"><%@include file="/themes/admin/common/actions.jsp"%></div>
</div>

<div class="content">
	<div class="row mb-3">
		<div class="col-12 col-md-6">
			<div class="text-color-primary fs-5"><fmt:message key="proposal.confirm.list" /></div>
		</div>
	</div>
	<form:form id="proposalForm" modelAttribute="criteria" action="${ctx}/proposal/confirm/list" method="post">
		<form:hidden path="username"/>
		<!-- \Searching -->
		<div class="card rounded-16">
			<div class="row"><div class="col-12 px-3 py-2 fw-bold"><fmt:message key="label.search" /></div></div>
			<div class="card-body py-0">
				<div class="row">
					<div class="col-md-4">
						<label> <fmt:message key="farm.code" /></label>
						<select name="farm.code" id ="farmSelectBox" class="form-control select2" data-placeholder="Chọn trại " data-fouc  >
								<option value="">&nbsp;</option>
								<c:forEach var="f" items="${farmCodes}" >
									<option value="${f.code}" ${criteria.farm.code  eq f.code ? 'selected' : ''}>${f.code}-${f.name}</option>
								</c:forEach>
						</select>
					</div>
					<div class="col-md-4">
						<div class="form-group"><label> <fmt:message key="processOrder.code" />
						</label> <input class="form-control rounded-10" type="text" name="processOrderCode" id ="poCodeInput" value="${criteria.processOrderCode}" placeholder="Nhập mã lệnh sản xuất" /></div>
					</div>
					 <div class="col-4 mt-3 text-right">
						 <button type="button" class="btn btn-secondary text-white" id="btnReset">Đặt lại</button>
						 <button type="button" class="btn btn-secondary text-white" id="btnSubmit"><fmt:message key="button.search" /></button>
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
							<th class="bgc-primary border-primary text-white text-center" style="width: 120px">#</th>
							<th class="bgc-primary border-primary text-white text-center"><fmt:message key="barn.farmCode" /></th>
							<th class="bgc-primary border-primary text-white text-center" ><fmt:message key="production.processOrderCode"/></th>		
							<th class="bgc-primary border-primary text-white text-center" ><fmt:message key="goodsIssue.createdBy"/></th>
							<th class="bgc-primary border-primary text-white text-center"><fmt:message key="goodsIssue.createdDate"/></th>
							<th class="bgc-primary border-primary text-white text-center"><fmt:message key="processorder.status" /></th>
							<th class="bgc-primary border-primary text-white text-center" style="width:120px;"><i class="icon-menu-open2"></i></th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${empty page.content}">
							<tr><td colspan="14" class="text-center text-none-data"><fmt:message key="not.data"/></td></tr>
						</c:if>
						<c:forEach var="item" items="${page.content}" varStatus="cnt">
							<tr>
								<td class="text-center"><c:out value="${cnt.count+page.size*page.number}" /></td>
								<td class="text-center"><c:out value="${item.farm.name }" /></td>
								<td class="text-center">${item.processOrderCode}</td>
								<td class="text-center">${item.createdBy}</td>
								<td class=" text-center ">${item.displayRecordDate}</td>
								<td  class="text-center">
									<c:choose>
										 <c:when test = "${item.status eq 'approve'}">
							            	<span class="badge bg-success-400"><fmt:message key="purchase.requisition.status.${item.status}"></fmt:message></span>
							         	</c:when>
							         	<c:when test = "${item.status eq 'cancel'}">
							            	<span class="badge bg-warning-400"><fmt:message key="purchase.requisition.status.${item.status}"></fmt:message></span>
							         	</c:when>
							        	 <c:otherwise>
							            	<span class="badge bg-danger-400"><fmt:message key="purchase.requisition.status.${item.status}"></fmt:message></span>
							         	</c:otherwise>
						      		</c:choose>
								</td>														
								<td class=" text-center">
									<div class="list-icons">
										<div class="dropdown">
											<a href="#" class="list-icons-item" data-toggle="dropdown"><i class="icon-menu7 mr-3 icon-2x"></i></a>
											<div class="dropdown-menu dropdown-menu-right">
												<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_PROPOSAL_EDIT')">
												<a href="/proposal/form?poCode=${item.processOrderCode}&id=${item.id}" class="dropdown-item"><i class="icon-pencil7" style="color:blue"> <fmt:message key="button.detail"/></i></a>
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