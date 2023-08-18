<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="dailyAverageWeight.list.title"/></title>
    <meta name="menu" content="processOrderMenu"/>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
	<link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/switch.min.js'/>"></script>	
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/ui/moment/moment.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/daterangepicker.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/anytime.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.date.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/legacy.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/jgrowl.min.js'/>"></script>
</head>

<div class="content">
<form:form id="dailyAverageWeightForm" modelAttribute="criteria" action="${ctx}/dailyAverageWeight/list"  method="post">
	<input type="hidden" value="${prOrder}" name="prOrder"/>
	<input type="hidden" id="processOrderStatus"  value="${processOrder.status }" />
	<!-- \Searching -->
	<div class="card">
		<div class="card-body">
			<div class="row">
				<div class="col-md-4 offset-md-1">
					<input class="form-control" type="text" id="fromDate" name="fromDate" value="${criteria.displaySearchFromDate}" placeholder="From..." autocomplete="off"/>
				</div>
				<div class="col-md-4">
					<input class="form-control" type="text" id="toDate" name="toDate" value="${criteria.displaySearchToDate}" placeholder="To..." autocomplete="off"/>
				</div>
				<div class="col-md-1">
					<button type="submit" id="submitButton" class="btn btn-secondary">
						<i class="icon-search4"></i> <fmt:message key="button.search"/>
					</button>
				</div>
				<div class="col-md-1" style="padding-left: 2%;">
					<button type="button" id="resetButton" class="btn btn-secondary"> <fmt:message key="button.reset"/></button>
				</div>
	    	</div>
    	</div>
    </div>
    <!-- /Searching -->
	    
	<!-- \Table -->
	<div class="card">
		<div class="card-header header-elements-inline">
			<span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="dailyAverageWeight.list.title"/> - <c:out value = "${processOrder.barn.farm.name}"/> - <c:out value = "${processOrder.barn.code}"/></span>
			<security:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_WEIGHT_NOTE_CREATE')">
			<div class="header-elements">
				<div class="list-icons">
					<c:if test="${ processOrder.status != 'closed' and totalPigRetained > 0  }">
						<a id="addDailyAverageWeightButton" href="<c:url value='${ctx}/dailyAverageWeight/form'><c:param name="code" value="${prOrder}" /></c:url>" class="btn btn-sm btn-primary" title="<fmt:message key="button.add"/>"><i class="icon-plus22"></i><fmt:message key="button.add"/></a>
					</c:if>
               	</div>
        	</div>
        	</security:authorize>
		</div>
		<div class="card-body"><fmt:message key="dailyAverageWeight.list.title.description"/></div>
		<div class="table-responsive table-scroll">
			<table class="table table-bordered table-striped">
				<thead>
					<tr class="table-success">
						<th class="text-center" style="width: 10px">#</th>
						<th class="text-center"><fmt:message key="dailyAverageWeight.poOrder"></fmt:message></th>
						<th class="text-center"><fmt:message key="event.transCode"></fmt:message></th>
						<th class="text-center"><fmt:message key="pigdead.recordDatetime"></fmt:message></th>
						<th class="text-center"><fmt:message key="dailyAverageWeight.status"></fmt:message></th>
						<th class="text-center" style="width:120px;"><i class="icon-menu-open2"></i></th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${empty page.content}">
						<tr><td colspan="6" class="text-center text-none-data"><fmt:message key="not.data"/></td></tr>
					</c:if>
					<c:forEach var="item" items="${page.content}" varStatus="cnt">
						<tr>
							<td class="text-center"><c:out value="${cnt.count+page.size*page.number}" /></td>
							<td class="text-center">${item.production.processOrderCode}</td>
							<td class="text-center">${item.transCode}</td>
							<td class="text-center">${item.displayPostingDate}</td>
							<td class="text-center">
								<span class="badge bg-${item.status eq 'approve' ? 'success' : 'danger' }-400"><fmt:message key="purchase.requisition.status.${item.status}"></fmt:message></span>
							</td>
							
							<td class="text-center">
								<div class="list-icons">
									<div class="dropdown">
										<a href="#" class="list-icons-item" data-toggle="dropdown"><i class="icon-menu9"></i></a>
										<div class="dropdown-menu dropdown-menu-right">
											<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_WEIGHT_NOTE_EDIT')">
											<a href="<c:url value='${ctx}/dailyAverageWeight/form'>
														<c:param name="code" value="${item.production.processOrderCode}" />
														<c:param name="id" value="${item.id}" />
													</c:url>" 
											class="dropdown-item"><i class="icon-pencil7" style="color:blue"> <fmt:message key="button.detail"/></i></a>
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

<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel"><fmt:message key="button.detail"/></h5>
      </div>
      <div class="modal-body">
	      <table class="table">
	      	  <thead>
			    <tr>
			      <th scope="col" class="text-center">#</th>
			      <th scope="col" class="text-center"><fmt:message key="dailyAverageWeight.avgWeight"></fmt:message></th>
			      <th scope="col" class="text-center"><fmt:message key="dailyAverageWeight.quantity"></fmt:message></th>
			    </tr>
			  </thead>
			  <tbody id="detailTableBody">
			  
			  </tbody>
			  
	      </table>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" id="closeModal" data-bs-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<script src="<c:url value='/themes/admin/assets/js/dailyaverageweight_list.js'/>"></script>

