<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="cust.form.title"/></title>
    <meta name="menu" content="orgMenu"/>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/extensions/jquery_ui/interactions.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/demo_pages/form_select2.js'/>"></script>
	
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/uniform.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/pnotify.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/bootstrap_multiselect.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/demo_pages/form_multiselect.js'/>"></script>
    <link href="${ctx }/themes/admin/assets/css/cust_form.css" rel="stylesheet" type="text/css">
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
</head>


<!-- Content area -->
<div class="content">
<form:form id="custForm" modelAttribute="cust" action="${ctx}/customer/save" method="post" role="form">
<form:hidden path="id" id="idCust"/>
<form:hidden path="createdBy"/>
<form:hidden path="createdDate"/>
<form:hidden path="detailString" id="detail"/>
	<!-- Basic layout-->
	<div class="card">
		<div class="card-header header-elements-inline"><span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="cust.form.title"/></span></div>
		<div class="card-body">
			<p class="mb-4"><fmt:message key="cust.form.title.description"/></p>
			<fieldset class="mb-3">
				<legend class="text-uppercase font-size-sm font-weight-bold"><fmt:message key="template.legend"/></legend>
				<div class="card">
					<div class="card-body">
						<div class="row">
							<div class="col-xs-12 col-md-4">
								<div class="form-group">
									<label ><fmt:message key="cust.code"/><span class="help-block">*</span></label>
									<input type="text" id="code" name="code" value="${cust.code}" class="form-control" required="required"  maxlength="30"/>
									<div><span id="messageCheckCode" style=" color:red "></span></div>
								</div>
								
							</div>
							<div class="col-xs-12 col-md-4">
								<div class="form-group">
									<label><fmt:message key="cust.name"/><span class="help-block">*</span></label>
									<input type="text" name="name" id="name" value="${cust.name}" class="form-control" required="required" maxlength="200"/>
									<div><span id="messageCheckName" style=" color:red "></span></div>
								</div>
							</div>
							<div class="col-xs-12 col-md-4">
								<div class="form-group">
									<label><fmt:message key="cust.status"/><span class="help-block">*</span></label>
									<%-- <input type="text" name="status" value="${cust.status}" class="form-control" required="required" maxlength="255"/> --%>
									<select class="form-control select " name="status">
										<c:forEach items="${listStatus}" var="status">
									        <option value="${status.status}" ${cust.status == status.status ? 'selected' : ''}>${status}</option>
									    </c:forEach>
								    </select>
								</div>
							</div>
	        			
	        			</div>
	        			<!-- detail -->
	        			<c:set var="productSize" scope="session" />
								<c:set var="lastProductSize" scope="session"  />
								<fieldset class="fsStyle">
									<legend class="legendStyle">
										<a data-toggle="collapse" aria-controls="products" data-target="#products" aria-expanded="true" href="#"><fmt:message key="detail"/><span class="help-block">*</span></a>
									</legend>
									<div class="collapse show" id="products" aria-expanded="true">
										<div class="dataTable_wrapper">
											<div class="table-responsive">
												<table class="table table-striped table-hover table-bordered dataTable text-center">
													<thead>
														<tr class="table-primary">
															<th ><fmt:message key="detail.key"/><span class="help-block">*</span></th>
															<th ><fmt:message key="detail.value"/><span class="help-block">*</span></th>
															<th style="width:150px"></th>
														</tr>
													</thead>
													<tbody>
													<c:if test="${empty cust.detail}">
														<tr class="clonableProductRow" >																		
															<!-- Thuộc tính-->
															<td>
																<div id="productKeyDetail">
																	<input type="text" class="form-control keyDetail" name="keyDetail" 
																	data-bv-notempty-message="Vui lòng không để trống mục này."  maxlength="255"/>
																</div>
															</td>
															<!-- /thuộc tính -->
															
															<!-- Giá trị -->
															<td>
																<div id="productValueDetail" >
																	<input type="text" class="form-control valueDetail" name="valueDetail" 
																	data-bv-notempty-message="Vui lòng không để trống mục này."  maxlength="255"/>
																</div>
															</td>
															<!-- Giá trị -->
															<td>
																<div id="btnGroup" style="white-space: nowrap;">
																	<button type="button" class=" btn-primary btn-xs addProductRow" title="Add Row" style="display: inline-block;float:none; border:none"><i class="fa fa-plus "></i></button>
																	<button type="button" class=" btn-danger btn-xs removeProductRow" title="Remove Row" style="display: inline-block;float:none;border:none"><i class="fa fa-times"></i></button>
																</div>
															</td>
															<!-- /số lượng -->
														</tr>
													</c:if>
													<c:forEach items="${cust.detail}" var="detail">
														<tr class="clonableProductRow" >																		
															<!-- Thuộc tính-->
															<td>
																<div id="productKeyDetail">
																	<input type="text" class="form-control keyDetail" name="keyDetail" value="${detail.key }"
																	data-bv-notempty-message="Vui lòng không để trống mục này."  maxlength="255"/>
																</div>
															</td>
															<!-- /thuộc tính -->
															
															<!-- Giá trị -->
															<td>
																<div id="productValueDetail" >
																	<input type="text" class="form-control valueDetail" name="valueDetail" value="${detail.value }"
																	data-bv-notempty-message="Vui lòng không để trống mục này."  maxlength="255"/>
																</div>
															</td>
															<!-- Giá trị -->
															<td>
																<div id="productNotEmpty" style="white-space: nowrap;">
																	<button type="button" class="btn-primary btn-xs addProductRow" title="Add Row" style="display: inline-block;float:none;border:none"><i class="fa fa-plus "></i></button>
																	<button type="button" class="btn-danger btn-xs removeProductRow" title="Remove Row" style="display: inline-block;float:none;border:none"><i class="fa fa-times"></i></button>
																</div>
															</td>
															<!-- /số lượng -->
														</tr>
														</c:forEach>
														
													</tbody>
												</table>
											</div>
										</div>
									</div>
								</fieldset>
					</div>
				</div>
				<div class="d-flex justify-content-end align-items-center">
					<a href="<c:url value="/customer/list"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i><fmt:message key="button.back"/></a>
					<button onclick="return validate()" type="submit" id="custSubmit" class="btn btn-primary ml-3"><fmt:message key="button.save"/><i class="icon-database-insert ml-2"></i></button>
			
				</div>			
			</fieldset>
		</div>
	</div>
	<!-- /basic layout -->
</form:form>
</div>
<!-- /content area -->

<script src="<c:url value='/themes/admin/assets/js/cust_form.js'/>"></script>
