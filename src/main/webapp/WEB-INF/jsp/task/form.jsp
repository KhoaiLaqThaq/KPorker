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

  <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>
  <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
  <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/bootstrap_multiselect.js'/>"></script>
  <script src="<c:url value='/themes/admin/global_assets/js/plugins/ui/moment/moment.min.js'/>"></script>
  <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/daterangepicker.js'/>"></script>
  <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/anytime.min.js'/>"></script>
  <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.js'/>"></script>
  <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.date.js'/>"></script>
  <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.time.js'/>"></script>
  <script src="<c:url value='/themes/admin/global_assets/js/demo_pages/picker_date.js'/>"></script>
  
  <script src="<c:url value='/themes/admin/assets/js/select2.js'/>"></script>
  <script src="<c:url value='/themes/admin/assets/js/task/form.js'/>"></script>
</head>

<security:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_TASK_CREATE')">
  <div class="content">
    <div class="row mb-3">
      <div class="col-12 col-md-6">
        <a href="/task/list" class="btn btn-secondary"><i class="icon-arrow-left12 mr-2"></i><fmt:message key="button.back"/></a>
      </div>
    </div>
    <form:form id="task__form" modelAttribute="task" action="/task/form" method="POST">
      <form:hidden path="id" id="taskId" />
      <form:hidden path="code" id="taskCode" />
      <c:if test="${task.action eq 'copy'}">
        <form:hidden path="parent.id"/>
        <form:hidden path="action"/>
      </c:if>
      <c:if test="${not empty task.id}">
        <form:hidden path="parent.id"/>
        <form:hidden path="assigneeEmail" />
        <form:hidden path="assigneeUsername" id="assigneeUsername" />
        <form:hidden path="assigneeReport"/>
        <form:hidden path="assigneeFullname"/>
        <form:hidden path="status" />
        <form:hidden path="createdByReport"/>
        <form:hidden path="createdDate"/>
      </c:if>

      <div class="row">
        <div class="col-12 col-md-8">
          <div class="card rounded-16 component-shadow">
            <c:if test="${not empty task}">
              <c:if test="${task.status eq 'done'}">
                <div class="card-body">
                  <div class="alert alert-success">Công việc đã hoàn thành!</div>
                </div>
              </c:if>
              <c:if test="${task.status eq 'rejected'}">
                <div class="card-body">
                  <div class="alert alert-danger">Công việc đã từ chối!</div>
                </div>
              </c:if>
            </c:if>

            <c:if test="${empty task.status || (task.status ne 'done' && task.status ne 'rejected')}">
              <div class="card-header header-elements-inline">
                <span class="text-uppercase font-size-lg font-weight-bold">
                  <c:choose>
                    <c:when test="${empty task.id}"><fmt:message key="${task.action ne 'copy' ? 'task.form.title':'task.form.copy.title'}"/></c:when>
                    <c:otherwise><fmt:message key="task.edit.title"/></c:otherwise>
                  </c:choose>
                </span>
              </div>
              <div class="card-body">
                <div class="row mb-3">
                  <!-- title -->
                  <div class="col-12">
                    <div class="form-group">
                      <label for="task__title"><fmt:message key="label.task.title"/> <span class="text-danger">(<fmt:message key="label.input.required"/>)*</span>:</label>
                      <input type="text" class="form-control rounded-10" id="task__title" name="title" value="${task.title}" required="required" maxlength="255" placeholder="Thêm tiêu đề công việc..." />
                      <p class="text-danger mt-2" id="title__message"></p>
                    </div>
                  </div>
                  <!-- /title -->

                  <!-- description -->
                  <div class="col-12">
                    <div class="form-group">
                      <label for="description"><i class="icon-paragraph-left2 mr-2"></i><fmt:message key="label.task.description"/>:</label>
                      <textarea class="form-control rounded-10" id="description" name="description" rows="5" placeholder="Thêm mô tả chi tiết hơn...">${task.description}</textarea>
                    </div>
                  </div>
                  <!-- /description -->

                  <!-- assignee -->
                  <c:if test="${empty task.assigneeUsername}">
                    <security:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_TASK_CREATE')">
                      <div class="col-12 col-md-8">
                        <div class="form-group">
                          <label for="task__assignee"><fmt:message key="task.form.assign.farm"/> <span class="text-danger">(<fmt:message key="label.input.required"/>)*</span>:</label>
                          <select id="task__assignee" data-placeholder="Chọn tài khoản phân phối" multiple="multiple" name="assignees" class="form-control" data-fouc>
                            <c:forEach var="item" items="${accounts}">
                              <option value="${item.username}_${item.firstName} ${item.lastName}_${item.email}_${item.mailToReport}">${item.firstName} ${item.lastName} (${item.email})</option>
<%--                              <option value="${item.username}_${item.firstName} ${item.lastName}_${item.email}_${item.mailToReport}">${item.firstName} ${item.lastName}</option>--%>
                            </c:forEach>
                          </select>
                        </div>
                      </div>
                    </security:authorize>
                  </c:if>
                  <!-- assignee -->
                  <c:if test="${not empty task.assigneeUsername}">
                    <div class="col-12 mb-3">
                      <div class="farm__assigned"><fmt:message key="label.task.farm.assigned"></fmt:message>: <div class="badge badge-success">${task.assigneeUsername} (${task.assigneeEmail})</div></div>
                    </div>
                  </c:if>

                  <div class="col-12 col-md-4">
                    <div class="form-group">
                      <label for=assignee__name><fmt:message key="task.assignee.name"/></label>
                      <input type="text" class="form-control rounded-10" id="assignee__name" name="subAssignee" value="${task.subAssignee}" placeholder="Nhập người chỉ định..." />
                    </div>
                  </div>
                </div>
                <hr />

                <!-- button -->
                <div class="row task--actions">
                  <div class="col-12 text-right">
                    <security:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_TASK_CREATE')">
                      <button type="button" id="btn--submit" class="btn bgc-warning rounded-10 py-1 px-3 text-white mb-3"><i class="icon-paperplane mr-1"></i><span><fmt:message key="action.save"/></span></button>
                    </security:authorize>
                  </div>
                </div>
                <!-- button -->

                <c:if test="${not empty task.id}">
                  <!-- task history -->
                  <hr>
                  <div class="row">
                    <div class="col-6"><p><i class="icon-list2 mr-3"></i><span class="fw-bold"><fmt:message key="label.task.activity"/></span></p></div>
                    <div class="col-6 text-right"><button type="button" id="btn--task__history" class="btn rounded-10"><fmt:message key="label.task.history.detail.close"/></button></div>
                  </div>

                  <div class="row task--history__container collapse">
                    <div class="col-12">
                      <ul class="pl-0">
                        <c:forEach var="revision" items="${task.revisions}">
                          <li>
                            <div class="row">
                              <div class="col-12 col-sm-4 col-md-4">
                                <span class="created-by">${revision.createdBy}</span>
                                <!-- action -->
                                <c:choose>
                                  <c:when test="${revision.content['action'] != null}">
                                    <span class="revision-content"><fmt:message key="task.revision.action.${revision.content['action']}"/></span>
                                  </c:when>
                                  <c:otherwise>
                                    <span class="revision-content">Không rõ</span>
                                  </c:otherwise>
                                </c:choose>
                                <!-- /action -->
                                <!-- time history -->
                                <p class="time ml-2"><span class="fw-bold text-secondary"><fmt:message key="task.revision.history"/></span>: ${revision.createdDateStr}</p>
                                <!-- /time history -->
                              </div>

                              <div class="col-12 col-sm-8 col-md-8">
                                <!-- content -->
                                <c:if test="${revision.content['content'] != null}">
                                  <c:if test="${revision.content['action'] != null && revision.content['action'] eq 'rejected'}">
                                    <span class="ml-5 mr-2 fw-bold ">Nội dung thay đổi:</span>
                                  </c:if>
                                  <span class="revision--content">${revision.content['content']}</span>
                                </c:if>
                                <!-- /content -->
                              </div>
                            </div>
                          </li>
                        </c:forEach>
                      </ul>
                    </div>
                  </div>
                  <!-- /task history -->
                </c:if>
              </div>
            </c:if>
          </div>
        </div>
        <div class="col-12 col-md-4">
          <div class="card rounded-16 component-shadow">
            <div class="card-header header-elements-inline">
                <span class="text-uppercase font-size-lg font-weight-bold"><i class="icon-gear mr-2"></i><fmt:message key="task.settings"/></span>
            </div>
            <div class="card-body">
              <div class="row">
                <div class="col-12">
                  <div class="form-group">
                    <label for="frequency"><fmt:message key="label.task.frequency" />:</label>
                    <select class="select2 form-control rounded-10" name="frequency" id="frequency" data-placeholder="Chọn loại công việc">
                      <c:forEach var="item" items="${taskFrequencies}">
                        <option value="${item}" ${task.frequency eq item ? 'selected':''}><fmt:message key="task.frequency.${item}"/></option>
                      </c:forEach>
                    </select>
                  </div>
                </div>

                <!-- start date -->
                <div class="col-12 col-lg-8">
                  <div class="form-group">
                    <label for="startDate__date"><fmt:message key="label.task.startDate" /></label>
                    <input type="text" class="form-control rounded-10" id="startDate__date" name="startDateStr" value="${task.startDateToDisplay}" placeholder="dd-MM-yyyy" autocomplete="off" />
                  </div>
                </div>
                <div class="col-12 col-lg-4">
                  <div class="form-group">
                    <label for="startDate__time"><fmt:message key="label.task.time" /></label>
                    <input type="text" class="form-control rounded-10" id="startDate__time" name="startDateTimeStr" value="${task.startDateTimeToDisplay != "" ? task.startDateTimeToDisplay : '00:00'}">
                  </div>
                </div>
                <!-- /start date -->

                <!-- deadline -->
                <div class="col-12 col-lg-8">
                  <div class="form-group">
                    <label for="deadline__date"><fmt:message key="label.task.deadline" /></label>
                    <input class="form-control rounded-10" id="deadline__date" name="deadlineStr" value="${task.deadlineToDisplay}" placeholder="dd-MM-yyyy" autocomplete="off" />
                  </div>
                </div>
                <div class="col-12 col-lg-4">
                  <div class="form-group">
                    <label for="deadline__time"><fmt:message key="label.task.time" /></label>
                    <input type="text" class="form-control rounded-10" id="deadline__time" name="deadlineTimeStr" value="${task.deadlineTimeToDisplay != "" ? task.deadlineTimeToDisplay : '00:00'}">
                  </div>
                </div>
                <!-- /deadline -->
                <hr>
                <%--time notification--%>
                <div class="col-12">
                  <div class="form-group">
                    <label><fmt:message key="label.task.time.notification.time1"/></label>
                    <div class="row">
                      <div class="col-12 col-md-6">
                        <input type="text" class="form-control rounded-10 number" name="time1" value="${task.time1}" placeholder="Thời gian..."/>
                      </div>
                      <div class="col-12 col-md-6">
                        <select name="unit1" id="unit1" class="select2 form-control rounded-10" data-placeholder="Kiểu thời gian">
                          <option value=""></option>
                          <c:forEach var="regex" items="${timeRegexLst}">
                            <option value="${regex}" ${task.unit1 eq regex ? 'selected':''}><fmt:message key="label.time.regex.${regex}"/></option>
                          </c:forEach>
                        </select>
                      </div>
                    </div>
                  </div>
                </div>

                <div class="col-12">
                  <div class="form-group">
                    <label><fmt:message key="label.task.time.notification.time2"/></label>
                    <div class="row">
                      <div class="col-12 col-md-6">
                        <input type="text" class="form-control rounded-10 number" name="time2" value="${task.time2}" placeholder="Thời gian..."/>
                      </div>
                      <div class="col-12 col-md-6">
                        <select name="unit2" id="unit2" class="select2 form-control rounded-10" data-placeholder="Kiểu thời gian">
                          <option value=""></option>
                          <c:forEach var="regex" items="${timeRegexLst}">
                            <option value="${regex}" ${task.unit2 eq regex ? 'selected':''}><fmt:message key="label.time.regex.${regex}"/></option>
                          </c:forEach>
                        </select>
                      </div>
                    </div>
                  </div>
                </div>
                <%--/time notification--%>
              </div>
            </div>
          </div>
        </div>
      </div>
    </form:form>
  </div>
</security:authorize>
