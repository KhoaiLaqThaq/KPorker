<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="consumingWater.list.title"/></title>
    <meta name="menu" content="consumingWaterMenu"/>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
	<link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">
	
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/switch.min.js'/>"></script> 
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>
</head>

<div class="content">
	<div class="row mb-3">
		<div class="col-12 col-md-6">
			<div class="text-color-primary fs-5"><fmt:message key="consumingWater.list.title" /></div>
		</div>
		<div class="col-12 col-md-6 text-right">
			<security:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_CONSUMING_FARM')">
				<a href="<c:url value='/consumingWater/form'/>" class="btn bgc-warning text-white" title="<fmt:message key="button.add"/>"><i class="icon-plus22"></i><fmt:message key="button.add"/></a>
			</security:authorize>
		</div>
	</div>
<form:form id="consumingWaterForm" modelAttribute="criteria" action="/consumingWater/list"  method="post">
	<!-- \Searching -->
	<div class="card rounded-16">
		<div class="row"><div class="col-12 px-3 py-2 fw-bold"><fmt:message key="label.search" /></div></div>
		<div class="card-body py-0">
			<div class="row">	
	    		<div class="col-md-4">
                    <div class="form-group">
                        <label> <fmt:message key="farm.name"/></label>
                        <input class="form-control rounded-10" type="text" id="farmName" name="farmName" value="${criteria.farmName}" placeholder="Nhập tên trại" />
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label><fmt:message key="otherCost.type" /></label>
					    <select id="otherCostType" name="type" class="select2 form-control rounded-10" data-placeholder="Chọn loại tiêu thụ">
		                    <option value=""></option>
		                    <c:forEach items="${otherCostTypes}" var="item">
		                       <option value="${item}" ${item eq criteria.type ? 'selected':'' }><fmt:message key="otherCost.type.${item}"></fmt:message></option>
		                    </c:forEach>
		                </select>
                    </div>
                </div>
				<div class="col-4 text-right mt-3">
					<button type="button" class="btn btn-secondary" id="btnReset">Đặt lại</button>
					<button type="submit" class="btn btn-secondary" onclick="searchFunction()"><i class="mr-2 icon-search4"></i><fmt:message key="button.search" /></button>
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
						<th class="bgc-primary border-primary text-white text-center" style="width: 10px">#</th>
						<th class="bgc-primary border-primary text-white "><fmt:message key="farm.code" /></th>
						<th class="bgc-primary border-primary text-white "><fmt:message key="farm.name" /></th>
						<th class="bgc-primary border-primary text-white text-center"><fmt:message key="otherCost.type" /></th>
						<th class="bgc-primary border-primary text-white "><fmt:message key="otherCost.recordDate" /></th>
						<th class="bgc-primary border-primary text-white "><fmt:message key="otherCost.cost" /></th>
						<th class="bgc-primary border-primary text-white text-center" style="width:120px;"><i class="icon-menu-open2"></i></th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${empty page.content}">
						<tr><td colspan="7" class="text-center text-none-data"><fmt:message key="not.data"/></td></tr>
					</c:if>
					<c:forEach var="item" items="${page.content}" varStatus="cnt">
						<tr>
							<td class="text-center"><c:out value="${cnt.count+page.size*page.number}" /></td>
							<td>${item.farm.code}</td>
							<td>${item.farm.name}</td>
							<td class="text-center ${ item.type eq 'ELECTRICITY' ? 'text-warning':'text-primary' }">
							     ${item.type eq 'ELECTRICITY' 
							         ? '<i class="icon-battery-charging mr-3 icon-2x"></i>'
							         : '<i class="icon-droplets mr-3 icon-2x"></i>'}
							</td>
							<td class="format-date">${item.recordDate}</td>
							<td class="cost-other currency">${item.cost }</td>
							
							<td class="text-center">
								<div class="list-icons">
									<div class="dropdown">
										<a href="#" class="list-icons-item" data-toggle="dropdown"><i class="icon-menu9"></i></a>
										<div class="dropdown-menu dropdown-menu-right">
											<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_CONSUMING_FARM')">
											<a href="<c:url value='/consumingWater/form?id=${ item.id }' />" class="dropdown-item"><i class="icon-pencil7" style="color:blue"> <fmt:message key="button.edit"/></i></a>
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
<script src="<c:url value='/themes/admin/assets/js/select2.js'/>"></script>
<script src="<c:url value='/themes/admin/assets/js/consumingwater_list.js'/>"></script>
<script src="<c:url value='/themes/admin/global_assets/js/autoNumeric/autoNumeric.js'/>"></script>
<script src="<c:url value='/themes/admin/assets/js/format_date.js'/>"></script>
<script src="<c:url value='/themes/admin/assets/js/format_number.js'/>"></script>
<script>
$(document).ready(function() {
    formatDateComponent.initAutoDate();
});

function searchFunction(){
	$('#page').val(0);
}
</script>

