<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="material.support.form.title"/></title>
    <meta name="menu" content="goodsAttritionSupportMenu"/>
    <link href="<c:url value='/themes/admin/assets/css/material-support.css'/>" rel="stylesheet" type="text/css">
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/extensions/jquery_ui/interactions.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/uniform.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/pnotify.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/bootstrap_multiselect.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
    
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/loaders/blockui.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/loaders/progressbar.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/demo_pages/components_progress.js'/>"></script>
    
    <!-- Map -->
</head>

<!-- Content area -->
<div class="content">
<form:form id="materialSupportForm" modelAttribute="materialSupport" action="${ctx}/materialSupport/save" method="post" role="form">
	<!-- Basic layout-->
	<div class="card">
		<div class="card-header header-elements-inline"><span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="material.support.form.title"/></span></div>
		<div class="card-body">
			<fieldset class="mb-3">
				<div class="row">
					<div class="col-md-12">
						<!-- Grey header and footer -->
						<div class="card">
							<div class="card-header bg-light d-flex justify-content-between">
								<span class="font-size-sm text-uppercase font-weight-semibold"><fmt:message key="material.info"/></span>
							</div>
							<div class="card-body">
							    <div class="row mb-3">
							        <div class="col-12" id="searchCollapse">
										  <div class="row">
										    <div class="col-md-4 col-sm-5">
											    <div class="form-group">
											       <label><fmt:message key="material.code" /></label>
						                           <input type="text" name="code" class="form-control" id="materialCode" value="${materialSupport.code }" placeholder="Nhập mã vật tư..."/>
											    </div>
										    </div>
										    <div class="col-md-4 col-sm-5">
											    <div class="form-group">
											       <label><fmt:message key="material.support.name" /></label>
						                           <input type="text" name="name" class="form-control" id="materialName" value="${materialSupport.name }" placeholder="Nhập tên vật tư..."/>
											    </div>
										    </div>
										    <div class="col-md-4 col-sm-5">
                                                <div class="form-group">
                                                   <label><fmt:message key="material.name.suggest" /></label>
                                                   <input type="text" name="suggestName" class="form-control" id="suggestName" value="${materialSupport.suggestName }" placeholder="Nhập tên vật tư thường dùng..."/>
                                                </div>
                                            </div>
                                            <div class="col-md-4 col-sm-5">
                                                <div class="form-group">
                                                    <label><fmt:message key="material.fast.code" /></label>
                                                    <input type="text" name="fastCode" class="form-control" id="fastCode" value="${materialSupport.fastCode }" placeholder="Nhập mã fast..." />
                                                </div>
                                            </div>
					                        <div class="col-md-2 col-sm-2">
					                            <div class="form-group mt-4">
					                                <button type="submit" id="btnSearch" class="btn btn-primary"><fmt:message key="label.search" /></button>
					                            </div>
					                        </div>
										  </div>
							        </div>
							    </div>
							    <div class="row">
							         <div class="col-12 title-suggest">
							             <p class="font-weight-bold">Chọn <input type="checkbox" disabled /> để thêm hoặc xóa vật tư dùng cho tool</p>
							         </div>
							    </div>
								<div class="table-responsive maxH-400 table-scroll">  
					               	<table id="tblSelectedMaterials" class="table table-bordered table-striped">
										<thead>
											<tr class="table-success">
												<th width="3%">
													<input type="checkbox" name="checkAll" id="checkAll">
												</th>
												<th width="20%"><fmt:message key="purchaserequisition.materialCode" /></th>
												<th width="20%"><fmt:message key="purchaserequisition.materialSuggestName" /></th>
												<th width="20%"><fmt:message key="purchaserequisition.fastCode" /></th>
												<th width="17%"><fmt:message key="purchaserequisition.unit" /></th>
												<th width="20%"><fmt:message key="material.support.name" /></th>
											</tr>
										</thead>
										<tbody id="dataMaterials">
											<c:forEach begin="0" items="${materials}" var="item" varStatus="cnt">
												<tr id="rec-material${cnt.index}" class="tr showable">
													<%-- <td><span class="no"><c:out value="${cnt.count+page.size*page.number}"></c:out></span></td> --%>
													<td>
 														<input type="checkbox" class="item-check" name="item[]" id="checkId" value="${item.code}" ${item.selected ? 'checked' : ''}>
													</td>
													<td>${item.code}<input type="hidden" id="materialCode${cnt.index}" value="${item.code}"></td>
													<td>${item.suggestName }</td>
													<td>${item.fastCode }</td>
													<td>${item.unit}</td>
													<td>${item.name}</td>
												</tr>
											</c:forEach>
										</tbody>
									</table>
								</div>
							</div>
						</div>
					<!-- /grey header and footer -->
					</div>
				</div>			
				<%-- <div class="d-flex justify-content-end align-items-center">
					<a href="<c:url value="/goodsAttritionSupport/list"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i><fmt:message key="button.back"/></a>
					<button type="button" id="btnSubmit" class="btn btn-primary ml-3"><fmt:message key="button.save"/><i class="icon-database-insert ml-2"></i></button>
				</div>			 --%>
			</fieldset>
		</div>
	</div>
	<!-- /basic layout -->
</form:form>
</div>
<div id="snackbar"></div>

<!-- /content area -->

<script src="<c:url value='/themes/admin/assets/js/material_support_form.js'/>"></script>