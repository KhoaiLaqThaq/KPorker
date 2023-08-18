<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login</title>
<link rel="stylesheet" type="text/css" href="<c:url value='/themes/login/css/bootstrap.min.css'/>" />
<link rel="stylesheet" type="text/css" href="<c:url value='/themes/login/css/fontawesome-all.min.css'/>" />
<link rel="stylesheet" type="text/css" href="<c:url value='/themes/login/css/iofrm-style.css'/>" />
<link rel="stylesheet" type="text/css" href="<c:url value='/themes/login/css/iofrm-theme3.css'/>" />
<link rel="stylesheet" type="text/css" href="<c:url value='/themes/login/css/main.css'/>" />
</head>
<body>
	<div class="form-body" class="container-fluid">
		<div class="row">
			<div class="img-holder">
				<div class="bg"></div>
				<div class="info-holder"></div>
			</div>
			<div class="form-holder">
				<c:if test="${param.error != null}">
					<div class="alert alert-danger alert-dismissible" role="alert">
						<button type="button" class="close" data-dismiss="alert" aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
						<c:choose>
							<c:when test="${param.error eq 'authenticationFailure'}">
								<fmt:message key="errors.password.mismatch" />
							</c:when>
							<c:when test="${param.error eq 'maximumSessions'}">
								<fmt:message key="errors.maximum.sessions" />
							</c:when>
							<c:when test="${param.error eq 'loginAttempts'}">
								<fmt:message key="errors.login.attempts">
									<fmt:param value="${param.fail}" />
									<fmt:param value="${param.limit}" />
								</fmt:message>
							</c:when>
							<c:when test="${param.error eq 'locked'}">
								<fmt:message key="errors.user.locked" />
							</c:when>
							<c:when test="${param.error eq 'disabled'}">
								<fmt:message key="errors.user.disabled" />
							</c:when>
							<c:when test="${param.error eq 'profileFailure'}">
								<fmt:message key="errors.profile.inactive" />
							</c:when>
							<c:otherwise>
								<fmt:message key="errors.user.notfound" />
							</c:otherwise>
						</c:choose>
					</div>
				</c:if>

				<div class="form-content">
					<div class="form-items">
						<img src='<c:url value="/themes/login/images/logo_mavin_group.jpg"/>' height="200px" width="400px" style="margin-bottom: 10%">
						<form method="post" id="loginForm" action="<c:url value='/login'/>">
							<span><fmt:message key="login.username" /></span>
							<input class="form-control input-login" type="text" name="username" placeholder="Tên đăng nhập..." required autofocus="autofocus" />
							<span><fmt:message key="login.password" /></span>
							<input class="form-control input-login" type="password" name="password" placeholder="Mật khẩu..." required />

							<div class="form-button">
								<button id="submit" type="submit" class="ibtn btn-login">Login</button>
							</div>
						</form>
						<div class="other-links">
							<%-- <span>Or login with</span><a href="#">Facebook</a><a href="#">Google</a><a href="#">Linkedin</a> --%>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<script type="text/javascript" src="<c:url value='/themes/login/js/jquery.min.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/themes/login/js/popper.min.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/themes/login/js/bootstrap.min.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/themes/login/js/main.js'/>"></script>
</body>
</html>
