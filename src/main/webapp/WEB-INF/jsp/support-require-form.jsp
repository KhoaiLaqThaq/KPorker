<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="help.form.title"/></title>
    <meta name="menu" content="supportRequire" />	
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/ui/moment/moment.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/legacy.js'/>"></script>
    <script src="https://cdn.ckeditor.com/ckeditor5/35.0.1/classic/ckeditor.js"></script>
    <!-- Map -->
</head>

<!-- Content area -->
<div class="content">
	<form:form id="helpForm" modelAttribute="criteria" action="${ctx}/help/save" method="post" role="form">
		<form:input type="hidden" id="formId" path="id"/>
		<!-- Basic layout-->
		<div class="card">
			<div class="card-header header-elements-inline">
				<span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="help.form.title" /></span>
			</div>
			<div class="card-body">
				<p class="mb-4"><fmt:message key="help.form.title.description" /></p>
				<fieldset class="mb-3">
					<legend class="text-uppercase font-size-sm font-weight-bold"><fmt:message key="template.legend" /></legend>
					<div class="card">
						<div class="card-body">
							<div class="row">
								<form:input id="category" name="category" class="form-control" type="hidden" path="category" />
								<div class="col-xs-4 col-md-6">
									<div class="form-group">
										<label><fmt:message key="help.subCategory" /><span class="help-block">*</span></label>
										<c:choose>
											<c:when test="${criteria.id != null}">
												<input class="form-control" value="${criteria.subCategory}" readonly="true"/>
											</c:when>
											<c:otherwise>
												<select required="true" id="subCategory" name="subCategory" class="form-control select2" data-placeholder="Chọn loại">
													<option value=""></option>
													
												</select>
												<div>
													<span id="msgForSubCategory" style="color: red"></span>
												</div>
											</c:otherwise>
										</c:choose>
									</div>
								</div>
								<div class="col-xs-4 col-md-6">
									<div class="form-group">
										<label><fmt:message key="help.item" /><span class="help-block">*</span></label>
										<c:choose>
											<c:when test="${criteria.id != null}">
												<input class="form-control" value="${criteria.itemName}" readonly="true"/>
											</c:when>
											<c:otherwise>
												<select  id="item" name="itemName" class="form-control select2" data-placeholder="Chọn loại">
													<option value=""></option>
													
												</select>
											</c:otherwise>
										</c:choose>
										
										<div>
											<span id="msgForItem" style="color: red"></span>
										</div>
									</div>
								</div>
							</div>
							
							<div class="row">
								<div class="col-xs-4 col-md-6">
									<div class="form-group">
										<label><fmt:message key="help.udfField_902" /><span class="help-block">*</span></label>
										<c:choose>
											<c:when test="${criteria.id != null}">
												<input class="form-control" value="${criteria.udfField_902}" readonly="true"/>
											</c:when>
											<c:otherwise>
												<select required="true" id="udfField_902" name="udfField_902" class="form-control select2" data-placeholder="Chọn loại">
													<option value=""></option>
													<c:forEach var="item" items="${requireType}">
											            <option value="${item}"><c:out value = "${item}"/></option>
											        </c:forEach>
												</select>
											</c:otherwise>
										</c:choose>
										
										<div>
											<span id="msgForUdfField_902" style="color: red"></span>
										</div>
									</div>
								</div>
								<div class="col-xs-4 col-md-6">
									<div class="form-group">
										<label><fmt:message key="help.emails" /><span class="help-block">*</span></label>
										<c:choose>
											<c:when test="${criteria.id != null}">
												<input class="form-control" value="${criteria.emailString}" readonly="true"/>
											</c:when>
											<c:otherwise>
												<form:input id="emails" path="emailString" class="form-control"/>
											</c:otherwise>
										</c:choose>
										
										<div>
											<span id="msgForEmails" style="color: red"></span>
										</div>
									</div>
								</div>
							</div>
							
							
							<div class="row">
								<div class="col-xs-12 col-md-12">
									<div class="form-group">
										<label><fmt:message key="help.subject" /><span class="help-block">*</span></label>
										<c:choose>
											<c:when test="${criteria.id != null}">
												<input class="form-control" value="${criteria.subject}" readonly="true"/>
											</c:when>
											<c:otherwise>
												<form:input type="text" id="subject" path="subject" class="form-control"/>
											</c:otherwise>
										</c:choose>
										
									</div>
								</div>
								
								<div class="col-xs-12 col-md-12">
									<div class="form-group">
										<label><fmt:message key="help.description" /><span class="help-block">*</span></label>
										<c:choose>
											<c:when test="${criteria.id != null}">
												<input id="desCriptionValue" value="${criteria.description}" type="hidden"/>
												<textarea name="description" id="editorSetValue" readonly="true"></textarea>
											</c:when>
											<c:otherwise>
												<textarea name="description" id="editor"></textarea>
											</c:otherwise>
										</c:choose>
										
									</div>
								</div>
							</div>
							
							
						</div>
					</div>
					<div class="d-flex justify-content-end align-items-center">
						<a href="<c:url value="/pigDead/list"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i><fmt:message key="button.back" /></a>
						<c:if test="${criteria.id == null}">
							<button type="submit" id="btnSubmit" class="btn btn-primary ml-3"><fmt:message key="button.save" /><i class="icon-database-insert ml-2"></i></button>
						</c:if>
						
					</div>
				</fieldset>
			</div>
		</div>
		<!-- /basic layout -->
	</form:form>
</div>
<div class="modal hide" id="pleaseWaitDialog" data-backdrop="static" data-keyboard="false">
    <div class="modal-body">
        <div class="loading">Loading&#8230;</div>
    </div>
</div>
<script src="<c:url value='/themes/admin/assets/js/help-require.js'/>"></script>
 <script>

 </script>
<!-- /content area -->
