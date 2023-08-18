<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
<title><fmt:message key="farm.list.title" /></title>
<meta name="menu" content="farmMenu" />
<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
<link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">
</head>

<div class="row mb-3">
	<div class="col-12"><%@include file="/themes/admin/common/actions.jsp"%></div>
</div>

<div class="content">
	<div class="row mb-3">
		<div class="col-12 col-md-6">
			<div class="text-color-primary fs-5"><fmt:message key="farm.list.title" /></div>
		</div>
		<div class="col-12 col-md-6 text-right">
			<a id="exportFarm" href="<c:url value='/farm/export'/>" class="btn btn-sm bgc-warning text-white" title="<fmt:message key="button.add"/>"><i class="icon-file-upload"></i> <fmt:message key="button.export" /></a>
		</div>
	</div>
	<form:form id="farmForm" modelAttribute="criteria" action="/farm/list" method="post">
		<input type="hidden" name="porkerFarm" value="${criteria.porkerFarm }"/>		
		<!-- \Searching -->
		<div class="card rounded-16">
			<div class="row"><div class="col-12 px-3 py-2 fw-bold"><fmt:message key="label.search" /></div></div>
			<div class="card-body py-0">
				<div class="row">
					<div class="col-md-4">
	                   <div class="form-group">
	                       <label><fmt:message key="farm.enterCode" /></label>
	                       <input class="form-control rounded-10" type="text" name="code" value="${searchCode}" placeholder="<fmt:message key="farm.enterCode" />" />
	                   </div>
	                </div>
	                <div class="col-md-4">
	                   <div class="form-group">
	                       <label><fmt:message key="farm.enterName" /></label>
	                       <input class="form-control rounded-10" name="name" value="${searchName}" placeholder="<fmt:message key="farm.enterName" />"/>
	                   </div>
	                </div>
					<div class="col-4 text-right mt-3">
						<button type="submit" class="btn btn-secondary rounded-20" onclick="searchFunction()"><i class="icon-search4 mr-2"></i><fmt:message key="button.search" /></button>
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
							<th class="text-center bgc-primary border-primary text-white" style="width: 10px">#</th>
							<th class="text-center bgc-primary border-primary text-white"><fmt:message key="farm.code" /></th>
							<th class="text-center bgc-primary border-primary text-white"><fmt:message key="farm.name" /></th>
							<th class="text-center bgc-primary border-primary text-white"><fmt:message key="farm.address" /></th>
							<th class="text-center bgc-primary border-primary text-white"><fmt:message key="farm.totalPig" /></th>
							<th class="text-center bgc-primary border-primary text-white"><fmt:message key="farm.pig.dead" /></th> 

							<th class="text-center bgc-primary border-primary text-white" style="width: 120px;"><i class="icon-menu-open2"></i></th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${empty page.content}">
							<tr>
								<td colspan="9" class="text-center text-none-data"><fmt:message key="not.data" /></td>
							</tr>
						</c:if>
						<c:forEach var="farm" items="${page.content}" varStatus="cnt">
							<tr>
								<td class="text-center"><c:out value="${cnt.count+page.size*page.number}" /></td>
								<td class="text-center">${farm.code}</td>
								<td class="text-center"> ${farm.name}</td>	
								<td> ${farm.address}</td>	
								<%-- <td class="text-center"><span class="badge bg-${farm.type eq 'gia_cong' ? 'blue' : 'success' }-400"><fmt:message key="farm.type.${farm.type}" /></span></td> --%>
								<td class="text-center">${farm.totalPigRetained}</td>
								<td class="text-center">${farm.totalPigDead}</td>
							
								<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_CONSUMING_FARM')">
								<td class="text-center">
								   <div class="list-icons">
                                       <div class="dropdown">
                                           <a href="#" class="list-icons-item dropdown-toggle" data-toggle="dropdown"><i class="icon-menu7 fontSize20"></i></a>

                                           <div class="dropdown-menu">
                                               <div class="dropdown-header">Options</div>
                                               <a href="<c:url value="/barn/list?farmCode=${farm.code}"/>" class="dropdown-item"><i class="icon-pencil7"></i><fmt:message key="button.view.barn.list"/></a>
                                           	 	<a href="<c:url value="/silo/list?farmCode=${farm.code}"/>" class="dropdown-item"><i class="icon-pencil7"></i><fmt:message key="button.view.silo.list"/></a>
                                           </div>
                                       </div>
                                   </div>
								</td>
								</security:authorize>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			<!-- 		Pagination -->
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

<script src="<c:url value='/themes/admin/assets/js/farm_list.js'/>"></script>
<script>
	function searchFunction(){
		$('#page').val(0);
	}
</script>

