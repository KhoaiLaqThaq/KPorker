<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="closePeriod.list.title"/></title>
    <meta name="menu" content="closePeriodMenu"/>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
	<link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">
	
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/assets/js/close-period-list.js'/>"></script>
</head>

<div class="row mb-3">
	<div class="col-12"><%@include file="/themes/admin/common/instock-actions.jsp"%></div>
</div>

<div class="content">
	<div class="row mb-3">
		<div class="col-12 col-md-6">
			<div class="text-color-primary fs-3"><fmt:message key="closePeriod.list.title" /></div>
		</div>
		<div class="col-12 col-md-6 text-right">
			<security:authorize access="hasAnyRole('ROLE_ADMIN','ROLE_PERIOD_CLOSE')">
				<a href="<c:url value='/periodClose/form'/>" class="btn bgc-warning rounded-10 text-white" title="<fmt:message key="button.add"/>">
					<i class="icon-plus22"></i><fmt:message key="button.add"/>
				</a>
				<button type="button" id="closePeriod" class="btn bgc-warning rounded-10 text-white"><fmt:message key="closePeriod" /></button>
			</security:authorize>
		</div>
	</div>
<!-- \Table -->
<div class="card">
	<div class="table-responsive">
		<table class="table table-bordered table-striped table-hover">
			<thead>
				<tr class="table-success">
					<th class="bgc-primary border-primary text-white text-center" style="width: 10px">#</th>
					<th class="bgc-primary border-primary text-white text-center"><fmt:message key="barn.farmCode"/></th>
					<th class="bgc-primary border-primary text-white text-center"><fmt:message key="closePeriod.fromDate"/></th>
					<th class="bgc-primary border-primary text-white text-center"><fmt:message key="closePeriod.toDate"/></th>
					<th class="bgc-primary border-primary text-white text-center" style="width:120px;"><i class="icon-menu-open2"></i></th>
				</tr>
			</thead>
			<tbody>
				<c:if test="${empty list}">
					<tr><td colspan="5" class="text-center text-none-data"><fmt:message key="not.data"/></td></tr>
				</c:if>
				<c:forEach var="item" items="${list}" varStatus="cnt">
					<tr>
						<td class="text-center"><c:out value="${cnt.count}" /></td>
						<td class="text-center">${item.farmCode}</td>
						<td class="text-center">${item.displayFromDate}</td>
						<td class="text-center">${item.displayToDate}</td>
						<td class="text-center">
							<button type="button" id="delete_${item.id }" class="btn btn-sm btn-primary deleteException"><i class="icon-bin"></i></button>
						</td>
					</tr> 
				</c:forEach>
			</tbody> 
		</table>
	</div>
</div>
<!-- /Table -->
</div>