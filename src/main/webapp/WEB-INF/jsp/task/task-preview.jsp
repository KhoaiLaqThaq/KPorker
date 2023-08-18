<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
  <title>
    <c:choose>
      <c:when test="${empty task.id}"><fmt:message key="task.form.title"/></c:when>
      <c:otherwise><fmt:message key="task.edit.title"/></c:otherwise>
    </c:choose>
  </title>

  <meta name="menu" content="taskManagement" />
  <link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">
  <link href="<c:url value='/themes/admin/assets/css/task.css'/>" rel="stylesheet" type="text/css">

  <script src="<c:url value='/themes/admin/global_assets/js/main/jquery.min.js'/>"></script>
  <script src="<c:url value='/themes/admin/global_assets/js/main/bootstrap.bundle.min.js'/>"></script>
  <script src="<c:url value='/themes/admin/global_assets/js/plugins/loaders/blockui.min.js'/>"></script>

  <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>
  <script src="<c:url value='/themes/admin/global_assets/js/plugins/uploaders/fileinput/fileinput.min.js'/>"></script>
  
  <script src="<c:url value='/themes/admin/assets/js/task/preview.js'/>"></script>
</head>

<security:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_TASK_ADMIN_VIEW, ROLE_TASK_UPDATE')">
  <div class="content">
    <div class="row mb-3">
      <div class="col-12">
        <div class="text-color-primary fs-3">Chi tiết công việc</div>
      </div>
    </div>
    <form:form modelAttribute="task">
      <form:hidden path="id" id="taskId" />
      <form:hidden path="code" id="taskCode" />
      <form:hidden path="status" id="taskStatus" />
      <c:if test="${task.status eq 'done'}">
        <c:if test="${task.imageType eq 'true'}">
          <form:hidden path="imageAttachments" />
        </c:if>
        <c:if test="${task.documentType eq 'true'}">
          <form:hidden path="documentAttachments"/>
        </c:if>
        <c:if test="${task.videoType eq 'true'}">
          <form:hidden path="videoAttachments"/>
        </c:if>
      </c:if>

      <div class="row">
        <div class="col-12 col-md-8">
          <div class="card rounded-16 component-shadow">
            <div class="card-body">
              <div class="row">
                <!-- title -->
                <div class="col-6">
                  <div class="form-group mb-0">
                    <p class="fs-4 mb-0">#${task.title}</p>
                  </div>
                </div>
                <div class="col-6">
                  <div class="form-group text-right mb-0">
                    <c:if test="${not empty task.id && (task.status eq 'confirmed' || task.status eq 'rq_reject')}">
                      <c:if test="${task.frequency ne 'arise' &&  task.requestRejectFrequency eq false}">
                        <button type="button" id="btn__request--frequency" class="btn btn-secondary rounded-10 px-3 mb-3 mr-2"><span><fmt:message key="action.task.requestReject.frequency"/></span></button>
                      </c:if>
                      <button type="button" id="btn--update__progress" class="btn bgc-primary text-white rounded-10 px-3 mb-3" data-toggle="modal" data-target="#modal--task__progress"><i class="icon-clipboard2 mr-1"></i><span><fmt:message key="action.task.update.progress"/></span></button>
                    </c:if>
                    <c:if test="${not empty task.id && task.status eq 'assigned' || task.status eq 'reassigned'}">
                      <button type="button" id="btn--update__confirm" class="btn bgc-warning rounded-10 text-white px-3 mb-3" data-toggle="modal" data-target="#modal--task__confirm"><i class="icon-file-check mr-1"></i><span><fmt:message key="action.task.update.confirmed"/></span></button>
                    </c:if>
                  </div>
                </div>
                <div class="col-12">
                  <div class="form-group">
                    <p class="ml-2 task--status__group">
                      <span class="mr-1"><fmt:message key="label.task.group.inside"/></span>
                      <span class="text-decoration-underline task--group ${task.taskGroup}"><fmt:message key="label.task.group.${task.taskGroup}"/></span>
                    </p>
                  </div>
                </div>
                <!-- /title -->

                <div class="col-12">
                  <div class="form-group">
                    <div class="mb-2">
                      <span><fmt:message key="label.task.createdBy" />:</span> <span class="badge badge-success"><c:out value="${task.createdBy}"/></span>
                    </div>
                    <div><span><fmt:message key="label.task.assignee" />:</span> <span class="badge badge-success">${task.assigneeFullname} (${task.assigneeEmail})</span></div>
                  </div>
                </div>

                <!-- description -->
                <div class="col-12">
                  <div class="form-group">
                    <label><i class="icon-paragraph-left2 mr-2"></i><span class="fw-bold"><fmt:message key="label.task.description"/></span>:</label>
                    <pre>${task.description}</pre>
                  </div>
                </div>
                <!-- /description -->

                <%--sub assignee--%>
                <div class="col-12 col-md-6">
                  <div class="form-group">
                    <p><fmt:message key="task.assignee.name"/>: <span class="fw-bold"><c:out value="${task.subAssignee}"/></span></p>
                  </div>
                </div>
                <%-- /sub assignee--%>
              </div>

              <c:if test="${not empty task.id}">
                <hr>
                <div class="row mb-3">
                  <div class="col-6"><p><i class="icon-list2 mr-3"></i><span class="fw-bold"><fmt:message key="label.task.activity"/></span></p></div>
                  <div class="col-6 text-right"><button type="button" id="btn--task__history" class="btn rounded-10"><fmt:message key="label.task.history.detail.close"/></button></div>
                </div>

                <div class="row mb-3">
                  <div class="col-12 mb-2">
                    <textarea class="form-control rounded-10" name="cmt" id="cmt" rows="2" placeholder="Viết bình luận..."></textarea>
                  </div>
                  <div class="col-12 col-md-6 btn--save__container">
                    <button type="button" id="btnSaveComment" class="btn btn-primary rounded-10 hide"><fmt:message key="action.save"/></button>
                  </div>
                  <c:if test="${not empty task.id && task.status eq 'done'}">
                  <div class="col-12 col-md-6 text-right">
                    <button type="button" id="btnAdditionEvidence" class="btn btn-primary rounded-10" data-toggle="modal" data-target="#modal--task__progress"><fmt:message key="upload.evidence.addition" /></button>
                  </div>
                  </c:if>
                </div>

                <!-- task history -->
                <div class="row task--history__container">
                  <div class="col-12">
                    <div class="col-12">
                      <ul class="nav nav-tabs">
                        <li class="nav-item"><a href="#tabHistory" class="nav-link active" data-toggle="tab">Chi tiết hoạt động</a></li>
                        <c:if test="${task.status eq 'done'}">
                          <li class="nav-item"><a href="#tabEvidence" class="nav-link" data-toggle="tab" id="tabTitleEvidence">Tệp tin đính kèm</a></li>
                        </c:if>
                      </ul>

                      <div class="tab-content">
                        <div class="tab-pane fade show active" id="tabHistory">
                          <div class="row">
                            <div class="col-12">
                              <ul class="pl-0">
                                <c:forEach var="revision" items="${task.revisions}">
                                  <li>
                                    <div class="row">
                                      <div class="col-12 col-sm-4 col-md-4">
                                        <span class="created-by fw-bold">${revision.createdBy}</span>
                                        <!-- action -->
                                        <c:if test="${revision.content['action'] != null}">
                                          <span class="revision--action"><fmt:message key="task.revision.action.${revision.content['action']}"/></span>
                                        </c:if>
                                        <!-- /action -->
                                        <!-- time history -->
                                        <p class="time ml-2"><span class="fw-bold text-secondary"><fmt:message key="task.revision.history"/></span>: ${revision.createdDateStr}</p>
                                        <!-- /time history -->
                                      </div>

                                      <div class="col-12 col-sm-8 col-md-8">
                                        <!-- content -->
                                        <c:if test="${revision.content['content'] != null}">
                                          <c:if test="${revision.content['action'] eq 'rejected'}">
                                            <span class="ml-5 mr-2 fw-bold ">Nội dung thay đổi:</span>
                                          </c:if>
                                          <span class="revision--content">
                                              <c:if test="${revision.content['action'] eq 'comment'}">
                                                <i class="icon-comment mr-2"></i>
                                              </c:if>
                                              ${revision.content['content']}
                                          </span>
                                        </c:if>
                                        <c:if test="${task.createdBy eq pageContext.request.remoteUser && revision.content['action'] eq 'request-to-reject-frequency' && task.request eq 'reject_frequency' && task.frequency ne 'arise'}">
                                          <button type="button" id="btnAccept" class="btn btn-primary rounded-10"><fmt:message key="label.action.accept"/></button>
                                        </c:if>
                                        <!-- /content -->
                                      </div>
                                    </div>
                                  </li>
                                </c:forEach>
                              </ul>
                            </div>
                          </div>
                        </div>

                        <c:if test="${task.status eq 'done'}">
                          <div class="tab-pane fade" id="tabEvidence">
                            <div class="row">
                              <div class="col-12 ${task.documentType eq 'true' ? 'col-md-8':''}">
                                <div class="row">
                                  <div class="file-loading file-loading-preview col-12 col-md-3">
                                    <input type="file" id="avatar" name="avatar" class="file-input-overwrite">
                                  </div>
                                  <div class="video-loading col-12 col-md-3">
                                    <input type="file" accept="video/*" class="file-input-overwrite-video">
                                  </div>
                                </div>
                              </div>

                              <c:if test="${task.documentType eq 'true'}">
                                <div class="col-12 col-md-4 border-left-dark-alpha document-list">
                                  <div class="document-loading w100p">
                                    <ul class="media-list">
                                      <c:forEach var="doc" items="${task.documentAttachments}">
                                        <li class="media">
                                          <div class="mr-3 align-self-center">
                                            <c:choose>
                                              <c:when test="${doc.fileType eq 'doc'}">
                                                <i class="icon-file-word icon-2x text-primary-300 top-0"></i>
                                              </c:when>
                                              <c:when test="${doc.fileType eq 'pdf'}">
                                                <i class="icon-file-pdf icon-2x text-warning-300 top-0"></i>
                                              </c:when>
                                              <c:when test="${doc.fileType eq 'xlsx'}">
                                                <i class="icon-file-excel icon-2x text-success-300 top-0"></i>
                                              </c:when>
                                              <c:otherwise>
                                                <i class="icon-file-text2 icon-2x text-warning-300 top-0"></i>
                                              </c:otherwise>
                                            </c:choose>
                                          </div>
                                          <div class="media-body">
                                            <div class="font-weight-semibold">${doc.fileName}</div>
                                          </div>
                                          <div class="ml-3">
                                            <div class="list-icons">
                                              <a href="${doc.photoUrl}" class="list-icons-item"><i class="icon-download"></i></a>
                                            </div>
                                          </div>
                                        </li>
                                      </c:forEach>
                                    </ul>
                                  </div>
                                </div>
                              </c:if>
                            </div>
                          </div>
                        </c:if>
                      </div>
                    </div>
                  </div>
                </div>
                <!-- /task history -->
              </c:if>
            </div>
          </div>
        </div>
        <div class="col-12 col-md-4">
          <div class="card rounded-16 component-shadow">
            <div class="card-header header-elements-inline">
              <span class="text-uppercase font-size-lg font-weight-bold"><i class="icon-gear mr-2"></i><fmt:message key="task.settings"/></span>
            </div>
            <div class="card-body">
              <div class="row">
                <!-- frequency -->
                <div class="col-12">
                  <label class="fw-bold"><fmt:message key="label.task.frequency" />:</label>
                  <div class="badge badge-primary"><fmt:message key="task.frequency.${task.frequency}"/></div>
                </div>
                <!-- /frequency -->

                <!-- startDate -->
                <div class="col-12">
                  <div class="form-group">
                    <label class="fw-bold"><fmt:message key="label.task.startDate" /></label>
                    <p>${task.startLocalDateTimeStr}</p>
                  </div>
                </div>
                <!-- /startDate -->
                <!-- deadline -->
                <div class="col-12">
                  <div class="form-group">
                    <label class="fw-bold"><fmt:message key="label.task.deadline" /></label>
                    <p>${task.deadlineLocalDateTimeStr}</p>
                  </div>
                </div>
                <!-- /deadline -->
                  <%--time notification--%>
                <c:if test="${task.time1 != null && task.unit1 != null}">
                <div class="col-12">
                  <div class="form-group">
                    <label><fmt:message key="label.task.time.notification.time1"/>: <span class="fw-bold">${task.time1} <fmt:message key="label.time.regex.${task.unit1}"/></span></label>
                  </div>
                </div>
                </c:if>

                <c:if test="${task.time2 != null && task.unit2 != null}">
                  <div class="col-12">
                    <div class="form-group">
                      <label><fmt:message key="label.task.time.notification.time2"/>: <span class="fw-bold">${task.time2} <fmt:message key="label.time.regex.${task.unit2}"/></span></label>
                    </div>
                  </div>
                </c:if>
                  <%--/time notification--%>
              </div>
            </div>
          </div>
        </div>
      </div>
    </form:form>

    <c:if test="${not empty task.id && task.status eq 'assigned' || task.status eq 'reassigned'}">
      <%@include file="/WEB-INF/jsp/task/task-confirm-modal.jsp"%>
    </c:if>
    <c:if test="${not empty task.id && task.status eq 'confirmed' || task.status eq 'done'}">
      <%@include file="/WEB-INF/jsp/task/task-update-progress.jsp"%>
    </c:if>
  </div>  
</security:authorize>
