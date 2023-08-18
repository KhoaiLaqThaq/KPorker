<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
	<title><fmt:message key="pigdead.list.title" /></title>
	<meta name="menu" content="processOrderMenu" />
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
	<link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">
</head>

<div class="content">
	<form:form id="pigdeadForm" modelAttribute="criteria" action="${ctx}/pigCulling/list" method="post">
	<form:hidden path="processOrderCode"/>
		<!-- \Table -->
		<div class="card">
			<div class="card-header header-elements-inline">
				<span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="pigdead.list.title" /> - <c:out value = "${processOrder.barn.farm.name}"/> - <c:out value = "${processOrder.barn.code}"/></span>
				<security:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_PIG_CULLING_CREATE')">
					<div class="header-elements">
						<div class="list-icons">
							<c:if test="${ processOrder.status != 'closed' and totalPigRetained > 0  }">
								<a href="<c:url value='/pigCulling/form?poCode=${criteria.processOrderCode}'/>" class="btn btn-sm btn-primary" title="<fmt:message key="button.add"/>"><i class="icon-plus22"></i>	<fmt:message key="button.add" /></a>
							</c:if>
							<a href="/report/pig-culling-export-excel" id="exportReport" class="btn btn-sm btn-primary"><i class="icon-database-export pr-2"></i>Xuất báo cáo</a>
						</div>
					</div>
				</security:authorize>
			</div>
			<div class="card-body">
				<fmt:message key="pigdead.list.title.description" />
				<div class="row">
					<div class="col-md-6 col-xs-12">
						<div class="form-group">
							<label ><fmt:message key="goodsissue.processOrder"/>: <b id="showPoCode" class="ml-3"><c:out value="${processOrder.code }" /></b></label>
						</div>
					</div>
				</div>
			</div>
			<div class="table-responsive">
				<table class="table table-bordered table-striped">
					<thead>
						<tr class="table-success">
							<th class="text-center" style="width: 5%">#</th>
							<th style="width: 10%"><fmt:message key="event.transCode"></fmt:message></th>
							<th style="width: 10%"><fmt:message key="pigdead.material"/></th>	
							<th style="width: 10%"><fmt:message key="pigdead.quantity"/></th>
							<th style="width: 10%"><fmt:message key="pigdead.weight"/>(Kg)</th>
							<th style="width: 10%"><fmt:message key="dailyAverageWeight.avgWeight"/>(Kg/con)</th>
							<th style="width: 10%"><fmt:message key="pigdead.reason"/></th>
							<th style="width: 10%"><fmt:message key="pigdead.posting.date"/></th>
							<th style="width: 10%"><fmt:message key="pigdead.status"/></th>
							<th class="text-center" style="width: 5%"><i class="icon-menu-open2"></i></th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${empty page.content}">
							<tr>
								<td colspan="8" class="text-center text-none-data"><fmt:message key="not.data" /></td>
							</tr>
						</c:if>
						<c:forEach var="pigdeal" items="${page.content}" varStatus="cnt">
							<tr>
								<td class="text-center"><c:out value="${cnt.count+page.size*page.number}" /></td>
								<td>${pigdeal.transCode}</td>	
								<td>${pigdeal.materialCode}</td>	
								<td>${pigdeal.quantity}</td>
								<td>${pigdeal.pigCulling.weight}</td>
								<td>${pigdeal.pigCulling.weight / pigdeal.quantity}</td>
								<td>${pigdeal.pigCulling.reason}</td>						
								<td>${pigdeal.displayPostingDate}</td>
								<td>
									<c:choose>
										 <c:when test = "${pigdeal.status eq 'confirmed'}">
							            	<span class="badge bg-info-400"><fmt:message key="purchase.requisition.status.${pigdeal.status}"></fmt:message></span>
							         	</c:when>
							         	<c:when test = "${pigdeal.status eq 'synchronized'}">
							            	<span class="badge bg-primary-400"><fmt:message key="purchase.requisition.status.${pigdeal.status}"></fmt:message></span>
							         	</c:when>
							        	 <c:otherwise>
							            	<span class="badge bg-danger-400"><fmt:message key="purchase.requisition.status.${pigdeal.status}"></fmt:message></span>
							         	</c:otherwise>
						      		</c:choose>
								</td>
								<td class="text-center">
									<div class="list-icons">
										<div class="dropdown">
											<a href="#" class="list-icons-item" data-toggle="dropdown"><i class="icon-menu9"></i></a>
											<div class="dropdown-menu dropdown-menu-right">
												<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_PIG_CULLING_EDIT')">
													<a href="/pigCulling/form?poCode=${criteria.processOrderCode}&id=${pigdeal.id}" class="dropdown-item"><i class="icon-pencil7" style="color:blue"> <fmt:message key="button.edit"/></i></a>
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
				<jsp:param value="${page.number}" name="pageNumber" />
				<jsp:param value="${page.totalPages}" name="maxPages" />
				<jsp:param value="${page.size}" name="size" />
				<jsp:param value="${page.totalElements}" name="totalElements" />
			</jsp:include>
		</div>
		<a href="<c:url value="/processOrder/list"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i><fmt:message key="button.back" /></a>
		<!-- /Table -->
	</form:form>
</div>

<script>
	$(document).ready(function(){
		$('#exportReport').on('click', function(e) {   
            var poCode = $("#showPoCode").text();
			
            e.preventDefault();
            var apiExport = '/report/pig-culling-export-excel?poCode=' + poCode;
            console.log(apiExport);
            location.href = apiExport;
        });
	});
</script>