<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
    <title><fmt:message key="home.title" /></title>
    <meta name="menu" content="homeMenu" />

    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/validation/validate.min.js'/>"></script>
    <link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" />
    <link href="<c:url value='/themes/admin/assets/css/material-support.css'/>" rel="stylesheet" type="text/css">
    <script src="<c:url value='/themes/admin/assets/js/echarts.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/visualization/echarts/echarts.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/bootbox.min.js'/>"></script>
    <!-- Datepicker -->
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/ui/moment/moment.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/daterangepicker.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/anytime.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.date.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/picker.time.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/pickers/pickadate/legacy.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/notifications/jgrowl.min.js'/>"></script>

    <script src="<c:url value='/themes/admin/global_assets/js/demo_pages/picker_date.js'/>"></script>
    <script src="<c:url value='/themes/admin/global_assets/js/plugins/forms/selects/select2.min.js'/>"></script>
    <script src="<c:url value='/themes/admin/assets/js/home.js'/>"></script>
</head>

<div class="content">
    <%@include file="/WEB-INF/jsp/home/production_actions.jsp"%>

    <%@include file="/WEB-INF/jsp/home/material_actions.jsp"%>

    <security:authorize access="hasAnyRole('ROLE_ADMIN,ROLE_REPORT_VIEW')">
        <%@include file="/WEB-INF/jsp/home/report_actions.jsp"%>
    </security:authorize>
</div>
