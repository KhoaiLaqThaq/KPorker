<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
  <title><fmt:message key="task.list.title"></fmt:message></title>
  <meta name="menu" content="taskManagement" />

  <link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">
  <link href="<c:url value='/themes/admin/assets/css/task.css'/>" rel="stylesheet" type="text/css">

  <link href="<c:url value='/themes/admin/assets/css/components.min.css'/>" rel="stylesheet" type="text/css">
  <link href="<c:url value='/themes/admin/assets/css/colors.min.css'/>" rel="stylesheet" type="text/css">

  <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>
  <script src="<c:url value='/themes/admin/global_assets/js/main/bootstrap.bundle.min.js'/>"></script>
  <script src="<c:url value='/themes/admin/global_assets/js/plugins/loaders/blockui.min.js'/>"></script>

  <!-- Theme JS files -->
  <script src="<c:url value='/themes/admin/global_assets/js/plugins/ui/moment/moment.min.js'/>"></script>
<%--  <script src="<c:url value='/themes/admin/global_assets/js/plugins/ui/fullcalendar/fullcalendar.min.js'/>"></script>--%>
  <script src="<c:url value='/themes/admin/assets/libs/fullcalendar/index.global.min.js'/>"></script>

  <script src="<c:url value='/themes/admin/assets/js/task/init.js'/>"></script>
  <script src="<c:url value='/themes/admin/assets/js/task/calendar.js'/>"></script>
</head>

<div class="content px-0">
  <%@include file="/WEB-INF/jsp/task/task-header.jsp"%>
  <div class="task px-2 pt-2">
    <div class="p-2 rounded-10 bg-white">
      <div id="calendar"></div>
    </div>
  </div>
</div>

