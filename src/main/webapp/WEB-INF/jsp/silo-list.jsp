<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="silo.list.title"/></title>
    <meta name="menu" content="siloMenu"/>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
	<link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">
</head>

<div class="content">
<form:form id="siloForm" modelAttribute="criteria" action="/silo/list"  method="post">	
	<form:hidden path="farmCode" value="${criteria.farmCode}" />    
	<!-- \Table -->
	<div class="card">
		<div class="card-header header-elements-inline">
			<span class="text-uppercase font-size-lg font-weight-bold">${page.content[0].barn.farm.name} - <c:out value = "${page.content[0].barn.farm.code}"/></span>
			<security:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_SILO_CREATE')">
			<div class="header-elements">
				<div class="list-icons">
					<%-- <a href="<c:url value='/silo/form?farmCode=${criteria.farmCode}'/>" class="btn btn-sm btn-primary" title="<fmt:message key="button.add"/>"><i class="icon-plus22"></i><fmt:message key="button.add"/></a> --%>
               	</div>
        	</div>
        	</security:authorize>
		</div>
		<div class="card-body"><fmt:message key="silo.list.title.description"/></div>
		<div class="table-responsive">
			<table class="table table-bordered table-striped">
				<thead>
					<tr class="table-success">
						<th class="text-center" style="width: 10px">#</th>			
						<th><fmt:message key="silo.barn.code" /></th>
						<th><fmt:message key="silo.material.amount" /></th>
						<th><fmt:message key="silo.createdBy" /></th>
						<th><fmt:message key="silo.createdDate" /></th>
						<th><fmt:message key="silo.modifiedDate" /></th>
						
						<th class="text-center" style="width:120px;"><i class="icon-menu-open2"></i></th> 
					</tr>
				</thead>
				<tbody>
					<c:if test="${empty page.content}">
						<tr><td colspan="6" class="text-center text-none-data"><fmt:message key="not.data"/></td></tr>
					</c:if>
					<c:forEach var="silo" items="${page.content}" varStatus="cnt">
						<tr>
							<td class="text-center"><c:out value="${cnt.count+page.size*page.number}" /></td> 
							<td>${silo.barn.code}</td>	
							<td>${silo.amount}</td>	
							<td>${silo.createdBy}</td>	
							<td>${silo.createdDateDisplay}</td>		
							<td>${silo.modifiedDateDisplay}</td>
							<td class="text-center">
								   <div class="list-icons">
                                       <div class="dropdown">
                                           <a href="#" class="list-icons-item dropdown-toggle" data-toggle="dropdown"><i class="icon-menu7 fontSize20"></i></a>

                                           <div class="dropdown-menu">
                                               <div class="dropdown-header">Options</div>                           
                                           	 	<a href="<c:url value="/silo/form?farmCode=${criteria.farmCode}&id=${silo.id}"/>" class="dropdown-item"><i class="icon-pencil7"></i><fmt:message key="button.detail"/></a>
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
         	<jsp:param value="${page.number}" name="pageNumber"/>
         	<jsp:param value="${page.totalPages}" name="maxPages"/>
         	<jsp:param value="${page.size}" name="size"/>
         	<jsp:param value="${page.totalElements}" name="totalElements"/>
      	</jsp:include>
	</div>
	<!-- /Table -->
</form:form>
</div>

