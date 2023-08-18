<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="othercost.list.title"/></title>
    <meta name="menu" content="othercostMenu"/>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
	<link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">
</head>

<div class="content">
<form:form id="othercostForm" modelAttribute="criteria" action="<c:url value='/othercost/list'/>"  method="post">
	<!-- \Searching -->
	<div class="card">
	   <div class="card-header bg-navbar text-white header-elements-inline">
          <h6 class="card-title text-navbar"><fmt:message key="label.search" /></h6>
        </div>
		<div class="card-body">
	    	<div class="row">	
	    		<div class="col-md-4">
                    <div class="form-group">
                        <label> <fmt:message key="otherCost.farmName"/></label>
                        <input class="form-control" type="text" id="farmName" name="farmName" value="${criteria.farmName}" placeholder="Nhập tên trại" />
                    </div>
                </div>
                <div class="col-md-4">
                    <label> <fmt:message key="otherCost.status"/></label>
                    <select class="form-control select2" name="status" id="status" data-placeholder="Chọn trạng thái" data-fouc>
						<option value="">&nbsp;</option>
						<c:forEach items="${otherCostTypes}" var="item">
							<option value="${item}" ${criteria.status eq item ? 'selected' : ''}><fmt:message key="purchase.requisition.status.${item}"></fmt:message></option>
						</c:forEach>
					</select>
                </div>
	    	</div>
	    	<div class="row text-right">
                <div class="col-md-12">
                    <button type="button" class="btn btn-secondary" id="btnReset"><i class="mr-2 icon-reset"></i><fmt:message key="button.reset" /></button>
                    <button type="submit" class="btn btn-secondary" onclick="searchFunction()"><i class="mr-2 icon-search4"></i><fmt:message key="button.search" /></button>
                </div>
            </div>
    	</div>
    </div>
    <!-- /Searching -->
	    
	<!-- \Table -->
	<div class="card">
		<div class="card-header header-elements-inline">
			<span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="othercost.list.title"/></span>
			<security:authorize access="hasAnyRole('ROLE_ADMIN')">
			<div class="header-elements">
				<div class="list-icons">
					<a href="<c:url value='/othercost/form'/>" class="btn btn-sm btn-primary" title="<fmt:message key="button.add"/>"><i class="icon-plus22"></i><fmt:message key="button.add"/></a>
               	</div>
        	</div>
        	</security:authorize>
		</div>
		<div class="card-body"><fmt:message key="othercost.list.title.description"/></div>
		<div class="table-responsive">
			<table class="table table-bordered table-striped">
				<thead>
					<tr class="table-success">
						<th class="text-center" style="width: 10px">#</th>
						<th><fmt:message key="othercost.type"/></th>
						<th><fmt:message key="othercost.cost"/></th>
						<th><fmt:message key="othercost.unit"/></th>
						<th><fmt:message key="othercost.month"/></th>
						<th><fmt:message key="othercost.year"/></th>
						<th><fmt:message key="othercost.recordDate"/></th>
						<th class="text-center" style="width:120px;"><i class="icon-menu-open2"></i></th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${empty page.content}">
						<tr><td colspan="6" class="text-center text-none-data"><fmt:message key="not.data"/></td></tr>
					</c:if>
					<c:forEach var="othercost" items="${page.content}" varStatus="cnt">
						<tr>
							<td class="text-center"><c:out value="${cnt.count+page.size*page.number}" /></td>
							<td>${othercost.type}</td>
							<td>${othercost.cost}</td>
							<td>${othercost.unit}</td>
							<td>${othercost.month}</td>
							<td>${othercost.year}</td>
							<td>${othercost.recordDate}</td>
							<td class="text-center">
								<div class="list-icons">
									<div class="dropdown">
										<a href="#" class="list-icons-item" data-toggle="dropdown"><i class="icon-menu9"></i></a>
										<div class="dropdown-menu dropdown-menu-right">
											<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_OTHERCOST_EDIT')">
											<a href="othercost/form?id=${othercost.id}" class="dropdown-item"><i class="icon-pencil7" style="color:blue"> <fmt:message key="button.edit"/></i><></a>
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
