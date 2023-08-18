<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	
	<!-- Global stylesheets -->
	<link href="https://fonts.googleapis.com/css?family=Roboto:400,300,100,500,700,900" rel="stylesheet" type="text/css">
	<link href="<c:url value='/themes/admin/global_assets/css/icons/icomoon/styles.css'/>" rel="stylesheet" type="text/css">
	<link href="<c:url value='/themes/admin/assets/css/bootstrap.min.css'/>" rel="stylesheet" type="text/css">
	<link href="<c:url value='/themes/admin/assets/css/bootstrap_limitless.min.css'/>" rel="stylesheet" type="text/css">
	<link href="<c:url value='/themes/admin/assets/css/components.min.css'/>" rel="stylesheet" type="text/css">
	<link href="<c:url value='/themes/admin/assets/css/colors.min.css'/>" rel="stylesheet" type="text/css">
	<!-- /global stylesheets -->

	<!-- custom stylesheet -->
	<link href="<c:url value='/themes/admin/assets/css/custom_style.css'/>" rel="stylesheet" type="text/css">
	<!-- custom stylesheet -->

	<!-- Core JS files -->
	<script src="<c:url value='/themes/admin/global_assets/js/main/jquery.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/main/bootstrap.bundle.min.js'/>"></script>
	<script src="<c:url value='/themes/admin/global_assets/js/plugins/loaders/blockui.min.js'/>"></script>
	<!-- /core JS files -->

	<!-- Custom JS files -->
	<script src="<c:url value='/themes/admin/assets/js/app.js'/>"></script>
</head>

<body>

	<!-- Main navbar -->
	<div class="navbar navbar-expand-md navbar-dark">
		<div class="navbar-brand"><a href="index.html" class="d-inline-block"><img src="<c:url value='/themes/login/images/logo_mavin_group.jpg'/>" alt="" style="width:170px; height:40px"></a></div>
	</div>
	<!-- /main navbar -->


	<!-- Page content -->
	<div class="page-content">

		<!-- Main content -->
		<div class="content-wrapper">

			<!-- Content area -->
			<div class="content d-flex justify-content-center align-items-center">

				<!-- Container -->
				<div class="flex-fill">

					<!-- Error title -->
					<div class="text-center mb-3">
						<h4>${errorStatus}</h4>
						<h5>${errorMsg}</h5>
						<c:if test="${ fn:contains(errorStatus, '401') }">
						  <h5 class="text-warning">Phiên đăng nhập của bạn đã hết. Yêu cầu đăng nhập lại</h5>
						</c:if>
					</div>
					<!-- /error title -->


					<!-- Error content -->
					<div class="row">
						<div class="col-xl-4 offset-xl-4 col-md-8 offset-md-2">
							<!-- Buttons -->
							<div class="row">
								<div class="col-sm-12">
								    <c:choose>
								        <c:when test="${ fn:contains(errorStatus, '401') }">
								            <a href="<c:url value="/logout"/>" class="btn btn-primary btn-block"><i class="icon-home4 mr-2"></i> Back to login</a>
								        </c:when>
								        <c:otherwise>
    								        <a href="<c:url value="/"/>" class="btn btn-primary btn-block"><i class="icon-home4 mr-2"></i> Back to home</a>
								        </c:otherwise>
								    </c:choose>
								</div>

							</div>
							<!-- /buttons -->
						</div>
					</div>
					<!-- /error wrapper -->
				</div>
				<!-- /container -->
			</div>
			<!-- /content area -->
		</div>
		<!-- /main content -->
	</div>
	<!-- /page content -->

</body>
</html>
