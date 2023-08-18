<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
	<title><fmt:message key="document.form.title" /></title>
	<meta name="menu" content="documentMenu" />
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/extensions/jquery_ui/interactions.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/styling/uniform.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/pnotify.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/bootstrap_multiselect.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/main/jquery.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/main/bootstrap.bundle.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/loaders/blockui.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/uploaders/fileinput/fileinput.min.js'/>"></script>
	<script	src="<c:url value='/themes/admin/assets/js/document_form.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
	
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/tags/tagsinput.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/tags/tokenfield.min.js'/>"></script>
</head>

<!-- Content area -->
<div class="content">
	<form:form id="documentForm" modelAttribute="document" action="${ctx}/document/save" method="post" role="form" enctype="multipart/form-data">
		<form:hidden path="id" id="id" />
		<input type="hidden" id="hasFiles" value="${hasFiles}">
		<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_DOCUMENT_DELETE')">
			<input type="hidden" id="canDelete" value=1>
		</security:authorize>
		<!-- Basic layout-->
		<div class="card">
			<div class="card-header header-elements-inline">
				<span class="text-uppercase font-size-lg font-weight-bold"><fmt:message key="document.form.title" /></span>
			</div>
			<div class="card-body">
				<fieldset class="mb-3">
					<div class="row">
						<div class="col-xs-12 col-md-6">
							<div class="form-group">
								<label>
									<fmt:message key="farm.code" />
									<span class="help-block">*</span>
								</label>
								<form:input path="farm.code" id="farmCode" class="form-control" readonly="true"/>
							</div>
						</div>
						<div class="col-xs-12 col-md-6">
							<div class="form-group">
								<label>
									<fmt:message key="document.created-date" />
									<span class="help-block">*</span>
								</label>
								<form:hidden path="createdDate" id="createdDate" class="form-control" required="required" />
								<form:input path="displayCreatedDate" id="displayCreatedDate" class="form-control" readonly="true" />
							</div>
						</div>
						<security:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_DOCUMENT_ENTER_MAIL')">
							<div class="col-12">
								<div class="form-group" id="emailId">
									<label><fmt:message key="document.email" /><span class="help-block">*</span></label>
									<input type="text" class="form-control tokenfield" value="${document.email}" name="email" id="email" data-fouc>
								</div>
							</div>
							<div class="col-12">
								<div class="form-group" id="ccEmailId">
									<label><fmt:message key="document.cc.email" /><span class="help-block"></span></label>
									<input type="text" class="form-control tokenfield" value="${document.ccEmail}" name="ccEmail" id="ccEmail" data-fouc>
								</div>
							</div>
						</security:authorize>
						<div class="col-12">
							<div class="form-group">
								<label><fmt:message key="document.type.description" /><span class="help-block"></span></label>
								<form:input path="description" id="description" class="form-control" />
							</div>
						</div>
						<div class="col-12">
							<div class="form-group">
								<label><fmt:message key="document.content" /><span class="help-block"></span></label>
								<textarea class="form-control" id="content" onKeyup="javascript:DocumentForm.changeRowTextArea()" name="content" rows="1">${document.content}</textarea>
							</div>
						</div>
					</div>
					<div class="col-12 card">
						<h5 class="mt-2 ml-2"><fmt:message key="document.title" /></h5>
						<div class="card-body row justify-content-center">
						
						<c:forEach var="type" items="${existedTypes}" varStatus="cnt">
							<c:set value="${fileMap}" var="map"/>
							<c:set value="${type.id.toString()}" var="typeid"/>
							<c:set value="${map[typeid]}" var="files"/>
							<div class="col-12 card document-type mx-2 row task--history__container" id="${typeid}">
								<div class="card-body">
									<div class="type-info">
										<h5>${type.name}</h5>
										<p>${type.description}</p>
									</div>
									<div class="type-content">
										<c:if test="${not empty files}">
											<ul class="nav nav-tabs">
												<c:if test="${type.status eq 'active'}">
													<li class="nav-item">
														<a href="#fileUpload-${typeid}" class="nav-link" data-toggle="tab">Tải lên tệp tin</a>
													</li>
												</c:if>
											
												<li class="nav-item">
													<a href="#oldFilesList-${typeid}" class="nav-link active" data-toggle="tab" id="tabTitleEvidence">Tệp tin đính kèm</a>
												</li>
											</ul>
										</c:if>
										<div class="tab-content">
											<c:if test="${type.status eq 'active'}">
												<div class="tab-pane fade" id="fileUpload-${typeid}">
													<div class="row">
														<div class="col-12">
															<div class="file-upload">
																<input type="file" name="uploadFiles" class="file-input-preview" multiple>
															</div>
														</div>
													</div>
												</div>
											</c:if>
											<c:if test="${not empty files}">
												<c:set value="" var="documentFiles"/>
												<c:set value="" var="videoFiles"/>
												<c:set value="" var="imageFiles"/>
												<c:forEach var="file" items="${files}">
													<c:if test="${documentExtensions.contains(file.fileType)}">
														<c:choose>
															<c:when test="${documentFiles eq ''}">
																<c:set var="documentFiles" value="${file.url}" />
															</c:when>
															<c:otherwise>
																<c:set var="documentFiles" value="${documentFiles},${file.url}" />
															</c:otherwise>
														</c:choose>
														<c:remove var="file" />
													</c:if>
													<c:if test="${videoExtensions.contains(file.fileType)}">
														<c:choose>
															<c:when test="${videoFiles eq ''}">
																<c:set var="videoFiles" value="${file.url}" />
															</c:when>
															<c:otherwise>
																<c:set var="videoFiles" value="${videoFiles},${file.url}" />
															</c:otherwise>
														</c:choose>
														<c:remove var="file" />
													</c:if>
													<c:if test="${imageExtensions.contains(file.fileType)}">
														<c:choose>
															<c:when test="${imageFiles eq ''}">
																<c:set var="imageFiles" value="${file.url}" />
															</c:when>
															<c:otherwise>
																<c:set var="imageFiles" value="${imageFiles},${file.url}" />
															</c:otherwise>
														</c:choose>
														<c:remove var="file" />
													</c:if>
												</c:forEach>
												<c:if test="${not empty documentFiles}">
													<input type="hidden" class="document-files-${typeid}" value="${documentFiles}" >
												</c:if>
												<c:if test="${not empty videoFiles}">
													<input type="hidden" class="video-files-${typeid}" value="${videoFiles}" >
												</c:if>
												<c:if test="${not empty imageFiles}">
													<input type="hidden" class="image-files-${typeid}" value="${imageFiles}" >
												</c:if>
												<div class="tab-pane fade old-files active show" id="oldFilesList-${typeid}">
													<div class="row">
														<div class="col-12 col-lg-8 document-preview document-list-preview-${typeid}">
															<div class="row">
																<div class="file-loading col-12 col-md-3">
																	<input type="file" id="avatar" name="avatar" class="file-input-overwrite-${typeid}" style="display: none;">
																</div>
																<div class="video-loading col-12 col-md-3">
																	<input type="file" accept="video/*" class="file-input-overwrite-video-${typeid}" style="display: none;">
																</div>
															</div>
														</div>
														<div class="col-12 col-lg-4 border-left-dark-alpha document-list document-list-file-${typeid}">
															<div class="document-loading w100p">
																<ul class="media-list">
																	<c:forEach var="file" items="${files}">
																		<c:choose>
																			<c:when test="${!videoExtensions.contains(file.fileType) && !imageExtensions.contains(file.fileType)}">
																				<li class="media has-content">
																					<div class="mr-3 align-self-center">
																						<c:choose>
																							<c:when test="${file.fileType eq 'doc'}">
																								<i class="icon-file-word icon-2x text-primary-300 top-0"></i>
																							</c:when>
																							<c:when test="${file.fileType eq 'pdf'}">
																								<i class="icon-file-pdf icon-2x text-warning-300 top-0"></i>
																							</c:when>
																							<c:when test="${file.fileType eq 'xlsx'}">
																								<i class="icon-file-excel icon-2x text-success-300 top-0"></i>
																							</c:when>
																							<c:otherwise>
																								<i class="icon-file-text2 icon-2x text-warning-300 top-0"></i>
																							</c:otherwise>
																						</c:choose>
																					</div>
																					<div class="media-body">
																						<div class="font-weight-semibold">${file.fileName}</div>
																					</div>
																					<div class="list-icons">
																						<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_DOCUMENT_DELETE')">
																							<a href="javascript:;" class="list-icons-item delete-file">
																								<i class="icon-bin mr-1"></i>
																								<input type="hidden" value="${file.url}" >
																							</a>
																						</security:authorize>
																						<a href="${file.url}" class="list-icons-item download-file">
																							<i class="icon-download"></i>
																						</a>
																					</div>
																				</li>
																			</c:when>
																		</c:choose>
																	</c:forEach>
																</ul>
															</div>
														</div>
													</div>
												</div>
											</c:if>
										</div>
									</div>
								</div>
							</div>
						</c:forEach>
						<c:forEach var="documentType" items="${documentTypes}" varStatus="cnt">
							<div class="col-12 card document-type mx-2" id="${documentType.id}">
								<div class="card-body">
									<div class="type-info">
										<h5>${documentType.name}</h5>
										<p>${documentType.description}</p>
									</div>
									<div class="file-upload">
										<input type="file" name="uploadFiles" class="file-input-preview" multiple>
									</div>
								</div>
							</div>
						</c:forEach>
						
						</div>
					</div>
					<div class="d-flex justify-content-end align-items-center">
						<a href="<c:url value="/document/list"/>" id="back" class="btn btn-light"><i class="icon-point-left mr-2"></i> <fmt:message key="button.back" /></a>
						<c:if test="${!isLate}">
							<security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_DOCUMENT_CREATE')">
								<button type="submit" class="btn btn-primary ml-3"><fmt:message key="button.save" /><i class="icon-database-insert ml-2"></i></button>
							</security:authorize>
						</c:if>
					</div>
				</fieldset>
			</div>
		</div>
		<!-- /basic layout -->
	</form:form>
</div>
<!-- /content area -->
