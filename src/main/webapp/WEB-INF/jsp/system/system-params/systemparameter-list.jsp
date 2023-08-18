<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="sysparam.list.title"/></title>
    <meta name="menu" content="parameterMenu"/>
    <script src="<c:url value='/themes/admin/assets/css/custom_style.css'/>"></script>
</head>
<div class="content">
<form:form id="systemParameterForm" modelAttribute="criteria" action="${ctx}/systemParameter/list"  method="post">
	<!-- \Searching -->
		<div class="card rounded-16">
			<div class="row">
				<div class="col-12 px-3 py-2 fw-bold"><fmt:message key="label.search" /></div>
			</div>
			<div class="card-body py-0">
				<div class="row">
					<div class="col-md-8">
						<div class="form-group">
							<label class="text-label"><fmt:message key="sysparam.paramName" /></label>
							<input class="form-control rounded-10" type="text" name="paramName" id ="paramName" value="${criteria.paramName}" placeholder="Keyword" />
						</div>
					</div>
					<div class="col-4 text-right mt-3">
						<button type="submit" class="btn btn-secondary rounded-20" onclick="searchFunction()"><i class="mr-2 icon-search4"></i><fmt:message key="button.search" /></button>
					</div>
				</div>
			</div>
		</div>
		<!-- /Searching -->
	    
	<!-- \Table -->
	<div class="card">
		<div class="card-header header-elements-inline">
			<span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="sysparam.list.title"/></span>
			<security:authorize access="hasAnyRole('ROLE_ADMIN, SYS_PARAM_CREATE')">
				<div class="header-elements">
					<div class="list-icons">
						<a href="<c:url value='/systemParameter/form'/>" class="btn btn-sm bgc-warning text-white" title="<fmt:message key="button.add"/>"><i class="icon-plus22"></i> <fmt:message key="button.add" /></a>
					</div>
				</div>
			</security:authorize>
		</div>
		<div class="card-body"><fmt:message key="sysparam.list.description"/></div>
		<div class="table-responsive">
			<table class="table table-bordered table-striped">
				<thead>
					<tr class="table-success">
						<th class="text-center bgc-primary text-white border-primary" style="width: 10px">#</th>
						<th class="bgc-primary text-white border-primary"><fmt:message key="sysparam.paramName"/></th>
						<th class="bgc-primary text-white border-primary"><fmt:message key="sysparam.paramValue"/></th>
						<th class="bgc-primary text-white border-primary"><fmt:message key="sysparam.description"/></th>
						<th class="text-center bgc-primary text-white border-primary" style="width:120px;"><i class="icon-menu-open2"></i></th>
					</tr>
				</thead>
				<tbody>
					<c:choose>
					<c:when test="${empty page.content}">
						<tr><td colspan="6" class="text-center text-none-data"><fmt:message key="not.data"/></td></tr>					
					</c:when>
					<c:otherwise>
					<c:forEach items="${page.content}" var="sysparam" varStatus="cnt">
						<tr>
							<td><c:out value="${cnt.count+page.size*page.number}"></c:out></td>
							<td><c:out value="${sysparam.paramName}"/></td>
							<td><c:out value="${sysparam.paramValue}"/></td>
							<td><c:out value="${sysparam.description}"/></td>
							<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_SYS_PARAM_UPDATE')">
							<td class="text-center">
								<div class="list-icons">
									<a href="#" class="list-icons-item" data-toggle="dropdown"><i class="icon-menu9"></i></a>
									<div class="dropdown-menu dropdown-menu-right">
										<a href="<c:url value='/systemParameter/form?id=${sysparam.id}'/>" class="dropdown-item"><i class="icon-pencil7" style="color:blue"></i><fmt:message key="button.edit"/></a>
									</div>
			                	</div>
							</td>
							</security:authorize>
						</tr>
					</c:forEach>
					</c:otherwise>
					</c:choose>
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
<script>
	function searchFunction(){
		$('#page').val(0);
	}
</script>