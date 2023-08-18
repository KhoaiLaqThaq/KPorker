<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>
<head>
    <title><fmt:message key="plan.list.title"/></title>
    <meta name="menu" content="planMenu"/>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
	<link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">
</head>

<div class="content">
<form:form id="planForm" modelAttribute="criteria" action="${ctx}/plan/list"  method="post">
	<!-- \Searching -->
	<div class="card">
		<div class="card-body">
			<div class="row">
				<div class="col-md-8 offset-md-2"><input class="form-control" type="text" name="barnCode" value="" placeholder="Enter keyword..."/></div>
				<div class="col-md-2"><button type="submit" class="btn btn-secondary"> <i class="icon-search4"></i> <fmt:message key="button.search"/></button></div>
	    	</div>
    	</div>
    </div>
    <!-- /Searching -->
	    
	<!-- \Table -->
	<div class="card">
		<div class="card-header header-elements-inline">
			<span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="plan.list.title"/></span>
		</div>
		<div class="card-body"><fmt:message key="plan.list.title.description"/></div>
		<div class="table-responsive">
			<table class="table table-bordered table-striped">
				<thead>
					<tr class="table-success">
						<th class="text-center" style="width: 10px">#</th>
						<th><fmt:message key="plan.barnCode"/></th>
						<th><fmt:message key="plan.pigType"/></th>
						<th><fmt:message key="plan.location"/></th>
						<th><fmt:message key="plan.quantity"/></th>
						<th><fmt:message key="plan.expectedDate"/></th>
						<th><fmt:message key="plan.createdDate"/></th>
						<th><fmt:message key="plan.status"/></th>
						<th class="text-center" style="width:120px;"><i class="icon-menu-open2"></i></th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${empty page.content}">
						<tr><td colspan="9" class="text-center text-none-data"><fmt:message key="not.data"/></td></tr>
					</c:if>
					<c:forEach var="plan" items="${page.content}" varStatus="cnt">
						<tr>
							<td class="text-center"><c:out value="${cnt.count+page.size*page.number}" /></td>
							<td>${plan.barnCode}</td>
							<td>${plan.pigType}</td>
							<td>${plan.location}</td>
							<td>${plan.quantity}</td>
							<td>${plan.displayExpectedDate}</td>			
							<td>${plan.displayCreatedDate}</td>
							<td>
								<c:choose>
									<c:when test="${plan.status == 0}">
										<i class="icon-circle2 icon-green" style="color: green;"></i>
									</c:when>
									<c:otherwise>
										<i class="icon-circle2" style="color: red;"></i>
									</c:otherwise>
								</c:choose>
							</td>
							
							<td class="text-center">
								<div class="list-icons">									
									<a href="<c:url value="/plan/form?id=${plan.id}"/>" class="list-icons-item " data-popup="tooltip" title="Xác nhận kế hoạch nuôi"><i class="icon-pencil7"></i></a>																			
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

<script src="<c:url value='/themes/admin/assets/js/plan_list.js'/>"></script>

