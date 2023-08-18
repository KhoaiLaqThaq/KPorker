<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/themes/common/taglibs.jsp"%>

	<%-- Error Messages --%>
	<c:if test="${not empty errors}">
		<div class="alert bg-danger text-white alert-styled-left alert-dismissible">
			<button type="button" class="close" data-dismiss="alert"><span>&times;</span></button>
			<c:forEach var="error" items="${errors}">
	            <c:out value="${error}"/><br />
	        </c:forEach>
	    </div>
	    <c:remove var="errors" scope="session"/>
	</c:if>

	<%-- Success Messages --%>
	<c:if test="${not empty messages}">
		<div class="alert bg-success text-white alert-styled-left alert-dismissible">
			<button type="button" class="close" data-dismiss="alert"><span>&times;</span></button>
	        <c:forEach var="msg" items="${messages}">
	            <c:out value="${msg}"/><br />
	        </c:forEach>
	    </div>
	    <c:remove var="messages" scope="session"/>
	</c:if>
