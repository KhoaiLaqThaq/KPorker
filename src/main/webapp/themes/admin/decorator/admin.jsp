<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<title><fmt:message key="webapp.title"/> | <sitemesh:write property='title'/></title>



	<!-- Global stylesheets -->
	<link href="https://fonts.googleapis.com/css?family=Roboto:400,300,100,500,700,900" rel="stylesheet" type="text/css">
	<link href="<c:url value='/themes/admin/global_assets/css/icons/icomoon/styles.css'/>" rel="stylesheet" type="text/css">
	<link href="<c:url value='/themes/admin/global_assets/css/icons/fontawesome/styles.min.css'/>" rel="stylesheet" type="text/css">
	<link href="<c:url value='/themes/admin/assets/css/bootstrap.min.css'/>" rel="stylesheet" type="text/css">
	<link href="<c:url value='/themes/admin/assets/css/bootstrap_limitless.min.css'/>" rel="stylesheet" type="text/css">
	<link href="<c:url value='/themes/admin/assets/css/layout.css'/>" rel="stylesheet" type="text/css">
	<!-- <link href="<c:url value='/themes/admin/assets/css/layout.min.css'/>" rel="stylesheet" type="text/css"> -->
	<link href="<c:url value='/themes/admin/assets/css/components.min.css'/>" rel="stylesheet" type="text/css">
	<link href="<c:url value='/themes/admin/assets/css/colors.min.css'/>" rel="stylesheet" type="text/css">
	<%--<link href="<c:url value='/themes/admin/assets/css/restaurant-menu.css' />" rel="stylesheet" type="text/css" /> --%>

	<!-- /global stylesheets -->

	<!-- custom stylesheet -->
	<link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">
	<link href="<c:url value='/themes/admin/assets/css/_sizing.css'/>" rel="stylesheet" type="text/css">
	<link href="<c:url value='/themes/admin/assets/css/common.css'/>" rel="stylesheet" type="text/css">
	<link href='<c:url value="/themes/admin/assets/css/spinner.css"></c:url>' rel="stylesheet" type="text/css">
	<!-- custom stylesheet -->

	<!-- Core JS files -->
	<script src="<c:url value='/themes/admin/global_assets/js/main/jquery.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/main/bootstrap.bundle.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/loaders/blockui.min.js'/>"></script>
	<!-- /core JS files -->

	<!-- Custom JS files -->
	<script src="<c:url value='/themes/admin/assets/js/app.js'/>"></script>
	<script src="<c:url value='/themes/admin/assets/js/custom.js'/>"></script>
	<script type="text/javascript" src='<c:url value="/themes/admin/assets/js/sync_data_spinner.js" />'></script>
	
	<script src="<c:url value='/themes/admin/assets/js/format_number.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/autoNumeric/autoNumeric.js'/>"></script>

	<script>
		function getContext() {
			return '${ctx}';
		}
	</script>
	<!-- /theme JS files -->

	<sitemesh:write property='head'/>
</head>

<body>
  <c:set var="currentMenu" scope="request"><sitemesh:write property='currentMenu'/></c:set>
  <input id="currentMenu" type="hidden" value='<sitemesh:write property="meta.menu" />'/>

	<!-- Page content -->
	<div class="page-content">
		<!-- Main sidebar -->
		<%@include file="/themes/admin/common/sidebar.jsp"%>
		<!-- /main sidebar -->

		<!-- Main content -->
		<div class="content-wrapper" style="background-color: #f1f1fe;">
			<!-- Main navbar -->
			<%@include file="/themes/admin/common/navbar.jsp"%>
			<!-- /main navbar -->

			<!-- Message -->
			<%@include file="/themes/admin/common/messages.jsp"%>
			<!-- /Message -->

			<!-- Content area -->
			<sitemesh:write property='body'/>
			<!-- /content area -->

			<!-- Footer -->
			<%@include file="/themes/admin/common/footer.jsp"%>
			<!-- /footer -->

		</div>
		<!-- /main content -->
		<%@include file="/themes/admin/common/loading.jsp" %>
	</div>
	<!-- /page content -->

</body>
</html>
