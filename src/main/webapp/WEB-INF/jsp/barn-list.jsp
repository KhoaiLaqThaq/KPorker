<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="barn.list.title"/></title>
    <meta name="menu" content="barnMenu"/>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
	<link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">
</head>

<div class="content">
<form:form id="barnForm" modelAttribute="criteria" action="/barn/list"  method="post">
	<!-- \Searching -->
<!-- 	<div class="card"> -->
<!-- 		<div class="card-body"> -->
<!-- 			<div class="row"> -->
<!-- 				<div class="col-md-8 offset-md-2"><input class="form-control" type="text" name="code" value="" placeholder="Enter keyword..."/></div> -->
<%-- 				<div class="col-md-2"><button type="submit" class="btn btn-secondary"> <i class="icon-search4"></i> <fmt:message key="button.search"/></button></div> --%>
<!-- 	    	</div> -->
<!--     	</div> -->
<!--     </div> -->
    <!-- /Searching -->
	    
	<!-- \Table -->
	<div class="card">
		<div class="card-header header-elements-inline">
			<span class="text-uppercase font-size-lg font-weight-bold"> ${page.content[0].farm.name}</span>
			<security:authorize access="hasAnyRole('ROLE_ADMIN')">
        	</security:authorize>
		</div>
		<div class="card-body"><fmt:message key="barn.list.title.description"/></div>
		<div class="table-responsive">
			<table class="table table-bordered table-striped">
				<thead>
					<tr class="table-success">
						<th class="text-center" style="width: 10px">#</th>
<%-- 						<th><fmt:message key="barn.id"/></th> --%>
						<th><fmt:message key="barn.code"/></th>
						<th><fmt:message key="barn.name"/></th>
						<th><fmt:message key="barn.farmCode"/></th>
						<th><fmt:message key="barn.pig.total"/></th>
						<th><fmt:message key="barn.pig.total.dead"/></th>
<!-- 						<th class="text-center" style="width:120px;"><i class="icon-menu-open2"></i></th> -->
					</tr>
				</thead>
				<tbody>
					<c:if test="${empty page.content}">
						<tr><td colspan="6" class="text-center text-none-data"><fmt:message key="not.data"/></td></tr>
					</c:if>
					<c:forEach var="barn" items="${page.content}" varStatus="cnt">
						<tr>
							<td class="text-center"><c:out value="${cnt.count+page.size*page.number}" /></td>
<%-- 							<td>${barn.id}</td> --%>
							<td>${barn.code}</td>
							<td>${barn.name}</td>
							<td>${barn.farm.code}</td>							
							<td>${barn.totalPigRetained}</td>
							<td>${barn.totalPigDead}</td>		
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


