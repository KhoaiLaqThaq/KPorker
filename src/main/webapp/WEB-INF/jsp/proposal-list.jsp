<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="proposal.list.title"/></title>
    <meta name="menu" content="processOrderMenu"/>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
	<link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">
	 	<script src="http://code.jquery.com/ui/1.10.2/jquery-ui.js"></script>
	
	<script src="<c:url value='/themes/admin/global_assets/js/main/bootstrap.bundle.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/loaders/blockui.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/ui/moment/moment.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/daterangepicker.js'/>"></script>
    
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.date.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/legacy.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/jgrowl.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/demo_pages/picker_date.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
	
</head>

<div class="content">
	<div class="row mb-3">
		<div class="col-12 col-md-6">
			<div class="text-color-primary fs-3">
				<fmt:message key="proposal.list.title"/> - <c:out value = "${processOrder.barn.farm.name}"/> - <c:out value = "${processOrder.barn.code}"/>
			</div>
		</div>
	</div>

<form:form id="proposalForm" modelAttribute="criteria" action="${ctx}/proposal/list?poCode=${criteria.processOrderCode}"  method="post">
	<form:hidden path="processOrderCode"/>
	<!-- \Searching -->
	<div class="card rounded-16">
		 <div class="row">
		 	<div class="col-12 px-3 py-2 fw-bold"><fmt:message key="label.search" /></div>
		 </div>
		<div class="card-body py-0">
			<div class="row">
				<div class="col-md-10">
					<div class="form-group"><label> <fmt:message key="event.transCode" />
					</label> <input class="form-control rounded-10" id="transCode" type="text" name="transCode" value="${criteria.transCode}"  /></div>
				</div>
				<div class="col-md-2 ">		
					<div class="form-group"> <label>&nbsp; 	</label>	
					<button type="submit" onclick="searchFunction()" class="btn btn-secondary form-control "> <i class="icon-search4"></i> <fmt:message key="button.search" /></button>	
					</div>				
				</div>
	    	</div>
    	</div>
    </div>
    <!-- /Searching -->
	    
	<!-- \Table -->
	<div class="card rounded-16">
		<div class="card-body pb-0">
			<fmt:message key="proposal.list.title.description"/>
			<div class="row">
				<div class="col-12 col-md-3">
					<div class="form-group">
						<label ><fmt:message key="goodsissue.processOrder"/>: <b class="ml-3"><c:out value="${processOrder.code }" /></b></label>
					</div>
				</div>
				<div class="col-12 col-md-9 text-right">
					<security:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_PROPOSAL_CREATE')">
						<c:if test="${ processOrder.status != 'closed' and totalPigRetained > 0 }">
							<a href="<c:url value='/proposal/form?poCode=${processOrder.code}'/>" class="btn btn-sm bgc-warning text-white" title="<fmt:message key="button.add"/>"><i class="icon-plus22"></i><fmt:message key="button.add"/></a>
		            	</c:if>
		        	</security:authorize>
				</div>
			</div>
		</div>
		<div class="table-responsive">
			<table class="table table-bordered table-striped">
				<thead>
					<tr class="table-success">
						<th class="text-center bgc-primary border-primary text-white" style="width: 120px">#</th>
						<th class="text-center bgc-primary border-primary text-white"><fmt:message key="processOrder.batch" /></th>
						<th class="text-center bgc-primary border-primary text-white" ><fmt:message key="event.transCode"/></th>		
						<th class="text-center bgc-primary border-primary text-white" ><fmt:message key="goodsIssue.createdBy"/></th>
						<th class="text-center bgc-primary border-primary text-white"><fmt:message key="goodsIssue.createdDate"/></th>
						<th class="text-center bgc-primary border-primary text-white"><fmt:message key="processorder.status" /></th>
						<th class="text-center bgc-primary border-primary text-white" style="width:120px;"><i class="icon-menu-open2"></i></th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${empty page.content}">
						<tr><td colspan="6" class="text-center text-none-data"><fmt:message key="not.data"/></td></tr>
					</c:if>
					<c:forEach var="item" items="${page.content}" varStatus="cnt">
						<tr>
							<td class="text-center"><c:out value="${cnt.count+page.size*page.number}" /></td>
							<td class="text-center"><c:out value="${processOrder.batch }" /></td>
							<td class="text-center">${item.transCode}</td>
							<td class="text-center">${item.createdBy}</td>
							<td class=" text-center ">${item.displayRecordDate}</td>
							<td  class="text-center">
								<c:choose>
									 <c:when test = "${item.status eq 'confirmed' || item.status eq 'approve'}">
						            	<span class="badge bg-success-400"><fmt:message key="purchase.requisition.status.${item.status}"></fmt:message></span>
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
											<a href="/proposal/form?poCode=${processOrder.code}&id=${item.id}" class="dropdown-item"><i class="icon-pencil7" style="color:blue"> <fmt:message key="button.detail"/></i></a>
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
	<a href="<c:url value="/processOrder/list"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i><fmt:message key="button.back" /></a>
	<!-- /Table -->
</form:form>
</div>


<script>
	function searchFunction(){
		$('#page').val(0);
	}
</script>
