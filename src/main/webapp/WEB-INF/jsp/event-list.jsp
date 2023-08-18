<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="event.list.title"/></title>
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
<form:form id="eventForm" modelAttribute="criteria" action="${ctx}/goodsAttrition/list?poCode=${criteria.processOrderCode}"  method="post">
	<form:hidden path="processOrderCode"/>
	<input hidden="hiden" id ="postingDateSearchInputValue" value="${criteria.postingDateSearch}">
	<!-- \Searching -->
	<div class="card">
		 <div class="card-header bg-navbar text-white header-elements-inline">
                <h6 class="card-title text-navbar"><fmt:message key="label.search" /></h6>
            </div>
		<div class="card-body">
			<div class="row">
				<div class="col-md-4 ">
						<div class="form-group"><label> <fmt:message key="goodsIssue.createdDate" />
						</label> <input class="form-control daterange-basic"  id = "postingDateSearchInput" type="text" name="postingDateSearch" value="${criteria.postingDateSearch}"  /></div>
					</div>
					<div class="col-md-4 " >
						<div class="form-group">
						<label> <fmt:message key="purchaserequisition.status" /></label>
						<select name="status" class="form-control select2" data-placeholder="Chọn trạng thái " data-fouc  >
								<option ></option>
								<c:forEach var="s" items="${status}" >
									<option value="${s.value}" ${criteria.status  eq s.value ? 'selected' : ''}><fmt:message key="goodsIssue.status.${s.value}"></fmt:message></option>
								</c:forEach>
						</select>
						</div>
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
	<div class="card">
		<div class="card-header header-elements-inline">
			<span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="event.list.title"/> - <c:out value = "${processOrder.barn.farm.name}"/> - <c:out value = "${processOrder.barn.code}"/></span>
			<security:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_GOODS_ATTRITION_CREATE')">
			<div class="header-elements">
				<div class="list-icons">
					<c:if test="${ processOrder.status != 'closed' and totalPigRetained > 0}">
						<a href="<c:url value='/goodsAttrition/form?poCode=${processOrder.code}'/>" class="btn btn-sm btn-primary" title="<fmt:message key="button.add"/>"><i class="icon-plus22"></i><fmt:message key="button.add"/></a>
<%--                			<a href="<c:url value='/goodsAttrition/export/${processOrder.code}/${processOrder.barn.code}'/>" class="btn btn-sm btn-primary" title="<fmt:message key="button.add"/>"><i class="icon-file-upload"></i><fmt:message key="button.export"/></a> --%>
               		</c:if>
               	</div>
        	</div>
        	</security:authorize>
		</div>
		<div class="card-body">
		<fmt:message key="event.list.title.description"/>
			<div class="row">
				<div class="col-xs-12 col-md-3">
					<div class="form-group">
						<label ><fmt:message key="goodsissue.processOrder"/>: <b class="ml-3"><c:out value="${processOrder.code }" /></b></label>
					</div>
				</div>
			</div>
		</div>
		<div class="table-responsive">
			<table class="table table-bordered table-striped">
				<thead>
					<tr class="table-success">
						<th class="text-center" style="width: 120px">#</th>			
						<th class="text-center" ><fmt:message key="goodsIssue.createdBy"/></th>
						<th class="text-center"><fmt:message key="goodsIssue.createdDate"/></th>
						<th class="text-center"><fmt:message key="processorder.status" /></th>
						<th class="text-center" style="width:120px;"><i class="icon-menu-open2"></i></th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${empty page.content}">
						<tr><td colspan="8" class="text-center text-none-data"><fmt:message key="not.data"/></td></tr>
					</c:if>
					<c:forEach var="goodsIssue" items="${page.content}" varStatus="cnt">
						<tr>
							<td class="text-center"><c:out value="${cnt.count+page.size*page.number}" /></td>
							<th class="text-center">${goodsIssue.createdBy}</th>
							<td class=" text-center ">${goodsIssue.displayPostingDate}</td>
							<td  class="text-center"><span class="badge bg-${goodsIssue.status eq 'confirmed' ? 'success'  : 'danger'}-400" ><fmt:message key="purchase.requisition.status.${goodsIssue.status}"/></span></td>														
							<td class=" text-center">
								<div class="list-icons">
									<div class="dropdown">
										<a href="#" class="list-icons-item" data-toggle="dropdown"><i class="icon-menu7 mr-3 icon-2x"></i></a>
										<div class="dropdown-menu dropdown-menu-right">
											<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_GOODS_ATTRITION_EDIT')">
											<a href="/goodsAttrition/form?poCode=${processOrder.code}&id=${goodsIssue.id}" class="dropdown-item"><i class="icon-pencil7" style="color:blue"> <fmt:message key="button.detail"/></i></a>
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

<script src="<c:url value='/themes/admin/assets/js/event_list.js'/>"></script>
<script src="<c:url value='/themes/admin/assets/js/format_date.js'/>"></script>

<script>
	function searchFunction(){
		$('#page').val(0);
	}
</script>
