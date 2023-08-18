<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="grossWeight.list.title"/></title>
    <meta name="menu" content="grossWeightMenu"/>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
	
	<script src="<c:url value='/themes/admin/global_assets/js/main/bootstrap.bundle.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/loaders/blockui.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/switch.min.js'/>"></script>	
    <script src="<c:url value='/themes/admin/assets/js/goodsreceipt_requisition_list.js'/>"></script>
</head>

<div class="content">
<form:form id="grossWeightForm" modelAttribute="criteria" action="${ctx}/grossWeight/list"  method="post">
	<!-- \Searching -->
	<div class="card">
	   <div class="card-header bg-navbar text-white header-elements-inline">
          <h6 class="card-title text-navbar"><fmt:message key="label.search" /></h6>
        </div>
		<div class="card-body">
			<div class="row">
				<div class="col-md-3">
				    <div class="form-group">
				        <label><fmt:message key="grossWeight.soPhieu" /></label>
				        <input class="form-control" type="text" id="soPhieu" name="soPhieu" value="${criteria.soPhieu }"  placeholder="Nhập số phiếu"/>
				    </div>
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
			<span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="grossWeight.list.title"/></span>
			<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_FARM_VIEW')">
                <div class="header-elements">
                    <div class="list-icons">
                        <a href="<c:url value='/grossWeight/form'/>" class="btn btn-sm btn-primary" title="<fmt:message key="button.add.grossWeight"/>"><i class="icon-plus22"></i>   <fmt:message key="button.add.grossWeight" /></a>
                    </div>
                </div>
            </security:authorize>
		</div>
		<div class="card-body"><fmt:message key="grossWeight.list.title.description"/></div>
		<div class="table-responsive">
			<table class="table table-bordered table-striped">
				<thead>
					<tr class="table-success">
						<th class="text-center" style="width: 5%">#</th>
						<th><fmt:message key="grossWeight.soPhieuXK"/></th>
						<th><fmt:message key="grossWeight.soPhieuCan" /></th>
						<th><fmt:message key="grossWeight.tenKhachHang" /></th>
						<th><fmt:message key="grossWeight.address"/></th>
						<th><fmt:message key="grossWeight.traiXuat"/></th>
						<th><fmt:message key="grossWeight.nhanVienCan"/></th>
						<th><fmt:message key="grossWeight.bienSoXe"/></th>
						<th class="text-center" style="width:120px;"><i class="icon-menu-open2"></i></th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${empty page.content}">
						<tr><td colspan="9" class="text-center text-none-data"><fmt:message key="not.data"/></td></tr>
					</c:if>
					<c:forEach var="grossWeight" items="${page.content}" varStatus="cnt">
						<tr>
							<td class="text-center"><c:out value="${cnt.count+page.size*page.number}" /></td>
							<!-- cac column -->
							<td>${ grossWeight.soPhieuXk }</td>
							<td>${ grossWeight.soPhieuNum }</td>
							<td>${ grossWeight.tenKh }</td>
							<td>${ grossWeight.diaChi }</td>
							<td>${ grossWeight.traiXuat }</td>
							<td>${ grossWeight.nhanVien }</td>
							<td>${ grossWeight.soXe }</td>
							<td class="text-center">
								<div class="list-icons">
									<security:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_GI_REQUISITION_VIEW')">
									<a href="/grossWeight/form?id=${grossWeight.id}">
									   <i class="icon-file-eye fontSize18" title="Chi tiết"></i>
									</a>
									</security:authorize>
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