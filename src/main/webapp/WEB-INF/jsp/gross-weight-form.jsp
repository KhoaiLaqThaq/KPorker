<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
	<c:choose>
        <c:when test = "${empty goodsIssue.id}">
           <title><fmt:message key="goodsissue.form.title" /></title>
        </c:when>
        <c:otherwise>
           <title><fmt:message key="goodsIssue.form.detail" /></title>
        </c:otherwise>
     </c:choose>
	<meta name="menu" content="grossWeightMenu" />
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/extensions/jquery_ui/interactions.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/uniform.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/pnotify.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
	<%-- <script src="<c:url value='/themes/admin/assets/js/goodsissue_form.js'/>"></script> --%>
	<script src="<c:url value='/themes/admin/assets/js/grossWeight_selector.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/ui/moment/moment.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/daterangepicker.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/anytime.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.date.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/legacy.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/jgrowl.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
	<!-- Map -->
</head>

<!-- Content area -->
<div class="content">
	<form:form id="grossWeightForm" modelAttribute="grossWeight" action="/grossWeight/save" method="post" role="form">
	   <form:hidden path="id"/>
	   <form:hidden path="soPhieu"/>
	   <form:hidden path="ngayBd"/>
	   <input type="hidden" id="materials" value="${ materialJsons }" />
	   
		<!-- Basic layout-->
		<div class="card">
			<div class="card-header header-elements-inline">
				<c:choose>
			        <c:when test = "${empty grossWeight.id}">
			           <span class="text-uppercase font-size-lg font-weight-bold"><fmt:message	key="grossWeight.form.title" /></span>
			        </c:when>
			        <c:otherwise>
			           <span class="text-uppercase font-size-lg font-weight-bold"><fmt:message	key="grossWeight.form.detail" /></span>
			        </c:otherwise>
			     </c:choose>
			</div>
			<div class="card-body">
				<p class="mb-4">
		           <fmt:message key="grossWeight.form.title.description" />
				</p>
				<fieldset class="mb-3">
					<legend class="text-uppercase font-size-sm font-weight-bold">
						<fmt:message key="template.legend" />
					</legend>
					<div class="card">
						<div class="card-body">
							<div class="row">
								<%-- <c:if test="${grossWeight.id != null}">
								    <fieldset  class="col-12">
	                                    <legend class="text-danger font-weight-bold fontSize18" style="font-family: 'FontAwesome'">QRCODE phiếu xuất kho từ SAP</legend>
	                                    <button type="button" class="btn btn-secondary">QRCODE Image</button>
	                                </fieldset>
								</c:if> --%>
								<hr />
							   <fieldset class="col-12 mb-2">
							       <legend class="text-danger font-weight-bold fontSize18 text-legend">Thông tin chung</legend>
							       <div class="row">
							           <div class="form-group col-md-4">
                                            <label><fmt:message key="grossWeight.label.soPhieuXk" /> <span class="text-danger">*</span></label>
                                            <input type="text" name="soPhieuXk" value="${grossWeight.soPhieuXk }" class="form-control" placeholder="Nhập số phiếu xuất kho" ${grossWeight.id != null ? 'readonly':'' } required="required" />
                                        </div>
                                        <div class="form-group col-md-4">
                                            <label><fmt:message key="grossWeight.label.soPhieuNum" /> <span class="text-danger">*</span></label>
                                            <input type="text" name="soPhieuNum" value="${grossWeight.soPhieuNum }" class="form-control" placeholder="Nhập số phiếu cân" ${grossWeight.id != null ? 'readonly':'' } required="required" />
                                        </div>
                                        <div class="form-group col-md-4">
                                            <label><fmt:message key="grossWeight.label.tenKh" /> <span class="text-danger">*</span></label>
                                            <input type="text" name="tenKh" class="form-control" value="${grossWeight.tenKh }" placeholder="Nhập tên khách hàng" required="required"/>
                                        </div>
                                        <div class="form-group col-12">
                                            <label><fmt:message key="grossWeight.label.diaChi" /> <span class="text-danger">*</span></label>
                                            <textarea name="diaChi" rows="3" class="form-control">${grossWeight.diaChi }</textarea>
                                        </div>
                                        <div class="form-group col-md-4">
                                            <label><fmt:message key="grossWeight.label.traiXuat" /> <span class="text-danger">*</span></label>
                                            <c:choose>
                                                <c:when test="${grossWeight.id != null }">
                                                    <select id="stockCode" name="traiXuat" class="form-control select2" 
                                                          data-placeholder="Chọn trại xuất">
                                                            <option value="${farm.code}" selected>${farm.name}</option>
                                                    </select>    
                                                </c:when>
                                                <c:otherwise>
                                                    <select id="stockCode" name="traiXuat" class="form-control select2" 
			                                              data-placeholder="Chọn trại xuất">
			                                                <option value=""></option>
			                                              <c:forEach var="item" items="${farms}">
			                                                  <option value="${item.code}"><c:out value="${item.name}"></c:out></option>
			                                              </c:forEach>
		                                            </select>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="form-group col-md-4">
                                            <label><fmt:message key="grossWeight.label.nhanVienCan" /> <span class="text-danger">*</span></label>
                                            <input type="text" name="nhanVien" class="form-control" value="${grossWeight.nhanVien }" placeholder="Nhập tên nhân viên" required="required" />
                                        </div>
                                        <div class="form-group col-md-4">
                                            <label><fmt:message key="grossWeight.label.bienSoXe" /> <span class="text-danger">*</span></label>
                                            <input type="text" name="soXe" class="form-control" value="${grossWeight.soXe }" placeholder="Nhập biển số xe" required="required" />
                                        </div>
							        </div>
							        <hr />
							    </fieldset>
                                <fieldset class="col-12">
                                    <legend class="text-danger font-weight-bold fontSize18 text-legend">Thông tin từng mã cân</legend>
                                    <jsp:include page="grossWeight-selector.jsp" />
                                </fieldset>
							</div>
						</div>
					</div>
					<div class="d-flex justify-content-end align-items-center">
						<a href="<c:url value="/goodsIssue-Requisition/list"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i> <fmt:message key="button.back" /></a>
						<button type="submit" id="btnSubmit" class="btn btn-primary ml-3">	<fmt:message key="button.save" /><i class="icon-database-insert ml-2"></i></button>
						<c:if test="${grossWeight.id != null }">
						  <a href="/grossWeight/export/${grossWeight.id}" class="btn btn-primary ml-3"><fmt:message key="button.grossWeight.print" /><i class="icon-paste2 ml-2"></i></a>
						</c:if>
					</div>
				</fieldset>
			</div>
		</div>
		<!-- /basic layout -->
	</form:form>
</div>
<!-- /content area -->