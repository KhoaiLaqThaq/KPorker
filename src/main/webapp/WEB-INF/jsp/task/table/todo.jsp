<%@ include file="/themes/common/taglibs.jsp"%>

<div class="task--column todo">
  <div class="task--column__title">
    <span><fmt:message key="task.view.mode.table.title.todo"/></span>
  </div>
  <div class="task--column__data">
    <c:forEach var="task" items="${criteria.todos}">
      <div class="task--column__item mb-2">
        <div class="task--item__title mb-2">
          <span>${task.title}</span>
          <div class="task--item__actions">
            <security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_TASK_ADMIN_VIEW,ROLE_TASK_CREATE')">
              <a href="/task/form?code=${task.code}" class="task--item__action_detail"><i class="icon-pencil"></i></a>
            </security:authorize>
            <security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_TASK_ADMIN_VIEW,ROLE_TASK_UPDATE')">
              <a href="/task/confirm?code=${task.code}" class="task--item__action_preview"><i class="icon-eye"></i></a>
            </security:authorize>
          </div>
        </div>
        <div class="task--item__content">
          <div class="row">
            <div class="col-12">
              <p class="mb-0"><fmt:message key="label.description"/>: </p>
            </div>
            <!-- desc -->
            <div class="col-12 desc mb-2">
              ${task.description}
            </div>
            <!-- /desc -->
          </div>
          <div class="row">
            <!-- frequency -->
            <div class="col-12 col-md-6">
              <div class="d-flex">
                <span><i class="icon-pulse2 mr-2"></i><fmt:message key="task.frequency.${task.frequency != '' ? task.frequency : 'unknown'}"/></span>
              </div>
            </div>
            <!-- /frequency -->
  
            <!-- assignee -->
            <div class="col-12 col-md-6 text-right">
              ${task.assigneeFullname}
            </div>
            <!-- /assignee -->
  
          </div>
        </div>
      </div>
    </c:forEach>
  </div>
  <c:if test="${criteria.totalTodosElements > 5}">
    <div class="row">
      <div class="col-12 text-center">
        <span class="text-link" id="task--todo__showMore">Show more</span>
      </div>
    </div>
  </c:if>
</div>
