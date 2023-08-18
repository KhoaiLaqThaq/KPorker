<%@ include file="/themes/common/taglibs.jsp"%>

<div class="row py-2 px-3 task--header__container">
  <div class="col-12 col-sm-6">
    <div class="d-flex">
      <div class="text-color-primary fs-4 mr-4"><fmt:message key="task.mng.title"/></div>
      <div class="btn-group justify-content-center">
        <a href="#" id="viewMode" class="btn bg-teal-400 dropdown-toggle" data-toggle="dropdown"></a>

        <div class="dropdown-menu">
          <div class="dropdown-item view__mode--table" id="view--model__table">
            <span><i class="icon-table mr-3"></i> <fmt:message key="task.view.mode.table"/></span>
          </div>
          <div class="dropdown-item view__mode--list" id="view--model__list">
            <span><i class="icon-paragraph-justify2 mr-3"></i> <fmt:message key="task.view.mode.list"/></span>
          </div>
          <div class="dropdown-item view__mode--calendar" id="view--model__calendar">
            <span><i class="icon-calendar2 mr-3"></i> <fmt:message key="task.view.mode.calendar"/></span>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="col-12 col-sm-6 text-right">
    <security:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_TASK_ADMIN_VIEW, ROLE_TASK_CREATE')">
      <a href="/task/form" class="btn bgc-warning text-white px-3 py-1 rounded-10"><i class="icon-plus22"></i><span class="ml-2"><fmt:message key="button.add"/></span></a>
    </security:authorize>
    <security:authorize access="hasAnyRole('ROLE_ADMIN, ROLE_TASK_ADMIN_VIEW')">
      <a href="<c:url value='/report/task'/>" class="btn bgc-warning text-white px-3  py-1 rounded-10"><fmt:message key="menu.report.task"/></a>
    </security:authorize>
<%--    <security:authorize access="hasRole('ROLE_ADMIN')">--%>
<%--      <button type="button" id="btnTaskClone" class="btn bgc-warning text-white px-3  py-1 rounded-10"><fmt:message key="label.task.clone"/></button>--%>
<%--    </security:authorize>--%>
  </div>
</div>
