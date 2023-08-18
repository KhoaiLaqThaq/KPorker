<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="cust.list.title"/></title>
    <meta name="menu" content="custMenu"/>

	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
	<link href="${ctx }/themes/admin/assets/css/custom_style.css" rel="stylesheet" type="text/css">
	
</head>

<div class="content">
<form:form id="orgListForm" modelAttribute="criteria" action="${ctx}/customer/list"  method="post">
	<%-- <security:authorize access="hasRole('ROLE_ACC_VIEW')"> --%>
		<div class="card">
			<div class="card-body">
				<div class="row">
					<div class="col-md-8 offset-md-2"><input class="form-control" type="text" name="name" value="${searchName }" placeholder="Nhập mã hoặc tên khách hàng ..."/></div>
					<div class="col-md-2"><button type="submit" class="btn btn-secondary"> <i class="icon-search4"></i> <fmt:message key="button.search"/></button></div>
		    	</div>	
	    	</div>
	    </div>
	<%-- </security:authorize> --%>
	<!-- Start form org -->
	<div class="card">
		<div class="card-header header-elements-inline">
			<span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="cust.list.title"/></span>
			<security:authorize access="hasAnyRole('ROLE_SUPER_ADMIN')">
			<div class="header-elements">
				<div class="list-icons">
					<a href="<c:url value='/tenant/form'/>" class="btn btn-sm btn-primary" title="<fmt:message key="button.add"/>"><i class="icon-plus22"></i><fmt:message key="button.add"/></a>
               	</div>
        	</div>
        	</security:authorize>
		</div>
		<div class="card-body"><fmt:message key="cust.list.title.description"/></div>
		<div class="table-responsive">
			<table class="table table-bordered table-striped">
				<thead>
					<tr class="table-success">
						<th class="text-center" style="width: 10px">#</th>
						<th><fmt:message key="cust.code"/></th>
						<th><fmt:message key="cust.name"/></th>
						<%-- <th><fmt:message key="cust.status"/></th> --%>
						<security:authorize access="hasAnyRole('ROLE_SUPER_ADMIN')"> 
						<th class="text-center" style="width:120px;"><i class="icon-menu-open2"></i></th>
						</security:authorize>
					</tr>
				</thead>
				<tbody>
					<c:if test="${empty page.content}">
						<tr><td colspan="6" class="text-center text-none-data"><fmt:message key="not.data"/></td></tr>
					</c:if>
					<c:forEach var="customer" items="${page.content}" varStatus="cnt">
						<tr>
							<td class="text-center"><c:out value="${cnt.count+page.size*page.number}" /></td>
							<td>${customer.code}</td>
							
							<td><a href data-customer_id="${customer.id }" data-toggle="modal" data-target="#exampleModalCenter">${customer.name}</a></td>
							
							<%-- 
							<td class="text-center">
								<c:if test="${ customer.status  == '0'}"><span class="badge bg-blue"><fmt:message key="status.active"/></span> </c:if>
								<c:if test="${ customer.status  == '1'}"> <span class="badge bg-danger"><fmt:message key="status.inactive"/></span> </c:if>
							</td>
							--%>
							
							
							<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_ORG_ADMIN,ROLE_CUST_EDIT,ROLE_STATION_VIEW')">
							<td class="text-center">
								
								<div class="list-icon"> 
									<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_ORG_ADMIN,ROLE_STATION_VIEW')">
									<a href="<c:url value="/station/list?custId=${customer.id}"/>"class="list-icons-item " data-popup="tooltip" title="Danh sách trạm"><i class="icon-list-numbered"></i></a>&nbsp
									</security:authorize>
									<%-- <span type="button" data-cust_detail="${customer.detail }" class="list-icons-item "  data-toggle="modal" data-target="#exampleModalCenter" data-popup="tooltip" title="Chi tiết khách hàng" >
									  <i class="icon-book"></i></span>&nbsp --%>
									<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_ORG_ADMIN,ROLE_CUST_EDIT')"> 
									<a href="<c:url value="/customer/form?id=${customer.id}"/>" class="list-icons-item " data-popup="tooltip" title="Sửa"><i class="icon-pencil7"></i></a>						
									</security:authorize>
								</div> 
							</td>
							</security:authorize>
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
</form:form>
</div>
 

<!-- Modal -->
<div class="modal fade" id="exampleModalCenter" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title " id="exampleModalLongTitle"><fmt:message key="cust.detail"/></h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
       <!--  <div class="row" id="addRow"></div> -->
       <div class="table-responsive">
			<table class="table table-bordered table-striped">
				<tbody id="dynamic-table" >
					
				</tbody> 
			</table>
		</div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>
<!-- End modal -->

<script src="<c:url value='/themes/admin/assets/js/cust_list.js'/>"></script>


