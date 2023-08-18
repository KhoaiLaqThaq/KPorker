<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
  <title><fmt:message key="task.list.title"></fmt:message></title>
  <meta name="menu" content="taskManagement" />

  <link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">
  <link href="<c:url value='/themes/admin/assets/css/task.css'/>" rel="stylesheet" type="text/css">

  <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
  <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/bootstrap_multiselect.js'/>"></script>

  <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>
  <script src="<c:url value='/themes/admin/global_assets/js/plugins/ui/moment/moment.min.js'/>"></script>
  <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/daterangepicker.js'/>"></script>
  <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/anytime.min.js'/>"></script>
  <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.js'/>"></script>
  <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.date.js'/>"></script>
  <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.time.js'/>"></script>
  <script src="<c:url value='/themes/admin/global_assets/js/demo_pages/picker_date.js'/>"></script>

  <script src="<c:url value='/themes/admin/assets/js/task/init.js'/>"></script>
  <script src="<c:url value='/themes/admin/assets/js/select2.js'/>"></script>
  <script src="<c:url value='/themes/admin/assets/js/task/list.js'/>"></script>

</head>

<div class="content px-0">
  <%@include file="/WEB-INF/jsp/task/task-header.jsp"%>
  <form:form id="task__list" modelAttribute="criteria" action="${ctx}/task/list" method="POST">
    <div class="row">
      <div class="col-12 task px-3 pt-2">
        <div class="card rounded-16">
          <div class="row">
            <div class="col-6 px-3 py-2 fw-bold"><fmt:message key="label.search" /></div>
            <div class="col-6 text-right">
              <button type="button" id="btn__reset" class="btn btn-secondary rounded-10 mt-2 mr-2">Đặt lại</button>
              <button type="submit" id="btn__submit" class="btn btn-secondary rounded-10 mt-2 mr-2"><i class="mr-2 icon-search4"></i><span class="mr-2"><fmt:message key="label.search"/></span></button>
            </div>
          </div>
          <div class="card-body py-0">
            <div class="row">
              <div class="col-12 col-md-8">
                <div class="row">

                  <%--keyword--%>
                  <div class="col-12 col-sm-6 col-md-3">
                    <div class="form-group">
                      <label><fmt:message key="label.task.content" /></label>
                      <input type="text" class="form-control rounded-10" id="task__keyword" name="keyword" value="${criteria.keyword}" placeholder="Tìm kiếm mã, tiêu đề, mô tả công việc..." />
                    </div>
                  </div>
                  <%--/keyword--%>

                  <%--frequency--%>
                  <div class="col-12 col-sm-6 col-md-3">
                    <div class="form-group">
                      <label><fmt:message key="label.task.frequency"/></label>
                      <select class="select2 form-control rounded-10" name="frequency" id="frequency" data-placeholder="Tần suất">
                        <option value=""></option>
                        <c:forEach var="item" items="${taskFrequencies}">
                          <option value="${item}" ${criteria.frequency eq item ? 'selected':''}><fmt:message key="task.frequency.${item}"/></option>
                        </c:forEach>
                      </select>
                    </div>
                  </div>
                  <%--/frequency--%>

                  <%--status--%>
                  <div class="col-12 col-sm-6 col-md-3">
                    <div class="form-group">
                      <label><fmt:message key="label.task.status"/></label>
                      <select class="select2 form-control rounded-10" name="status" id="farm__status" data-placeholder="Trạng thái">
                        <option value=""></option>
                        <c:forEach var="item" items="${taskStatus}">
                            <option value="${item}" ${criteria.status eq item ? 'selected':''}><fmt:message key="task.status.${item}"/></option>
                        </c:forEach>
                      </select>
                    </div>
                  </div>
                  <%--/status--%>

                  <%--assignee--%>
                    <security:authorize access="hasRole('ROLE_TASK_ADMIN_VIEW')">
                    <div class="col-12 col-sm-6 col-md-3">
                      <div class="form-group">
                        <label for="assigneeUsername"><fmt:message key="label.task.assignee.title"/></label>
                        <select class="select2 form-control rounded-10" name="assigneeUsername" id="assigneeUsername" data-placeholder="Người tiếp nhận">
                          <option value=""></option>
                          <c:forEach var="item" items="${assignees}">
                            <option value="${item.username}" ${criteria.assigneeUsername eq item.username ? 'selected':''}><c:out value="${item.username}"/></option>
                          </c:forEach>
                        </select>
                      </div>
                    </div>
                    </security:authorize>
                  <%--/assignee--%>
                </div>
              </div>
              <div class="col-12 col-md-4">
                <label class="text-label">Giai đoạn:</label>
                <div class="row">
                  <div class="col-md-6 col-sm- col-xs-12">
                    <div class="form-group row">
                      <span class="flex-center-vertical">Từ</span>
                      <div class="col-lg-10">
                        <input type="text" class="form-control rounded-10" placeholder="DD/MM/YYYY" id="from__date" name="searchFromDateStr" value="${criteria.searchFromDateStr }" autocomplete="off" />
                      </div>
                    </div>
                  </div>
                  <div class="col-md-6 col-sm-6 col-xs-12">
                    <div class="form-group row">
                      <span class="flex-center-vertical">đến</span>
                      <div class="col-lg-10">
                        <input type="text" class="form-control rounded-10" placeholder="DD/MM/YYYY" id="to__date" name="searchToDateStr" value="${criteria.searchToDateStr }" autocomplete="off" />
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="card rounded-16">
          <div class="table-responsive">
            <table class="table table-bordered table-striped">
              <thead>
              <tr class="table-success">
                <th class="border-0 text-center bgc-primary border-primary text-white">#</th>
                <th class="border-0 bgc-primary border-primary text-white maxW-400"><fmt:message key="task.table.th.title"/></th>
                <th class="border-0 bgc-primary border-primary text-white text-center"><fmt:message key="task.table.th.frequency"/></th>
                <th class="border-0 bgc-primary border-primary text-white text-center"><fmt:message key="task.table.th.status" /></th>
                <th class="border-0 bgc-primary border-primary text-white text-center d-xs-none"><fmt:message key="task.table.th.assignee" /></th>
                <th class="border-0 bgc-primary border-primary text-white text-center"><fmt:message key="task.table.th.deadline" /></th>
                <th class="border-0 text-center bgc-primary border-primary text-white"><i class="icon-checkmark3"></i></th>
              </tr>
              </thead>
              <tbody>
              <c:choose>
                <c:when test="${empty page.content}">
                  <tr>
                    <td colspan="8" class=" text-center text-none-data"><fmt:message key="not.data" /></td>
                  </tr>
                </c:when>
                <c:otherwise>
                  <c:forEach var="task" items="${page.content}" varStatus="cnt">
                    <tr class="task--todo__row">
                      <td class="text-center task__index">#<c:out value="${cnt.count + page.size*page.number}"></c:out></td>
                      <td class="maxW-400">
                        <div class="text-primary fw-bold">
                          <span>${task.title}</span>
                          <c:if test="${task.requestRejectFrequecy != null && task.requestRejectFrequecy eq true}">
                            <span class="text-danger">(<fmt:message key="task.request.reject.frequency"/>)</span>
                          </c:if>
                        </div>
                        <div class="text-secondary d-xs-none">${task.description}</div>
                      </td>
                      <td class="text-center"><fmt:message key="task.frequency.${task.frequency != '' ? task.frequency : 'unknown'}"/></td>
                      <td class="text-center">
                        <c:choose>
                          <c:when test="${task.status eq 'done'}">
                            <span class="badge badge-success"><fmt:message key="task.status.${task.status}"/></span>
                          </c:when>
                          <c:when test="${task.status eq 'rejected'}">
                            <span class="badge badge-danger"><fmt:message key="task.status.${task.status}"/></span>
                          </c:when>
                          <c:when test="${task.status eq 'assigned' || task.status eq 'reassigned'}">
                            <span class="badge badge-warning"><fmt:message key="task.status.${task.status}"/></span>
                          </c:when>
                          <c:otherwise>
                            <span class="badge badge-primary"><fmt:message key="task.status.${task.status}"/></span>
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td class="text-center d-xs-none">
                        <div>${task.assigneeFullname}</div>
                        <div class="fw-bold">(${task.assigneeEmail})</div>
                      </td>
                      <td class="text-center">${task.deadlineLocalDateTimeStr}</td>
                      <td class="text-center">
                        <div class="list-icons">
                          <div class="dropdown">
                            <a href="#" class="list-icons-item" data-toggle="dropdown"><i class="icon-menu9"></i></a>
                            <div class="dropdown-menu dropdown-menu-right">
                              <security:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_TASK_ADMIN_VIEW, ROLE_TASK_CREATE')">
                                <a href="/task/form?code=${task.code}" class="dropdown-item task--item__action_detail"><i class="icon-pencil7"></i><span><fmt:message key="button.detail"/></span></a>
                              </security:authorize>
                              <security:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_TASK_ADMIN_VIEW, ROLE_TASK_UPDATE')">
                                <a href="/task/confirm?code=${task.code}" class="dropdown-item task--item__action_preview"><i class="icon-eye"></i><span><fmt:message key="button.preview"/></span></a>
                              </security:authorize>
                              <security:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_TASK_ADMIN_VIEW,  ROLE_TASK_COPY')">
                                <a href="/task/copy?code=${task.code}" class="dropdown-item task--item__action_copy"><i class="icon-copy3"></i><span><fmt:message key="button.copy"/></span></a>
                              </security:authorize>
                            </div>
                          </div>
                        </div>
                      </td>
                    </tr>
                  </c:forEach>
                </c:otherwise>
              </c:choose>
              </tbody>
            </table>
          </div>
          <jsp:include page="/themes/admin/common/pagination.jsp">
            <jsp:param value="${page.number}" name="pageNumber"/>
            <jsp:param value="${page.totalPages}" name="maxPages"/>
            <jsp:param value="${page.size}" name="size"/>
            <jsp:param value="${page.totalElements}" name="totalElements"/>
          </jsp:include>
        </div>
      </div>
    </div>
  </form:form>
</div>
