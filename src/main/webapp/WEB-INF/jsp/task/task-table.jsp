<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
  <title><fmt:message key="task.list.title"></fmt:message></title>
  <meta name="menu" content="taskManagement" />

  <link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">
  <link href="<c:url value='/themes/admin/assets/css/task.css'/>" rel="stylesheet" type="text/css">

  <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>
  <script src="<c:url value='/themes/admin/assets/js/task/init.js'/>"></script>
  <script src="<c:url value='/themes/admin/assets/js/task/table.js'/>"></script>
</head>

<div class="content px-0">
  <form:form id="task--viewmode__table" modelAttribute="criteria" method="POST">
    <%@include file="/WEB-INF/jsp/task/task-header.jsp"%>

    <div class="row">
      <div class="task px-3 pt-2 w100p" id="task--table__content">
        <div class="task--table__container">
          <!-- plan -->
          <%@include file="/WEB-INF/jsp/task/table/plan.jsp"%>
          <!-- /plan -->

          <!-- todo -->
          <%@include file="/WEB-INF/jsp/task/table/todo.jsp"%>
          <!-- /todo -->

          <!-- overdue -->
          <%@include file="/WEB-INF/jsp/task/table/overdue.jsp"%>
          <!-- /overdue -->

          <!-- done -->
          <%@include file="/WEB-INF/jsp/task/table/done.jsp"%>
          <!-- /done -->

          <!-- rejected -->
          <%@include file="/WEB-INF/jsp/task/table/rejected.jsp"%>
          <!-- /rejected -->
        </div>
      </div>
    </div>
  </form:form>
</div>
